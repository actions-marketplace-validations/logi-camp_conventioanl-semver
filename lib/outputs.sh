write_outputs() {
  {
    echo "version=${NEW_VERSION}"
    echo "version_tag=${NEW_TAG}"
    echo "previous_version=${PREVIOUS_VERSION}"
    echo "previous_version_tag=${PREVIOUS_TAG}"
    echo "bump=${BUMP}"
    echo "last_commit=${LAST_COMMIT}"
    printf "changelog<<SEMVER_EOF\n%s\nSEMVER_EOF\n" "${CHANGELOG}"
  } >> "${GITHUB_OUTPUT}"

  echo "::notice::${PREVIOUS_TAG:-none} → ${NEW_TAG} (${BUMP} bump)"
}
