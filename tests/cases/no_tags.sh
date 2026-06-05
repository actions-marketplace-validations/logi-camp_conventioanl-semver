echo -e "${YELLOW}No tags${NC}"

r=$(new_repo); commit "$r" "chore: init"
o=$(run_action "$r")
assert_eq "no-tags: version"               "0.0.1"  "$(get_out "$o" version)"
assert_eq "no-tags: version_tag"           "v0.0.1" "$(get_out "$o" version_tag)"
assert_eq "no-tags: previous_version"      "0.0.0"  "$(get_out "$o" previous_version)"
assert_eq "no-tags: bump"                  "patch"  "$(get_out "$o" bump)"
assert_eq "no-tags: previous_version_tag"  ""       "$(get_out "$o" previous_version_tag)"
rm_repo "$r"

r=$(new_repo); commit "$r" "feat: add login"
o=$(run_action "$r")
assert_eq "no-tags-feat: version" "0.1.0" "$(get_out "$o" version)"
assert_eq "no-tags-feat: bump"    "minor" "$(get_out "$o" bump)"
rm_repo "$r"

r=$(new_repo); commit "$r" "feat!: total rewrite"
o=$(run_action "$r")
assert_eq "no-tags-breaking: version" "1.0.0" "$(get_out "$o" version)"
assert_eq "no-tags-breaking: bump"    "major" "$(get_out "$o" bump)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"
o=$(INPUT_INITIAL_VERSION=2.5.0 run_action "$r")
assert_eq "initial-version: version"  "2.5.1" "$(get_out "$o" version)"
assert_eq "initial-version: previous" "2.5.0" "$(get_out "$o" previous_version)"
rm_repo "$r"
