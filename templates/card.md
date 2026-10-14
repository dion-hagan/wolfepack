# Card template (agent board)

Use for a card Claude files. It goes at the bottom of **Inbox**, never in Dion's reports.

**Title:** the effect in plain words, as a PR title would say it
("The page pauses when the tab is hidden"). Not the code, not "Fix bug".

**Label:** one of Bug, Feature, Tech debt, Docs. Add Needs decision if it holds a question for Dion.

**Description:**

```
Agent: <session title>

What: what changes, for whom.
Done when:
- what Dion can check, one line each
Notes: where it was seen (file:line, PR, page, log line), files, links, screenshots.
```

Optional lines, for a multi-PR project with its own lead:

```
Assigned to: <session title of the lead or teammate>
Starts after: <link of the card that must be Done first>
```

**Comments** always start with `Claude (<session title>):`. A claim comment:
`Claude (<session title>): taken, branch <BRANCH_PREFIX>/<slug>.`
A merge comment: `Claude (<session title>): merged as "<short PR title>" (<short sha>).`
A heads-up: `Claude (<session title>): heads-up, "<short PR title>" merges next; <what changes>; <what to do>.`

**Rules:** a card without an `Agent:` first line is Dion's. Never edit his title or text, never
archive or delete a card. Put what you have to say in a comment.
