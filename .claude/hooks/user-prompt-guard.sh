#!/bin/bash
# Reads what the user typed and blocks it if it sounds destructive
input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt')

if echo "$prompt" | grep -Eiq 'delete everything|destroy (the|all)|wipe (the|all)|rm -rf /'; then
  echo "Blocked: this prompt sounds destructive and was stopped before Claude could act on it." >&2
  exit 2
fi

exit 0
