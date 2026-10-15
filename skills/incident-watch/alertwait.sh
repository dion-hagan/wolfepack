#!/usr/bin/env bash
# The primary alert watch: polls alertwatch.py every 2 minutes and EXITS as soon as a NEW incident appears
# (or after two failed reads in a row). Run it as a background task: its completion notice reaches the team
# lead even mid-turn, which a session cron does not (crons fire only while the session is idle).
# After handling an incident: `alertwatch.py --mark`, then start this again in the background.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fails=0
while true; do
  out=$(PYTHONIOENCODING=utf-8 python -W ignore "$HERE/alertwatch.py" 2>&1)
  case "$out" in
    *NEW:*) echo "$out"; exit 0 ;;
    *"READ FAILED"*) fails=$((fails + 1)); [ "$fails" -ge 2 ] && { echo "$out"; exit 2; } ;;
    *) fails=0 ;;
  esac
  sleep 120
done
