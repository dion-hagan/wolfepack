# Long-running work: launches that outlast one session

Some work takes more than one agent session: a launch built in several PRs, or a task a builder
can't finish inside its context. Every new session starts with no memory, so the work has to carry
its own state. This is adapted from Anthropic's study of harnesses for long-running agents
("Effective harnesses for long-running agents", 2025), fitted to how this team already works.

The two failures it prevents:

- **Doing too much at once.** The agent starts several things, runs out of context mid-change, and
  the next session has to guess what was half done.
- **Declaring victory early.** A later session sees a lot of progress and calls the whole thing
  done, or ticks an item after a unit test without trying it as a user would.

## The shape

| Problem | The first session (the planner) | Every later session (a builder) |
| --- | --- | --- |
| Done too early | Writes the acceptance list: every behaviour, all `"passes": false` | Reads the list and picks **one** item that isn't passing |
| Left broken or undocumented | Starts the branch and the progress file | Reads the progress file and `git log`, runs the smoke check, and at the end commits and updates the progress file |
| Ticked without trying it | Writes steps a person would follow for each item | Flips `passes` only after walking those steps in a browser or on a device |
| Time lost working out how to run it | Makes sure the project has one command to start the app and one smoke check | Runs them first |

The planner and the builders are the same kind of agent with a different first message. On a team
with managers, the planner is usually the team's manager or the agent it briefs first. The
acceptance list is how <MANAGER_NAME>'s ask reaches every builder unchanged.

## The acceptance list

A JSON file on the launch's feature branch, for example `launch/<slug>.acceptance.json`. Start from
`templates/acceptance.json`. JSON, not Markdown: agents are less likely to rewrite or drop entries
in JSON than in a prose checklist.

```json
[
  {
    "id": "tap-pause",
    "area": "playback",
    "behaviour": "One tap on the video pauses it; another tap plays it",
    "steps": ["Open the page on a phone-width viewport", "Tap the video", "See it pause", "Tap again", "See it play"],
    "passes": false,
    "checked": ""
  }
]
```

Rules:

- **Builders change only `passes` and `checked`.** `checked` gets how it was checked and when, for
  example `"phone viewport, staging, 2025-11-03"`. Adding, removing or rewording an item is for
  the planner, the lead or <MANAGER_NAME>, and the commit that does it says why. Removing an item to
  make the list pass is never acceptable.
- **`passes: true` means walked, not tested.** Unit tests and API calls are necessary but not
  enough. The builder follows the steps as a user would, in a browser or on a device. An item that
  can't be walked by an agent (it needs a real phone, a payment or a person's judgement of feel)
  stays `false` with a note in `checked`, and goes on the list for <MANAGER_NAME>'s device test.
- **The final PR (`merging.md`, "Staging for one PR, and a final PR for a launch") carries the list.** Its
  body says how many items pass and names those left for the device test.

## The progress file

A plain text file in the builder's worktree, kept out of git (add `.agent-progress.md` to the
project's `.gitignore`). Newest entry at the top, one entry per working session:

```
## <date> <agent or session name>
Did: <what changed, with commit ids>
State: <green / red, and the smoke check's result>
Next: <the one next step>
```

It is for the next session in the same worktree, or for the agent that takes over after a handoff
at about 200k tokens of context (`agents/manager-brief.md`, "Handoffs"). Anything others need, such as
decisions, questions or what's left, goes on the card or the PR as usual. The progress file doesn't
replace them.

## Each builder session

1. **Get your bearings.** `pwd` (you can only edit your own worktree), `git fetch`, `git log
   --oneline -15` on the branch, the progress file, the acceptance list.
2. **Run the smoke check before changing anything.** Start the app and walk one core path. If it's
   already broken, fix that first, or, if the break came from main, stop and report it. Building on
   a broken base makes both problems harder to find.
3. **Pick one item.** The highest-priority item that isn't passing. Don't start a second item
   until the first is committed.
4. **Build it, test it, walk it.** Then flip `passes` and fill in `checked`.
5. **Leave a clean state.** Tests green, a commit with a message that says what changed, the
   progress file updated. Never end a session mid-change: if you must stop, commit what works and
   write the next step down. Git is how the next session gets back to a working state if this one
   went wrong.

## Blind spots of agent walks

- **Native browser dialogs** (`alert`, `confirm`, `prompt`) don't show in browser automation's
  view of the page, so agents miss bugs behind them. Prefer in-page dialogs, and list any native
  one for the human's device test.
- **Feel**: timing, haptics, scroll physics and gestures that only exist on a real phone. Agents can
  check the code paths, not the feel. Those items stay on the device-test list.
- Screenshot reading misses small visual faults. For a visual change, attach the screenshots to the
  PR so a person can look.

## When to use this

- A launch built in several PRs on one feature branch: always.
- A single card a builder expects to finish in one session: no list, no progress file. The card's
  "Done when" is the list, and the PR is the record.
- A card that turns out bigger than one session: start a progress file when you notice, and split
  the rest into cards.
