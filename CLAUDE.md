# Ideaverse Pro 2.5 — Claude Configuration

This is a personal knowledge management (PKM) vault in Obsidian, built on **Ideaverse Pro 2.5**: Nick Milo's **ACE Folder Framework** and **Linking Your Thinking (LYT)** methodology. Dashboards use Obsidian **Bases**, not Dataview.

## Vault Architecture (ACE)

```
Home.md / Home Base.md / Home Pro.md   ← Launchpads
+/                       ← Inbox: quick captures before processing
Atlas/                   ← Knowledge
  Maps/                  ← Maps of Content (MOCs) and collection maps
    Bases/               ← .base files (ATLAS, DOTS, SOURCES, EFFORTS, PROJECTS, CALENDAR, ORPHANAGE, …)
  Dots/                  ← Atomic notes
    People/  Questions/  Quotes/  Statements/  Things/
    x/Groups/  x/PKM/    ← Groups; archived/system dots
  Sources/               ← What you consumed
    Books/ Clippings/ Courses/ Games/ Movies/ Papers/ Songs/ Talks/ TV/  x/
Calendar/                ← Time
  Days/                  ← Daily notes: YYYY-MM-DD.md
  Records/               ← Events/ Ideas/ Meetings/ Nice Things/
  Reviews/               ← Periodic reviews
Efforts/                 ← Action
  Areas/                 ← Areas of Effort (AOE/ holds top-level AOEs; subfolders per area)
  Projects/              ← Active/ Simmering/ Sleeping/
  Works/                 ← Articles/ Newsletters/ Videos/
x/                       ← System: Templates/, Packs/, Visuals/, x/ (Prompts, Scripts)
```

A folder named `x` inside a section is that section's archive or system space.

## Navigation: Use the Maps

- **Launchpads**: `Atlas/Maps/Home.md`, `Home Base.md` (links to every Base view), `Home Pro.md`
- **Index of maps**: `Atlas/Maps/Maps.md`
- **Classification**: `Atlas/Maps/Library.md` (LYT Classification System, 000–900)
- **Section maps**: `Atlas.md`, `Dots.md`, `Sources.md`, `Calendar.md`, `Efforts.md`, `Areas.md`, `Projects.md`, `Works.md`
- **Topic MOCs** (examples): `AI MOC`, `PKM Map`, `Thinking Map`, `Infrastructure MOC`, `Philosophy MOC`, `People Map`, `Life Map`
- **Garden workflow**: `Garden.md` → `Plant`, `Cultivate`, `Question`, `Repot`, `Revitalize`, `Revisit`; `Architect.md` → `Build`, `Renovate`

Don't maintain a separate reference index. The Maps and Bases are the reference system.

## Bases

Dynamic views are `.base` files in `Atlas/Maps/Bases/`. Claude can't run them, but they are plain YAML. Read a `.base` file to learn which folders, properties, and filters a view uses, then search the files directly to reproduce its results. Key Bases:

- `PROJECTS.base`: `Efforts/Projects/*`, grouped by folder, sorted by `rank` descending
- `EFFORTS.base`: Areas, Projects, Works
- `SOURCES.base`, `DOTS.base`, `MAPS.base`, `CALENDAR.base`
- `ORPHANAGE.base`: notes with no outlinks or no backlinks, and placeholder (uncreated) links
- `+.base`: the inbox

## Frontmatter Conventions

| Property | Purpose | Example |
|---|---|---|
| `up` | Parent (topic MOC, a Dot it supports, or the Area for an Effort; often empty on Days, Records, Clippings) | `- "[[AI MOC]]"` |
| `related` | Lateral connections | `- "[[n8n]]"` |
| `created` | Creation date | `2026-11-23` |
| `collections` | Collection membership (replaces the older `in`) | `- "[[Projects]]"` |
| `wayfinder` | Optional wayfinding links | |
| `tags` | Tags: plain lowercase strings | `- ai` |
| `rank` | Priority / importance (Efforts, Maps) | `3` |
| `mapState` | Map maturity marker (Maps) | `- 🟨` |

