---
name: create-knowledge
description: Create a structured note in an Ideaverse Pro 2.5 Obsidian vault from any input — pasted text, rough notes, Notion exports, Apple Notes, OneNote content, clipboard dumps, meeting notes, or freeform context the user provides. Use this skill whenever the user wants to add knowledge to their vault, asks to "create a note", "save this", "add this to my knowledge base", imports content from another app, or provides raw information that should become a vault note. Also triggers when the user pastes a block of text and wants it structured, or says things like "turn this into a note", "clean this up for my vault", "log this idea", "new project", or "I learned something about X".
---

# Create Knowledge (Ideaverse Pro 2.5)

Turn any user-provided content into a properly structured note in an Ideaverse Pro 2.5 vault.

Pro 2.5 essentials:
- Notes join collections with the **`collections`** property (not `in`). Obsidian **Bases** (`Atlas/Maps/Bases/*.base`) build views from folders and properties, so the right folder is what matters most, with `collections` second.
- Most note types have a template in `x/Templates/Collections/`. **Read the template, then read two or three sibling notes in the target folder. Where they disagree, follow the siblings.**
- Every note has `up`, `related`, `created`. Many Dots (Statements, Things, Questions) have nothing more, and that is normal. Add `collections`, `tags`, `rank`, and `wayfinder` only when the template or siblings use them.

## Input Types This Skill Handles

| Input | How to handle |
|---|---|
| **Pasted text / raw notes** | Structure and distill directly |
| **Notion export** | Strip database property text, toggle syntax, UUID links; restructure |
| **Apple Notes paste** | Rebuild headings and checklists (formatting is usually lost) |
| **OneNote paste** | Flatten deep nesting, drop formatting artifacts |
| **Meeting notes / transcript** | Extract decisions, action items, key points → a Meeting record |
| **Freeform "I learned about X"** | Ask what was learned; optionally research; build a Dot |
| **A quick idea** | An Idea record in Calendar |
| **Multiple fragments** | Ask whether to make one combined note or several |

## Workflow

### Step 1: Understand the Content

Identify the subject, the note type (Step 2), and whether the user wants it kept short or expanded. Ask if anything is ambiguous, e.g.:
- "Is this a standalone idea for the Atlas, or part of one of your projects?"
- "This mentions [X]. Should [X] get its own note?"

### Step 2: Pick Folder and Template

| Note type | Folder | Template (`x/Templates/Collections/` unless noted) |
|---|---|---|
| **Thing**: tool, reference, how-to, cheatsheet, concept | `Atlas/Dots/Things/` | `Concepts Template.md` for concepts (`collections: [[Concepts]]`); otherwise `x/Templates/Base 1 Template (up, related, created).md` |
| **Statement**: claim, opinion, principle (title is the claim) | `Atlas/Dots/Statements/` | `x/Templates/Base 1 Template (up, related, created).md` |
| **Person** | `Atlas/Dots/People/` | `People Template.md` |
| **Group** (team, org, community) | `Atlas/Dots/x/Groups/` | `Groups Template.md` |
| **Question** | `Atlas/Dots/Questions/` | `Questions Template.md` |
| **Quote** | `Atlas/Dots/Quotes/` | `Quotes Template.md` |
| **Source** (article, book, course, talk, paper) | `Atlas/Sources/<type>/` | see the `web-capture` skill's table |
| **Map of Content** | `Atlas/Maps/` | `Map Template (MOC).md` (or `Map Template (Collections).md` for a collection map) |
| **Area of Effort**: ongoing responsibility | `Efforts/Areas/AOE/` for the AOE note; notes belonging to an area go in `Efforts/Areas/<Area>/` | `Areas of Effort Template (AOE).md`; siblings use `up: [[Efforts]]`, `collections: [[Areas]]` |
| **Project**: finite outcome | `Efforts/Projects/Active/` (new projects), or `Simmering/` / `Sleeping/` | `Projects Template.md` |
| **Work**: article, newsletter, video you are making or have published | `Efforts/Works/<Articles\|Newsletters\|Videos>/` | `Works Template.md`; published works also carry `title`, `medium`, `URLs`, `published` |
| **Daily note** | `Calendar/Days/YYYY-MM-DD.md` | `x/Templates/Daily Template.md` |
| **Idea** (quick, dated) | `Calendar/Records/Ideas/YYYY-MM-DD <title>.md` | `Ideas Template.md` |
| **Meeting** | `Calendar/Records/Meetings/YYYY-MM-DD <title>.md` | `Meetings Template.md` |
| **Event** | `Calendar/Records/Events/` | `Events Template.md` |
| **Unprocessed capture** | `+/` | `x/Templates/Base 1 Template (up, related, created).md` |

