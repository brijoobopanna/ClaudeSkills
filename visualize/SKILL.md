---
name: visual-brief
description: Create publication-quality technical infographics from any source — tweets, articles, architectures, or ideas. Use this skill whenever the user wants to visually break down a technical concept, map a system architecture, turn a tweet or thread into a shareable diagram, create editorial-style pipeline or flow visualizations, illustrate feedback loops or compounding mechanisms, or produce visuals for a newsletter or blog. Trigger on phrases like "visualize this", "diagram this", "break this down visually", "map this architecture", "make an infographic", "turn this tweet into a visual", "show me how this system works", "create a visual for my newsletter", or any request to produce a designed technical visual rather than a generic flowchart. Also trigger when the user shares a URL, screenshot, or paste of technical content and asks for analysis — the visual IS the analysis.
---

# visual-brief

Turn complex technical content into clean, publication-quality visuals.

Not flowcharts. Not generic diagrams. Editorial-grade infographics that
look like they belong on Stripe's blog or in a conference keynote.

---

## What this skill produces

Single-file HTML infographics with:
- Monospace section headers, clean sans-serif body text
- Color-coded functional zones
- Trust boundaries and quality gates when applicable
- Explicit feedback/compound loops
- Core insight callout
- Responsive design (desktop + mobile)
- Zero external dependencies beyond Google Fonts

---

## When to use this skill

### Direct triggers (user asks explicitly)

| User says | What to build |
|---|---|
| "Visualize this tweet" | Extract structure, choose layout, build infographic |
| "Diagram my architecture" | Map components to zones, show data flow |
| "Make an infographic of this article" | Distill to 5-7 key concepts, show relationships |
| "Create a visual for my newsletter" | Editorial-style breakdown, shareable format |
| "Break down how this system works" | Layered flow or pipeline with annotations |
| "Turn this into something I can share" | Publication-quality HTML, one file |

### Proactive triggers (skill adds value even if not asked)

| Situation | Why use it |
|---|---|
| User shares a technical tweet/thread | A visual breakdown IS the best analysis |
| User describes a multi-step system | Seeing it beats reading about it |
| User is comparing before/after | Side-by-side visual makes the delta obvious |
| User asks "how does X work" for a system | Pipeline or layered flow answers faster than prose |

### When NOT to use this skill

- Quick code diagrams (use mermaid instead)
- Data charts with real numbers (use chart libraries)
- UI mockups (use the frontend-design skill)
- Simple lists or comparisons (just write prose)

---

## How to use this skill

### Step 1: Read the source

Before touching any HTML, fully understand the content. Extract:

```
ENTITIES:    What are the nouns? (wiki, agent, gate, cache)
RELATIONS:   What connects them? (posts to, reviews, compiles)
STAGES:      What's the sequence or hierarchy?
TRUST:       Where does raw become trusted? Where's the gate?
LOOP:        How does output improve input?
THESIS:      What's the one-sentence takeaway?
```

### Step 2: Choose layout pattern

Ask: **what's the primary story?**

| Story | Pattern | Example |
|---|---|---|
| Data transforms through stages | **Horizontal pipeline** | Karpathy's Sources → raw/ → Wiki → Q&A → Output |
| Data passes through trust boundaries | **Vertical layered flow** | Swarm: Work → Compile+Review → Brief+Read |
| Different systems collaborate | **Three-column zones** | Ingest | Engine | Store |
| Something compounds over time | **Any + compound loop strip** | read → work → enrich → better reads |
| One thing connects to many | **Hub-and-spoke** | Wiki at center, tools around it |
| Showing a transformation | **Before/after split** | Manual process → automated pipeline |

### Step 3: Choose color strategy

| Complexity | Strategy | Rule |
|---|---|---|
| Simple (5-7 boxes) | **Single accent** | One strong color for hero, rest neutral |
| Complex (8+ boxes) | **Multi-accent** | One color per functional zone |
| Has review gates | **Trust-boundary** | Gray raw → Red gate → Green approved |

### Step 4: Identify hero and gate

- **Hero**: The centerpiece — largest box, accent background
- **Gate**: The review/decision point — accent color, centered between zones
- Only ONE hero. If everything is highlighted, nothing is.

### Step 5: Write box content

Each box gets:
- **Title**: 1-3 words, bold
- **Details**: 3-4 lines, each under 30 characters
- **Annotation**: 1 line italic (optional, for secondary context)

If you need more than 4 detail lines, split into two boxes.

### Step 6: Build

Single HTML file. Use the templates in `references/templates.md`.
Test at both desktop and mobile widths.

### Step 7: Refine

Run through the quality checklist in `references/checklist.md`.