Only `up`, `related`, `created` are universal. Plain Statements and Things usually have nothing more. Type-specific properties: Clippings use `title`, `source`, `author`, `published`, `description`, `year` (the template says `by`, but clipped notes use `author`); Books, Talks, and Courses use `by`, `year`, `yearXP`, `URLs`; Papers use `people`, `year`, `yearXP`; Works use `title`, `medium`, `URLs`, `published`, `WIPstatus`; Meetings use `groupMeetings`, `one-liner`; People use `peopleType`, `peopleGroups`, `lifespan`, ….

**When a template and existing notes disagree, follow the existing notes in that folder.**

### Tag families
Ideaverse Pro uses tags mainly for *state*, and links for topics.
- Garden tags (`x/Templates/Master Keys/Master Key (Garden Tags).md`): `garden/plant`, `garden/cultivate`, `garden/probe`, `garden/repot`, `garden/revitalize`, `garden/revisit`, `garden/question`
- Architect tags: `architect/build`, `architect/renovate`
- Output tags: `output/article☑️`, `output/youtube☑️`
- Topic tags (optional, this vault uses some): lowercase and hyphenated (`ai`, `foundryvtt`). Reuse before creating.
- Clippings carry the tag `clippings`.

## Templates

- Base templates in `x/Templates/`: `Base 1 Template (up, related, created)`, `Base 2 add-on (collections, wayfinder, tags)`, `Base 3 add-on (rank)`, `Base 4 Template (all)`, `Daily Template`
- Per-type templates in `x/Templates/Collections/`: People, Groups, Questions, Quotes, Concepts, Ideas, Clippings, Books, Courses, Movies, TV, Songs, Events, Meetings, Projects, Areas of Effort (AOE), Works, Map (MOC / Collections / View), and more
- Master Keys in `x/Templates/Master Keys/`: canonical tag and property sets

**Before creating a note, read its template and two or three sibling notes.** Replace placeholders (`{{date}}`, `<% … %>`) with real values. QuickAdd routes: Quote → `Atlas/Dots/Quotes`, Person → `Atlas/Dots/People`, Clipping → `Atlas/Sources/Clippings`, Event/Idea/Meeting/Nice Thing → `Calendar/Records/<type>`, AOE → `Efforts/Areas/AOE`, Project → `Efforts/Projects/Active`, Work → `Efforts/Works`.

## Skills

| Skill | Trigger | What it does |
|---|---|---|
| `web-capture` | User shares a URL or says "save/capture/clip this" | Fetches the URL → Source note in `Atlas/Sources/<type>/` from the matching template |
| `create-knowledge` | User pastes content, imports from another app, logs an idea/meeting, starts a project | Any input → the right note type, folder, and template |
| `vault-review` | "Review my vault", "what needs attention", "clean up" | Inbox, orphans (ORPHANAGE rules), frontmatter, efforts, connections, placeholder links, tags |

Shared behaviors:
- Reuse existing tags before creating new ones.
- Use `Atlas/Maps/Maps.md` and `Library.md` to pick the `up` MOC.
- Confirm file name, location, and frontmatter with the user before writing.
- Distill content. Never paste raw source material into a note.

## Rules for Working in This Vault

1. **Respect ACE**: Atlas = knowledge, Calendar = time, Efforts = action.
2. **Use the template** for the note type; always include frontmatter.
3. **`collections`, not `in`**: it decides which collection maps and Bases a note appears in.
4. **Link liberally** with `[[wikilinks]]`, the core of LYT.
5. **`up` for hierarchy**: Dots/Sources → a topic MOC; Projects/Works → their Area of Effort.
6. **New MOCs go in `Atlas/Maps/`** with `collections: - "[[Maps]]"`.
7. **Sources go in `Atlas/Sources/<type>/`**. Atomic ideas go in `Atlas/Dots/<type>/`.
8. **Quick captures go in `+/`** to be processed later.
9. **Projects move between `Active/`, `Simmering/`, and `Sleeping/`** as priority changes.
10. **System files stay in `x/`.**
11. **Use the skills proactively** when a request matches one.
