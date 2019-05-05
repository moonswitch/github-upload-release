#!/bin/bash

set -euo pipefail

if [[ -z "$GITHUB_WORKSPACE" ]]; then
  echo "Set the GITHUB_WORKSPACE env variable."
  exit 1
fi

if [[ -z "$GITHUB_REF" ]]; then
    echo "Set the GITHUB_REF env variable."
    exit 1
fi

# Regex and validate-version function adapted from https://github.com/fsaintjacques/semver-tool/blob/master/src/semver
SEMVER_REGEX="^[v]?(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)(\\-[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?(\\+[0-9A-Za-z-]+(\\.[0-9A-Za-z-]+)*)?$"

function validate-version {
  local version=$1
  if [[ "$version" =~ $SEMVER_REGEX ]]; then
    # if a second argument is passed, store the result in var named by $2
    if [ "$#" -eq "2" ]; then
      local major=${BASH_REMATCH[1]}
      local minor=${BASH_REMATCH[2]}
      local patch=${BASH_REMATCH[3]}
      local prere=${BASH_REMATCH[4]}
      local build=${BASH_REMATCH[5]}
      eval "$2=(\"$major\" \"$minor\" \"$patch\" \"$prere\" \"$build\")"
    else
      echo "$version"
    fi
  else
    echo -e "version '$version' does not match the semver scheme 'X.Y.Z(-PRERELEASE)(+BUILD)'. Ensure this action is being run for a tag and not a branch." >&2
    exit 1
  fi
}

release_path="$GITHUB_WORKSPACE/.release"
version="${GITHUB_REF##*/}"

validate-version $version

echo "----> Creating release $version and uploading files from $release_path:"
ghr $version $release_path
