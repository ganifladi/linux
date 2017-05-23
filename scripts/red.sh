#!/bin/bash

echo BAM

PROC=$(pgrep redshift)

if [[ "$PROC" == "" ]]; then
#  echo "Not Running"
  redshift
else
#  echo "Running"
  pkill redshift
fi
