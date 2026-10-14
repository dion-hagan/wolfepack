# The Trello boards

Two boards. The **agent board** (`<BOARD_URL>`) is where work waits and where you can see it move.
The **ops board** (`<OPS_BOARD_URL>`) is <MANAGER_NAME>'s own list of manual steps. Both URLs live in
`wolfepack.config.md`.

The board shows PR state; **the PR's status label is the truth** (`merging.md`). Questions go on
the card and in chat. Device tests and merges are not tracked as tasks: the labels show them.

## Create the agent board

Do this once, by hand in Trello (a free board is enough):

1. Create a board. Copy its URL into `BOARD_URL` in your config.
2. Add the nine lists, in this order, with exactly these names:

| List | What is in it | Cards get there by |
| --- | --- | --- |
| **<MANAGER_NAME>'s reports** | <MANAGER_NAME>'s bugs and ideas, in their own words. | <MANAGER_NAME> |
| **Inbox** | Bugs and ideas an agent found, not yet agreed. | any session (`/trello-card new <what>`) |
| **Ready** | Agreed and clear enough to build. The top card is next. | <MANAGER_NAME>; Wolfe, for their clear reports |
| **In progress** | An agent has it. The claim comment names the branch. Its PR, if any, is a draft. | Wolfe or the session taking it |
| **Blocked** | Waits on <MANAGER_NAME> (a question on the card), or on a third party. | Wolfe or the session, before a PR exists |
| **In review** | Its PR is open: `needs review`, `needs update`, `work in progress`, `stacked`, or no label yet. | the session or Wolfe |
| **Needs testing** | `needs testing`: <MANAGER_NAME> tries it on a device. | the session or Wolfe |
| **Ready to merge** | `ready to merge`. | the session or Wolfe |
| **Done** | Merged into the main branch. | the session or Wolfe |

3. Add six labels (Trello board menu, Labels): **Bug** (red), **Feature** (green), **Tech debt**
   (purple), **Docs** (blue), **Needs decision** (orange), **From <MANAGER_NAME>** (yellow).
   *Needs decision* means the card holds a question for <MANAGER_NAME> and no agent starts it until they
   answers and takes the label off. *From <MANAGER_NAME>* means <MANAGER_NAME> wrote it.

## Create the ops board

A second board with three lists: **To do**, **Waiting**, **Done**. Copy its URL into
`OPS_BOARD_URL`. See "<MANAGER_NAME>'s ops board" below.

## Connect Claude to Trello

On claude.ai, Settings, Connectors, connect **Trello**. Sessions load its tools with one
ToolSearch for "trello". See `desktop-app-settings.md`.

## <MANAGER_NAME>'s words

<MANAGER_NAME>'s reports are theirs. Claude never changes the title or description of a card labelled From <MANAGER_NAME>
or in their list, and never archives or deletes any card. What Claude has to say goes in a comment.

Trello shows every change as <MANAGER_NAME>'s, because the connector signs in as them. So every card and
comment Claude writes names the agent that wrote it:

