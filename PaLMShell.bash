#!/bin/bash
#
#
# Title: PaLM Shell - Pathways Language Model Shell.
#
# Description: A interactive prompt-response shell that uses RESTful API calls
#              to send prompts and receive the responses, display, and log the
#              results.
#
# By William F. Gilreath (will@wfgilreath.xyz)
# Version 1.11  10/22/2023
#
# Copyright © 2023 All Rights Reserved.
#
# License: This software is subject to the terms of the GNU General Public License (GPL)
#     version 3.0 available at the following link: http://www.gnu.org/copyleft/gpl.html.
#
# You must accept the terms of the GNU General Public License (GPL) license agreement
#     to use this software.
#
#

#
# Get Google Gemini formerly PaLM Key
#
PALM_KEY="NHGUBE-PBATENGF-BA-XABJVAT-EBG13-PBQVAT" #pseudo-value

#
#
#
echo "PaLM Shell v1.1 (c) 2023 William F. Gilreath"
echo "All Rights Reserved. License is GPLv3       "
echo

#
# check if PALM_KEY empty, report error need key, exit
if [ -z $PALM_KEY ]
then
  echo "Must have PaLM key to use PaLM API!"
  exit 1
fi

date_time=$(date | date | tr '  ' '-' | tr ':' '-')
log_file="PaLM-$date_time.log"

echo
echo "Logging this session to: 'PaLM-$date_time.log'"
echo

#
# main loop
#

while :
do
  echo -n "PaLM>"
  read prompt_line

  #'bye' is bye/exit/quit PaLM Shell
  if [ "$prompt_line" == "bye" ]; then
    break
  fi

  echo "Prompt: '$prompt_line'" | tee -a $log_file #PaLM-$date_time.log

  echo | tee -a $log_file #PaLM-$date_time.log

  curl \
  -s \
  -H 'Content-Type: application/json' \
  -d '{ "prompt": { "text": '"\"$prompt_line\""' }}' \
  "https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$PALM_KEY" |  jq '.candidates | .[].output' | sed 's/\\n/\n/g' | tee -a $log_file #PaLM-$date_time.log

  echo | tee -a $log_file ##PaLM-$date_time.log

done

echo "All done! Exiting...Have a nice day!" | tee -a $log_file #PaLM-$date_time.log

exit 0
