echo -e "\n${YELLOW}Version arithmetic${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v3.7.9"
commit "$r" "feat!: breaking"
o=$(run_action "$r")
assert_eq "major-resets-minor-patch: version" "4.0.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.5.8"
commit "$r" "feat: something"
o=$(run_action "$r")
assert_eq "minor-resets-patch: version" "1.6.0" "$(get_out "$o" version)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "docs: no bump"
o=$(INPUT_DEFAULT_BUMP=none run_action "$r")
assert_eq "none-keeps-version: version" "1.0.0" "$(get_out "$o" version)"
assert_eq "none-keeps-version: bump"    "none"  "$(get_out "$o" bump)"
rm_repo "$r"
