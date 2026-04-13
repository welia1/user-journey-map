---
name: user-journey-map
description: Build or edit swimlane-style user journey maps as single-page HTML documents. Use when the user asks for a user journey, journey map, swimlane diagram, integration flow, or wants to chart a multi-actor process for a business case, discovery, or integration design doc. Also trigger when the user says "adapt this flow".
---

# User Journey Map

Produces a contained, light-themed HTML document that charts a multi-actor process as a swimlane journey — with explicit flow arrows between every step, coloured actor lanes, scenario callouts, and open questions. Includes a built-in "Export PNG" button for exporting the whole page as a high-quality image.

## When to use

- User asks for a *user journey*, *journey map*, *swimlane diagram*, *integration flow*, or *business case diagram*
- User wants to "adapt the flow for a new integration"
- User is planning or reviewing how a process moves across actors or systems
- User hands you an existing dark-themed flow doc and wants it modernised

Do **not** use for: UML diagrams, pure flowcharts, sequence diagrams, org charts.

## Output

A single self-contained `.html` file, no build step. Open directly in a browser. Hostable as a static asset (S3 + CloudFront, Cloudflare Pages, Netlify, etc.).

Every document generated from the template includes a fixed **Export PNG** button top-right that renders the whole page to a high-DPI PNG (2× scale) using `html2canvas`. No extra setup — the library loads from a public CDN.

Start from `template.html` in this skill folder — it has every component wired up with a working example and the export button already built in. Copy it and replace the content.

## Design language

Light, compact, modern. Restrained, not editorial. No decorative fonts, no gradients, no shadows beyond a 1px hover.

| Token | Value |
|---|---|
| Background | `#ffffff` pure white |
| Ink | `#0a0a0a` |
| Muted ink | `#737373` |
| Border | `#e5e5e5` (1px only) |
| Font | `Inter Tight` — 300, 400, 500, 600 |
| Base size | 13px, line-height 1.5 |
| Container | `max-width: 1120px`, 40px padding |
| Radius | 6px on cards, 10px on containers |

Use **one colour per actor lane**, plus the three status colours.

Standard actor palette (pick 4, add more via new CSS variables if you need them):

| Role | Colour | Tint |
|---|---|---|
| Human / end user | `#6b7280` slate | `#f3f4f6` |
| Primary system (the subject of the journey) | `#5b3fb8` violet | `#f0ecfa` |
| Partner / integration target | `#0f766e` teal | `#e6f1ef` |
| External / peripheral system | `#57534e` stone | `#f5f4f2` |
| Commerce flavour (alt) | `#16794d` green | `#ecf5f0` |
| Ticketing / transactional flavour (alt) | `#c0392b` red | `#fbecea` |

Status colours: ok `#16794d` on `#ecf5f0` · warn `#a16207` on `#fef7e6` · err `#c0392b` on `#fbecea`.

## Document shape

```
<body>
  <button class="export-btn">…</button>   <!-- fixed, top-right, export-to-png -->

  <div class="wrap">
    <div class="legend">…</div>

    <section class="scenario" id="s1">
      <div class="scenario-head">…</div>
      <div class="journey">
        <div class="j-lanes">…</div>
        <div class="row step">…</div>
        <div class="row flow">…</div>
        <!-- optional <div class="path">…</div> wrappers for multi-path scenarios -->
        <div class="callouts">…</div>
      </div>
    </section>

    <!-- additional scenarios (02, 03, …) -->

    <section id="compare">                      <!-- optional: summary compare table -->
      <div class="block-head"><h2>Summary <em>comparison.</em></h2><p>…</p></div>
      <div class="compare-wrap"><table class="compare">…</table></div>
    </section>

    <section id="questions">
      <div class="block-head"><h2>Open <em>questions.</em></h2><p>…</p></div>
      <div class="questions"><div class="q-card">…</div></div>
    </section>

    <footer class="foot">…</footer>
  </div>

  <script src="https://unpkg.com/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
  <script>/* export handler */</script>
</body>
```

## The swimlane grid

Every journey is a 5-column CSS Grid:

```css
grid-template-columns: 36px repeat(4, 1fr);
column-gap: 14px;
```

- **Column 1** = step number gutter (36px)
- **Columns 2–5** = four actor lanes (equal width)

Every row — step or flow — reuses this same grid via the `.row` class. Every cell you don't fill must still be an empty `<div></div>`, or the grid collapses.

### Step rows

`.row.step` has exactly 5 children: the step number, then 4 lane cells. Each lane cell contains either a `.node` or nothing.

