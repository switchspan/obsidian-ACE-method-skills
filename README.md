# Obsidian ACE Method Skills for Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **This fork targets Ideaverse Pro 2.5.** The skills and `CLAUDE.md` use the Pro 2.5 layout: `Atlas/Sources/`, `Efforts/Areas|Projects|Works`, `Calendar/Days|Records|Reviews`, the `collections` property, and Obsidian Bases. The skills read note templates from `x/Templates/Collections/` when they run. For the original (Ideaverse Lite) version, see [yanickfischer/obsidian-ACE-method-skills](https://github.com/yanickfischer/obsidian-ACE-method-skills).

A collection of three specialized Claude Code skills designed for managing an [Obsidian](https://obsidian.md) vault structured with Nick Milo's **ACE Method** from the [Ideaverse](https://www.linkingyourthinking.com/).

These skills enable efficient knowledge capture, creation, and maintenance while following the Access-Control-Express (ACE) organizational framework and Linking Your Thinking (LYT) principles.

---

## 📚 What is This?

This repository contains three custom skills that transform Claude Code into a powerful knowledge management assistant for your Obsidian vault:

1. **`web-capture`** — Capture web articles and URLs into properly structured knowledge notes
2. **`create-knowledge`** — Transform any input (notes, imports, rough ideas) into structured vault notes
3. **`vault-review`** — Audit and maintain vault health (orphaned notes, missing metadata, connection opportunities)

---

## 🎯 The ACE Method

The **ACE Method** (Access-Control-Express) is a folder structure system created by Nick Milo for organizing personal knowledge:

- **Atlas/** — Your knowledge
  - **Maps/** — Maps of Content (MOCs), plus `Bases/` with the `.base` dashboard views
  - **Dots/** — Atomic notes: People, Questions, Quotes, Statements, Things
  - **Sources/** — What you consumed: Books, Clippings, Courses, Movies, Papers, Talks, TV, …
- **Calendar/** — Days, Records (Events, Ideas, Meetings, Nice Things), Reviews
- **Efforts/** — Areas (of Effort), Projects (Active, Simmering, Sleeping), Works
- **+/** — Quick capture inbox for unprocessed notes
- **x/** — Templates, packs, visuals, and other system files

These skills work within this structure, automatically placing notes in the correct folders and creating appropriate metadata following the [Linking Your Thinking](https://www.linkingyourthinking.com/) framework.

---

## ⚡ Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/claude-code) CLI installed
- An Obsidian vault structured using the ACE Method (this fork expects Ideaverse Pro 2.5, from https://www.linkingyourthinking.com)
- The included `CLAUDE.md` copied to `<vault>/.claude/CLAUDE.md` (see Setup Guide below)

### Installation

Pick **one** route per agent. Installing more than one gives you every skill twice.

<details open>
<summary><strong>Claude Code plugin</strong> (updates when the plugin version changes)</summary>

```bash
claude plugin marketplace add switchspan/obsidian-ACE-method-skills
claude plugin install ace-method-skills@ace-method
```

Plugin skills are namespaced: `/ace-method-skills:web-capture`, `/ace-method-skills:create-knowledge`, `/ace-method-skills:vault-review`. Copy [`CLAUDE.md`](CLAUDE.md) to `<vault>/.claude/CLAUDE.md` yourself.

</details>

<details>
<summary><strong>Install script</strong> (Claude Code, Codex, any Agent Skills harness; best for a single vault)</summary>

```bash
git clone https://github.com/switchspan/obsidian-ACE-method-skills.git
cd obsidian-ACE-method-skills

./install.sh --vault ~/path/to/vault   # <vault>/.claude/skills + <vault>/.claude/CLAUDE.md (recommended)
./install.sh                           # ~/.claude/skills (all projects)
./install.sh --agents                  # ~/.agents/skills (Codex and other Agent Skills harnesses)
```

Add `--link` to symlink instead of copy, so `git pull` updates the install. Add `--dry-run` to preview, `--force` to replace existing copies, and `--uninstall` to remove. An existing `<vault>/.claude/CLAUDE.md` is never overwritten without `--force`.

</details>

<details>
<summary><strong>skills.sh</strong> (any other agent; editable copies, manual updates)</summary>

```bash
npx skills@latest add switchspan/obsidian-ACE-method-skills   # add -a <agent> to preselect: cursor, opencode, windsurf, amp, …
```

Update with `npx skills@latest update`. Copy `CLAUDE.md` to `<vault>/.claude/CLAUDE.md` yourself.

</details>

Then open your vault in your agent and try:

```
/web-capture https://example.com/article
/create-knowledge
/vault-review
```

---

## 🧠 CLAUDE.md — The Routing Document

The included [`CLAUDE.md`](CLAUDE.md) is the central configuration file that gives Claude Code a complete understanding of your Ideaverse vault. Put it at `<vault>/.claude/CLAUDE.md` and it will serve as the instruction layer between Claude and your knowledge system. Claude Code (and Claudian, which runs it inside Obsidian) loads it from there. Because Obsidian ignores dot-folders, it won't show up in search, the graph, or your Bases the way a root-level `CLAUDE.md` would.

**What it defines:**
- **Vault architecture** — The full ACE folder structure and what goes where
- **Navigation system** — How to use Maps of Content (MOCs) as the primary reference layer
- **Frontmatter conventions** — Required properties (`up`, `in`, `related`, `created`, `tags`, etc.) and their purpose
- **Templates** — Available note templates and their property presets
- **Bases** — How to read the `.base` dashboard files Claude can't run
- **Skill routing** — When and how to trigger each skill automatically
- **Rules** — The 11 core rules for working within the vault

This file is what makes the skills context-aware. Without it, the skills still work but won't know your specific vault structure, existing MOCs, or organizational conventions.

---

## 🛠️ Skills Overview

### 1. `/web-capture`

**Purpose:** Capture web content into your vault as structured knowledge notes.

**Use when:**
- You find an interesting article, blog post, or webpage
- You want to save reference material with proper context
- You need to extract and distill web content into your knowledge system

**What it does:**
- Fetches and extracts content from URLs
- Determines the appropriate vault location (Atlas/Dots, People, Things, etc.)
- Scans existing tags and MOCs for consistency
- Creates properly structured notes with complete frontmatter
- Links to related notes and concepts in your vault

**Example:**
```bash
claude /web-capture https://example.com/article-about-ai
```

---

### 2. `/create-knowledge`

**Purpose:** Transform any raw input into a structured vault note following ACE conventions.

**Use when:**
- Importing content from Notion, Apple Notes, OneNote, or other apps
- You have rough notes or meeting transcripts to process
- Cleaning up pasted text or unstructured information
- Creating notes from "I learned about X" moments

**What it does:**
- Handles multiple input formats (Notion exports, Apple Notes, meeting notes, raw text)
- Cleans up formatting and removes artifacts from other apps
- Determines note type and appropriate folder placement
- Scans for existing tags and MOCs to maintain consistency
- Structures content with headers, bullets, tables, and wikilinks
- Creates or updates frontmatter with proper metadata

**Supported input types:**
- Pasted text / raw notes
- Notion exports (markdown or plain text)
- Apple Notes content
- OneNote dumps
- Meeting notes and transcripts
- Freeform learning captures

---

### 3. `/vault-review`

**Purpose:** Audit and maintain the health of your Obsidian vault.

**Use when:**
- You want to check vault organization and health
- Looking for orphaned or disconnected notes
- Processing items in your inbox (`+/` folder)
- Finding opportunities to link related notes
- Checking for missing metadata or incomplete frontmatter
- Reviewing effort priorities and project status

**What it checks:**
1. **Inbox processing** — Unprocessed captures in `+/`
2. **Orphaned notes** — Notes without upward links or MOC placement
3. **Incomplete frontmatter** — Missing required properties (tags, dates, etc.)
4. **Effort intensity** — Projects that might need status updates
5. **Connection opportunities** — Notes that could be linked but aren't
6. **Tag consistency** — Duplicate or inconsistent tag usage

**Example output:**
```
# Vault Review — 2026-04-13

## Summary
- Inbox: 3 items to process
- Orphaned notes: 2
- Connection opportunities: 5

## Priority Actions
1. Process inbox items
2. Link "Machine Learning" with "AI Ethics" (shared tags)
3. Add MOC links to orphaned notes
```

---

## 📖 Setup Guide

To get the most out of these skills, set up your Obsidian vault with supporting files that help Claude understand your structure:

### 1. Copy `CLAUDE.md` to `<vault>/.claude/CLAUDE.md`

The included [`CLAUDE.md`](CLAUDE.md) describes the Ideaverse Pro 2.5 layout, frontmatter, templates, Bases, and tag families. Edit it to add your own topic MOCs and Areas of Effort.

### 2. Keep the Pro templates in place

The skills read `x/Templates/Collections/*.md` and `x/Templates/Master Keys/*.md` each time they create a note. If you customise a template, new notes follow your version automatically.

### 3. Maintain a Library.md MOC

Keep a `Atlas/Maps/Library.md` file that explains your LYT Classification System (the 000-900 organization categories). This helps the skills place notes correctly.

---

## 🙏 Credits

This project builds on the excellent work of:

### Jake Van Clief — File-System Architecture with Claude
Jake pioneered best practices for using Claude Code with file-based knowledge systems. His approach to structuring repositories and using `CLAUDE.md` files forms the foundation of these skills.

- **Video:** [File-System Architecture with Claude](https://www.youtube.com/watch?v=MkN-ss2Nl10&t=6s)
- **Community:** [Quantum Quill Lyceum on Skool](https://www.skool.com/quantum-quill-lyceum-1116)

### Nick Milo — Ideaverse and the ACE Method
Nick created the ACE Method and the Linking Your Thinking framework, which provides the organizational structure these skills implement.

- **Video:** [The ACE Method Introduction](https://www.youtube.com/watch?v=z4AbijUCoKU&t=392s)
- **Website:** [Linking Your Thinking](https://www.linkingyourthinking.com/)

---

## 💡 Tips for Effective Use

1. **Start with `/web-capture`** when you find something worth saving online
2. **Use `/create-knowledge`** to process rough notes or imports from other systems
3. **Run `/vault-review`** weekly to maintain vault health and discover connections
4. **Let Claude explore your vault first** — it will learn your existing tags, MOCs, and organizational patterns
5. **Always review and confirm** before Claude makes changes — you know your knowledge system best

---

## 🤝 Contributing

Found a bug? Have an improvement? Feel free to:
- Open an issue describing the problem or enhancement
- Submit a pull request with your changes
- Share your experience using these skills

---

## 📄 License

MIT License - feel free to use, modify, and distribute these skills as needed.

---

## 🔗 Related Resources

- [Obsidian](https://obsidian.md) — The knowledge base app
- [Linking Your Thinking](https://www.linkingyourthinking.com/) — Nick Milo's LYT framework
- [Claude Code](https://claude.ai/claude-code) — Anthropic's CLI for Claude
- [Quantum Quill Lyceum](https://www.skool.com/quantum-quill-lyceum-1116) — Community for Claude-powered knowledge work

---

**Happy knowledge building! 🌱**
