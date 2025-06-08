#!/usr/bin/env bash
#
#
# Title: PaLM Shell - Pathways Language Model Shell. Now Google Gemini.
#
# Description: A interactive prompt-response shell that uses RESTful API calls
#              to send prompts and receive the responses, display, and log the
#              results from Google Gemini API. PaLM was original name for 
#              Pathways API LLM Model.
#
#
# By William F. Gilreath (will@wfgilreath.xyz)
# Version 2.1  06/07/2024
#
# Copyright © 2025 All Rights Reserved.
#
# License: This software is subject to the terms of the GNU General Public License (GPL)
#     version 3.0 available at the following link: http://www.gnu.org/copyleft/gpl.html.
#
# You must accept the terms of the GNU General Public License (GPL) license agreement
#     to use this software.
#
# Updated with new Google Gemini API 9-30-2024
# Updated with $PALM_MODEL to more easily change Google Gemini model 6-7-2025
#
#

PALM_KEY="DML6817f041-73d3-4740-82a1-c06e584e7393"  #pseudo-value ROT13 ;-)

# gemini models used list of models:
# https://ai.google.dev/gemini-api/docs/models
#
PALM_MODEL0="gemini-1.5-flash-latest:generateContent" #expires by Sep 24 2025
PALM_MODEL1="gemini-2.0-flash:generateContent" 
PALM_MODEL2="gemini-2.5-flash-preview-05-20:generateContent"

PALM_MODEL="gemini-2.0-flash:generateContent" #gemini model used in script

#
# copyright and version of PaLMShell script
#
VERSION="v2.1"
COPYRIGHT="2025"

#
# PaLM shell header
#
echo "PaLM Shell $VERSION (c) $COPYRIGHT William F. Gilreath"
echo "All Rights Reserved. License is GPLv3                 "
echo

#
# check if PALM_KEY empty, report error need key, exit
if [ -z $PALM_KEY ]
then
  echo "Must have PaLM key to use PaLM API!"
  exit 1
fi

date_time=$(date | date | tr '  ' '-' | tr ':' '-' | tr -s '--' '-')
log_file="PaLM-$date_time.log"

echo
echo "Logging this session to: 'PaLM-$date_time.log'"
echo

#
# main loop of PaLM shell script
#
while :
do
  # print prompt and read line into $prompt_line
  echo -n "PaLM>"
  read -r prompt_line

  # command 'bye' is bye/exit/quit PaLM Shell
  if [ "$prompt_line" == "bye" ]; then
    break
  fi

  # command 'clear' is 'clear' console window with external shell command
  if [ "$prompt_line" == "clear" ]; then
    clear
    continue
  fi
  
  # check if input is blank line avoid empty prompt
  if [ -z "$prompt_line" ]; then
    continue
  fi

  echo "Prompt: '$prompt_line'" | tee -a "$log_file" #PaLM-$date_time.log

  echo | tee -a "$log_file" #PaLM-$date_time.log

  curl \
  -s \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":'"\"$prompt_line\""'}]}]}' \
  -X POST "https://generativelanguage.googleapis.com/v1beta/models/$PALM_MODEL?key=$PALM_KEY" | jq '.candidates[].content.parts[].text' | sed 's/\\n/\n/g' | tee -a "$log_file" 
 
  echo | tee -a "$log_file" ##PaLM-$date_time.log

done

echo ""
echo "All done! Exiting...Have a nice day!"
echo ""

exit 0