```html
<div class="row step">
  <div class="n">01</div>
  <div><div class="node m">…Lane 1 node…</div></div>
  <div></div>
  <div><div class="node x">…Lane 3 node…</div></div>
  <div></div>
</div>
```

A single step row can have multiple nodes across lanes — useful when two actors act in parallel or hand off simultaneously.

### Flow rows

`.row.flow` sits between step rows to show the arrow. Two arrow components:

**Vertical arrow** (stays in one lane) — `.v`:

```html
<div class="row flow">
  <div></div><div></div><div></div>
  <div class="v"><div class="v-line"></div></div>
  <div></div>
</div>
```

**Horizontal arrow** (crosses lanes) — `.h` with CSS variables for grid span:

```html
<div class="row flow">
  <div></div>
  <div class="h" style="--gs:2;--ge:6"><div class="line"></div><div class="label">Checkout</div></div>
</div>
```

`--gs` and `--ge` are grid line numbers. With 5 columns:
- Line 2 = left edge of lane 1
- Line 3 = left edge of lane 2
- Line 4 = left edge of lane 3
- Line 5 = left edge of lane 4
- Line 6 = right edge of lane 4

A span of `--gs:2;--ge:5` covers lanes 1–3. `--gs:3;--ge:5` covers lanes 2–3 (a single cross-lane hop). `--gs:2;--ge:6` covers all four lanes.

When you use an `.h` on a flow row, omit the empty `<div></div>` placeholders for the cells it spans — the arrow itself occupies those grid cells.

**Arrow modifiers** (extra classes on `.h` or `.v`):

| Class | Effect |
|---|---|
| `.rev` | Arrowhead points left (reverse direction) |
| `.accent` | Violet — use for primary-system outbound flows |
| `.twoc` (rename as needed) | Teal — use for partner-system flows |
| `.danger` | Dashed red line — manual gap or blocker |

Combine freely: `.h.accent.rev` is a reverse violet arrow.

## Components

### Node (`.node`)

```html
<div class="node m">
  <div class="chip"><span class="d"></span>Actor name</div>
  <div class="t">Node title</div>
  <div class="sub">Optional supporting sentence.</div>
</div>
```

Suffix classes — `.m`, `.c`, `.x`, `.e` — pick the left-border and chip colour. Add a new suffix in CSS for each actor you introduce.

### Callout (`.callout`)

```html
<div class="callout ok">
  <div class="cicon">✓</div>
  <div class="ctext"><strong>Win.</strong> Why this matters.</div>
</div>
```

Types: `.ok` (✓), `.warn` (△), `.err` (!), `.info` (i).

### Scenario head

```html
<div class="scenario-head">
  <div class="s-body">
    <div class="s-kicker variant"><span class="num">01</span><span class="d"></span>Scenario kicker</div>
    <h2 class="s-title">Title with <em>italic accent</em>.</h2>
    <p class="s-desc">One-sentence framing.</p>
  </div>
  <div class="s-tags">
    <span class="tag ok"><span class="d"></span>Positive</span>
    <span class="tag warn">Caveat</span>
  </div>
</div>
```

Kicker variants are just colour tints for the dot — introduce new ones in CSS (`.s-kicker.variant .d { background: var(--some-colour); }`) as needed.

### Path (sub-section inside a scenario)

Use when one scenario has meaningfully distinct flows — e.g. "new user" vs "returning user", "viable" vs "blocker".

```html
<div class="path">
  <div class="path-head">
    <span class="path-kicker">Path A</span>
    <div class="path-label">Label <em>qualifier</em></div>
    <div class="path-rule"></div>
  </div>
  <!-- step + flow rows -->
  <div class="callouts">…</div>
</div>
```

### Open question card

```html
<div class="q-card">
  <div class="q-num"><span class="n">Q · 01</span>Category</div>
  <h4>Headline question <em>with emphasis</em>?</h4>
  <p>Paragraph explaining the stakes.</p>
</div>
```

Add `.critical` to the card for a red-bordered blocker, plus `<span class="flag">· BLOCKER</span>` inside the `q-num`.

Grid: 2-column by default. Switch to `grid-template-columns: repeat(3, 1fr)` if you have exactly 3 cards.

### Summary compare table

A capability matrix that sits between the journey scenarios and the open questions. Use it to spell out — at a glance — what's supported in each scenario, what isn't, and what depends on an unresolved question.

Two common shapes:

**Multi-scenario comparison** — columns are the scenarios, rows are capabilities. Good for "current vs proposed A vs proposed B" docs.

