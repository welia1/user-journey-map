# User Journey Map — Claude Code Skill

A [Claude Code](https://claude.com/claude-code) skill that produces light-themed, swimlane-style user journey maps as single-page HTML documents. Ask Claude to make a user journey, journey map, swimlane diagram, or integration flow, and this skill kicks in to generate a contained, modern document with explicit flow arrows, scenario callouts, and open questions.

Every generated document ships with a built-in **Export PNG** button that renders the full page to a high-DPI image.

## What you get

- **Swimlane journey grid** — 4 actor lanes, step rows and flow rows sharing one CSS Grid
- **Explicit flow arrows** — vertical (same lane), horizontal (cross-lane), forward and reverse, with variant colours and a dashed "gap" style for manual hand-offs
- **Scenario cards** with numbered kickers, tags, and callouts (ok / warn / err / info)
- **Multi-path scenarios** — use the `.path` wrapper to show branching flows in a single scenario
- **Open questions** — 2- or 3-column grid with a `.critical` variant for blockers
- **Export to PNG** — fixed top-right button, 2× scale, powered by `html2canvas` from CDN
- **No build step** — every output is one self-contained `.html` file
- **Print-friendly** — a `@media print` rule hides the export button so you also get clean browser PDF export for free

## Install

Clone or copy this folder into your Claude Code skills directory:

```bash
# user-level (available to all projects)
git clone https://github.com/<your-username>/user-journey-map.git ~/.claude/skills/user-journey-map

# or project-level (only in one project)
git clone https://github.com/<your-username>/user-journey-map.git .claude/skills/user-journey-map
```

Claude Code picks up the skill automatically — no config needed. The next time you ask for a journey map in that project, the skill's instructions load into context.

## Use

Just ask:

> Create a user journey for how a customer signs in through our SSO provider and syncs profile data.

> Adapt the flow map to show the purchase path with the payments provider.

Claude will copy `template.html`, rename the actor lanes, and build the scenarios around your process.

## Manual use (no Claude Code)

You can use `template.html` directly without the skill wrapper:

1. Copy `template.html` to a new location
2. Open it in a browser to see the baseline example
3. Edit the actor lanes in the CSS variables at the top
4. Replace the example scenarios with your own
5. Click **Export PNG** to download a high-res snapshot

The template uses only one external dependency (the `html2canvas` library from unpkg) — everything else is vanilla HTML and CSS.

## Structure

```
user-journey-map/
├── SKILL.md        # Instructions loaded by Claude Code
├── template.html   # Working template with all components + export button
├── README.md       # This file
└── LICENSE         # MIT
```

## Design language

Light, compact, modern. One sans-serif font (`Inter Tight`), pure white background, minimal colour — one per actor lane plus three status colours. No gradients, no display serifs, no decorative hero sections. The design is tuned for executive-readable business case documents that print cleanly and screenshot well.

Full tokens, component catalogue, and arrow grid mechanics are documented in [`SKILL.md`](./SKILL.md).

## Export quality notes

The export button uses `html2canvas` at `scale: 2` for retina-quality PNGs. For even higher resolution, edit the scale value in the inline `<script>` at the bottom of `template.html`:

```js
scale: 2,  // 2× DPI  — default
// scale: 3,  // 3× DPI — ~2.5× file size
```

`html2canvas` is a mature library but has a few known limits with modern CSS features (some filters, some gradients). The template deliberately avoids all of them, so captures should be pixel-perfect.

## Contributing

Issues and PRs welcome. Good directions to extend:

- Alternative export formats (SVG, JPEG, PDF via `jsPDF`)
- Additional actor-colour presets
- A built-in "print to PDF" button for those who prefer vector output
- Theme variants (high-contrast, compact mode)

Please keep contributions aligned with the design language — **restrained is the point**. Proposals that add gradients, animations, or display fonts will probably be declined.

## License

MIT — see [LICENSE](./LICENSE).
