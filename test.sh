#!/bin/sh
# Runs the OberonTest conformance suite (src/OberonTest) against the
# installed Jacob compiler: FTest (front-end: scan/parse/type-check output
# vs reference dumps) and CTest (back-end: compile+link+run vs reference
# program output).
#
# Usage: ./test.sh [of|oc|all]   (default: all; see src/OberonTest/check)
set -e

HOME_DIR=/home/mspring/prj/jacob/jacob
MODE="${1:-all}"

if [ ! -x "$HOME_DIR/Jacob" ]; then
    echo "==> $HOME_DIR/Jacob not found - run ./build.sh first." >&2
    exit 1
fi

export PATH="$HOME_DIR/bin:$PATH"

LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT

echo "==> Running OberonTest ($MODE)..."
"$HOME_DIR/src/OberonTest/check" "$MODE" > "$LOG" 2>&1 || true

cat "$LOG"

fail=0
if grep -q "Fehler im Front-End" "$LOG"; then
    echo "==> Front-End: FAILED (see $HOME_DIR/src/OberonTest/FTest/out/differences)"
    fail=1
elif grep -q "of ist in Ordnung" "$LOG"; then
    echo "==> Front-End: passed"
fi

if grep -q "Fehler im Back-End" "$LOG"; then
    echo "==> Back-End: FAILED (see $HOME_DIR/src/OberonTest/CTest/alldiffs)"
    fail=1
elif grep -q "oc ist in Ordnung" "$LOG"; then
    echo "==> Back-End: passed"
fi

exit $fail
