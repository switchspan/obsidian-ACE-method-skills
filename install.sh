#!/usr/bin/env bash
set -euo pipefail

# Install the Ideaverse Pro 2.5 skills into agent skill folders.
#
#   ./install.sh                         # copy into ~/.claude/skills
#   ./install.sh --agents                # copy into ~/.agents/skills (Codex and other Agent Skills harnesses)
#   ./install.sh --claude --agents       # both
#   ./install.sh --vault ~/Documents/ideaverse
#                                        # install into <vault>/.claude/skills and copy CLAUDE.md to <vault>/.claude/
#   ./install.sh --link ...              # symlink instead of copy, so `git pull` updates the install
#   ./install.sh --uninstall ...         # remove these skills from the chosen targets
#   ./install.sh --dry-run ...           # show what would happen
#
# Without --force, an existing skill folder that is not a symlink is left alone,
# and an existing <vault>/.claude/CLAUDE.md is never overwritten.

REPO="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO/skills"

usage() { sed -n '4,17p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

claude=0; agents=0; vault=""; link=0; force=0; uninstall=0; dry=0
while [ $# -gt 0 ]; do
  case "$1" in
    --claude) claude=1 ;;
    --agents) agents=1 ;;
    --vault) [ $# -ge 2 ] || { echo "error: --vault needs a path" >&2; exit 2; }; vault="$2"; shift ;;
    --vault=*) vault="${1#--vault=}" ;;
    --link) link=1 ;;
    --force) force=1 ;;
    --uninstall) uninstall=1 ;;
    --dry-run) dry=1 ;;
    -h|--help) usage 0 ;;
    *) echo "error: unknown option $1" >&2; usage 2 ;;
  esac
  shift
done

# Default target: Claude Code user skills.
if [ "$claude" = 0 ] && [ "$agents" = 0 ] && [ -z "$vault" ]; then claude=1; fi

run() { if [ "$dry" = 1 ]; then echo "  would run: $*"; else "$@"; fi; }

dests=()
[ "$claude" = 1 ] && dests+=("$HOME/.claude/skills")
[ "$agents" = 1 ] && dests+=("$HOME/.agents/skills")
if [ -n "$vault" ]; then
  vault="${vault/#\~/$HOME}"
  [ -d "$vault" ] || { echo "error: vault not found: $vault" >&2; exit 1; }
  vault="$(cd "$vault" && pwd)"
  [ -d "$vault/.obsidian" ] || echo "warning: $vault has no .obsidian folder; is it an Obsidian vault?" >&2
  dests+=("$vault/.claude/skills")
fi

names=()
while IFS= read -r -d '' skill_md; do
  names+=("$(basename "$(dirname "$skill_md")")")
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -print0 | sort -z)
[ "${#names[@]}" -gt 0 ] || { echo "error: no skills found in $SKILLS_DIR" >&2; exit 1; }

for dest in "${dests[@]}"; do
  # Refuse to write into this repo through a symlinked destination.
  if [ -e "$dest" ]; then
    case "$(readlink -f "$dest")" in
      "$REPO"|"$REPO"/*) echo "error: $dest resolves into this repo; remove it first." >&2; exit 1 ;;
    esac
  fi
  echo "$dest"
  [ "$uninstall" = 1 ] || run mkdir -p "$dest"

  for name in "${names[@]}"; do
    src="$SKILLS_DIR/$name"; target="$dest/$name"

    if [ "$uninstall" = 1 ]; then
      if [ -L "$target" ]; then run rm "$target"; echo "  removed $name"
      elif [ -d "$target" ]; then
        if [ -f "$target/SKILL.md" ] && grep -q "^name: $name\$" "$target/SKILL.md"; then run rm -rf "$target"; echo "  removed $name"
        else echo "  skipped $name (not ours)"; fi
      fi
      continue
    fi

    if [ -e "$target" ] && [ ! -L "$target" ] && [ "$force" = 0 ]; then
      echo "  skipped $name (a folder already exists; re-run with --force to replace it)"
      continue
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then run rm -rf "$target"; fi
    if [ "$link" = 1 ]; then run ln -s "$src" "$target"; echo "  linked $name"
    else run cp -R "$src" "$target"; echo "  copied $name"; fi
  done
done

# CLAUDE.md goes in <vault>/.claude/: Claude Code loads it from there, and
# Obsidian ignores dot-folders, so it never shows up as a note.
if [ -n "$vault" ] && [ "$uninstall" = 0 ]; then
  vault_md="$vault/.claude/CLAUDE.md"
  if [ -e "$vault_md" ] && [ "$force" = 0 ]; then
    echo "$vault_md exists; left as is (compare with $REPO/CLAUDE.md, or re-run with --force)"
  else
    run cp "$REPO/CLAUDE.md" "$vault_md"; echo "copied CLAUDE.md to $vault_md"
  fi
  if [ -e "$vault/CLAUDE.md" ]; then
    echo "note: $vault/CLAUDE.md also exists. Claude loads both, and Obsidian shows the root one as a note."
    echo "      Merge anything you need into $vault_md, then delete the root copy."
  fi
fi

[ "$dry" = 1 ] && echo "(dry run: nothing changed)"
echo "Done. Run /reload-skills in an open Claude Code session, or start a new one."
