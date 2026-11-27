---
name: tldr
description: >-
  Re-explain the previous output (or the whole thread) as a one-sentence summary
  plus a short, plain-language explainer. Use when the user says the last answer
  was too long, too complex, or too technical, e.g. "/tldr", "tldr", "too long",
  "simplify that", "explain that more simply".
---

# TL;DR

The user found the previous output too long, too complex, or too technical. Restate it so they get it in seconds.

## 1. Pick the scope

- Default: the **last assistant message**.
- If the last message only makes sense with earlier context, or the user says "thread" / "so far" / "everything", cover the **thread so far**.
- If it's genuinely unclear, ask in one line ("Just the last message, or the whole thread?") and stop.

## 2. Write it

Output exactly this shape:

```
## 🧵 TL;DR
<One sentence. The answer or the issue, not a teaser.>

## 💡 In plain terms
- <3-5 bullets max. Plain words, short sentences.>
- <Explain what it is, why it matters, what (if anything) the user needs to do.>
```

## Rules

- Answer first. No preamble like "Here's a simpler version".
- No new information or analysis. Only compress and clarify what was already said.
- Stay at the gist and "what it means for you" level. Skip deep technical detail - that's what the user is escaping.
- Strip jargon. If a technical term is unavoidable, explain it in a few words.
- Drop code, file paths, and class names unless one is the point. If so, keep at most one.
- Keep facts vs assumptions clear if the original mixed them.
- Hyphens, not em-dashes.
- If it still runs over ~120 words, cut more.
