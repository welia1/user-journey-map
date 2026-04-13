---
description: Build a swimlane user journey map (HTML) using the user-journey-map skill
---

Build a user journey map following the `user-journey-map` skill.

- Skill instructions: `~/.claude/skills/user-journey-map/SKILL.md`
- Baseline template: `~/.claude/skills/user-journey-map/template.html`

User-supplied brief (may be empty):

$ARGUMENTS

## What to do

1. If the brief above is empty, ask the user:
   - What process or integration are you charting?
   - Who are the 3–4 actors / systems in the journey?
   - How many scenarios should the document include, and what's the narrative (e.g. *current → proposed A → proposed B*, or *happy path + edge cases*)?
   - Where should the output file be saved, and what should the title be?

2. Once the brief is clear:
   - Copy `~/.claude/skills/user-journey-map/template.html` to the target path
   - Rename the actor lanes and update the CSS variables at the top
   - Set the document title and footer
   - Replace the example scenarios with the real ones, step by step
   - Every step needs an arrow (vertical or horizontal) leading to the next one
   - Every scenario ends with callouts naming the win, caveat, and gap
   - Close the document with open questions; flag real blockers with `.critical`
   - Optionally include a summary compare table when the doc has multiple scenarios

3. Keep the design restrained — no decorative fonts, gradients, or extra colours beyond the actor set and status palette. The whole skill is about quiet, confident documents that screenshot and print cleanly.
