parse_semver() {
  IFS='.' read -r MAJOR MINOR PATCH <<< "$PREVIOUS_VERSION"
  MAJOR="${MAJOR:-0}"
  MINOR="${MINOR:-0}"
  PATCH="${PATCH:-0}"
}

determine_bump() {
  if [ "$HAS_BREAKING" = true ]; then
    BUMP="major"
  elif [ "$HAS_FEAT" = true ]; then
    BUMP="minor"
  elif [ "$HAS_PATCH" = true ]; then
    BUMP="patch"
  else
    BUMP="$DEFAULT_BUMP"
  fi
}

calculate_version() {
  NEW_MAJOR="$MAJOR"
  NEW_MINOR="$MINOR"
  NEW_PATCH="$PATCH"

  case "$BUMP" in
    major) NEW_MAJOR=$((MAJOR + 1)); NEW_MINOR=0; NEW_PATCH=0 ;;
    minor) NEW_MINOR=$((MINOR + 1)); NEW_PATCH=0 ;;
    patch) NEW_PATCH=$((PATCH + 1)) ;;
    none)  ;;
  esac

  NEW_VERSION="${NEW_MAJOR}.${NEW_MINOR}.${NEW_PATCH}"
  NEW_TAG="${PREFIX}${NEW_VERSION}"
}