---

## Design reference

### Typography

```css
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=DM+Sans:wght@300;400;500;600;700&display=swap');

:root {
  --mono: 'IBM Plex Mono', monospace;
  --sans: 'DM Sans', sans-serif;
}

/* Section labels: MAIN PIPELINE, SUPPORT LAYER */
.section-label {
  font-family: var(--mono);
  font-size: 0.7rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-weight: 600;
}

/* Box titles */
.box-title {
  font-family: var(--sans);
  font-size: 1.1rem;
  font-weight: 700;
}

/* Box details */
.box-detail {
  font-family: var(--sans);
  font-size: 0.78rem;
  line-height: 1.6;
}

/* Annotations */
.annotation {
  font-size: 0.7rem;
  font-style: italic;
  opacity: 0.6;
}

/* Arrow labels */
.arrow-label {
  font-family: var(--mono);
  font-size: 0.6rem;
  letter-spacing: 0.05em;
}
```

### Color palettes

**Warm editorial** (the Karpathy original style)
```css
:root {
  --accent: #8B2500;
  --accent-light: rgba(139,37,0,0.08);
  --bg: #FAF5F0;
  --card: #FFFFFF;
  --text: #2D2D2D;
  --text-muted: #8A8078;
  --border: #E5DDD4;
  --approved: #2D6A4F;
  --approved-bg: #E8F5E9;
  --rejected: #999;
}
```

**Cool technical**
```css
:root {
  --accent: #1A56DB;
  --bg: #F8FAFC;
  --card: #FFFFFF;
  --text: #1E293B;
  --text-muted: #64748B;
  --border: #E2E8F0;
}
```

**Multi-zone** (for complex architectures)
```css
:root {
  --zone-ingest: #FFF0EB;     /* warm salmon */
  --zone-engine: #EDE9FE;     /* lavender */
  --zone-store: #ECFDF5;      /* mint */
  --zone-tools: #F0FDF4;      /* sage */
  --zone-output: #FEF3C7;     /* amber */
  --zone-future: transparent;  /* dashed border only */
}
```

### Visual elements

See `references/elements.md` for CSS snippets of:
- Standard box, hero box, gate box, future box
- Grouping containers (dashed zones)
- Solid arrows, dashed arrows, feedback arrows
- Tags/pills inside boxes
- Section headers with subtitles
- Compound loop strip
- Callout box (thesis)
- Responsive breakpoints

---

## Examples of what this skill produces

### From a tweet → pipeline infographic
Input: Karpathy's LLM Knowledge Bases tweet
Output: 5-step horizontal pipeline + support layer + future section + callout
Layout: Horizontal pipeline
Color: Single accent (warm editorial)

### From a multi-agent architecture → layered flow
Input: OpenClaw + Hermes swarm description
Output: 4-layer vertical flow (Work → Compile+Review → Brief+Read → Loop)
Layout: Vertical layered flow
Color: Trust-boundary (gray → red gate → green approved)

### From a system description → zone diagram
Input: Detailed breakdown of Karpathy's system
Output: 3-column layout (Data Ingest | LLM Engine | Knowledge Store)
Layout: Three-column zones
Color: Multi-accent (one per zone)

### From a project architecture → pipeline + gaps
Input: AIweekly codebase analysis
Output: Current pipeline (teal) + gap analysis (coral) + priority (purple)
Layout: Horizontal pipeline + gap grid
Color: Multi-accent (semantic: teal=have, coral=missing, purple=priority)

---

## File structure

```
visual-brief/
├── SKILL.md              ← this file (read first)
└── references/
    ├── templates.md       ← HTML/CSS templates for each layout pattern
    ├── elements.md        ← CSS snippets for every visual element
    ├── checklist.md       ← quality checklist to run before delivering
    └── examples/          ← complete HTML examples
        ├── pipeline.html
        ├── layered-flow.html
        ├── zone-diagram.html
        └── compound-loop.html
```

---

## Naming rationale

**visual-brief** was chosen because:
- **visual**: it produces visuals, not text
- **brief**: it distills complex content into a concise breakdown (like a briefing)
- It's short (2 words), memorable, and works as both a noun ("create a visual brief")
  and an adjective+noun pair
- It doesn't say "infographic" (too specific) or "diagram" (too generic)
- The name signals editorial quality — a "brief" implies curation and judgment,
  not just mechanical diagramming

Alternative names considered:
- `editorial-infographic` — accurate but long, sounds like a template
- `tech-poster` — too narrow, implies print
- `visual-breakdown` — good but 15 characters vs 12
- `explain-visual` — verb-first feels like a command, not a tool
