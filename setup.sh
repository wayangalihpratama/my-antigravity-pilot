#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# setup.sh — Stack Selector + BMAD Team Merger (v1.1.0)
# ============================================================================
# Creates a new project by copying a chosen stack's .agent/ directory
# and merging the portable BMAD team assets into it.
#
# Usage:
#   ./setup.sh                          # Interactive mode
#   ./setup.sh [flags] <stack> <path>   # Non-interactive mode
#
# Flags:
#   -s, --sync-all                      # Update BMAD assets in ALL projects
#   -d, --dry-run                       # Show changes without applying them
#   -p, --prune                         # Detect orphaned skills in projects
#   -h, --help                          # Show this help message
#
# Example:
#   ./setup.sh laravel ./my-new-app
#   ./setup.sh --sync-all --dry-run
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
STATS_ORPHANS=0
OVERWRITE_ALL=""  # Stores "a" (all) or "s" (skip remaining)
INTERACTIVE=true  # Default to true, updated in main
DRY_RUN=false
PRUNE_CHECK=false
SYNC_ALL=false

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

# Update directory contents (standardized with stats + dry-run + orphan check)
update_directory() {
    local src="$1"
    local dst="$2"

    if [[ ! -d "$src" ]]; then
        return
    fi

    [[ "$DRY_RUN" == false ]] && mkdir -p "$dst"

    # 1. Sync / Update existing or new files
    while read -r file; do
        local relative="${file#"$src"/}"
        local target="${dst}/${relative}"
        local target_dir="$(dirname "$target")"

        [[ "$DRY_RUN" == false ]] && mkdir -p "$target_dir"

        if [[ -f "$target" ]]; then
            if ! diff -q "$file" "$target" > /dev/null 2>&1; then
                if [[ "$DRY_RUN" == true ]]; then
                    echo -e "${BLUE}[DRY] Would Update: ${relative}${NC}"
                else
                    cp "$file" "$target"
                    print_info "Updated: ${relative}"
                fi
                ((STATS_UPDATED++)) || true
            else
                ((STATS_SKIPPED++)) || true
            fi
        else
            if [[ "$DRY_RUN" == true ]]; then
                echo -e "${GREEN}[DRY] Would Add: ${relative}${NC}"
            else
                cp "$file" "$target"
                print_success "Added: ${relative}"
            fi
            ((STATS_ADDED++)) || true
        fi
    done < <(find "$src" -type f)

    # 2. Orphan detection (Prune check)
    if [[ "$PRUNE_CHECK" == true && -d "$dst" ]]; then
        while read -r target_file; do
            local relative="${target_file#"$dst"/}"
            local source_match="${src}/${relative}"
            if [[ ! -f "$source_match" ]]; then
                print_warn "Orphan detected (not in master): ${relative}"
                ((STATS_ORPHANS++)) || true
            fi
        done < <(find "$dst" -type f)
    fi
}

ensure_gitignore() {
    local target_dir="$1"
    local gitignore="${target_dir}/.gitignore"
    local entries=(
        ".agent/"
        "agent_docs/"
        ".claude/history/"
        ".claude/sessions/"
        ".claude/cache/"
        ".claude/projects/"
        ".claude/telemetry/"
        ".claude/*.local.json"
        ".claude/*.log"
        ".claude/state.json"
        ".env"
        ".env.*"
        "node_modules/"
        "test-results/"
        "playwright-report/"
        ".strix/"
        "*.log"
    )
    local added=0

    # If gitignore has blanket .claude/ rule, remove it to preserve .claude/skills and .claude/mcp.json
    if [[ -f "$gitignore" ]] && grep -qxF ".claude/" "$gitignore" 2>/dev/null; then
        if [[ "$DRY_RUN" == false ]]; then
            sed -i.bak '/^\.claude\/$/d' "$gitignore" && rm -f "${gitignore}.bak"
            print_info "Removed broad .claude/ from .gitignore to preserve .claude/skills & mcp.json"
        fi
    fi

    if [[ "$DRY_RUN" == true ]]; then
        for entry in "${entries[@]}"; do
            if [[ ! -f "$gitignore" ]] || ! grep -qxF "$entry" "$gitignore" 2>/dev/null; then
                echo -e "${GREEN}[DRY] Would add to .gitignore: ${entry}${NC}"
            fi
        done
        return 0
    fi

    touch "$gitignore"
    for entry in "${entries[@]}"; do
        if ! grep -qxF "$entry" "$gitignore" 2>/dev/null; then
            echo "$entry" >> "$gitignore"
            added=$((added + 1))
        fi
    done

    if [[ $added -gt 0 ]]; then
        print_success ".gitignore updated (added ${added} entries, preserved .claude/skills)"
    fi
}

