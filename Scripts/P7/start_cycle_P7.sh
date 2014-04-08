#!/bin/bash
set -e # abort if anything goes wrong
# script to set up a cycling WPS/WRF run: machine-specific part (GPC)
# starts/submits first WPS and WRF runs, the latter dependent on the former
# created 28/06/2012 by Andre R. Erler, GPL v3, adapted 07/04/2014

# machine-specific defaults
WAITTIME=${WAITTIME:-'00:15:00'} # wait time for queue selector
QUEUE=${QUEUE:-'SELECTOR'} # queue mode: SELECTOR (default), SIMPLE

## launch jobs on P7

# submit first WPS instance
if [ $SKIPWPS == 1 ]; then
  echo 'Skipping WPS!'
elif [[ "$QUEUE" == 'SIMPLE' ]]; then
  qsub ./${WPSSCRIPT} -v NEXTSTEP="${NEXTSTEP}"
elif [[ "$QUEUE" == 'SELECTOR' ]]; then
  echo
  # launch queue seletor; other variables are set above: NEXTSTEP, WPSSCRIPT
  export WRFWCT="$WAITTIME"
  python "${SCRIPTDIR}/selectWPSqueue.py"
else
  echo "ERROR: unknown WPS queue handler '${QUEUE}'" 
  exit 1
fi # if $SKIPWPS

## launch jobs

# use sleeper script to to launch WPS and WRF
./sleepCycle.sh "${NEXTSTEP}" # should be present in the root folder

# exit with 0 exit code: if anything went wrong we would already have aborted
exit 0
