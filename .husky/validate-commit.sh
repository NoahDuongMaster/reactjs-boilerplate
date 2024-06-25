#!/bin/sh

# Determine the platform
PLATFORM=$(uname)

# Function to read file content
read_file_content() {
  file_path=$1
  if [ "$PLATFORM" = "Linux" ] || [ "$PLATFORM" = "Darwin" ]; then
    # Unix-like system (Linux, macOS)
    cat "$file_path"
  elif echo "$PLATFORM" | grep -q "MINGW" || echo "$PLATFORM" | grep -q "CYGWIN"; then
    # Windows system
    powershell.exe -Command "Get-Content -Path '$file_path'"
  else
    echo "Unsupported platform: $PLATFORM"
    exit 1
  fi
}

COMMIT_MSG_PATH=
while getopts "m:" opt
do
   case "$opt" in
      m ) COMMIT_MSG_PATH="$OPTARG" ;;
   esac
done

TYPE=$(read_file_content "$PWD/.husky/metadata/type.txt")
SERVICE=$(read_file_content "$PWD/.husky/metadata/service.txt")
ISSUE_CODE=$(read_file_content "$PWD/.husky/metadata/issue_code.txt")
COMMIT_MSG="$(cat "$COMMIT_MSG_PATH")"
valid_commit_regex="^(($TYPE)\(($SERVICE)\): ($ISSUE_CODE(-)[0-9]+|no_issue) [a-zA-Z0-9 \-]+)$"

message="❌ Commit invalid, regex: $valid_commit_regex"

# Use awk to check if the commit message matches the regex
if echo "$COMMIT_MSG" | awk "/$valid_commit_regex/ { exit 0 } { exit 1 }" > /dev/null 2>&1; then
  exit 0
else
  echo "$message"
  echo "Eg: feat(dapp): "$ISSUE_CODE"-112 test commit"
  exit 1
fi

exit 0
