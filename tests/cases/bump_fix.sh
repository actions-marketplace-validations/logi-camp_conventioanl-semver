echo -e "\n${YELLOW}Bump: fix${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v2.3.4"
commit "$r" "fix: null pointer on login"
o=$(run_action "$r")
assert_eq "fix: bump"    "patch" "$(get_out "$o" bump)"
assert_eq "fix: version" "2.3.5" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "fix(auth): token expiry"
o=$(run_action "$r")
assert_eq "fix(scope): bump"    "patch" "$(get_out "$o" bump)"
assert_eq "fix(scope): version" "1.0.1" "$(get_out "$o" version)"
rm_repo "$r"
