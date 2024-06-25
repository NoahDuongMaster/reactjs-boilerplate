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

# Get the local branch name
local_branch_name="$(git rev-parse --abbrev-ref HEAD)"

# Read metadata from files
TYPE=$(read_file_content "$PWD/.husky/metadata/type.txt")
SERVICE=$(read_file_content "$PWD/.husky/metadata/service.txt")
ISSUE_CODE=$(read_file_content "$PWD/.husky/metadata/issue_code.txt")

# Define the regex for a valid branch name
valid_branch_regex="^(($TYPE)\(($SERVICE)\)/($ISSUE_CODE(-)[0-9]+(-)|no_issue(-))[a-zA-Z0-9\-]+)$"

# Error message for invalid branch name
message="❌ Branch name invalid, regex: $valid_branch_regex"

echo "Validating branch name: $local_branch_name"
echo "Regex: $valid_branch_regex"

# Use awk to check if the commit message matches the regex
if echo "$local_branch_name" | awk "/$valid_branch_regex/ { exit 0 } { exit 1 }"; then
  exit 0
else
  echo "$message"
  echo "Eg: feat(dapp)/$ISSUE_CODE-112-test-branch"
  exit 1
fi

exit 0
