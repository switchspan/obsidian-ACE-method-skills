---
name: web-capture
description: Capture a web article or URL into an Ideaverse Pro 2.5 Obsidian vault as a properly structured Source note. Use this skill whenever the user shares a URL, link, or web page and wants to save it, capture it, take notes on it, or add it to their knowledge base. Also use when the user says things like "save this article", "add this to my vault", "capture this page", "clip this", or pastes a URL and asks to process it. This skill handles the full workflow — fetching, extracting, structuring, tagging, and placing the note in the correct Atlas/Sources folder.
---

# Web Capture (Ideaverse Pro 2.5)

Capture a web URL into the vault as a Source note, following Ideaverse Pro 2.5 conventions.

In Pro 2.5, web captures are **Sources**, not Dots. They live under `Atlas/Sources/<type>/`, and they join a collection through the `collections` property (not `in`). If the capture describes a lasting thing (a tool, a person) that deserves its own Dot, offer to create one too and link the two.

## Workflow

### Step 1: Fetch and Extract

1. Use `WebFetch` to retrieve the page content.
2. Extract:
   - **Title**: the article/page title, cleaned of site suffixes like " | Medium"
   - **Author(s)**
   - **Date published**
   - **Description**: one or two sentences (the page's meta description if it is good)
   - **Core content**: the main body, without navigation, ads, or footers
   - **Key images**: reference by original URL in markdown image syntax. Do NOT download images unless the user asks.
   - **Source type**: one of the rows in the Step 2 table

### Step 2: Pick the Folder and Template

| Source type | Folder | Template in `x/Templates/Collections/` | `collections` |
|---|---|---|---|
| Article, blog post, web page, tool/product page, GitHub repo, docs | `Atlas/Sources/Clippings/` | `Clippings Template.md` | `[[Clippings]]` |
| Book | `Atlas/Sources/Books/` | `Books Template (Book Search).md` | `[[Books]]`, `[[Sources]]` |
| Course | `Atlas/Sources/Courses/` | `Courses Template.md` | `[[Courses]]`, `[[Sources]]` |
| Talk, lecture, conference video | `Atlas/Sources/Talks/`, named `<Title> (talk).md` | `x/Templates/Base 4 Template (all).md` | `[[Speeches]]`, `[[Sources]]` |
| Paper / academic | `Atlas/Sources/Papers/`, named `<Title> - <First author> et al (paper).md` | `x/Templates/Base 4 Template (all).md` | `[[Papers]]`, `[[Sources]]` |
| Movie / TV | `Atlas/Sources/Movies/` or `Atlas/Sources/TV/` | `Movies Template (Backup).md` / `TV Template (Backup).md` | per template |

**Always read the chosen template file** before building the note. Its frontmatter keys, default tags, and default `collections` are the starting point. Do not invent keys that neither the template nor sibling notes use.

Talks and Papers have no dedicated template. Use the Base template plus the properties sibling notes use: `by` (list), `year` (published), `yearXP` (year you encountered it), and `URLs` (list) for talks; `people` (list of authors), `year`, and `yearXP` for papers.

If the folder or template is missing in this vault, list `Atlas/Sources/` and `x/Templates/Collections/` and pick the closest match, telling the user what you chose.

### Step 3: Match Sibling Notes

Read two or three existing notes in the target folder. **When sibling notes and the template disagree, follow the sibling notes.** They show how the vault actually works, and the Bases filter on what notes actually contain.

Known case: the Clippings Template lists `by:` and tag `x/clippings`, but clippings in Ideaverse Pro 2.5 (and those made with the Obsidian Web Clipper) use `author:` and tag `clippings`, plus a `year:`. Follow the siblings, and mention the mismatch once so the user can fix the template if they like.

### Step 4: Choose `up`, Tags, and Links

- **`up`**: the map or note this source feeds. Read `Atlas/Maps/Maps.md` and `Atlas/Maps/Library.md`, then pick the best topic MOC (e.g. `[[AI MOC]]`, `[[PKM Map]]`). `up` may also point at a Dot the source supports (the example vault links a paper `up` to the statement it backs). For quick clippings, an empty `up` is normal in Ideaverse Pro: suggest one, but leave it empty if the user doesn't care. Do not create a MOC automatically.
- **Tags**: keep the folder's usual tag (e.g. `clippings`). Ideaverse Pro uses tags mainly for *state* (`garden/*`, `output/*`) rather than topics, and links handle topics. Add topic tags only if the user's vault already uses them (Grep for lines under `tags:`), reusing existing ones, at most 1–2 new.
- **`related`**: existing Dots or Efforts this source connects to (e.g. a tool's Dot in `Atlas/Dots/Things/`, an active project in `Efforts/Projects/Active/`). Search before linking.
- **`wayfinder`**: leave empty unless the user uses it for this kind of note (check sibling notes).

### Step 5: Build the Note

Use the template frontmatter, filled in. A Clippings note typically looks like:

```markdown
---
up:
  - "[[<topic MOC>]]"
related:
  - "[[<related note>]]"
created: <today YYYY-MM-DD>
collections:
  - "[[Clippings]]"
wayfinder:
tags:
  - clippings
title: "<clean title>"
source: "<original URL>"
author:
  - "[[<author>]]"
published: <YYYY-MM-DD if known>
description: "<one or two sentences>"
year: <publication year>
---

<Concise summary: what this is and why it matters. Distill, don't transcribe.>

## Key Takeaways

<3–7 bullets>

## Notes

<Connections to other notes in the vault, your observations, relevant images.>
```

Body guidelines:
- **Be concise**: distill the author's points in your own words.
- **Preserve key data**: numbers, dates, names, quotes, code stay exact.
- **Wikilink generously**: link concepts, people, and tools that exist (or should exist) in the vault. Check before linking.
- **Structure**: H2 for sections, H3 for subsections, tables for comparisons, code blocks for code.
- For non-article pages (repos, product pages, docs), replace "Key Takeaways" with "Overview" / "Features".

### Step 6: Offer a Companion Dot (optional)

If the page is about a lasting tool, person, or concept that has no Dot yet, offer to create one in `Atlas/Dots/Things/`, `Atlas/Dots/People/`, etc. (use the `create-knowledge` skill's conventions), and link the Source and the Dot via `related`.

### Step 7: Confirm with the User

Before writing, present:
1. File name and folder
2. Frontmatter
3. A short preview of the body

Apply adjustments, then write the file.

## Edge Cases

- **Paywalled content**: tell the user, ask them to paste the text, then continue with the `create-knowledge` workflow.
- **Multiple URLs**: process one at a time, confirming each.
- **PDF URL**: use the Read tool if possible, or ask the user to paste key sections. File it under `Atlas/Sources/Papers/` if it is a paper.
- **Already captured**: search `Atlas/Sources/` for the same `source` URL first. If it exists, offer to update that note instead.
