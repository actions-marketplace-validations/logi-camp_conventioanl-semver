echo -e "\n${YELLOW}Priority: major > minor > patch${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "fix: small bug"
commit "$r" "feat: new thing"
o=$(run_action "$r")
assert_eq "minor-over-patch: bump"    "minor" "$(get_out "$o" bump)"
assert_eq "minor-over-patch: version" "1.1.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "feat: new thing"
commit "$r" "fix: bug"
commit "$r" "feat!: breaking"
o=$(run_action "$r")
assert_eq "major-over-all: bump"    "major" "$(get_out "$o" bump)"
assert_eq "major-over-all: version" "2.0.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "fix: bug"
commit_with_body "$r" "fix: another" "BREAKING CHANGE: changed interface"
o=$(run_action "$r")
assert_eq "breaking-body-priority: bump" "major" "$(get_out "$o" bump)"
rm_repo "$r"
