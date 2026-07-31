#!/bin/bash
# Logs terraform commands after they run successfully
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command')

if echo "$command" | grep -q 'terraform'; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $command" >> "${CLAUDE_PROJECT_DIR}/.claude/deploy.log"
fi

exit 0
