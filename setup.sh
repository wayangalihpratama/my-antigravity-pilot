#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# setup.sh — Stack Selector + BMAD Team Merger
# ============================================================================
# Creates a new project by copying a chosen stack's .agent/ directory
# and merging the portable BMAD team assets into it.
#
# Usage:
#   ./setup.sh                          # Interactive mode
#   ./setup.sh <stack> <target-path>    # Non-interactive mode
#
# Example:
#   ./setup.sh laravel ./my-new-app
#   ./setup.sh fastapi-nextjs /path/to/project
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BMAD_TEAM_DIR="${SCRIPT_DIR}/bmad-team"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ---- Tracking Stats ---------------------------------------------------------
STATS_ADDED=0
STATS_UPDATED=0
STATS_SKIPPED=0
OVERWRITE_ALL=""  # Stores "a" (all) or "s" (skip remaining)
INTERACTIVE=true  # Default to true, updated in main

# ---- Helper Functions -------------------------------------------------------

print_banner() {
    echo ""
    echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}${BOLD}║       🚀 BMAD Agent Stack Setup                 ║${NC}"
    echo -e "${CYAN}${BOLD}║       Build with AI Agent Teams                 ║${NC}"
    echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Discover available stacks by looking for directories with .agent/ subdirectories
discover_stacks() {
    local stacks=()
    for dir in "${SCRIPT_DIR}"/*/; do
        dir_name="$(basename "$dir")"
        # Skip hidden dirs, bmad-team, and non-stack directories
        if [[ "$dir_name" == .* ]] || [[ "$dir_name" == "bmad-team" ]] || [[ "$dir_name" == "bmad-web-bundles" ]]; then
            continue
        fi
        if [[ -d "${dir}.agent" ]]; then
            stacks+=("$dir_name")
        fi
    done
    echo "${stacks[@]}"
}

# Show interactive stack selection menu
select_stack() {
    local stacks=($1)
    echo -e "${BOLD}Available stacks:${NC}" >&2
    echo "" >&2
    for i in "${!stacks[@]}"; do
        local stack="${stacks[$i]}"
        local rules_count=$(find "${SCRIPT_DIR}/${stack}/.agent/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        local skills_count=$(find "${SCRIPT_DIR}/${stack}/.agent/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
        local workflows_count=$(find "${SCRIPT_DIR}/${stack}/.agent/workflows" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "  ${CYAN}$((i + 1))${NC}) ${BOLD}${stack}${NC}" >&2
        echo -e "     📏 ${rules_count} rules | 🛠️  ${skills_count} skills | 🔄 ${workflows_count} workflows" >&2
    done
    echo "" >&2

    while true; do
        read -rp "$(echo -e "${BOLD}Select a stack (1-${#stacks[@]}): ${NC}")" choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#stacks[@]} )); then
            echo "${stacks[$((choice - 1))]}"
            return
        fi
        echo -e "${RED}❌ Invalid choice. Please enter a number between 1 and ${#stacks[@]}.${NC}" >&2
    done
}

# Select installation mode
select_mode() {
    echo -e "${BOLD}Installation Mode:${NC}" >&2
    echo -e "  ${CYAN}1${NC}) ${BOLD}Full Stack${NC} (Recommended for new projects)" >&2
    echo -e "     Copies the entire project skeleton + agent configuration." >&2
    echo -e "  ${CYAN}2${NC}) ${BOLD}Agent Config Only${NC} (For existing projects)" >&2
    echo -e "     Copies only the .agent/ directory and BMAD team." >&2
    echo -e "  ${CYAN}3${NC}) ${BOLD}BMAD Only${NC} (No stack config)" >&2
    echo -e "     Copies ONLY the BMAD team agents into .agent/ directory." >&2
    echo "" >&2

    while true; do
        read -rp "$(echo -e "${BOLD}Select mode (1-3): ${NC}")" choice
        if [[ "$choice" == "1" ]]; then
            echo "full"
            return
            elif [[ "$choice" == "2" ]]; then
            echo "agent"
            return
            elif [[ "$choice" == "3" ]]; then
            echo "bmad"
            return
        fi
        echo -e "${RED}❌ Invalid choice. Please enter 1, 2, or 3.${NC}" >&2
    done
}

# Helper to prompt for overwrite when files differ
prompt_for_overwrite() {
    local relative="$1"

    # If non-interactive mode, default to Skip (safe)
    if [[ "$INTERACTIVE" == false ]]; then
        return 1
    fi

    # If "Apply to all" was previously selected
    if [[ "$OVERWRITE_ALL" == "a" ]]; then
        return 0
    fi
    if [[ "$OVERWRITE_ALL" == "s" ]]; then
        return 1
    fi

    while true; do
        echo -e "${YELLOW}❓ File ${BOLD}${relative}${NC}${YELLOW} exists and is different.${NC}" >&2
        # Redirect read to /dev/tty to avoid consuming from the find loop's stdin
        read -rp "$(echo -e "   Overwrite? [y]es / [n]o / [a]ll / [s]kip remaining: ")" choice < /dev/tty
        case "$choice" in
            [yY]) return 0 ;;
            [nN]) return 1 ;;
            [aA]) OVERWRITE_ALL="a"; return 0 ;;
            [sS]) OVERWRITE_ALL="s"; return 1 ;;
            *) echo -e "${RED}Invalid choice.${NC}" >&2 ;;
        esac
    done
}

# Merge directory contents (now with diff checks and prompting)
merge_directory() {
    local src="$1"
    local dst="$2"

    if [[ ! -d "$src" ]]; then
        return
    fi

    mkdir -p "$dst"

    while read -r file; do
        local relative="${file#"$src"/}"
        local target="${dst}/${relative}"
        local target_dir="$(dirname "$target")"

        mkdir -p "$target_dir"

        if [[ -f "$target" ]]; then
            if diff -q "$file" "$target" > /dev/null 2>&1; then
                # Identical
                ((STATS_SKIPPED++)) || true
                # Silent or very concise skip for identical files
            else
                # Different
                if prompt_for_overwrite "${relative}"; then
                    cp "$file" "$target"
                    print_info "Updated: ${relative}"
                    ((STATS_UPDATED++)) || true
                else
                    print_warn "Skipping (retaining local): ${relative}"
                    ((STATS_SKIPPED++)) || true
                fi
            fi
        else
            cp "$file" "$target"
            print_success "Added: ${relative}"
            ((STATS_ADDED++)) || true
        fi
    done < <(find "$src" -type f)
}

# Update directory contents (standardized with stats)
update_directory() {
    local src="$1"
    local dst="$2"

    if [[ ! -d "$src" ]]; then
        return
    fi

    mkdir -p "$dst"

    while read -r file; do
        local relative="${file#"$src"/}"
        local target="${dst}/${relative}"
        local target_dir="$(dirname "$target")"

        mkdir -p "$target_dir"

        if [[ -f "$target" ]]; then
            if ! diff -q "$file" "$target" > /dev/null 2>&1; then
                cp "$file" "$target"
                print_info "Updated: ${relative}"
                ((STATS_UPDATED++)) || true
            else
                ((STATS_SKIPPED++)) || true
            fi
        else
            cp "$file" "$target"
            print_success "Added: ${relative}"
            ((STATS_ADDED++)) || true
        fi
    done < <(find "$src" -type f)
}

# ---- Main Logic -------------------------------------------------------------

main() {
    print_banner

    # Validate bmad-team exists
    if [[ ! -d "$BMAD_TEAM_DIR" ]]; then
        print_error "BMAD team directory not found at: ${BMAD_TEAM_DIR}"
        print_info "Make sure bmad-team/ exists in the same directory as this script."
        exit 1
    fi

    # Discover available stacks
    local stacks_string
    stacks_string="$(discover_stacks)"
    if [[ -z "$stacks_string" ]]; then
        print_error "No stacks found! Each stack needs a <stack-name>/.agent/ directory."
        exit 1
    fi
    local stacks=($stacks_string)

    # Get stack selection
    local selected_stack=""
    local target_path=""
    local mode="full"

    if [[ $# -ge 2 ]]; then
        # Non-interactive mode
        INTERACTIVE=false
        selected_stack="$1"
        target_path="$2"
        if [[ $# -ge 3 ]]; then
            mode="$3"
        fi

        # Validate stack exists (unless mode is 'bmad')
        if [[ "$mode" != "bmad" ]]; then
            local valid=false
            for s in "${stacks[@]}"; do
                if [[ "$s" == "$selected_stack" ]]; then
                    valid=true
                    break
                fi
            done
            if [[ "$valid" == false ]]; then
                print_error "Stack '${selected_stack}' not found."
                print_info "Available stacks: ${stacks[*]}"
                exit 1
            fi
        fi

        # Validate mode
        if [[ "$mode" != "full" && "$mode" != "agent" && "$mode" != "bmad" ]]; then
            print_error "Invalid mode '${mode}'. Use 'full', 'agent', or 'bmad'."
            exit 1
        fi
    else
        # Interactive mode
        mode=$(select_mode)
        echo ""

        if [[ "$mode" != "bmad" ]]; then
            selected_stack=$(select_stack "${stacks_string}")
            echo ""
        else
            selected_stack="none (BMAD Only)"
        fi

        read -rp "$(echo -e "${BOLD}Target project path: ${NC}")" target_path
    fi

    # Resolve target path (supports ~, relative paths, and paths outside this repo)
    target_path="${target_path/#\~/$HOME}"
    # Convert relative path to absolute using caller's working directory
    if [[ ! "$target_path" = /* ]]; then
        target_path="$(pwd)/${target_path}"
    fi
    # Canonicalize: resolve .., ., and symlinks by creating the dir then using cd+pwd
    mkdir -p "${target_path}"
    target_path="$(cd "${target_path}" && pwd)"
    local target_agent_dir="${target_path}/.agent"

    echo ""
    echo -e "${BOLD}Configuration:${NC}"
    echo -e "  Stack:  ${CYAN}${selected_stack}${NC}"
    echo -e "  Target: ${CYAN}${target_path}${NC}"
    echo -e "  Mode:   ${CYAN}${mode}${NC}"
    echo ""

    # Confirm
    if [[ $# -lt 2 ]]; then
        read -rp "$(echo -e "${BOLD}Proceed? (y/n): ${NC}")" confirm
        if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
            print_info "Aborted."
            exit 0
        fi
        echo ""
    fi

    # Step 1: Create target directory
    mkdir -p "$target_path"
    print_success "Created target directory"

    # Step 2: Copy stack files
    if [[ "$mode" == "full" ]]; then
        print_info "Copying ${selected_stack} stack files (Full Stack)..."
        merge_directory "${SCRIPT_DIR}/${selected_stack}" "${target_path}"
        print_success "Stack files copied"
        elif [[ "$mode" == "agent" ]]; then
        print_info "Copying ${selected_stack} agent config (Agent Only)..."
        merge_directory "${SCRIPT_DIR}/${selected_stack}/.agent" "${target_path}/.agent"
        print_success "Agent configuration copied"
    else
        print_info "Skipping stack files (BMAD Only mode)..."
    fi

    # Step 3: Merge BMAD team assets (force-overwrite to keep in sync with upstream)
    print_info "Merging BMAD team assets ..."
    update_directory "${BMAD_TEAM_DIR}/rules" "${target_agent_dir}/rules"
    update_directory "${BMAD_TEAM_DIR}/skills" "${target_agent_dir}/skills"
    update_directory "${BMAD_TEAM_DIR}/workflows" "${target_agent_dir}/workflows"
    print_success "BMAD team rules, skills, and workflows merged"

    # Step 4: Bootstrap docs/ directory
    print_info "Bootstrapping docs/ directory ..."
    mkdir -p "${target_path}/docs"
    print_success "docs/ directory ready"

    # Step 5: Update .gitignore
    print_info "Updating .gitignore ..."
    local gitignore="${target_path}/.gitignore"
    touch "$gitignore"

    local entries_added=0
    for entry in ".agent/" "agent_docs/"; do
        if ! grep -qxF "$entry" "$gitignore" 2>/dev/null; then
            echo "$entry" >> "$gitignore"
            entries_added=$((entries_added + 1))
        fi
    done

    if [[ $entries_added -gt 0 ]]; then
        print_success ".gitignore updated (added ${entries_added} entries)"
    else
        print_warn ".gitignore already contains required entries"
    fi

    # Step 6: Summary
    local total_rules=$(find "${target_agent_dir}/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local total_skills=$(find "${target_agent_dir}/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    local total_workflows=$(find "${target_agent_dir}/workflows" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    echo ""
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║       ✨ Setup Complete!                         ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${BOLD}Project:${NC}    ${target_path}"
    echo -e "  ${BOLD}Stack:${NC}      ${selected_stack} + BMAD Team
  ${BOLD}Mode:${NC}       ${mode}
  ${BOLD}Summary:${NC}    ${GREEN}${STATS_ADDED} added${NC}, ${BLUE}${STATS_UPDATED} updated${NC}, ${YELLOW}${STATS_SKIPPED} skipped${NC}
"
    echo -e "  ${BOLD}Skills:${NC}     ${total_skills} skills"
    echo -e "  ${BOLD}Workflows:${NC}  ${total_workflows} workflows"
    echo ""
    echo -e "  ${BOLD}Documentation:${NC}"
    echo -e "    📂 docs/           → Shared (git-tracked): LLD.md + feature specs"
    echo -e "    📂 agent_docs/     → Local (gitignored): sprint plans + stories"
    echo -e "    📂 .agent/         → Local (gitignored): rules, skills, workflows"
    echo ""
    echo -e "  ${BOLD}BMAD Agents Available:${NC}"
    echo -e "    📋 PM (John)       📊 Analyst (Mary)     🏗️  Architect (Winston)"
    echo -e "    🎨 UX (Sally)      🏃 SM (Bob)           💻 Dev (Amelia)"
    echo -e "    🧪 Tester (Murat)  📚 Writer (Paige)"
    echo ""
    echo -e "  ${CYAN}To start the BMAD lifecycle: use /bmad-orchestrator${NC}"
    echo -e "  ${CYAN}To invoke a specific agent: use the bmad-{role} skill${NC}"
    echo -e "  ${CYAN}To generate an initial LLD: use /generate-lld${NC}"
    echo ""
}

main "$@"
