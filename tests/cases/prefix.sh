echo -e "\n${YELLOW}Prefix${NC}"

r=$(new_repo); commit "$r" "chore: init"; tag "$r" "v1.0.0"
commit "$r" "fix: something"
o=$(run_action "$r")
assert_eq "default-prefix: version_tag"          "v1.0.1" "$(get_out "$o" version_tag)"
assert_eq "default-prefix: previous_version_tag" "v1.0.0" "$(get_out "$o" previous_version_tag)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"; git -C "$r" tag "release-2.0.0"
commit "$r" "fix: something"
o=$(INPUT_PREFIX=release- run_action "$r")
assert_eq "custom-prefix: version"              "2.0.1"         "$(get_out "$o" version)"
assert_eq "custom-prefix: version_tag"          "release-2.0.1" "$(get_out "$o" version_tag)"
assert_eq "custom-prefix: previous_version_tag" "release-2.0.0" "$(get_out "$o" previous_version_tag)"
rm_repo "$r"

r=$(new_repo); commit "$r" "chore: init"
o=$(run_action "$r")
assert_eq "no-prior-tag: previous_version_tag" "" "$(get_out "$o" previous_version_tag)"
rm_repo "$r"
