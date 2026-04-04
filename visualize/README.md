# visual-brief

A Claude skill for turning complex technical content into publication-quality infographics.

Not flowcharts. Not generic diagrams. **Editorial-grade visuals** — the kind you see on Stripe's blog or in conference keynotes.

---

## What it does

Give it a tweet, article, system description, or architecture — it produces a single-file HTML infographic with clean typography, color-coded zones, explicit feedback loops, and a core insight callout.

**Examples of what triggers this skill:**

- "Visualize this Karpathy tweet"
- "Diagram my multi-agent architecture"  
- "Turn this article into a shareable visual"
- "Create an infographic for my newsletter"
- "Break down how this system works"

## What it produces

Single HTML files with:

- Monospace section headers, clean sans-serif body
- Color-coded functional zones
- Trust boundaries and quality gates
- Compound loop visualization
- Core insight callout
- Responsive (desktop + mobile)
- Zero dependencies beyond Google Fonts

## How to download and use this skill

### Step 1: Download from GitHub

```bash
git clone https://github.com/brijoobopanna/ClaudeSkills/visualize.git
```

Or download the ZIP from the GitHub page and extract it.

You should have a folder that looks like this:

```
visual-brief/
├── SKILL.md
├── README.md
└── references/
    ├── elements.md
    └── checklist.md
```

### Step 2: Install (pick your platform)

There are three ways to use this skill depending on where you work with Claude.

---

#### Option A: Claude Code — project-level

The skill works only inside one specific project. Best for teams where the
skill is relevant to a single repo.

```bash
cd your-project
mkdir -p .claude/skills
cp -r /path/to/visual-brief .claude/skills/visual-brief
```

Claude Code watches `.claude/skills/` automatically — no restart needed.
The skill is available immediately in your next message.

#### Option B: Claude Code — global

The skill works in every project on your machine. Best for personal use
across all your repos.

```bash
mkdir -p ~/.claude/skills
cp -r /path/to/visual-brief ~/.claude/skills/visual-brief
```

Same as project-level, but the `~/.claude/skills/` path makes it available
everywhere. If a project also has a project-level copy, the project-level
version takes priority.

#### Option C: Claude.ai — web/mobile chat

For people who don't use Claude Code and want the skill in the browser
or mobile app.

```bash
cd visual-brief
zip -r visual-brief.zip .
```

Then in Claude.ai:
1. Go to **Settings → Features**
2. Find the **Custom Skills** section
3. Click **Upload skill**
4. Select `visual-brief.zip`
5. Enable the skill

The skill is now active in your Claude.ai conversations.

> **Note:** Claude.ai requires a Pro, Max, Team, or Enterprise plan for
> custom skills, and code execution must be enabled.

---

### Step 3: Verify it's installed

In Claude Code, ask:

```
What skills do you have access to?
```

Claude will list all installed skills. You should see `visual-brief` with
its description. You can also invoke it directly with `/visual-brief`.

### Step 4: Use it

There are two ways to trigger the skill:

**Automatic (recommended)** — just talk naturally. Say things like:

- "Visualize this tweet for me"
- "Diagram my system architecture"
- "Turn this article into a shareable infographic"
- "Break down how this pipeline works"
- "Make a visual of this multi-agent setup"

Claude reads your request, matches it against the skill's description, and
automatically follows the SKILL.md instructions — choosing a layout pattern,
picking a color strategy, identifying the hero element, and producing an
HTML file.

**Manual** — type `/visual-brief` in Claude Code to force-invoke the skill.
Useful when Claude doesn't auto-trigger and you know you want it.

### What happens under the hood

When the skill triggers, Claude follows this process:

1. **Reads SKILL.md** — loads the instructions into context (~500 lines)
2. **Extracts structure** from your content — entities, relationships,
   stages, trust boundaries, feedback loops, and the core thesis
3. **Chooses layout** — horizontal pipeline, vertical layered flow,
   three-column zones, or hub-and-spoke based on the content's shape
4. **Chooses color strategy** — single accent for simple diagrams,
   multi-accent for complex ones, trust-boundary coloring for systems
   with review gates
5. **Reads reference files** only as needed — if it needs CSS snippets,
   it reads `references/elements.md`. If it needs the quality checklist,
   it reads `references/checklist.md`. Files not needed stay unloaded
   (zero token cost).
6. **Produces a single HTML file** with clean typography, color-coded zones,
   explicit feedback loops, and a core insight callout
7. **Runs the quality checklist** before delivering

### Examples of input → output

| You give it | It produces |
|---|---|
| A tweet about a technical system | Horizontal pipeline infographic with support layer and callout |
| A multi-agent architecture description | Vertical layered flow with quality gates and compound loop |
| A complex system with multiple subsystems | Three-column zone diagram with color-coded functional areas |
| Your project's codebase or README | Gap analysis visual showing what exists vs. what's missing |
| An article comparing approaches | Side-by-side comparison with highlighted differences |

### Tips for best results

- **Give it the full source** — paste the entire tweet/article, don't
  summarize. The skill extracts structure better from raw content.
- **Mention the audience** — "for my newsletter" or "for a conference talk"
  helps it calibrate detail level.
- **Ask for iteration** — "make the wiki the hero" or "add a compound loop"
  to steer the output. The skill is designed for editorial back-and-forth.
- **Combine with other skills** — use `visual-brief` for the diagram, then
  `frontend-design` if you want to embed it in a full web page.

### Safety note

This skill contains only markdown instructions and CSS reference files —
no executable scripts, no network calls, no file system access beyond
reading its own reference files. It's safe to install and inspect.
That said, always review any skill's files before enabling it. You can
read every file in this repo — there's nothing hidden.

---

## Layout patterns

The skill knows six layout patterns and selects based on your content:

| Your content | Layout chosen |
|---|---|
| Linear process (A → B → C) | **Horizontal pipeline** |
| System with review gates | **Vertical layered flow** |
| Multiple collaborating subsystems | **Three-column zones** |
| Self-improving system | **Any layout + compound loop strip** |
| Central concept with facets | **Hub-and-spoke** |
| Before/after transformation | **Side-by-side comparison** |

## Color strategies

| Diagram complexity | Strategy |
|---|---|
| Simple (5-7 boxes) | One accent color, rest neutral |
| Complex (8+ boxes) | One color per functional zone |
| Has review/approval gates | Gray (raw) → Red (gate) → Green (approved) |

## Origin

This skill was developed by analyzing three community visualizations of Andrej Karpathy's viral tweet on LLM Knowledge Bases (April 2026):

1. **The original** — horizontal pipeline with support layer
2. **The swarm version** — multi-agent architecture with Hermes quality gate
3. **The system version** — three-column functional zone breakdown

Each visualization contributed patterns that the skill now codifies:
the original gave us the editorial aesthetic, the swarm gave us trust
boundaries and compound loops, the system version gave us functional
zone coloring and dashed containers.

## File structure

```
visual-brief/
├── SKILL.md              ← main skill file (read this first)
├── README.md             ← you are here
└── references/
    ├── elements.md        ← CSS snippets for every visual element
    └── checklist.md       ← quality checklist before delivering
```

## License

MIT
