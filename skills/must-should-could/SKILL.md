---
name: must-should-could
description: >-
  Presentation format that groups items (PR review findings, spec requirements,
  bug report issues, to-dos, etc.) under Must / Should / Could headings, or
  P1-P4 headings when prioritizing, each with an emoji and an item count. Use
  when the user says "/must-should-could", "present as must/should/could", "MoSCoW
  this", or asks for items grouped by P1/P2/P3/P4 priority.
---

# Must / Should / Could

A presentation preference. Do the underlying task first (review the PR, read the spec, triage the bug, etc.), then present the resulting items in this format.

## 1. Pick the mode

- **Must / Should / Could** (default): when the question is "what's needed?" - review changes, requirements, scope.
- **P1-P4**: when the user says "prioritize", "priority", "P1", or passes `priority` / `p` as an argument - ordering work by urgency.

| Must / Should / Could | Meaning |
|---|---|
| 🔴 Must | Blocking. Without it the thing is wrong, broken, unsafe, or won't ship. |
| 🟠 Should | Important. Real cost if skipped, but not blocking. |
| 🟢 Could | Nice to have. Polish, follow-ups, optional. |

| Priority | Meaning |
|---|---|
| 🔴 P1 | Do now. Urgent and important. |
| 🟠 P2 | Do next. Important, not urgent. |
| 🟡 P3 | Do later. Worth doing when there's room. |
| 🟢 P4 | Backlog. Low value or speculative. |

## 2. Format

```
## 🔴 Must (2)
1. **<Short title>** - <one line: what and why>. `<file:line or link if relevant>`
2. ...

## 🟠 Should (1)
3. ...

## 🟢 Could (0)
None.
```

## Rules

- Heading = emoji + label + count in parentheses.
- Number items **continuously across groups** (1, 2, 3...) so the user can reply "do 1 and 3".
- Order groups highest to lowest. Within a group, most important first.
- Show every group, even empty ones (count `(0)`, body "None.") - an empty Must is useful to know.
- One item per distinct thing. Bold short title, then one line on what and why. Add a reference (file:line, link, ticket) when there is one.
- Be honest with the grading. Don't inflate to Must, and don't pad Could to fill the list.
- If an item's grade depends on an assumption, say so in the item.
- Anything outside the list (summary, verdict, questions) goes above or below the groups, kept short.
