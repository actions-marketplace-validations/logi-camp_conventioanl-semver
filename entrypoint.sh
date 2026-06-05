#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/inputs.sh
source "${SCRIPT_DIR}/lib/inputs.sh"
# shellcheck source=lib/git.sh
source "${SCRIPT_DIR}/lib/git.sh"
# shellcheck source=lib/classify.sh
source "${SCRIPT_DIR}/lib/classify.sh"
# shellcheck source=lib/semver.sh
source "${SCRIPT_DIR}/lib/semver.sh"
# shellcheck source=lib/changelog.sh
source "${SCRIPT_DIR}/lib/changelog.sh"
# shellcheck source=lib/outputs.sh
source "${SCRIPT_DIR}/lib/outputs.sh"

parse_inputs
find_latest_tag
parse_semver
collect_commits
classify_commits
determine_bump
calculate_version
build_changelog
write_outputs
