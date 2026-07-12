# Design lock - Skills explainer site

**Status:** ✅ locked 2026-07-11 (user approved)  
**Locked against:** product-brief visual direction; decisions D5, G1–G13; content-outline IA  
**v1 ships:** text + CSS only (illustration assets optional / fast-follow)

---

## Direction (one sentence)

Dark engineering workbench: **warm** ink-depth surfaces, crisp type, and a **continuity rail** through the four lifecycle steps as the single signature — Linear clarity + Superset craft, not a generic neon-on-black or purple SaaS landing.

**Signature:** the lifecycle skim strip (connected rail + four verb steps). Everything else stays quiet.

**Palette amendment (build, 2026-07-11):** cool blue accent (`#5b8def`) replaced by soft cream (`#ebe6dc`) on warm ink (`#0f0e0c`). User validated on the live page — treat this as the locked palette for CSS **and** future illustrations.

**Avoid (explicit):** purple/indigo gradient themes; light cream *page* + terracotta serif (AI light-theme cluster); broadsheet columns; acid-green or saturated blue accents on pure black; card stacks in the hero; pill clusters / stat strips; blue “tech glow” in art that fights the cream rail.

---

## CSS tokens

Ship as custom properties on `:root` in `docs/assets/css/site.css`.

### Color

| Token | Hex / value | Role |
|---|---|---|
| `--bg` | `#0f0e0c` | Page ground |
| `--bg-elevated` | `#161513` | Hero / sticky nav wash |
| `--surface` | `#1c1b18` | Skill blocks, install panel |
| `--border` | `#33312c` | Hairlines, block edges |
| `--text` | `#ebeae8` | Primary copy |
| `--text-muted` | `#999287` | Supporting, nav secondary |
| `--accent` | `#ebe6dc` | CTAs, rail, focus ring |
| `--accent-soft` | `rgba(235, 230, 220, 0.14)` | Soft fills (CTA secondary, rail glow at low opacity) |
| `--optional` | `#7a9e7e` | Quiet “optional” mark on orchestrate-build only |
| `--code-bg` | `#0d0c0b` | Install snippet panel |

Atmosphere: subtle radial gradient from `--bg-elevated` toward `--bg` (top-center), optional 2–3% noise via CSS only — no full-bleed photo required for v1.

### Typography

| Role | Family | Fallback | Notes |
|---|---|---|---|
| UI / display | **Plus Jakarta Sans** | `system-ui, sans-serif` | Brand + headlines + body; Google Fonts |
| Mono | **JetBrains Mono** | `ui-monospace, monospace` | Install snippet, path labels, skill filenames |

**Scale (rem @ 16px root):**

| Token | Size | Use |
|---|---|---|
| `--text-xs` | `0.75rem` | Optional mark, captions |
| `--text-sm` | `0.875rem` | Nav, meta, one-liners |
| `--text-base` | `1rem` | Body |
| `--text-lg` | `1.125rem` | Supporting hero |
| `--text-xl` | `1.25rem` | Section heads (mobile) |
| `--text-2xl` | `1.75rem` | Section heads (desktop) |
| `--text-brand` | `clamp(2rem, 5vw, 3.25rem)` | Hero brand name |
| `--text-hero` | `clamp(1.35rem, 3vw, 1.85rem)` | Hero headline (under brand) |

**Weights:** brand/display 600–700; body 400–500; mono 400.  
**Line-height:** body `1.6`; heads `1.2`; skim one-liners `1.4`.

### Spacing

| Token | Value |
|---|---|
| `--space-1` … `--space-8` | `0.25 / 0.5 / 0.75 / 1 / 1.5 / 2 / 3 / 4 rem` |
| `--space-section` | `clamp(3.5rem, 8vw, 6rem)` |
| `--content-max` | `72rem` |
| `--prose-max` | `40rem` |
| `--radius` | `0.5rem` (blocks, buttons — modest; not pill) |
| `--radius-sm` | `0.375rem` (code panel) |

### Focus / interaction

- Focus ring: `2px solid var(--accent)`; offset `2px` on dark
- Link hover: underline or accent color shift; no glow stacks

---

## Layout

### Global

- Single column, centered `max-width: var(--content-max)`; horizontal padding `--space-5` / `--space-6`
- Sticky top nav: suite name left; anchors `#lifecycle` `#skills` `#install` `#principles`; GitHub text link right
- No dashboard chrome; no cards in hero

### Hero (`#top`)

```
[ nav ]
my-agent-skills                    ← brand (largest type)
{one headline}
{one supporting sentence}
[ Install ]  [ View on GitHub ]
[ optional illustration slot — empty in v1 ]
```

Brand must remain the strongest signal; headline does not overpower it.

### Lifecycle skim (`#lifecycle`) — signature

Hybrid skim strip: **one horizontal rail** (desktop) / **vertical stack with rail** (mobile).

```
Desktop:
  (●)───(●)───(●)───(●)
 Decide  Write  Check  Drive
 one-liner under each
 short narrative below the strip

Mobile:
  ● Decide + one-liner
  │
  ● Write + one-liner
  …
```

- Verbs: Decide → Write → Check → Drive  
- Labels: start-interview → plan-build → review-plan → orchestrate-build  
- Rail uses `--accent` at ~60% opacity; nodes are filled dots / small discs (not heavy numbered badges)
- Illustration slot optional beside or under strip; strip must read without it

