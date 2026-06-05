echo -e "\n${YELLOW}Changelog${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "feat: add dark mode toggle"
commit "$r" "feat(api): add pagination support"
commit "$r" "fix: resolve null pointer on login"
commit "$r" "perf: cache database queries"
o=$(run_action "$r")
cl=$(get_multiline "$o" "changelog")
assert_contains     "changelog: Features section"  "## Features"                  "$cl"
assert_contains     "changelog: Bug Fixes section"  "## Bug Fixes"                "$cl"
assert_contains     "changelog: Perf section"       "## Performance Improvements" "$cl"
assert_contains     "changelog: feat entry"         "feat: add dark mode toggle"  "$cl"
assert_contains     "changelog: feat(scope) entry"  "feat(api): add pagination"   "$cl"
assert_contains     "changelog: fix entry"          "fix: resolve null pointer"   "$cl"
assert_contains     "changelog: perf entry"         "perf: cache database queries" "$cl"
assert_not_contains "changelog: chore absent"       "chore:"                      "$cl"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "feat!: redesign API response format"
o=$(run_action "$r")
cl=$(get_multiline "$o" "changelog")
assert_contains "changelog: Breaking Changes section" "## Breaking Changes"          "$cl"
assert_contains "changelog: breaking entry"           "feat!: redesign API response" "$cl"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "docs: update readme"
o=$(INPUT_DEFAULT_BUMP=none run_action "$r")
cl=$(get_multiline "$o" "changelog")
assert_eq "changelog: empty when no conv commits" "" "$cl"
rm_repo "$r"
