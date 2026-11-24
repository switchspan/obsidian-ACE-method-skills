---
name: vault-review
description: Review and maintain an Ideaverse Pro 2.5 Obsidian vault — find orphaned notes, missing or malformed frontmatter, unprocessed inbox items, placeholder links, stale projects, and suggest new connections between notes. Use this skill when the user asks to "review my vault", "clean up my notes", "find orphans", "check my inbox", "what needs attention", "audit my vault", or any request about vault health, maintenance, hygiene, or organization. Also use when the user asks things like "what's in my inbox", "are there notes that need linking", or "help me process my captures".
---

# Vault Review (Ideaverse Pro 2.5)

Audit the vault for health, completeness, and connection opportunities. This is the "gardening" skill.

Pro 2.5 builds its dashboards with Obsidian **Bases** (`Atlas/Maps/Bases/*.base`), not Dataview. You can't run Bases, but they are readable YAML. Where a check below mirrors a Base (e.g. ORPHANAGE), read that `.base` file first and apply the same filters by searching files directly, so your results match what the user sees in Obsidian.

**Always skip** `.obsidian/`, `.claude/`, any other dot-folders, `x/` (system: templates, packs, visuals), and folders named `x` inside Atlas/Calendar/Efforts (archives), unless the user asks for them.

## Review Modes

- **Full review**: run all checks and present one consolidated report.
- **Targeted review**: run only the checks the user asked about.

---

## Check 1: Inbox (`+/`)

List every note in `+/`. For each one:
1. Read it.
2. Suggest a destination using the `create-knowledge` folder table (Dots/Things, Dots/Statements, Sources/Clippings, Calendar/Records/Ideas, Efforts/Projects/…).
3. Suggest `up`, `collections`, and tags.
4. Ask before processing (move, fill in the template frontmatter, restructure).

```
## Inbox (`+/`)
- X note(s) waiting
  - "Note Title" → Atlas/Dots/Things/, up: [[AI MOC]], collections: —, tags: [ai]
```

## Check 2: Orphans and Unlinked Notes

Mirror `Atlas/Maps/Bases/ORPHANAGE.base`:
- **Orphan**: no outlinks AND no backlinks. Outlinks include wikilinks in frontmatter (`up`, `related`, `collections`) as well as the body.
- **No outlinks**: links to nothing, even if something links to it.

How to check:
1. For each `.md` in `+/`, `Atlas/`, `Calendar/`, `Efforts/` (excluding the skip list and anything with "Readwise" in its path), find outlinks: any `[[...]]` in the file.
2. For notes with no outlinks, search the vault for `[[<basename>` or `[[<path>|` to find backlinks.
3. Also flag Dots, Books/Talks/Papers/Courses, Projects, and Works with an empty `up`. They aren't orphans, but they're unanchored. Don't flag Calendar notes or Clippings: an empty `up` is normal for them in Ideaverse Pro.
4. Suggest an `up` (topic MOC for Dots/Sources, Area of Effort for Projects/Works) and any `related` links.

```
## Orphans
- "Note Title" (Atlas/Dots/Things) — no in/out links → suggest up: [[Infrastructure MOC]]
## Unanchored (empty `up`)
- "Note Title" (Atlas/Sources/Clippings) → suggest up: [[AI MOC]]
```

## Check 3: Frontmatter

Baseline every note should have: `up`, `related`, `created` (the keys may be empty). Beyond that, compare against what sibling notes in the same folder use, and the template where siblings are few. Expectations from a stock Ideaverse Pro 2.5 vault:

