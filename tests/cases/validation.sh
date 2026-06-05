echo -e "\n${YELLOW}Validation${NC}"

r=$(new_repo); commit "$r" "chore: init"
rc=0
(
  cd "$r"
  INPUT_PREFIX=v INPUT_DEFAULT_BUMP=bogus INPUT_INITIAL_VERSION=0.0.0 \
  GITHUB_OUTPUT=/dev/null bash "$ENTRYPOINT" >/dev/null 2>&1
) || rc=$?
if [ "$rc" -ne 0 ]; then pass "invalid-bump: exits non-zero"
else fail "invalid-bump: exits non-zero" "expected non-zero exit, got 0"; fi
rm_repo "$r"
