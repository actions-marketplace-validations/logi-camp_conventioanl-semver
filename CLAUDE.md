# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this action does

A pure-bash GitHub Actions composite action. Given a git repo that uses [Conventional Commits](https://www.conventionalcommits.org/), it:
1. Finds the latest `vX.Y.Z` tag (configurable prefix)
2. Scans commits since that tag
3. Calculates the next semantic version
4. Emits a grouped markdown changelog and all version data as step outputs

No runtime, no Node.js, no Docker — only bash and git.

## Files

- `action.yml` — declares inputs, outputs (mapped from `steps.semver.outputs.*`), and the composite run step
- `entrypoint.sh` — all logic; receives inputs via `INPUT_*` env vars set in `action.yml`

## Conventional commit → bump rules

| Commit pattern | Bump |
|---|---|
| `type!:` or `type(scope)!:` | major |
| `BREAKING CHANGE:` in commit body | major |
| `feat:` / `feat(scope):` | minor |
| `fix:` / `fix(scope):` | patch |
| `perf:` / `perf(scope):` | patch |
| anything else | `default_bump` input (default: `patch`) |

Priority: **major > minor > patch**. The highest bump found across all commits wins.

## Outputs

`version`, `version_tag`, `previous_version`, `previous_version_tag`, `changelog`, `bump`, `last_commit`

## Testing locally

Requires a git repo with tags. Run with a temp output file:

```bash
INPUT_PREFIX=v INPUT_DEFAULT_BUMP=patch INPUT_INITIAL_VERSION=0.0.0 \
  GITHUB_OUTPUT=/tmp/out bash entrypoint.sh && cat /tmp/out
```

## User requirement

Callers must check out with full history — shallow clones miss tags and commit history:

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0
```
