#!/bin/bash

# run an arbitrary psql command as cfpostgres user
# expectation is that a line will be output with exit_code=<n>
# this exit code <n> will then be used to exit
# This design enables cfengine policy to run a commands promise
# that can be kept, repaired or failed depending on an exit
# code from psql since psql can't get different codes from scripts.

if [ $# -ne 2 ]; then
    echo "Usage: $0 [DBNAME] [SQL STRING]"
    exit 2
fi

TMP=$(mktemp)
TMP2=$(mktemp)
OUT=$(su - cfpostgres --command "psql --quiet --tuples-only --no-align --no-psqlrc \"$1\" --command=\"$2\"" 2> $TMP)
RETURN_CODE=$?
ERR=$(<$TMP)

EXIT_CODE=$(echo $TMP | awk -F= '{ if ( /exit_code/ ) print $2}')

rm $TMP $TMP2

if [ $RETURN_CODE -ne 0 ]; then
    echo "$OUT"
    echo "$ERR"
    exit 2; # failed
fi

exit $EXIT_CODE
