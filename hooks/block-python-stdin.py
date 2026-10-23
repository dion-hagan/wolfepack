"""PreToolUse hook: refuse `python -` (a script on stdin) and a bare `python` REPL.

On this PC `python` is the Windows Store build; started with `-` or no script in an agent shell it
sits in its REPL writing junk until the command times out. Exit code 2 blocks the command and shows
the message to the agent.
"""
import json
import re
import sys

PYTHONS = {"python", "python3", "py", "python.exe", "python3.exe", "py.exe"}
TAKES_ARG = {"-W", "-X", "-Q"}
MESSAGE = (
    "Blocked: `python -` (or a bare `python`) starts the Windows Store Python REPL here and hangs "
    "until the timeout. Write the script to a file in your scratchpad and run `python <file>`, "
    "or use `python -c \"...\"`."
)


def bad(command: str) -> bool:
    for segment in re.split(r"&&|\|\||[;&\n]", command):
        tokens = segment.split()
        for i, tok in enumerate(tokens):
            if tok.replace("\\", "/").rsplit("/", 1)[-1].lower() not in PYTHONS:
                continue
            if i and tokens[i - 1] not in ("|", "then", "do", "else", "time", "exec") and not re.fullmatch(r"\w+=\S*", tokens[i - 1]):
                continue  # an argument to something else, e.g. `which python`
            rest = tokens[i + 1:]
            piped = "|" in tokens[:i] or any(t.startswith("<") for t in rest)
            if not rest or all(t.startswith("2>") or t.startswith(">") for t in rest):
                if not piped:
                    return True
            j = 0
            while j < len(rest):
                t = rest[j]
                if t == "-":
                    return True
                if t in TAKES_ARG:
                    j += 2
                    continue
                if t.startswith("-") and t not in ("-c", "-m"):
                    j += 1
                    continue
                break
    return False


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except ValueError:
        return 0
    command = (data.get("tool_input") or {}).get("command") or ""
    if bad(command):
        print(MESSAGE, file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