**Single-scenario capability sheet** — columns are ownership dimensions (native / via partner / status). Good for a single integration where the question is "who owns which piece".

```html
<section id="compare">
  <div class="block-head">
    <h2>Summary <em>comparison.</em></h2>
    <p>Capability matrix — what's already supported, what isn't, and what depends on confirming an open question.</p>
  </div>

  <div class="compare-wrap">
    <table class="compare">
      <thead>
        <tr>
          <th>Capability</th>
          <th><span class="lbl">01</span><em>Scenario A</em></th>
          <th><span class="lbl">02</span><em>Scenario B</em></th>
          <th><em>Status</em></th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Capability row</td>
          <td><span class="badge ok"><span class="ic"></span>Yes</span></td>
          <td><span class="badge no"><span class="ic"></span>Manual</span></td>
          <td><span class="badge part"><span class="ic"></span>Pending Q·01</span></td>
        </tr>
      </tbody>
    </table>
  </div>
</section>
```

Badge variants: `.ok` (green), `.no` (red), `.part` (amber), `.info` (partner colour). Each badge is a pill with a 5px dot — keep the text short (1–3 words is ideal).

**When to add the summary, when to skip it**

- **Add it** when the document compares multiple scenarios, or when an exec reader will want a one-glance "what works, what doesn't" view
- **Add it** when some capabilities are blocked on open questions — the table makes the dependency visible without reading every scenario
- **Skip it** when there's only one scenario and every capability is trivially in scope
- **Skip it** when the open questions section is already short and self-explanatory

## Writing style

- **Titles**: sentence case, end with a period, use `<em>` for mid-phrase italic accents (*"Single sign-on & **account bootstrap.**"*)
- **Flow labels**: 2–4 words, mono'd, CSS uppercases them — API shapes welcome (`POST /endpoint`, `Webhook · JSON`)
- **Sub text**: 1–2 sentences, no jargon bombs
- **Callouts**: lead with a `<strong>` takeaway sentence, then one sentence of context
- **Tags**: Title-Case, 1–3 words, chip-sized
- **Every scenario should answer**: what happens, who drives it, where it breaks

## Building a new journey — playbook

1. **Copy `template.html`** from this skill folder to the new location.
2. **Rename actor lanes** and update the CSS variables at the top. Keep 4 lanes even if one scenario only uses 3 — dim the unused lane with `.lane-dim`.
3. **Set document title, footer, and block headings**.
4. **Sketch each scenario on paper first** — one step per beat. Then write step rows + flow rows.
5. **Every step needs an arrow** leading to the next one. Decide per transition: vertical (same lane) or horizontal (cross-lane).
6. **Close each journey with callouts** — ideally one `ok`, one `warn`, one `err` — naming the win, the caveat, and the gap.
7. **Close the document with open questions**. Flag real blockers with `.critical`.

## Export to PNG

The template ships with a fixed "Export PNG" button top-right, powered by [`html2canvas`](https://html2canvas.hertzen.com/).

- Loads from `https://unpkg.com/html2canvas@1.4.1/dist/html2canvas.min.js`
- Captures the `.wrap` element at `scale: 2` for retina-quality output
- Download filename defaults to `journey-map.png`
- The button is `position: fixed` outside `.wrap`, so it's automatically excluded from the capture
- A `@media print` rule hides the button when printing to PDF from the browser (so you get both PNG and PDF export paths for free)

If you need larger/smaller output, change `scale: 2` inside the export handler. `scale: 3` produces ~3× resolution; `scale: 1` matches what you see on screen.

## Common pitfalls

- **Forgetting empty `<div></div>` placeholders** in step/flow rows — the grid collapses and arrows land in the wrong column.
- **Using `transform: scaleX(-1)`** to reverse arrows — use `.rev` instead, it handles the arrowhead cleanly.
- **Wrong grid line numbers** on `.h` arrows — remember line 2 = start of lane 1, line 6 = end of lane 4.
- **Adding shadows, gradients, serif display fonts** — keep it restrained. The whole point of this design is quiet confidence.
- **Long multi-paragraph callouts** — one takeaway sentence, one context sentence. Anything longer belongs in open questions.
- **Different lane widths per scenario** — reuse the same 4-lane grid across all scenarios. Use `.lane-dim` to mark lanes that aren't active in a given scenario.
- **Inventing colours beyond the actor set** — lean on status (ok/warn/err) instead. More colour = more noise.
- **Web fonts not loaded before export** — if the PNG shows fallback fonts, wait for `document.fonts.ready` before calling `html2canvas` (the template's handler already does this).
