parse_inputs() {
  PREFIX="${INPUT_PREFIX:-v}"
  DEFAULT_BUMP="${INPUT_DEFAULT_BUMP:-patch}"
  INITIAL_VERSION="${INPUT_INITIAL_VERSION:-0.0.0}"

  case "$DEFAULT_BUMP" in
    major|minor|patch|none) ;;
    *)
      echo "::error::Invalid default_bump: '$DEFAULT_BUMP'. Must be one of: major, minor, patch, none" >&2
      exit 1
      ;;
  esac
}