| Folder | Expected beyond the baseline |
|---|---|
| Atlas/Dots/Statements, Things, Questions | nothing more. Don't flag missing `collections`/`tags`; concepts may have `collections: [[Concepts]]` |
| Atlas/Dots/People | `collections: [[People]]` |
| Atlas/Sources/Clippings | `collections: [[Clippings]]`, `title`, `source`, `author`, `published`, `description` |
| Atlas/Sources/Books, Courses, Talks, Papers | `collections` (type + `[[Sources]]`), `year`, and `by` or `people` |
| Atlas/Maps | `collections` containing `[[Maps]]`; usually `rank` and `mapState` |
| Efforts/Areas/AOE | `collections: [[Areas]]`, `rank` |
| Efforts/Projects/* | `rank`; usually `collections: [[Projects]]` |
| Efforts/Works/* | `collections: [[Works]]` |
| Calendar/Days | nothing more |
| Calendar/Records/* | `collections` for the record type (`[[Ideas]]`, `[[Meetings]]`, …) |

Also flag **malformed** frontmatter:
- Legacy `in:` used instead of `collections:` → suggest renaming the key.
- `collections` as a bare string instead of a list (`collections: "[[Clippings]]"`) → suggest the list form.
- `tags` entries that aren't tags: sentences, wikilinks (`"[[Matt Pocock]]"`), emoji status markers, or a leading `#`.
- Placeholder text left from templates (`{{date}}`, `<% ... %>`, `BLANK`).
- Notes whose keys differ from their siblings (e.g. one clipping using `by:` where the others use `author:`). Report these as a convention question, not an error. A whole folder differing from its template (clippings using `author:` while the template says `by:`) is stock Ideaverse behaviour: mention it at most once.

```
## Frontmatter
- "Note Title" — missing: `up`, `collections` → suggest up: [[PKM Map]], collections: [[Concepts]]
- "Note Title" — `tags` contains a sentence ("The situation is…") → move to body
```

## Check 4: Efforts

Mirror `Atlas/Maps/Bases/PROJECTS.base` and `EFFORTS.base`:

1. **Projects/Active**: list with `rank` and last-modified date. Ask whether each is still active. Flag ones not modified in 30+ days.
2. **Projects/Simmering**: should any move to Active or Sleeping?
3. **Projects/Sleeping**: anything to revive? Should any be marked done or dropped?
4. **Areas**: list AOEs. Flag Projects/Works whose `up` doesn't point to an Area.
5. **Works**: list them by `WIPstatus` if present.
6. Flag Efforts missing `rank`.

Moving a project means moving the file between `Efforts/Projects/Active|Simmering|Sleeping/`. Ask first.

```
## Efforts
### Active Projects
- "Project" (rank 3, modified 2026-11-22, up: [[Viking Sasquatch]])
### Simmering
- "Project" — revive or sleep?
### Areas
- Viking Sasquatch: 2 projects, 1 area note
```

## Check 5: Connection Opportunities

The highest-value check. For notes in `Atlas/Dots/` and `Atlas/Sources/`:
1. Read content and tags.
2. Find notes with overlapping tags, the same `up`, or shared topics.
3. If they don't already link each other (`related` or body wikilinks), suggest the link.
4. Find unlinked mentions: body text naming an existing note's title (or alias) without a `[[wikilink]]`.
5. Find Sources with no companion Dot when the Source describes a lasting tool or person, and Dots with no Source behind them when one exists.

```
## Connections
- "Herdr" (Sources/Clippings) ↔ "Herdr" (Dots/Things) — already linked ✓
- "Note A" mentions "n8n" without linking [[n8n]]
```

## Check 6: Placeholder Links

Mirror ORPHANAGE's "Placeholder/Uncreated notes" view: find `[[wikilinks]]` that point to notes that don't exist. Group them by target. Targets linked from several notes are good candidates for new notes; one-off targets may be typos.

## Check 7: Tags

- Count unique tags in use.
- Tags used once: possible typos or candidates for consolidation.
- Near-duplicates: `ai`/`AI`, `clippings`/`x/clippings`, `#source/course`/`source/course`.
- State tags (`garden/*`, `architect/*`, `output/*`): list the notes under each so the user can work through them (the `Garden` and `Architect` maps cover the same ground). Suggest `garden/plant` notes that look mature for promotion to `garden/cultivate`.

---

## Output: The Review Report

```
# Vault Review — <today YYYY-MM-DD>

## Summary
- Inbox: X
- Orphans: X (unanchored: Y)
- Frontmatter issues: X
- Efforts needing attention: X
- Connection opportunities: X
- Placeholder links: X
- Tag issues: X

## Priority Actions
1. ...
2. ...

## Details
<each check's findings>
```

Then ask which items to address, and work through them one at a time, confirming each change.

## Don't Auto-Fix

This skill is diagnostic first. Get approval before modifying files. A note that looks orphaned may be standalone on purpose, and a convention that differs from the template may be deliberate.

Exception: if the user says "fix everything" or "just clean it all up", proceed, then summarize every change you made.
