---
name: rebase
description: Rebase the current branch (or a named one) onto the latest remote base branch, resolve conflicts, commit only relevant changes, force-push with lease, and verify any open PR description. Use when the user says "rebase", "rebase this branch", "rebase onto main/develop", or "/rebase".
---

# rebase

Rebase a branch onto the latest remote base branch, then force-push and sanity-check the PR.

- **Target branch** = the one named by the user, else the current branch. Never rebase the base branch itself.
- **Base branch** = the one the user named, else the open PR's base (`gh pr view --json baseRefName -q .baseRefName`), else the remote default (`git symbolic-ref --short refs/remotes/origin/HEAD`, e.g. `origin/main`).

## Steps

1. **Fetch**: `git fetch origin`
2. **Rebase**: `git rebase origin/<base>` (checkout the target branch first if one was named).
3. **Resolve conflicts**: resolve them yourself. Keep both sides' intent; prefer the incoming base for pure infra/lockfile churn and the branch's version for its own feature code. Only stop to ask the user when the correct resolution is genuinely ambiguous and picking wrong would lose real work. After each fix: `git add <files>` then `git rebase --continue`.
4. **Commit only relevant changes**: stage only files that belong to this branch's work. Never `git add -A` blindly - leave unrelated/stray files unstaged. If nothing relevant changed, don't create empty commits.
5. **Force-push**: `git push --force-with-lease`.
6. **Check the PR**: if an open PR exists for the branch (`gh pr view`), read its description against the final diff (`gh pr diff`). If the summary is stale or inaccurate, update it (`gh pr edit --body-file`). If accurate, leave it.

## Notes

- If the working tree is dirty before starting, stash or surface it - don't rebase over uncommitted mess silently.
- If the rebase can't proceed safely (diverged in a way that risks data loss), stop and report rather than guessing.
