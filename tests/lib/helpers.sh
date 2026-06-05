pass() { echo -e "  ${GREEN}✓${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${RED}✗${NC} $1: $2"; FAIL=$((FAIL + 1)); ERRORS+=("$1: $2"); }

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  if [ "$expected" = "$actual" ]; then pass "$name"
  else fail "$name" "expected '${expected}', got '${actual}'"; fi
}

assert_contains() {
  local name="$1" needle="$2" haystack="$3"
  if echo "$haystack" | grep -qF "$needle"; then pass "$name"
  else fail "$name" "'${needle}' not found in output"; fi
}

assert_not_contains() {
  local name="$1" needle="$2" haystack="$3"
  if ! echo "$haystack" | grep -qF "$needle"; then pass "$name"
  else fail "$name" "'${needle}' should not appear in output"; fi
}

new_repo() {
  local dir
  dir=$(mktemp -d)
  git init "$dir" -q
  git -C "$dir" config user.email "ci@test.local"
  git -C "$dir" config user.name "CI Test"
  echo "$dir"
}

commit() {
  local repo="$1"; shift
  git -C "$repo" commit --allow-empty -m "$@" -q
}

commit_with_body() {
  local repo="$1" subject="$2" body="$3"
  git -C "$repo" commit --allow-empty -m "$subject" -m "$body" -q
}

tag() { git -C "$1" tag "$2"; }

run_action() {
  local repo="$1"
  local out
  out=$(mktemp)
  (
    cd "$repo"
    INPUT_PREFIX="${INPUT_PREFIX:-v}" \
    INPUT_DEFAULT_BUMP="${INPUT_DEFAULT_BUMP:-patch}" \
    INPUT_INITIAL_VERSION="${INPUT_INITIAL_VERSION:-0.0.0}" \
    GITHUB_OUTPUT="$out" \
    bash "$ENTRYPOINT" >/dev/null
  )
  echo "$out"
}

get_out() {
  local file="$1" key="$2"
  grep "^${key}=" "$file" 2>/dev/null | head -n1 | cut -d= -f2- || true
}

get_multiline() {
  local file="$1" key="$2"
  awk -v key="$key" '
    $0 ~ ("^" key "<<") { delim=substr($0, length(key "<<")+1); in_block=1; next }
    in_block && $0==delim { in_block=0; next }
    in_block { print }
  ' "$file" 2>/dev/null || true
}

rm_repo() { rm -rf "$1"; }
