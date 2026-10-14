# wolfepack config

The one file you fill in. Everything else in this repo uses the placeholders below, so nothing
else needs editing.

**Where it lives.** `install.sh` / `install.ps1` copy this file to `~/.claude/wolfepack.config.md`
if you don't have one yet (they never overwrite it). A project can override it with its own
`wolfepack.config.md` in the repo root; the project's file wins. Skills and Wolfe read this file
whenever they need a value, so keep the table format.

**Never put a secret here** (no keys, tokens or passwords). Board links are fine in your own copy.
`wolfepack.config.md` is git-ignored in this repo, so a filled-in copy is not published by accident.

**Forking this setup?** Set `MANAGER_NAME` below to your own name. The docs write the manager as
`<MANAGER_NAME>`, including in the list and label names (`<MANAGER_NAME>'s reports`, `From <MANAGER_NAME>`,
`blocked: waiting on <MANAGER_NAME>`): name those lists and labels on your boards with your name too.
No doc needs editing.

## Values

| Key | Your value | What it is |
| --- | --- | --- |
| `MANAGER_NAME` | `Dion` | The person the team reports to: approves what only a human may, owns the ops board and their own report list. Docs write it as `<MANAGER_NAME>`. |
| `GITHUB_REPO` | `<OWNER>/<REPO>` | The project repository, used in every `gh ... --repo` command. |
| `MAIN_BRANCH` | `main` | The branch that merges deploy from. |
| `BRANCH_PREFIX` | `agent` | Branches are `<BRANCH_PREFIX>/<slug>`, one per card. |
| `CI_COMMAND` | `<the one command that runs everything CI runs>` | Run before every PR, for example `make check`. |
| `BOARD_URL` | `<BOARD_URL>` | The agent kanban board (Trello). |
| `OPS_BOARD_URL` | `<OPS_BOARD_URL>` | <MANAGER_NAME>'s own board for manual ops steps. |
| `TEAM_LEAD_NAME` | `Wolfe` | The team lead session's title. |
| `AGENT_LIMIT` | `3` | How many card agents run at once. |
| `BIG_DIFF_LINES` | `500` | A diff this long or longer counts as "big" for review by risk. |
| `MIGRATION_LIST_COMMAND` | `n/a` | Optional. A command that lists schema migrations held by open PRs. `n/a` if the project has none. |
| `ALERTS_PROVIDER` | `none` | Optional. The alerting tool the incident watch reads, e.g. `betterstack`. `none` turns the watch off. |
| `ALERTS_TOKEN_FILE` | `<path outside every repo>` | Where the alerting API token lives, as a path only. The watch reads it through the environment variable of the same name. |
| `ALERTS_READ_NOTES` | `<how a responder reads logs and metrics>` | Endpoints, table names and query syntax for the incident responder brief. No secrets. |
| `MORNING_REPORT_TIME` | `07:47` | Local time of the daily morning report. |
| `PR_TEMPLATE_PATH` | `.github/pull_request_template.md` | Where the project keeps its PR template. |

## Board lists (exact names, left to right)

Agent board (`BOARD_URL`):

| List | Meaning |
| --- | --- |
| `<MANAGER_NAME>'s reports` | <MANAGER_NAME>'s own bugs and ideas, in their words. |
| `Inbox` | Found by an agent, not yet agreed. |
| `Ready` | Agreed and clear. The top card is next. |
| `In progress` | An agent has it. |
| `Blocked` | Waits on <MANAGER_NAME>. |
| `In review` | A PR is open. |
| `Needs testing` | <MANAGER_NAME> tries it on a device. |
| `Ready to merge` | Labelled `ready to merge`. |
| `Done` | Merged. |

Ops board (`OPS_BOARD_URL`): `To do`, `Waiting`, `Done`.

## Board labels

`Bug` (red), `Feature` (green), `Tech debt` (purple), `Docs` (blue), `Needs decision` (orange),
`From <MANAGER_NAME>` (yellow). Name them by hand; agents also match them by colour.

## GitHub PR labels

`work in progress`, `blocked: waiting on <MANAGER_NAME>`, `blocked: external`, `needs update`,
`stacked`, `needs review`, `needs testing`, `ready to merge`. Create them once with the commands
in `docs/merging.md`, "Create the labels".
