echo -e "\n${YELLOW}Bump: perf${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "perf: cache database queries"
o=$(run_action "$r")
assert_eq "perf: bump"    "patch" "$(get_out "$o" bump)"
assert_eq "perf: version" "1.0.1" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "perf(db): index on users table"
o=$(run_action "$r")
assert_eq "perf(scope): bump" "patch" "$(get_out "$o" bump)"
rm_repo "$r"