### Connect (`#connect`)

One short prose block (`--prose-max`); no card grid. Throughline + HANDOFF.md + one harvest beat.

### Skills (`#skills`)

Four **equal** surface blocks in a 2×2 grid (desktop) / stacked (mobile). Not nested cards; one border + `--surface` fill each.

Each block:

```
{name}     {role line}   [optional]
what …
when …
why …
how to start …
→ SKILL.md (GitHub)
```

orchestrate-build: same structure; quiet `--optional` text mark (“optional”).

### Install (`#install`)

Monospace panel (`--code-bg`, `--radius-sm`); copy button top-right of panel; README-identical snippet; warning line about `~/.cursor/skills-cursor/`.

### Principles (`#principles`)

Three short principles + one harvest one-liner; text links to SCRIPTS.md / README. No icon row.

### Footer

Muted; GitHub; quiet “How this site was planned” → `plans/skills-explainer-site/HANDOFF.md`; nav echo.

---

## Motion (G10)

Minimal; all gated by `prefers-reduced-motion: reduce` → instant / no transform.

| Moment | Behavior |
|---|---|
| Page load | Soft fade-in of hero brand + CTA group (~280ms, opacity only) |
| Skim strip | Desktop: rail draws left→right once on first in-view (CSS width or stroke; ~500ms, ease-out); nodes fade with slight delay cascade |
| Scroll | `scroll-behavior: smooth` for in-page nav (respect reduced motion → `auto`) |
| Hover | CTA background / border; skill block border → accent-soft; no parallax, no glow pulse |

No scroll-jacking; no continuous ambient animation.

---

## Asset paths (Phase 6)

| Path | Role |
|---|---|
| `docs/index.html` | Single page |
| `docs/assets/css/site.css` | Tokens + layout + motion |
| `docs/assets/js/site.js` | Smooth-scroll polyfill if needed; install clipboard |
| `docs/assets/img/` | Fast-follow illustrations (empty OK for v1) |

Fonts: Google Fonts link for Plus Jakarta Sans + JetBrains Mono (or self-host later if desired).

---

## Illustration prompt pack (fast-follow)

**When generating:** match the **shipped** page (`docs/index.html` + `site.css`), not the original cool-blue draft. Art supports type; it does not replace the CSS rail or the brand wordmark.

### Constraints (non-negotiable)

- **Palette:** warm ink `#0f0e0c` / elevated `#161513` / surface `#1c1b18`; luminous lines and nodes in soft cream `#ebe6dc` (or `#ebeae8`); muted warm gray `#999287` for secondary marks only. Optional quiet green `#7a9e7e` only if marking “optional.”
- **No blue glow, purple, neon, cyan HUD, clay 3D, stock photos, or busy isometric cities.**
- **Quiet diagram language:** thin threads, sparse nodes, document/leaf shapes — editorial product diagram, not marketing splash.
- **Negative space:** leave clear regions for HTML type (hero brand especially). Prefer left- or right-weighted empty fields.
- **Do not redraw the full four-step rail as a competing hero** — the page already owns that signature in CSS. Lifecycle art should *echo* (softer, fewer labels) or sit beside/below the strip.
- **Texture:** page already has subtle CSS noise; keep illustration fills flat or lightly grainy, not heavily speckled.

### Shared style line

*Dark warm-charcoal UI illustration, background #0f0e0c, surfaces #1c1b18, single soft cream luminous accent #ebe6dc, thin geometric continuity thread, sparse nodes, editorial product-diagram, generous negative space for typography, no blue neon, no purple, no glossy 3D clay, no people photos.*

### Prompts

1. **Hero — continuity** (landscape, ~16:9 or wider; type sits left or center-left)  
   Sparse metaphor for cold-start resumability: a thin cream luminous thread connecting two quiet document/node shapes on warm ink; one node suggests a handoff leaf (`HANDOFF`). Large empty field for the brand wordmark. No logos, no readable fake UI chrome.

2. **Lifecycle — support** (wide; below or beside the CSS skim strip)  
   Soft echo of Decide → Write → Check → Drive: four small cream nodes on a faint rail, labels minimal or absent (HTML carries verbs). Optional tiny “packet” between Write and Check. Must not overpower the live strip — lower contrast than on-page rail.

3. **Optional — harvest** (square or 4:3; principles / footer-adjacent)  
   Quiet accretion: a small stack of lesson leaves feeding a gated arrow into a skill document. Warm ink + cream only; not celebratory; no trophies or confetti.

v1: `docs/assets/img/` may stay empty (`.gitkeep` only); drop assets when generated without blocking launch. Filenames when added: `hero-continuity.*`, `lifecycle-support.*`, `harvest.*`.

### Placement notes (Phase 6+)

| Asset | Slot |
|---|---|
| Hero | Optional under CTAs or as non-blocking side plane — never overlay brand text |
| Lifecycle | Optional under `.lifecycle__narrative` or beside rail on wide viewports |
| Harvest | Optional near principles harvest line; omit if noisy |

---

## Approval checklist

- [x] Direction + signature OK  
- [x] Tokens (color / type / space) OK  
- [x] Skim-strip + skill-block layout OK  
- [x] Motion notes OK  
- [x] Prompt pack OK (assets still optional)  

**Phase 5 closed.** Proceed to Phase 6 Build.
