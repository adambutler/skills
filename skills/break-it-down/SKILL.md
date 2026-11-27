---
name: break-it-down
description: >-
  Produce a layered, progressively-deepening explanation of a complex technical
  subject, system, PR, bug, or concept — written for an experienced (Ruby-leaning)
  engineer who has been context-switching and needs to re-acquire context fast.
  Opens with a plain-language gist, then layers in technical depth so the reader
  can stop at whatever depth they need. Use this ONLY when the user explicitly asks
  for it — e.g. "break it down", "break this down", "give me a layered explanation",
  "catch me up on X / explain X properly / walk me through how X works in depth",
  or when they invoke /break-it-down. Do not trigger for quick one-line factual
  lookups where a single sentence is the right answer.
---

# Break It Down

Turn something complex into an explanation that an experienced engineer can absorb
quickly — even when they've been pulled in ten directions and have lost the thread.

## Who you're writing for

Picture a strong engineer who has context-switched hard and is coming to this topic
cold. They are sharp, but **out of the loop**. Your job is to rebuild their mental
model efficiently — not to teach them to code.

- 🧠 **Deep Ruby/Rails fluency.** Don't explain blocks, ActiveRecord, mixins, enums,
  metaprogramming, or other Ruby/Rails idioms — use them freely. Explaining them
  wastes the reader's time and reads as condescending.
- 🟨 **Moderate JS / TypeScript / React.** They can read it, but may be rusty on
  current patterns. When these come up, add a half-sentence of orientation (e.g. what
  a React Query `select` does, why a hook re-runs) rather than assuming fluency.
- 🔌 **Missing *situational* context, not *foundational* knowledge.** The gap is
  usually "where does this live, what problem does it solve, what happened before me"
  — so restore that. Name the actual files, models, and flows.

The guiding tension: **don't dumb it down — layer it up.** Depth is good; dumping all
the depth at once is the problem.

## The core technique: layer, don't flatten

Lead with the simplest true version, then add precision in passes. A context-switched
expert needs the high-level frame re-established *before* details will stick. Layering
also lets them bail out at the depth they need — read the gist and leave, or read to
the bottom. This is progressive disclosure applied to prose.

Two habits make this work:

1. **Separate concerns before you explain them.** Break the subject into its distinct
   parts/responsibilities, explain each in isolation, *then* show how they interact.
   Interleaving everything at once is what makes explanations feel like a wall.
2. **Cover what / why / how — but only where each earns its place.** *What* it is,
   *why* it exists (the problem or motivation), *how* it works (the mechanism). The
   **why** is the part most explanations skip and the part a returning engineer most
   needs — it's what makes the rest cohere. Don't force all three on every point.

## Default structure

Use this as a flexible scaffold, not a form to fill in. Drop sections that don't
apply, merge them for small topics, add depth for large ones. Match the size of the
explanation to the size of the subject — a one-file bug fix is not five sections.

```markdown
## 🎯 The gist
1–3 sentences. What this is and why it matters, in plain language — the version you'd
say out loud to a colleague at the coffee machine. No jargon yet.

## 🧭 Context you might be missing
Orient the returning reader: where this lives in the codebase, the problem it solves,
and any prior state/history that makes the rest make sense.

## 🧱 How it fits together
Separate the moving parts. A short list of the distinct pieces and each one's job,
before going deep on any of them. If the parts form a flow or a hierarchy, a small
ASCII/mermaid diagram here is often the fastest way to convey the shape.

## 🔍 How it actually works
The mechanics, now at code level. Reference real files/methods as `path:line`. This is
where the technical depth lands, once the frame is set.

## ⚠️ Why it's done this way / gotchas
The reasoning behind non-obvious choices, tradeoffs, edge cases, and the traps a
returning engineer would fall into. Often the highest-value section.

## 🔗 Where to look next
Optional. The few files or entry points to read to go deeper.
```

## Style

These exist to maximise scan-ability — a returning reader skims before they read.

- 📑 **Section it.** Short headers with a leading emoji as a visual anchor, one idea
  per section. Keep headers as **plain prose** — no code spans, backticks, or symbols
  in a heading. Headings are skim anchors; an identifier like `validate_assignment`
  in a header is visual noise when you're scanning. Put the identifier in the body.
- 🔢 **Lists over paragraphs** for anything enumerable (steps, parts, options,
  gotchas). Prose for narrative/reasoning. When an item runs longer than a line or
  two, put a **blank line between items** so they don't fuse into a wall of text —
  short one-line items can stay tight together.
- 🗺️ **Draw it when relationships are the point.** If the subject is about *flow* or
  *how parts connect* (a request path, a pipeline, nesting), a small diagram lands
  faster than a paragraph. Use a fenced ASCII diagram (or a `mermaid` block) to show
  the shape. A reader rebuilding a mental model anchors on a picture quickly. Reach
  for one whenever you catch yourself describing a sequence or a hierarchy in prose.
- ✂️ **Short, plain sentences.** Simple language carries complex ideas best. Cut
  hedging and filler.
- 😌 **Emoji as signposts, not decoration.** A few per explanation to mark sections
  and call-outs. Don't sprinkle them into every bullet.
- 🧾 **Show real code/identifiers.** Concrete `Model.method`, file paths, and small
  snippets beat hand-waving. Keep snippets minimal — just the illuminating lines.
  (In the *body* — not in headings.)
- 📏 **Right-size depth.** Layering means the reader *can* go deep, not that everything
  must be exhaustive. Stop when the model is rebuilt.

## How to work

1. **Make sure you actually understand it first.** If it's code in the repo, read the
   relevant files before explaining — a layered explanation of a thing you half-grasp
   will be confidently wrong. Investigate, then explain.
2. **Write the gist last-ish in your head, first on the page.** Figure out the
   one-sentence version; if you can't, you don't understand it well enough yet.
3. **Deliver inline** as your chat response (markdown). Offer to save it to a file only
   if the user asks or the explanation is long enough to be worth keeping.

## A small worked example

This shows the *shape* - a real explanation goes deeper.

**Request:** "break down how password reset links expire in our app"

> ## 🎯 The gist
> A reset link works once, and only for 2 hours. We never store the token itself,
> so a leaked database can't be used to reset anyone's password.
>
> ## 🧭 Context you might be missing
> This replaced the Devise default last year, when we needed per-link expiry. Reset
> state lives on `users` (`reset_password_digest`, `reset_password_sent_at`) - there
> is no separate tokens table.
>
> ## 🧱 How it fits together
> - **Controller** takes the email and always responds the same way (no user enumeration)
> - **`PasswordReset` service** generates the token and stores its digest
> - **Mailer** sends the raw token in the link
> - **Update action** looks the user up by digest and checks the age
>
> ## 🔍 How it actually works
> `PasswordReset#issue!` creates a random token, saves `Digest::SHA256` of it plus a
> timestamp, and emails the raw token. On submit, `PasswordReset.redeem(token)`
> digests the incoming token, finds the user, rejects it if `sent_at` is over 2 hours
> old, then clears both columns so it can't be reused.
>
> ## ⚠️ Why it's done this way
> Storing only the digest means the token in the email is the only working copy.
> Clearing the columns on success is what makes the link single-use - forget that and
> the same link works until it expires.
