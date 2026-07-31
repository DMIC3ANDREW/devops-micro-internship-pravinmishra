#!/bin/bash
# Reads the command Claude is about to run and blocks dangerous ones
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

if echo "$command" | grep -Eq 'terraform destroy|rm -rf|aws .* delete|az .* delete'; then
  echo "Blocked: this command is destructive and was stopped before it ran." >&2
  exit 2
fi

exit 0
