#!/usr/bin/env bash
#
#
# Title: PaLM Shell - Pathways Language Model Shell. Now Google Gemini AI.
#
# Description: A interactive prompt-response shell that uses RESTful API calls
#              to send prompts and receive the responses, display, and log the
#              results from Google Gemini API.
#
# By William F. Gilreath (will@wfgilreath.xyz)
# Version 2.0  09/30/2024
#
# Copyright © 2024 All Rights Reserved.
#
# License: This software is subject to the terms of the GNU General Public License (GPL)
#     version 3.0 available at the following link: http://www.gnu.org/copyleft/gpl.html.
#
# You must accept the terms of the GNU General Public License (GPL) license agreement
#     to use this software.
#
# Updated with new Google Gemini API 9-30-2024
#

#
# Get Google Gemini formerly PaLM Key
#
PALM_KEY="NHGUBE-PBATENGF-BA-XABJVAT-EBG13-PBQVAT" #pseudo-value

#
# Echo header about script, version, all that fun stuff.
#
echo "PaLM Shell v2.0 (c) 2024 William F. Gilreath"
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
# main loop of PaLM shell script
#
while :
do
  echo -n "PaLM>"
  read prompt_line

  #'bye' is bye/exit/quit PaLM Shell
  if [ "$prompt_line" == "bye" ]; then
    break
  fi

  #check if input is blank line avoid empty prompt to Gemini AI
  if [ -z "$prompt_line" ]; then
    continue
  fi

  echo "Prompt: '$prompt_line'" | tee -a $log_file #PaLM-$date_time.log
  echo | tee -a $log_file #PaLM-$date_time.log

  curl \
  -s \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":'"\"$prompt_line\""'}]}]}' \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$PALM_KEY" | jq '.candidates[].content.parts[].text' | sed 's/\\n/\n/g' | tee -a $log_file 
 
  echo | tee -a $log_file ##PaLM-$date_time.log
done

echo "All done! Exiting...Have a nice day!" | tee -a $log_file #PaLM-$date_time.log

exit 0