setup_claude_codex() {
    local target_dir="$1"
    local agent_dir="${target_dir}/.agent"

    # 1. Sync CLAUDE.md and AGENTS.md (Non-destructive: do NOT overwrite if target already has them)
    for doc in "CLAUDE.md" "AGENTS.md"; do
        if [[ -f "${SCRIPT_DIR}/${doc}" ]]; then
            if [[ -f "${target_dir}/${doc}" ]]; then
                print_info "Preserving existing ${doc} in target project (will not overwrite)"
                ((STATS_SKIPPED++)) || true
            else
                if [[ "$DRY_RUN" == true ]]; then
                    echo -e "${GREEN}[DRY] Would Add: ${doc}${NC}"
                else
                    cp "${SCRIPT_DIR}/${doc}" "${target_dir}/${doc}"
                    print_success "Added: ${doc}"
                fi
                ((STATS_ADDED++)) || true
            fi
        fi
    done

    # 2. Setup .claude/skills symlinks pointing to .agent/skills
    if [[ -d "${agent_dir}/skills" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            mkdir -p "${target_dir}/.claude/skills"
        fi
        for skill_dir in "${agent_dir}/skills"/*; do
            if [[ -d "$skill_dir" ]]; then
                local skill_name="$(basename "$skill_dir")"
                local link_path="${target_dir}/.claude/skills/${skill_name}"
                if [[ ! -e "$link_path" && ! -L "$link_path" ]]; then
                    if [[ "$DRY_RUN" == true ]]; then
                        echo -e "${GREEN}[DRY] Would link skill: .claude/skills/${skill_name}${NC}"
                    else
                        ln -s "../../.agent/skills/${skill_name}" "$link_path"
                    fi
                fi
            fi
        done
        if [[ "$DRY_RUN" == false ]]; then
            print_success "Claude Code skills synchronized (.claude/skills/)"
        fi
    fi
}

# ---- Main Logic -------------------------------------------------------------

main() {
    print_banner

    local selected_stack=""
    local target_path=""
    local mode=""

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

    # ---- Argument Parsing ----
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--sync-all) SYNC_ALL=true; INTERACTIVE=false; shift ;;
            -d|--dry-run)  DRY_RUN=true; shift ;;
            -p|--prune)    PRUNE_CHECK=true; shift ;;
            -h|--help)
                grep '^# ' "$0" | head -n 25 | sed 's/^# //'
                exit 0
                ;;
            -*) print_error "Unknown option: $1"; exit 1 ;;
            *)
                if [[ -z "$selected_stack" ]]; then
                    selected_stack="$1"
                elif [[ -z "$target_path" ]]; then
                    target_path="$1"
                elif [[ -z "$mode" ]]; then
                    mode="$1"
                fi
                INTERACTIVE=false
                shift
                ;;
        esac
    done

    # Handle Sync-All Mode
    if [[ "$SYNC_ALL" == true ]]; then
        print_info "Starting Global Sync..."
        [[ "$DRY_RUN" == true ]] && echo -e "${YELLOW}⚠️  DRY RUN ENABLED - No files will be changed.${NC}"
        echo ""

        # Find all directories that have a .agent folder
        # Skip current dir and bmad-team itself
        local projects=($(find . -maxdepth 2 -name ".agent" -type d | sed 's|/\.agent||'))

        for project in "${projects[@]}"; do
            # Skip the root and bmad-team
            if [[ "$project" == "." ]] || [[ "$project" == "./bmad-team" ]]; then continue; fi

            echo -e "${BOLD}Syncing project: ${CYAN}${project}${NC} ..."

            local project_agent_dir="${project}/.agent"
            update_directory "${BMAD_TEAM_DIR}/rules" "${project_agent_dir}/rules"
            update_directory "${BMAD_TEAM_DIR}/skills" "${project_agent_dir}/skills"
            update_directory "${BMAD_TEAM_DIR}/workflows" "${project_agent_dir}/workflows"
            update_directory "${BMAD_TEAM_DIR}/templates" "${project_agent_dir}/templates"
            update_directory "${BMAD_TEAM_DIR}/subagents" "${project_agent_dir}/subagents"
            update_directory "${BMAD_TEAM_DIR}/scripts" "${project_agent_dir}/scripts"

            # Sync MCP configurations (.claude/mcp.json and .mcp.json)
            if [[ -f "${SCRIPT_DIR}/.claude/mcp.json" ]]; then
                [[ "$DRY_RUN" == false ]] && mkdir -p "${project}/.claude"
                if [[ ! -f "${project}/.claude/mcp.json" ]] || ! diff -q "${SCRIPT_DIR}/.claude/mcp.json" "${project}/.claude/mcp.json" > /dev/null 2>&1; then
                    if [[ "$DRY_RUN" == true ]]; then
                        echo -e "${BLUE}[DRY] Would Sync: .claude/mcp.json${NC}"
                    else
                        cp "${SCRIPT_DIR}/.claude/mcp.json" "${project}/.claude/mcp.json"
                        print_info "Synced: .claude/mcp.json"
                    fi
                fi
            fi
            if [[ -f "${SCRIPT_DIR}/.mcp.json" ]]; then
                if [[ ! -f "${project}/.mcp.json" ]] || ! diff -q "${SCRIPT_DIR}/.mcp.json" "${project}/.mcp.json" > /dev/null 2>&1; then
                    if [[ "$DRY_RUN" == true ]]; then
                        echo -e "${BLUE}[DRY] Would Sync: .mcp.json${NC}"
                    else
                        cp "${SCRIPT_DIR}/.mcp.json" "${project}/.mcp.json"
                        print_info "Synced: .mcp.json"
                    fi
                fi
            fi

            # Setup Claude Code & Codex integration (CLAUDE.md, AGENTS.md, .claude/skills)
            setup_claude_codex "$project"

            # Ensure .gitignore includes granular .claude state and local configs
            ensure_gitignore "$project"
            echo ""
        done

        echo -e "${GREEN}${BOLD}Global Sync Complete!${NC}"
        echo -e "Summary: ${GREEN}${STATS_ADDED} added${NC}, ${BLUE}${STATS_UPDATED} updated${NC}, ${YELLOW}${STATS_SKIPPED} skipped${NC}, ${RED}${STATS_ORPHANS} orphans${NC}"
        exit 0
    fi

    # ---- Interactive Fallback ----
    if [[ "$INTERACTIVE" == true ]]; then
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
    if [[ "$INTERACTIVE" == true ]]; then
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
    update_directory "${BMAD_TEAM_DIR}/templates" "${target_agent_dir}/templates"
    update_directory "${BMAD_TEAM_DIR}/subagents" "${target_agent_dir}/subagents"
    update_directory "${BMAD_TEAM_DIR}/scripts" "${target_agent_dir}/scripts"

    # Initialize .agent/config.yaml if not already present
    if [[ ! -f "${target_agent_dir}/config.yaml" && ! -f "${target_path}/.agents/config.yaml" && -f "${BMAD_TEAM_DIR}/templates/CONFIG.yaml" ]]; then
        cp "${BMAD_TEAM_DIR}/templates/CONFIG.yaml" "${target_agent_dir}/config.yaml"
        print_success "Skill filter configuration initialized (.agent/config.yaml)"
        ((STATS_ADDED++)) || true
    fi
    print_success "BMAD team rules, skills, workflows, templates, subagents, and scripts merged"

    # Step 4: Setup MCP Server Configurations (.claude/mcp.json and .mcp.json)
    print_info "Setting up MCP server configurations ..."
    if [[ -f "${SCRIPT_DIR}/.claude/mcp.json" ]]; then
        mkdir -p "${target_path}/.claude"
        if [[ ! -f "${target_path}/.claude/mcp.json" ]]; then
            cp "${SCRIPT_DIR}/.claude/mcp.json" "${target_path}/.claude/mcp.json"
            print_success "MCP configuration initialized (.claude/mcp.json)"
            ((STATS_ADDED++)) || true
        fi
    fi
    if [[ -f "${SCRIPT_DIR}/.mcp.json" ]]; then
        if [[ ! -f "${target_path}/.mcp.json" ]]; then
            cp "${SCRIPT_DIR}/.mcp.json" "${target_path}/.mcp.json"
            print_success "Root MCP configuration initialized (.mcp.json)"
            ((STATS_ADDED++)) || true
        fi
    fi

    # Step 5: Bootstrap docs/ directory
    print_info "Bootstrapping docs/ directory ..."
    mkdir -p "${target_path}/docs"
    print_success "docs/ directory ready"

    # Step 6: Setup Claude Code & Codex integration
    print_info "Configuring Claude Code & Codex integration ..."
    setup_claude_codex "$target_path"

    # Step 7: Update .gitignore
    print_info "Updating .gitignore ..."
    ensure_gitignore "$target_path"

    # Step 8: Summary
    local total_rules=$(find "${target_agent_dir}/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local total_skills=$(find "${target_agent_dir}/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    local total_workflows=$(find "${target_agent_dir}/workflows" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    local total_subagents=$(find "${target_agent_dir}/subagents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    echo ""
    echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║       ✨ Setup Complete! (BMAD v6 Ready)        ║${NC}"
    echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${BOLD}Project:${NC}    ${target_path}"
    echo -e "  ${BOLD}Stack:${NC}      ${selected_stack} + BMAD v6 Team
  ${BOLD}Mode:${NC}       ${mode}
  ${BOLD}Summary:${NC}    ${GREEN}${STATS_ADDED} added${NC}, ${BLUE}${STATS_UPDATED} updated${NC}, ${YELLOW}${STATS_SKIPPED} skipped${NC}
"
    echo -e "  ${BOLD}Subagents:${NC}  ${total_subagents} personas (BMAD v6 Agent-as-Code)"
    echo -e "  ${BOLD}Skills:${NC}     ${total_skills} skills"
    echo -e "  ${BOLD}Workflows:${NC}  ${total_workflows} workflows"
    echo ""
    echo -e "  ${BOLD}Documentation & Config:${NC}"
    echo -e "    📂 docs/           → Shared (git-tracked): briefs/, prd/, lld/ (versioned docs)"
    echo -e "    📂 agent_docs/     → Local (gitignored): sprint plans + stories"
    echo -e "    📂 .agent/         → Local (gitignored): rules, skills, workflows, subagents"
    echo -e "    ⚙️  .agent/config.yaml → Skill pruning (reduces token usage)"
    echo -e "    🔌 .claude/mcp.json → MCP Servers (Playwright, Context7)"
    echo ""
    echo -e "  ${BOLD}BMAD v6 Subagent Personas Available:${NC}"
    echo -e "    📋 PM (John)       📊 Analyst (Mary)     🏗️  Architect (Winston)"
    echo -e "    🎨 UX (Sally)      🏃 SM (Bob)           💻 Dev (Amelia)"
    echo -e "    🧪 Tester (Murat)  📚 Writer (Paige)     🎭 Council (Party Mode)"
    echo ""
    echo -e "  ${CYAN}To check status & next steps: use /bmad-help${NC}"
    echo -e "  ${CYAN}To run Party Mode deliberation: use /bmad-party${NC}"
    echo -e "  ${CYAN}To run full v6 lifecycle:      use /bmad-orchestrator${NC}"
    echo -e "  ${CYAN}To run 2-step Fastpath:        use /bmad-fastpath${NC}"
    echo ""
}


main "$@"
