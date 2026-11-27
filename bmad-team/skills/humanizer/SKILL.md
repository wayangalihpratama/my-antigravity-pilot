---
name: humanizer
description: Strip AI-generated writing tells from documentation, READMEs, UI microcopy, and PR descriptions based on Wikipedia's Signs of AI Writing. Use when drafting or editing user-facing prose.
---

# Humanizer — Anti-AI-Prose Filter ✍️

Eliminate predictable LLM writing tells from technical docs, READMEs, PR bodies, and UI microcopy while preserving exact technical meaning.

## 1. Top 10 AI-Writing Tells to Strip

| # | AI Writing Tell | Fix |
|---|---|---|
| **1** | **Puffery & significance inflation** ("pivotal", "testament to", "game-changing", "landscape") | State concrete facts, constraints, or measured metrics. |
| **2** | **Negative parallelisms** ("Not just X, but Y" / "It's not about X—it's about Y") | State directly what the system does. |
| **3** | **Forced Rule-of-Three triads** ("fast, scalable, and reliable") | List only specific, verifiable attributes. |
| **4** | **Em-dash overuse** (`—` in every other sentence) | Prefer periods, commas, colons, or parentheses. |
| **5** | **Stock AI buzzwords** ("delve", "tapestry", "leverage", "streamline", "seamless", "unlock", "foster", "robust") | Use plain verbs: `use`, `simplify`, `build`, `verify`. |
| **6** | **Filler openers** ("Moreover,", "Furthermore,", "In today's fast-paced...", "It is worth noting") | Delete throat-clearing; start with the subject and verb. |
| **7** | **Trailing `-ing` participle fluff** ("...ensuring seamless integration and boosting velocity") | Cut the tail or state the exact mechanism. |
| **8** | **Chatbot artifacts** ("Certainly!", "Here is...", "Let's dive in", "Hope this helps") | Output the document or section directly. |
| **9** | **Vague authority claims** ("Industry best practices suggest", "Experts agree") | Cite the exact spec, RFC, or rule file, or delete. |
| **10** | **Synonym cycling** ("the service... the platform... the ecosystem... the solution") | Repeat the exact domain noun consistently. |

## 2. Final Verification Pass

Before outputting user-facing prose:
- [ ] **Cut 20%+ filler**: Every sentence carries a distinct fact, command, or constraint.
- [ ] **Zero banned buzzwords**: No "delve", "leverage", "seamless", "pivotal", or "not just X, but Y".
- [ ] **Active voice & concrete numbers**: Replace vague adjectives with exact thresholds (e.g., `>=80% coverage`, `<=60 lines`).
- [ ] **Consistent domain vocabulary**: Match codebase models, routes, and glossary terms verbatim.
