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

### A staging copy must be safe to open anywhere and share nothing with production
- Seen: a staging environment was set up in an afternoon: its own database, storage and domain, a
  sign-in limited to admins, and demo content seeded from free-licence stock.
- Why: copying production data into staging puts real users' content on a demo box, and a shared
  storage zone lets staging delete live files.
- Now: never copy production folders into staging; lock staging's database to the staging app;
  point staging at a fresh database after any window where sign-up was open.

### A rolling deploy can exhaust a small database's connections
- Seen: on the smallest managed Postgres (about 22 connections), a deploy ran the old and new web
  and worker side by side; a boot-time seed job hit "remaining connection slots are reserved",
  swallowed the error and never retried.
- Why: during a rolling deploy, connection pools briefly double.
- Now: boot-time jobs retry with backoff while the database is unavailable; restart only the
  worker component to re-run one (`doctl apps restart --components worker`).

### Every deploy restarts the workers; batch merges into windows
- Seen: three deploys in 15 minutes kept handing a long render back to the queue, and a batch
  script that queued work faster than it finished made it worse.
- Now: release windows (`docs/merging.md`), and queue long jobs one at a time as the queue drains.

### Path-filtered CI must keep its check names
- Seen: CI was cut from about 15 to 5.6 minutes by running only the jobs a change needs and
  sharding the slow suite into four parallel jobs, for about 10% more total CI time.
- Why: merge rules check named checks, so a skipped job must still report success, and one
  aggregate check must fail if any shard fails, is cancelled or is skipped unexpectedly.
- Now: keep job names stable, shard by measured per-file time, and give each shard its own
  test database.

### A dependency install in CI needs a time limit and a cache
- Seen: package-mirror stalls left CI shards hanging on an apt install until the job timeout, and
  several PRs in a row waited behind reruns.
- Why: package managers retry slow mirrors for a long time; with no time limit, one stall costs
  a whole job.
- Now: install through a script with a hard time limit and two tries, and cache the downloaded
  packages (keyed by version, saved from the main branch) so most runs skip the mirror. A stall now
  fails in minutes; rerun only the failed jobs.

### A health check on a cheap endpoint stops deploy blips
- Seen: users saw brief errors during deploys while new instances took traffic before they could
  serve it.
- Why: with no health check, the platform routes to an instance as soon as its process starts.
- Now: a health check on a fast endpoint that touches no heavy dependency (for example a version
  route), every 10 seconds with a few failures allowed. Apply it like any spec change: copy before
  and after, one change, then watch.

### Test walks never create or delete accounts on production
- Seen: an agent walking a sign-up-to-deletion flow was about to make and delete a test account on
  the live site.
- Why: a deletion on production fires real alerts, audit rows and possibly emails, and a test
  account there skews the numbers.
- Now: walk account flows on staging or a local stack. Production gets read-only checks.
