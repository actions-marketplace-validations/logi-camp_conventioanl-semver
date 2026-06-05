echo -e "\n${YELLOW}Default bump${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "docs: update readme"
o=$(run_action "$r")
assert_eq "default-patch: bump"    "patch" "$(get_out "$o" bump)"
assert_eq "default-patch: version" "1.0.1" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "docs: update readme"
o=$(INPUT_DEFAULT_BUMP=minor run_action "$r")
assert_eq "default-minor: bump"    "minor" "$(get_out "$o" bump)"
assert_eq "default-minor: version" "1.1.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "docs: update readme"
o=$(INPUT_DEFAULT_BUMP=major run_action "$r")
assert_eq "default-major: bump"    "major" "$(get_out "$o" bump)"
assert_eq "default-major: version" "2.0.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "docs: update readme"
o=$(INPUT_DEFAULT_BUMP=none run_action "$r")
assert_eq "default-none: bump"    "none"  "$(get_out "$o" bump)"
assert_eq "default-none: version" "1.0.0" "$(get_out "$o" version)"
rm_repo "$r"