If a folder or template is missing, list `x/Templates/Collections/` and the parent folder, choose the closest match, and tell the user.

Templates contain placeholders like `"{{date}}"` or `{{DATE:YYYY-MM-DD}}`. Replace them with real values (`created: YYYY-MM-DD`, today's date). Don't copy placeholder syntax into the note.

### Step 3: Choose `up`, `collections`, Tags, and Links

- **`collections`**: use the template's default (e.g. `[[People]]`, `[[Projects]]`, `[[Ideas]]`). Add another collection only if the user asks for one or sibling notes do (Sources usually also carry `[[Sources]]`). Leave it out for plain Statements and Things.
- **`up`**: the note's parent:
  - Dots and Sources: the best topic MOC. Read `Atlas/Maps/Maps.md` and `Atlas/Maps/Library.md` (LYT Classification 000–900) to choose (e.g. `[[AI MOC]]`, `[[PKM Map]]`).
  - Projects and Works: the Area of Effort they belong to (e.g. `[[Viking Sasquatch]]`, `[[KLW LLC]]`). List `Efforts/Areas/` to find it.
  - Areas: `[[Areas]]` or a parent AOE.
  - Daily notes and Calendar records: empty is normal; link the project or area in the body or `related` if relevant.
  - If nothing fits, leave it empty and mention that a new MOC might be warranted. Don't create MOCs automatically.
- **`rank`**: for Projects, Areas, Works, and Maps, ask the user or suggest one by comparing with siblings' ranks. Higher means more important in the PROJECTS base, which sorts by rank descending.
- **Tags**: Ideaverse Pro uses tags mainly for *state*, while links carry topics. Keep any template default tags. Add topic tags only if the user's vault already uses them, reusing existing ones (Grep for lines under `tags:` in `Atlas/`, `Efforts/`, `Calendar/`), at most 1–2 new, lowercase and hyphenated. Tags are plain strings, never wikilinks or sentences.
- **State tags** (from `x/Templates/Master Keys/`), suggested when they fit and never added silently:
  - Garden: `garden/plant` (new note to grow), `garden/cultivate`, `garden/question`, `garden/probe`, `garden/repot`, `garden/revitalize`, `garden/revisit`
  - Architect, for maps: `architect/build`, `architect/renovate`
  - Output: `output/article☑️`, `output/youtube☑️` (a Dot that has been turned into a published Work)
- **`related`**: existing notes this connects to. Search before linking.

### Step 4: Build the Note

Example for a Thing:

```markdown
---
up:
  - "[[<topic MOC>]]"
related:
  - "[[<related note>]]"
created: <today YYYY-MM-DD>
---

<Lead paragraph: what this is and why it matters.>

## <Section>
...
```

Example for a Project:

```markdown
---
up:
  - "[[<Area of Effort>]]"
related: []
created: <today YYYY-MM-DD>
collections:
  - "[[Projects]]"
wayfinder:
tags:
  - <topic tag>
rank: <n>
---

<Goal of the project in one or two sentences.>

## Current state
## Next actions
- [ ] ...
```

### Step 5: Structure the Content

- **Distill, don't dump.** Rewrite for clarity and cut filler.
- **Lead with the essence.** The first paragraph says what the note is about and why it matters.
- **Use headers.** H2 for sections, H3 for subsections. Never a flat wall of text.
- **Lists and tables** for enumerable or structured data.
- **Wikilink generously** to existing notes. Check before linking.
- **Preserve specifics**: numbers, dates, names, quotes, and code stay exact.

### Step 6: Import-Specific Cleanup

**Notion:** strip property blocks rendered as text; turn toggles into Obsidian callouts (`> [!note]+ Title`); replace UUID links with `[[wikilinks]]` or plain text.

**Apple Notes:** rebuild the heading hierarchy; convert checklists to `- [ ]`; mark lost images as `[Image: description]` and ask if the user wants to add them.

**OneNote:** flatten nesting deeper than 2–3 levels; convert OneNote tags to vault tags; strip invisible formatting.

**General:** fix broken links, normalize heading levels (no starting at H4), remove excess blank lines, keep list formatting consistent.

### Step 7: Confirm with the User

Before writing, present:
1. File name
2. Folder
3. Frontmatter
4. First paragraph plus section headers

Apply adjustments, then write the file.

## Handling Multiple Notes

For a large dump covering several topics:
1. Identify the distinct topics.
2. Propose the split: file names, folders, and note types.
3. Get approval.
4. Create the notes one at a time and link them to each other via `related` and body wikilinks.

## When the User Says "I Learned About X"

1. Ask what specifically they learned or want captured.
2. If they want it built out, do light research (WebSearch if needed) and draft the note.
3. Clearly separate the user's own input from content you added, so they can check it.
