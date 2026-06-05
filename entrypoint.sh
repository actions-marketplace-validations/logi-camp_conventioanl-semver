#!/usr/bin/env bash
set -eo pipefail

# --- Inputs ---
PREFIX="${INPUT_PREFIX:-v}"
DEFAULT_BUMP="${INPUT_DEFAULT_BUMP:-patch}"
INITIAL_VERSION="${INPUT_INITIAL_VERSION:-0.0.0}"

# --- Validate ---
case "$DEFAULT_BUMP" in
  major|minor|patch|none) ;;
  *)
    echo "::error::Invalid default_bump: '$DEFAULT_BUMP'. Must be one of: major, minor, patch, none" >&2
    exit 1
    ;;
esac

# --- Find latest version tag ---
PREVIOUS_TAG=$(git tag --list "${PREFIX}*" --sort=-v:refname 2>/dev/null \
  | grep -E "^${PREFIX}[0-9]+\.[0-9]+\.[0-9]+$" \
  | head -n1 || true)

if [ -z "$PREVIOUS_TAG" ]; then
  PREVIOUS_VERSION="$INITIAL_VERSION"
  LOG_RANGE=""
else
  PREVIOUS_VERSION="${PREVIOUS_TAG#"${PREFIX}"}"
  LOG_RANGE="${PREVIOUS_TAG}..HEAD"
fi

# --- Parse semver ---
IFS='.' read -r MAJOR MINOR PATCH <<< "$PREVIOUS_VERSION"
MAJOR="${MAJOR:-0}"
MINOR="${MINOR:-0}"
PATCH="${PATCH:-0}"

# --- Collect commits ---
if [ -n "$LOG_RANGE" ]; then
  SUBJECTS=$(git log "$LOG_RANGE" --pretty=format:"%s" 2>/dev/null || true)
  BODIES=$(git log "$LOG_RANGE" --pretty=format:"%b" 2>/dev/null || true)
else
  SUBJECTS=$(git log --pretty=format:"%s" 2>/dev/null || true)
  BODIES=$(git log --pretty=format:"%b" 2>/dev/null || true)
fi

LAST_COMMIT=$(git rev-parse HEAD 2>/dev/null || true)

# --- Classify commits ---
HAS_BREAKING=false
HAS_FEAT=false
HAS_PATCH=false

BREAKING_LIST=""
FEAT_LIST=""
FIX_LIST=""
PERF_LIST=""

# Check commit bodies for BREAKING CHANGE footer
if echo "$BODIES" | grep -q "^BREAKING CHANGE:"; then
  HAS_BREAKING=true
fi

while IFS= read -r subject; do
  [ -z "$subject" ] && continue

  if echo "$subject" | grep -qE "^[a-zA-Z]+(\([^)]*\))?!:"; then
    HAS_BREAKING=true
    BREAKING_LIST="${BREAKING_LIST}- ${subject}"$'\n'
  elif echo "$subject" | grep -qE "^feat(\([^)]*\))?:"; then
    HAS_FEAT=true
    FEAT_LIST="${FEAT_LIST}- ${subject}"$'\n'
  elif echo "$subject" | grep -qE "^fix(\([^)]*\))?:"; then
    HAS_PATCH=true
    FIX_LIST="${FIX_LIST}- ${subject}"$'\n'
  elif echo "$subject" | grep -qE "^perf(\([^)]*\))?:"; then
    HAS_PATCH=true
    PERF_LIST="${PERF_LIST}- ${subject}"$'\n'
  fi
done <<< "$SUBJECTS"

# --- Determine bump ---
if [ "$HAS_BREAKING" = true ]; then
  BUMP="major"
elif [ "$HAS_FEAT" = true ]; then
  BUMP="minor"
elif [ "$HAS_PATCH" = true ]; then
  BUMP="patch"
else
  BUMP="$DEFAULT_BUMP"
fi

# --- Calculate new version ---
NEW_MAJOR="$MAJOR"
NEW_MINOR="$MINOR"
NEW_PATCH="$PATCH"

case "$BUMP" in
  major) NEW_MAJOR=$((MAJOR + 1)); NEW_MINOR=0; NEW_PATCH=0 ;;
  minor) NEW_MINOR=$((MINOR + 1)); NEW_PATCH=0 ;;
  patch) NEW_PATCH=$((PATCH + 1)) ;;
  none)  ;;
esac

NEW_VERSION="${NEW_MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
NEW_TAG="${PREFIX}${NEW_VERSION}"

# --- Build changelog ---
CHANGELOG=""
[ -n "$BREAKING_LIST" ] && CHANGELOG+="## Breaking Changes"$'\n'"${BREAKING_LIST}"$'\n'
[ -n "$FEAT_LIST" ]     && CHANGELOG+="## Features"$'\n'"${FEAT_LIST}"$'\n'
[ -n "$FIX_LIST" ]      && CHANGELOG+="## Bug Fixes"$'\n'"${FIX_LIST}"$'\n'
[ -n "$PERF_LIST" ]     && CHANGELOG+="## Performance Improvements"$'\n'"${PERF_LIST}"$'\n'

# Trim trailing newline
CHANGELOG="${CHANGELOG%$'\n'}"

# --- Write outputs ---
{
  echo "version=${NEW_VERSION}"
  echo "version_tag=${NEW_TAG}"
  echo "previous_version=${PREVIOUS_VERSION}"
  echo "previous_version_tag=${PREVIOUS_TAG}"
  echo "bump=${BUMP}"
  echo "last_commit=${LAST_COMMIT}"
  printf "changelog<<SEMVER_EOF\n%s\nSEMVER_EOF\n" "${CHANGELOG}"
} >> "${GITHUB_OUTPUT}"

echo "::notice::${PREVIOUS_TAG:-none} → ${NEW_TAG} (${BUMP} bump)"
