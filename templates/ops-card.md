# Ops card template (Dion's ops board)

The ops board holds only the manual steps a feature needs that **only Dion can do**: make and paste
a key or secret, change a setting in a hosting or service console, run a script or command against
production, open an account.

It does **not** hold device tests, merges, reviews or decisions. Those live on the PR (its labels),
on the agent board's card (Needs decision), or in chat.

Lists: **To do** (he can do it now), **Waiting** (on a PR merging, an account, a date: the card's
first line says which), **Done**.

**Title:** `<where>: <the step>`, for example "Hosting console: set the MAIL_API_KEY on web and
worker".

**Description:**

```
Waits on: <PR short title merging / a date / an account>      (Waiting cards only; first line)
Agent: <session title>

Why: the feature and the PR that need this step.
Steps:
1. exact clicks or commands. Never write a secret's value.
Done when: how anyone can tell it worked (a log line, a check, a page).
```

**Moves:** the session whose work needs the step files the card in the same turn, unasked: in
Waiting ("after the PR merges") or in To do (needed now). The session whose merge a Waiting card
waits on moves it to To do. A card goes to Done when Dion says so, or when a session sees the proof
its Done when names. Never edit Dion's own cards, never archive or delete a card.