- a card's description starts with the line `Agent: <session title>`, the title as the app's
  sidebar shows it (for a dispatcher's agent: `Agent: <dispatcher title> / <agent name>`);
- a comment starts with `Claude (<session title>):`.

A card without an `Agent:` first line, wherever it was made, is <MANAGER_NAME>'s and gets the From <MANAGER_NAME>
label. A comment that does not start with `Claude (` is theirs.

**Reporting a bug.** <MANAGER_NAME> adds a card to their list, from the desktop or the Trello phone app, in any
words. On its next look, Wolfe labels it From <MANAGER_NAME> and comments a triage
(`Claude (Wolfe): triage`) with what they think is happening, where, a proposed Done when, and any
questions. With no questions and no product or pricing call in it, they move it to the bottom of
Ready; otherwise they label it Needs decision and ask.

## A card Claude files

Template: `templates/card.md`.

```
Agent: <session title>

What: what changes, for whom.
Done when:
- what <MANAGER_NAME> can check, one line each
Notes: where it was seen (page, log line, PR), files, links, screenshots.
```

The title says the effect in plain words, as a PR title does. Label it Bug, Feature, Tech debt or
Docs. File it at the bottom of Inbox, never in <MANAGER_NAME>'s reports.

## Where a card goes as its PR moves

The session (or Wolfe) moves the card whenever the PR changes. (The wolfepack setup ships no GitHub
Action for this; if you add one, it must follow the same table.)

| The PR | The card's list |
| --- | --- |
| a `blocked: ...` label | Blocked |
| a draft | In progress |
| `ready to merge` | Ready to merge |
| `needs testing` | Needs testing |
| open, any other label or none | In review |
| merged into the main branch, and no other open PR links the card | Done (with a comment) |
| merged into another branch, or closed without merging | stays where it is (with a comment) |

Only the `Trello:` line of a PR body links a card. A card that several open PRs link follows the
one furthest behind. Blocking a card: before a PR exists, move it to Blocked; after, use the
`blocked: waiting on <MANAGER_NAME>` label (a move by hand would be undone at the next move from the PR).

## Fewer rebuilds and CI runs

Agents organize themselves on the board so that branches are rebuilt, and CI run, as few times as
possible:

- **Claims.** A card whose `Assigned to:` line or latest claim comment names another session is
  theirs: do not take it. One with `Starts after:` waits until that card is Done or that PR merged.
- **Before starting**, look at the In progress and In review cards for work in the same area. If one
  overlaps, comment on its card and agree an order; the later one waits.
- **Before merging**, read the open PRs' titles and descriptions
  (`gh pr list --repo <GITHUB_REPO> --json number,title,body`; no code needed) and pick the ones your
  merge will likely make conflict or need an update. Comment on each one's **card**, for example
  `Claude (<you>): heads-up, "<short PR title>" merges next; it edits the same list as yours; expect
  a conflict, keep both`. A PR without a card: message its session.
- **On a heads-up**, update the branch from the main branch once, right before your merge, not
  after every merge. Push a round of fixes as one push.

## Finishing a session

A session's work is finished when its cards are in Done, not when its PR merges. The desktop app's
setting "Auto-archive sessions when their pull request closes" must be **off**
(`desktop-app-settings.md`): left on, it archives each session the moment its PR merges, before the
session can move its card, and leaves cards in In review for sessions that are gone.

A session's cards are the cards its own PRs link on the `Trello:` line. Inbox cards and ops cards
it filed are not its cards. After a merge into the main branch:

1. Move each card the PR links to **Done**, with the comment
   `Claude (<session title>): merged as "<short PR title>" (<short sha>).` A card another open PR
   still links stays where it is.
2. Read the card back and check that it is in Done. A card whose `Starts after:` names it can start
   now: comment that on it.
3. Finish the rest: a second PR, memory clean-up (`memory.md`), and any ops card in Waiting that
   waits on this merge, moved to To do. Every follow-up for <MANAGER_NAME> is on their board: a manual step on
   their ops board, a question on the card. Nothing for them lives only in a session's chat.
4. Archive the session (`archive_session` with `self`) once it has no open PR, each of its cards is
   in Done (or stayed where it was because its PR closed without merging: comment why), and its
   follow-ups for <MANAGER_NAME> are on their board. A session with several PRs stays open until the last one
   is done. Outside auto mode the app asks <MANAGER_NAME> to approve the archive: declined or refused, say so
   and stop; Wolfe or <MANAGER_NAME> archives it.

Only a session <MANAGER_NAME> opened archives itself. A background agent or a reviewer never calls
`archive_session`.

**Wolfe** may archive an agent session whose work is completely finished by the test in step 4,
including sessions that stayed open after their work was done. He does not archive himself: <MANAGER_NAME>
compacts him.

**A refused card move** (auto mode's classifier can treat it as an external write): say so in chat
with the card's link and leave the session open. <MANAGER_NAME> or Wolfe moves the card, and the session
archives on a later turn once it reads the card in Done, or Wolfe archives it.

## A project with its own lead

A session running a multi-PR project with its own team may schedule a card per planned PR, with an
`Assigned to:` line naming the lead or a teammate and a `Starts after:` line where order matters.
Its owners move the cards as the PRs move.

## <MANAGER_NAME>'s ops board

<MANAGER_NAME>'s own board, with three lists: **To do** (they can do it now), **Waiting** (on a PR merging, an
account, a date: the card's first line says which) and **Done**.

It holds only the manual steps a feature needs that only <MANAGER_NAME> can do: a key or secret to make and
paste, a setting in a hosting or service console, a script or command against production, an
account to open. Not device tests, merges, reviews or decisions: those live on the PR, the card
or in chat.

- The session whose work needs the step files the card, when it opens the PR (in Waiting, "after
  the PR merges") or as soon as it is needed (in To do). Template: `templates/ops-card.md`. Title:
  `<where>: <the step>`. Description: the `Agent:` line, then **Why**, **Steps** (exact clicks or
  commands; never a secret's value), **Done when**.
- Wolfe, or the session whose merge a card waits on, moves a Waiting card to To do once what it
  waits on has happened.
- A card goes to Done when <MANAGER_NAME> says so, or when a session sees the proof its Done when names.
  The same rules as <MANAGER_NAME>'s words: never edit their cards, never archive or delete a card.
