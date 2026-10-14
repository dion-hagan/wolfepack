"""Alert watch: prints NEW incidents (and handled ones still open) from the alerting provider, or 'quiet'.

Built for the Better Stack Uptime API (GET /api/v2/incidents). For another provider (PagerDuty,
Opsgenie, Grafana OnCall ...) replace fetch() so it returns the same dicts.

Settings (environment variables; never put a token in this file or in the config):
  ALERTS_TOKEN_FILE   path to a file holding the API token (read here, never printed)
  ALERTS_API_URL      default https://uptime.betterstack.com/api/v2/incidents?per_page=25
  ALERTS_STATE_FILE   default ~/.claude/wolfepack-alertwatch-seen.json (ids already handed to a responder)

Usage:
  python alertwatch.py            print NEW / STILL OPEN incidents, or "quiet"
  python alertwatch.py --mark     also record every listed incident as handled
Exit code is always 0; a failed read prints "ALERTWATCH READ FAILED: ..." so the watcher can count it.
"""
import json
import os
import sys
import urllib.request

TOKEN_FILE = os.environ.get("ALERTS_TOKEN_FILE", "")
API_URL = os.environ.get("ALERTS_API_URL", "https://uptime.betterstack.com/api/v2/incidents?per_page=25")
STATE = os.environ.get("ALERTS_STATE_FILE", os.path.expanduser("~/.claude/wolfepack-alertwatch-seen.json"))


def fetch():
    """Return incidents newest first: [{id, name, cause, started_at, acknowledged_at, resolved_at}]."""
    token = open(TOKEN_FILE, encoding="utf-8").read().strip()
    req = urllib.request.Request(API_URL, headers={"Authorization": "Bearer " + token})
    with urllib.request.urlopen(req, timeout=60) as f:
        data = json.load(f).get("data", [])
    return [dict(id=str(i["id"]), **{k: i["attributes"].get(k) for k in
                                    ("name", "cause", "started_at", "acknowledged_at", "resolved_at")})
            for i in data]


def main():
    if not TOKEN_FILE:
        print("ALERTWATCH READ FAILED: set ALERTS_TOKEN_FILE")
        return
    seen = set(json.load(open(STATE, encoding="utf-8"))) if os.path.exists(STATE) else set()
    try:
        incidents = fetch()
    except Exception as e:  # noqa: BLE001 - any failure is reported, never raised
        print("ALERTWATCH READ FAILED:", str(e)[:160])
        return
    new, still_open = [], []
    for i in incidents:
        line = "%s | %s | cause=%s | started %s | ack %s | resolved %s" % (
            i["id"], (i["name"] or "")[:70], (i["cause"] or "")[:120],
            i["started_at"], i["acknowledged_at"], i["resolved_at"])
        if i["id"] not in seen:
            new.append(line)
        elif not i["resolved_at"]:
            still_open.append(line)
    if "--mark" in sys.argv:
        seen |= {i["id"] for i in incidents}
        os.makedirs(os.path.dirname(STATE), exist_ok=True)
        json.dump(sorted(seen), open(STATE, "w", encoding="utf-8"))
    if new:
        print("NEW:\n" + "\n".join(new))
    if still_open:
        print("STILL OPEN:\n" + "\n".join(still_open))
    if not new and not still_open:
        print("quiet")


if __name__ == "__main__":
    main()
