# Memory conventions

Claude's memory is a folder of small Markdown files that loads into every session on one computer
and nowhere else. This page says what goes in it and how to keep it small.

## What belongs in memory

Only what is **true across sessions and not in a repo**:

- <MANAGER_NAME>'s preferences and feedback ("how they want things reported", "what they never want asked");
- where their notes live;
- facts about this computer.

Everything else has a better home:

| It is... | Put it in |
| --- | --- |
| a command, a toolchain fact, a how-to-run-the-tests note | the project's `CLAUDE.md`, where every session, cloud agent and reviewer can read it |
| the reason for a rule that code enforces | a code comment |
| what a PR did | the PR description and the commit messages |
| a manual step only <MANAGER_NAME> can do | their ops board |
| a secret | nowhere in memory or in a repo. Never. |

When a memory note turns out to be a repo fact, move it to the project's `CLAUDE.md` and delete the
note.

## The folder

```
memory/
  MEMORY.md              the index: one line per note
  <short-slug>.md        one fact per file
```

On a new computer the folder starts empty. That is fine: the rules in `CLAUDE.md` carry the
essentials. Notes are built up as <MANAGER_NAME> gives feedback.

## One fact per file

Each note is a short file with front matter and a body:

```
---
name: short-slug
description: one line, under about 150 characters, that says when to use it
metadata:
  type: feedback
---

The rule, in one or two sentences, with the date and what <MANAGER_NAME> said if it was a quote.

**Why:** the reason they gave or the incident behind it.

**How to apply:** when it applies and what to do.
```

Types:

| `type` | Holds |
| --- | --- |
| `feedback` | A rule from <MANAGER_NAME>: how they want work done, reported or asked. The most common. |
| `user` | A fact about <MANAGER_NAME>'s role or way of working. |
| `project` | State of a piece of work that is open right now (see "State notes expire"). |
| `reference` | A pointer to where something lives, or how a tool behaves on this computer. |

Rules for the body: lead with the rule; give the why, so edge cases can be judged; keep it to what a
future session needs; quote <MANAGER_NAME> only where their words are the rule.

## The index

`MEMORY.md` is loaded into every session, so it stays short:

- one line per note: `- [Title](file.md) - the hook, under about 150 characters`;
- no front matter, no long text;
- add the line when you add the note, delete it when you delete the note;
- group related lines; keep the file under about 200 lines. Past that, merge or delete notes.

## State notes expire

A note about an open piece of work ("the PR is open, reviews done, one device untested") exists for
continuity while the PR is open. **It expires when the PR merges.** Before you merge:

1. move any lasting rule or reason into the project's `CLAUDE.md` or a code comment;
2. put an open console step on <MANAGER_NAME>'s ops board and a device test in your merge message;
3. delete the note and its index line.

## Hygiene pass

When asked, or when the index grows past its limit: merge duplicates, fix stale facts, delete notes
for merged work, and shorten index lines. Do not delete a `feedback` note unless <MANAGER_NAME>'s rule changed
or the note duplicates one in `CLAUDE.md`. Never rewrite something <MANAGER_NAME> wrote: add beside it.

## Moving to a new computer

Memory is not copied by the installer. The durable rules are already in `CLAUDE.md`. If you want a
note on the new machine, write it again from its description; keep it short.
