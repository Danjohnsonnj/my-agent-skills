# Design lock - Skills explainer site

**Status:** ✅ locked 2026-07-11 (user approved)  
**Locked against:** product-brief visual direction; decisions D5, G1–G13; content-outline IA  
**v1 ships:** text + CSS only (illustration assets optional / fast-follow)

---

## Direction (one sentence)

Dark engineering workbench: ink-depth surfaces, crisp type, and a **continuity rail** through the four lifecycle steps as the single signature — Linear clarity + Superset craft, not a generic neon-on-black or purple SaaS landing.

**Signature:** the lifecycle skim strip (connected rail + four verb steps). Everything else stays quiet.

**Avoid (explicit):** purple/indigo gradient themes; cream + terracotta serif; broadsheet columns; acid-green accent on pure black; card stacks in the hero; pill clusters / stat strips.

---

## CSS tokens

Ship as custom properties on `:root` in `docs/assets/css/site.css`.

### Color

| Token | Hex / value | Role |
|---|---|---|
| `--bg` | `#0c0e12` | Page ground |
| `--bg-elevated` | `#12151c` | Hero / sticky nav wash |
| `--surface` | `#171b24` | Skill blocks, install panel |
| `--border` | `#2a3140` | Hairlines, block edges |
| `--text` | `#e8eaef` | Primary copy |
| `--text-muted` | `#8b93a7` | Supporting, nav secondary |
| `--accent` | `#5b8def` | CTAs, rail, focus ring |
| `--accent-soft` | `rgba(91, 141, 239, 0.14)` | Soft fills (CTA secondary, rail glow at low opacity) |
| `--optional` | `#7a9e7e` | Quiet “optional” mark on orchestrate-build only |
| `--code-bg` | `#0a0c10` | Install snippet panel |

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

Shared style line for all prompts:  
*Dark UI illustration, ink charcoal background (#0c0e12), cool slate surfaces, single soft blue accent (#5b8def), clean geometric shapes, no purple neon, no glossy 3D clay, no stock people photos, editorial product-diagram feel, generous negative space.*

1. **Hero — continuity**  
   Metaphor for cold-start resumability: a thin luminous thread connecting two sparse document/node shapes across a dark field; one node labeled faintly like a handoff leaf. Landscape, left-heavy negative space for type.

2. **Lifecycle — four-step support**  
   Four nodes on a horizontal rail (Decide / Write / Check / Drive), matching the skim strip; subtle handoff “packet” between Write and Check. Wide aspect for beside/below strip.

3. **Optional — harvest**  
   Small accretion diagram: a lessons stack feeding a gated arrow into a skill document; quiet, not celebratory. Square or 4:3.

v1: leave `img/` empty or use CSS-only rail; drop PNGs when generated without blocking launch.

---

## Approval checklist

- [x] Direction + signature OK  
- [x] Tokens (color / type / space) OK  
- [x] Skim-strip + skill-block layout OK  
- [x] Motion notes OK  
- [x] Prompt pack OK (assets still optional)  

**Phase 5 closed.** Proceed to Phase 6 Build.
