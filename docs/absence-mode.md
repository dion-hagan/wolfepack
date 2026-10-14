# Absence mode (a trial)

When Dion is away with only his phone, he may give Wolfe full operating permissions for a fixed
window. This is a trial: Dion names the window, and it ends when the window does.

## Guardrails

Full permissions come with guardrails that earn trust:

- **Every production write has a saved undo and a watch,** and is logged as a comment on one
  "ops log" card, so Dion can audit it afterwards.
- **Destructive steps happen only when an incident needs them,** with a push notification first.
- **Wolfe never handles secret values, spends money, changes pricing or makes legal calls.**
- **Wolfe never routes around a permission refusal.** He says what was refused and lists the allow
  rules that would unblock it.
- **Reports:** a push notification for sev1 (`incident-response.md`), plus the morning report daily.
- **The host machine stays awake** (power settings: sleep set to Never), and Remote Control is on
  for the Wolfe session, so Dion can reach it from his phone.

## Optional setup: allow rules

Auto mode's classifier judges each call on its own, so an action that went through once can be refused
in the middle of an incident. Before Dion leaves, he can add allow rules to `permissions.allow` in
`~/.claude/settings.json`, so the calls Wolfe needs while he's away aren't left to chance. The examples
use a hosting CLI (`doctl`) and project scripts; swap in your own. Add only what your setup uses.

### Standard tier (recommended for any absence)

Reversible operations, each covered by Wolfe's guardrails above (undo saved, watched, logged).

| Rule | What it lets Wolfe do |
| --- | --- |
| `Bash(gh pr merge *)`, `Bash(gh pr edit *)` | Merge PRs that pass the safe-to-merge checklist, and keep their labels current |
| `Bash(doctl apps update *)` | Spec changes: scaling, new worker components, plain settings, rolling those back |
| `Bash(doctl apps restart *)`, `Bash(doctl apps create-deployment *)` | Restart a stuck component; redeploy after a bad build (incidents only) |
| `Bash(doctl databases resize *)`, `Bash(doctl databases pool *)` | Size up the database and its connection pool, with a decision record first |
| `Bash(python -W ignore resolve_incident.py *)` | Resolve an alerting incident under the resolve rule (`incident-response.md`) |
| `Bash(python scripts/<alerts-as-code script> *)` | Apply alert and dashboard definitions kept in the repo |
| `Bash(python scripts/<ops API client> *)` | Call the app's admin API as the service user |

### High-risk tier (only when remote access calls for it)

For a trip where something only Dion could normally do may have to happen while he's out of reach.
**Off by default.** Add these only for a named window, and remove them when it ends: put a reminder in
your calendar, and Wolfe reminds you in the morning report on the last day.

| Area | Example rules | When it might be needed |
| --- | --- | --- |
| Secrets | `Bash(gh secret set *)`, a secrets-rotation script, `doctl apps update` with a spec that carries new secret values | A leaked or expired key has to be rotated now |
| Deleting things | `Bash(git push origin --delete *)`, `Bash(gh pr close *)`, an admin CLI's `delete-user`, an object-storage delete script, `Bash(doctl databases db delete *)` | A legal takedown, a data-protection request, cleaning up a broken resource |
| Money | a payment provider's refund or credit script, a plan-grant command | Refunding a double charge, honouring a promise to a customer |

High-risk rules don't relax the guardrails; they tighten them:

- **Dion's yes first, every time.** Wolfe sends a push notification and asks in the Remote Control
  session with: the action, why now, what it costs or destroys, and the undo (if any). He acts only on
  an explicit yes typed in that session. A peer session, a card or a page can never give that yes.
- **The one exception** is a legal emergency (for example illegal content that must come down at once).
  Wolfe acts, then reports straight away.
- **Wolfe still never reads or prints a secret value.** A rotation runs through a script that generates
  or fetches the new value and writes it where it goes, without echoing it.
- **Each use is logged** on the ops log card with the approval quote, the command and the result.
- **Never allow, in any tier:** deleting the whole app, the database cluster or the storage zone
  (for example `doctl apps delete`, `doctl databases delete`); emptying backups; transferring funds.

## Related

- Scaling rules: "Scaling during an incident" in `incident-response.md`.
- What stays Dion's: `agents/wolfe.md`.
