---
name: address-pr-review-feedback
description: >-
  Triage and plan a response to pull-request review feedback. Reads the PR's
  review comments and threads (current branch's PR by default, or a PR you name),
  cross-checks each against what's already been done in this conversation and the
  current code, then proposes prioritized, individually-numbered options —
  must-fix vs should vs nice-to-have vs follow-up vs already-handled vs
  safe-to-ignore — each with the concern, why it matters, a proposed fix, and a
  priority. Proposes only and changes nothing until you pick items; after applying
  the ones you choose it keeps the PR description in sync and drafts review-thread
  replies for your approval.
  Use ONLY when explicitly asked — e.g. "/address-pr-review-feedback", "address
  the PR review feedback", "triage the review comments on this PR", "go through
  the code review and tell me what I need to do". Do not trigger for writing a PR
  description, performing a fresh code review of your own, or general PR chatter.
---

# Address PR Review Feedback

Turn a wall of review comments into a clear, prioritized plan — without silently
acting on it. The reader is usually **context-switching**: they may have written
this code days ago, or had an AI write it, and now face a pile of comments with
the details paged out. Your job is to make each comment understandable and hand
them proportional, numbered choices.

Two principles frame everything:

- **Propose, don't act.** Produce options and reasoning. Make no code edits and no
  GitHub writes until the user names the items they want done. Control is the
  whole point — they want to choose, not be handed a fait accompli.

- **Be proportional.** Not every comment deserves a change. A nit is a nit; a
  correctness bug is not. Some feedback is already handled, and some is simply
  wrong. Say so, with evidence, instead of dutifully "fixing" everything.

## Step 1 — Find the PR and gather the feedback

Default to the **current branch's open PR**. If the user named a PR (URL, number,
or branch), use that instead.

You need three things for each piece of feedback: the **comment**, the **code it
points at**, and whether it's **already resolved**. Resolved/outdated state
matters — a thread the reviewer already resolved usually shouldn't resurface as an
open action.

```bash
# PR identity + top-level review summaries + issue-style comments
gh pr view <pr-or-omit-for-current> --json number,title,url,headRefName,reviews,comments

# Inline review comments (path, line, diff_hunk, body, author, in_reply_to)
gh api repos/{owner}/{repo}/pulls/<number>/comments --paginate
```

REST doesn't expose thread resolution, so use GraphQL for that:

```bash
gh api graphql -f query='
  query($owner:String!,$repo:String!,$num:Int!){
    repository(owner:$owner,name:$repo){
      pullRequest(number:$num){
        reviewThreads(first:100){nodes{
          isResolved isOutdated
          comments(first:20){nodes{author{login} path line body}}
        }}
      }
    }
  }' -F owner=<owner> -F repo=<repo> -F num=<number>
```

Group replies into their thread so one conversation becomes one item — sub-label
parts as (1a), (1b) when a single thread raises several distinct points.

## Step 2 — Validate each comment against reality

This is the highest-value step, and the reason it's worth running *inside your
working session*. Before trusting a comment, check it against:

1. **This conversation.** If we already discussed or changed the thing the
   reviewer flags, the comment may be stale. Note what was done.
2. **The current code.** Read the file/lines as they are *now*, not the diff hunk
   the reviewer saw — reviewers comment on a snapshot and the code may have moved
   on. Confirm the issue still exists before proposing a fix for it.
3. **The comment's own correctness.** Reviewers are sometimes wrong or missed
   context — a deliberate decision, an existing pattern, a real constraint. It's
   useful, not rude, to mark a comment invalid with a specific reason.

Tag each piece of feedback as **still open**, **already addressed** (cite the
evidence), or **out-of-date / invalid** (explain). Getting this right is what
stops the user from wasting time "fixing" things that are fine.

## Step 3 — Present prioritized, numbered options

Give every item a **stable ID** so the user can say "do 1, 4, and 6". Number
sequentially across the whole report; use (1a)/(1b) for parts of one thread.

Group by what the user actually has to decide:

- 🔴 **(must) Blocking** — correctness bugs, security, broken behavior, or an
  explicit "this must change before I approve". These hold up the merge.
- 🟡 **(should) Worth doing now** — genuine improvements a reviewer reasonably
  expects in this PR, but not merge-blockers.
