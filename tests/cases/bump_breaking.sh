echo -e "\n${YELLOW}Bump: breaking change via !${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.2.3"
commit "$r" "feat!: redesign API response format"
o=$(run_action "$r")
assert_eq "feat!: bump"    "major" "$(get_out "$o" bump)"
assert_eq "feat!: version" "2.0.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "fix!: change return type"
o=$(run_action "$r")
assert_eq "fix!: bump" "major" "$(get_out "$o" bump)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "refactor!: drop support for Node 14"
o=$(run_action "$r")
assert_eq "refactor!: bump" "major" "$(get_out "$o" bump)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "feat(api)!: remove deprecated endpoints"
o=$(run_action "$r")
assert_eq "type(scope)!: bump"    "major" "$(get_out "$o" bump)"
assert_eq "type(scope)!: version" "2.0.0" "$(get_out "$o" version)"
rm_repo "$r"

echo -e "\n${YELLOW}Bump: BREAKING CHANGE in commit body${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit_with_body "$r" "feat: update config format" "BREAKING CHANGE: old config keys removed"
o=$(run_action "$r")
assert_eq "breaking-body: bump"    "major" "$(get_out "$o" bump)"
assert_eq "breaking-body: version" "2.0.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit_with_body "$r" "fix: handle edge case" "BREAKING CHANGE: old param removed\nMigrate by using newParam"
o=$(run_action "$r")
assert_eq "breaking-body-fix: bump" "major" "$(get_out "$o" bump)"
rm_repo "$r"
