# Operations: production and incident lessons

### A scheduled check only runs while the session is idle; use a background watcher
- Seen: an alert watch on a 10-minute session cron missed an incident for about 30 minutes,
  because the team lead was busy all evening and the cron never fired.
- Why: session crons fire only between turns, so a busy session is a deaf one.
- Now: the primary watch is a background task that polls every 2 minutes and exits when a new
  incident appears, and its completion notice wakes the lead mid-turn. The cron stays as a backup
  and re-launches the watcher if it isn't running.

### Before resolving an incident, check the alert itself has recovered
- Seen: an incident was resolved because the metrics were healthy. A new incident opened 8 seconds
  later and paged the human again.
- Why: the alert had been stuck firing for 11 hours (its query was malformed), so resolving the
  incident only opened a new one.
- Now: the resolve rule's fourth condition is that the alert's own state reads clear.

### Alert queries must emit rows on the aggregation grid
- Seen: an alert stayed stuck firing even though data existed. Its single result row was stamped
  off the grid, so the alerting engine dropped it, and "treat missing as zero" turned the gap into
  0. Five other alerts used the same shape, so they could never have fired.
- Why: the engine matches rows to its time buckets; a row on the wrong timestamp counts as missing
  data.
- Now: every alert emits rows stamped with its time bucket, and new alert queries are run against
  real data before they ship.

### Log intake can lag by half an hour; alert windows must end in the past
- Seen: logs arrived up to 34 minutes late, and a "logs stopped" alert paged on the gap.
- Now: alerts that fire on an absence look at a window ending at least 10 minutes ago, with a
  confirmation period longer than the worst lag seen. The alerting tool only allows certain
  confirmation periods (an hour, not 40 minutes); check which before writing the setting into code.

### The first reading after a restart can lie; start in-memory state at the process start
- Seen: after each deploy, a queue's "oldest wait" read 27 minutes for one tick and paged.
- Why: in-memory state (when a hold began) was empty at start, so the age was counted from the
  item's creation.
- Now: such state is initialised to the process start time, and queue alerts read the lowest value
  in each bucket. A real stall is high in every reading, so it still fires; a single odd reading
  doesn't. Don't solve this with "need N readings": a crash loop produces too few readings, and
  that's exactly when the alert matters.

### Measure a heavy job's peak memory before switching it on for everyone
- Seen: a new media job was switched on for the whole library and crash-looped on a 1 GB worker.
  The ffmpeg child was killed at 1.2 GB; unbounded, it peaked at 3.1 GB, because it decoded 8
  inputs at once.
- Now: sized up as a stopgap; the fix decodes one frame point at a time (about 400 MB at 4K) and
  refuses inputs beyond a pixel cap. A new heavy job gets a short watched trial and a child-memory
  metric before it reaches the whole library.

### Before adding instances, check each loop for single-instance assumptions
- Seen (audit): some worker loops keep files on their own instance's disk, run sweeps without
  locks, or emit metrics that would double. Only some components could safely scale out. Per-
  instance limiters, caches and analysis slots all multiply with the number of instances.
- Now: a scaling playbook per component. A busy loop that can't be scaled out is moved into a
  component of its own. The database (a shared connection pool on 1 vCPU) is the real ceiling.

### Check bulk costs with a dry run before spending
- Seen: a site-wide "re-read everything" was requested. The worst case on paper was about $1,000;
  a dry run counting stored data gave about $46, and the one real run found no new items.
- Now: any paid bulk operation gets a dry-run estimate first, and the decision is made on real
  numbers.

### Resolve, pause and delete need explicit permission even under broad trust
- Seen: a permission classifier refused writes to outside systems (resolving an incident,
  relabelling a production switch) even after the human granted broad permissions in chat. It
  allowed others (a spec change, a merge). Each call is judged on its own.
- Now: before an absence, the human adds narrow allow rules (`docs/absence-mode.md`). A refusal is
  reported and never routed around.