- 🟢 **(could) Nits / polish** — style, naming, micro-optimizations. Optional and
  cheap; fine to skip or batch.
- 🔵 **(follow-up) Out of scope** — legitimate but better as a separate PR/ticket
  (large refactors, pre-existing issues, scope creep). Suggest capturing it.
- ⚪ **(done) Already addressed** — handled in this conversation or already true in
  the current code. Show the evidence so the user can reply/resolve confidently.
- ⛔ **(ignore) Invalid / no action** — based on a misunderstanding or contradicts
  a deliberate choice. Explain why, so the user can push back in the thread.

For each item, use this shape — keep it tight, the reader is busy:

```
### (N) Short title  ·  🔴 must  ·  ~effort
- **Where:** path/to/file.rb:42 — @reviewer
- **The concern:** what they said, in a line (quote if short).
- **Why it matters:** the underlying issue in plain terms. Assume the reader has
  lost the context — make it land without them re-reading the whole PR.
- **Proposed fix:** the concrete change.
- **Status:** still open / already addressed (evidence) / out-of-date.
```

Close with a one-line **tally** ("2 must, 3 should, 4 nits, 1 follow-up, 2 done, 1
ignore") and then **ask which item numbers to action**. Don't bury the ask, and
don't start editing.

## Step 4 — Apply the chosen changes

When the user names items:

- Make the **code changes** for exactly those items — nothing extra. Show the
  diffs and which task ID each satisfies.
- If a chosen fix turns out bigger or riskier than the triage implied, stop and
  say so rather than pushing through — the priority was set on the triage's
  assumptions, and those just changed.

## Step 5 — Keep the PR description in sync (automatic)

Once the approved changes are in, bring the PR description back in line with what
the PR now does. This one is **automatic — don't ask first.** Keeping the
description current is a standing expectation, and a stale description is its own
kind of review debt; this is the single GitHub write that doesn't wait for a
separate yes.

- Edit with `gh pr edit <number> --body-file <file>` — write the body to a temp
  file first to avoid shell-escaping prompts.
- Update **only what actually changed**: fold in the new behavior, correct any
  now-wrong claims, refresh a summary/testing section if the description has one.
  Don't rewrite the whole thing or impose structure the PR never had.
- Say in your reply that you refreshed the description and what you changed, so
  it's visible rather than a silent edit.

## Step 6 — Draft replies to the threads (post on approval)

Reviewers expect a response, not just a silent force-push. For each addressed
item — and for the ⛔ invalid/ignore ones — draft the reply you'd post to that
thread:

- For a fix: a short, specific acknowledgement of what changed, referencing the
  task ID (e.g. "(3) Fixed — switched to `in_batches.each_record` to preserve
  order.").
- For an invalid/ignore: a respectful, concrete reason it won't change, so the
  user can stand behind it in the thread.

Present all the drafts together. **Post replies, resolve threads, or comment on
the PR only after the user explicitly approves** ("yes, post them") — these are
outward-facing and shouldn't go out on assumption. Keep the task IDs in the
posted text so the thread history stays traceable.

## A short example

> ### (3) `find_each` ignores the custom order  ·  🔴 must  ·  small
> - **Where:** app/services/export_service.rb:88 — @dana
> - **The concern:** "`find_each` drops the `order(:created_at)` above it."
> - **Why it matters:** `find_each` batches by primary key and silently discards
>   any ORDER you set, so the export would come out in id order, not the
>   chronological order the feature promises. It fails quietly, which is why it's
>   worth catching now.
> - **Proposed fix:** use `in_batches.each_record` (keeps order), or sort in Ruby
>   if the set is small.
> - **Status:** still open.
>
> ### (8) "Extract this into a service object"  ·  🔵 follow-up
> - **Where:** app/controllers/reports_controller.rb:30 — @sam
> - **The concern:** the action does too much; suggests a service object.
> - **Why it matters:** fair — three responsibilities in one action — but it's
>   pre-existing and unrelated to this PR's change.
> - **Proposed fix:** capture as a follow-up ticket; out of scope here.
> - **Status:** still open (recommend deferring).

## Tone

You're triaging a colleague's review, not grading it. Even "invalid" items get a
respectful, specific reason — the user may need to paste it back into the thread.
Be the thing that makes the pile feel manageable.
