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

## Related

- Scaling rules: "Scaling during an incident" in `incident-response.md`.
- What stays Dion's: `agents/wolfe.md`.
