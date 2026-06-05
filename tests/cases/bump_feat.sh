echo -e "\n${YELLOW}Bump: feat${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "feat: dark mode"
o=$(run_action "$r")
assert_eq "feat: bump"    "minor" "$(get_out "$o" bump)"
assert_eq "feat: version" "1.1.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "feat(api): add pagination"
o=$(run_action "$r")
assert_eq "feat(scope): bump"    "minor" "$(get_out "$o" bump)"
assert_eq "feat(scope): version" "1.1.0" "$(get_out "$o" version)"
rm_repo "$r"
