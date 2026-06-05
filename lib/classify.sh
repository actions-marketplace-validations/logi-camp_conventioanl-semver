classify_commits() {
  HAS_BREAKING=false
  HAS_FEAT=false
  HAS_PATCH=false

  BREAKING_LIST=""
  FEAT_LIST=""
  FIX_LIST=""
  PERF_LIST=""

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
}
