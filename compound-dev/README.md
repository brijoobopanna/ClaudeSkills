# compound-dev

A Claude Code skill that makes every session build on the last one.



## What it does

You install it once. It scans your codebase, generates a `CLAUDE.md` schema,
creates a living wiki with interlinked entity/concept/decision pages, and
starts logging metrics. From that point on, every session reads the wiki at
start, works with full context, and integrates new knowledge at end.

Three modularity levels — pick your fit:

- **Minimal** (5 min): CLAUDE.md + .project-state.md only. Just session memory.
- **Standard** (recommended): + wiki/ with interlinked pages + metrics
- **Full** (teams/advanced): + raw/ source collection + trust layer (drafts/) + log.md

**Examples of what triggers this skill:**

- "Set up compound-dev for this project"
- "Initialize project memory"
- "Create a CLAUDE.md for this codebase"
- "I keep re-explaining things to Claude"
- "Run a project health check"
- "Show compound metrics"

## The problem it solves

You open Claude Code. You say "add error handling to the API routes." Claude asks
"what framework are you using?" — even though you told it last session. You explain
Express, the middleware pattern, the error format. That's 2000 tokens spent on
context that should already exist.

Next session, same thing. And the session after that.

**compound-dev** fixes this by creating files that persist across sessions:
project identity, current state, documented decisions, discovered patterns,
and known gotchas. Claude Code reads these automatically at session start.

## What it creates

**Standard level (recommended):**

```
your-project/
├── CLAUDE.md              ← schema: project identity + session protocol
├── .project-state.md      ← living state, updated every session
├── .metrics.json           ← session metrics log
└── wiki/
    ├── index.md            ← content-oriented catalog
    ├── log.md              ← chronological, append-only, parseable
    ├── overview.md          ← living synthesis of the project
    ├── decisions/           ← one file per major decision
    ├── concepts/            ← patterns, architectures, approaches
    ├── entities/            ← tools, services, APIs, key components
    └── gotchas/             ← traps and how to avoid them
```

## How to download and use this skill

### Step 1: Download from GitHub

```bash
git clone https://github.com/YOUR_USERNAME/compound-dev.git
```

Or download the ZIP from the GitHub page and extract it.

You should have a folder that looks like this:

```
compound-dev/
├── SKILL.md
├── README.md
└── references/
    └── metrics-schema.md
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
cp -r /path/to/compound-dev .claude/skills/compound-dev
```

Claude Code watches `.claude/skills/` automatically — no restart needed.
The skill is available immediately in your next message.

#### Option B: Claude Code — global (recommended)

The skill works in every project on your machine. Best for personal use
across all your repos. **This is the recommended install** — you want
project memory everywhere, not just in one repo.

```bash
mkdir -p ~/.claude/skills
cp -r /path/to/compound-dev ~/.claude/skills/compound-dev
```

Same as project-level, but the `~/.claude/skills/` path makes it available
everywhere. If a project also has a project-level copy, the project-level
version takes priority.

#### Option C: Claude.ai — web/mobile chat

For people who don't use Claude Code and want the skill in the browser
or mobile app.

```bash
cd compound-dev
zip -r compound-dev.zip .
```

Then in Claude.ai:
1. Go to **Settings → Features**
2. Find the **Custom Skills** section
3. Click **Upload skill**
4. Select `compound-dev.zip`
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

Claude will list all installed skills. You should see `compound-dev` with
its description. You can also invoke it directly with `/compound-dev`.

### Step 4: Initialize in your project

Open Claude Code in any project and say:

```
Set up compound-dev for this project
```

Claude Code will:
1. Scan your codebase (README, package.json, main files, directory structure)
2. Generate a `CLAUDE.md` tailored to the project's type and architecture
3. Create `.project-state.md` with initial state
4. Create `docs/` with empty template files
5. Create `.metrics.json` with baseline entry
6. Commit: `feat: initialize compound-dev`

### Step 5: Use it

There are two modes:

**Automatic (recommended)** — just work normally. The session protocol is
embedded in the `CLAUDE.md` it generates. Claude Code automatically reads
state at start and updates it at end. You don't have to remember anything.

Every session, Claude Code:
- Reads `CLAUDE.md` + `.project-state.md` at start
- Does your actual work
- Updates `.project-state.md` + relevant docs/ files at end
- Appends session metrics to `.metrics.json`
- Commits doc changes

**On demand** — periodically ask:
- **"Run a project health check"** — see metrics dashboard
- **"What decisions have we made?"** — review docs/decisions.md
- **"What patterns do we have?"** — review docs/patterns.md
- **"What gotchas should I know about?"** — review docs/gotchas.md

### What happens under the hood

When the skill triggers for initialization, Claude follows this process:

1. **Reads SKILL.md** — loads the instructions into context
2. **Scans the codebase** — README, package.json, main entry points,
   directory structure, existing config files
3. **Detects project type** — web app, CLI tool, pipeline, library,
   content project, or hobby build
4. **Generates CLAUDE.md** — tailored to the project with architecture,
   commands, and session protocol
5. **Creates state files** — `.project-state.md` with initial state,
   `docs/` with empty templates, `.metrics.json` with baseline
6. **Reads metrics-schema.md** only when a health check is requested —
   reference files stay unloaded until needed (zero token cost)

For every session after initialization:

1. **Session start** — reads CLAUDE.md and .project-state.md (~200 lines
   total, giving full project context for ~1500 tokens)
2. **During work** — references docs/ files when prior decisions or
   patterns are relevant to the current task
3. **Session end** — updates state, logs decisions/patterns/gotchas
   discovered, appends metrics, commits

### Examples of input → output

| You say | What compound-dev does |
|---|---|
| "Set up compound-dev" | Scans codebase, generates CLAUDE.md + state + docs/ + metrics |
| "Add auth to the API" | Reads prior decisions about API design, works with full context, logs new decisions made |
| "Why did we choose JWT?" | Pulls answer from docs/decisions.md instead of guessing |
| "Run a health check" | Reads .metrics.json, reports efficiency + growth + compounding scores |
| "This caching pattern keeps coming up" | Adds it to docs/patterns.md so future sessions know it |
| "I wasted 20 min debugging that again" | Adds it to docs/gotchas.md so it never happens again |
| "Where were we?" | Reads .project-state.md — instant context, zero re-explanation |

### Tips for best results

- **Install globally** — use `~/.claude/skills/` so every project gets
  memory. This is the biggest leverage point.
- **Fill in the blanks** — after initialization, review the generated
  CLAUDE.md and add any context Claude couldn't auto-detect (constraints,
  audience, deployment targets).
- **Don't skip session-end** — the 30 seconds spent updating state saves
  5 minutes of re-explanation next session. Quick fixes are where gotchas
  live — log them especially.
- **Run health checks monthly** — the metrics exist to be read. A stale
  docs/ directory means knowledge is evaporating.
- **Pair with visual-brief** — if installed, health checks render as
  editorial-grade infographics instead of plain text.

### Safety note

This skill contains only markdown instructions and one JSON schema
reference file — no executable scripts, no network calls, no file system
access beyond reading its own reference files and your project's existing
files. It's safe to install and inspect.

That said, always review any skill's files before enabling it. You can
read every file in this repo — there's nothing hidden.

---

## Metrics and observability

The skill tracks three categories of metrics in `.metrics.json`:

### Efficiency — are sessions cheaper?

| Metric | What it tells you | Target |
|---|---|---|
| Cold start rate | % of sessions that started without context | < 5% |
| Tokens per task | Are sessions getting shorter over time? | Trending down |
| Recovery rate | Checkpoint recoveries vs full restarts | > 80% checkpoint |

### Knowledge growth — is the project getting smarter?

| Metric | What it tells you | Target |
|---|---|---|
| Decisions logged | How many "why" explanations are captured | ≥ 1 per design session |
| Patterns captured | Reusable solutions documented | Growing over time |
| Gotchas documented | Traps identified (fewer repeated mistakes) | Growing |
| Docs freshness | Are docs being maintained or going stale? | No file > 2 weeks stale |

### Compounding — is knowledge feeding back?

| Metric | What it tells you | Target |
|---|---|---|
| Context reuse rate | How often prior docs inform current work | > 70% |
| Session continuity | Does each session pick up where the last left off? | > 90% |
| Compound ratio | % of sessions that contribute back to docs | > 50% |

### Estimated token savings

| Practice | Token saving |
|---|---|
| CLAUDE.md read at session start | 30-40% |
| .project-state.md is current | 20-30% |
| docs/ referenced during work | 10-15% |
| Checkpoint recovery vs restart | 50-80% per incident |
| **Combined (steady state)** | **~2-3x more efficient** |

---

## Works with any project

The skill detects your project type and adapts:

| Type | Detection | What it adjusts |
|---|---|---|
| Web app | package.json with react/next/vue | Component patterns in docs/, route architecture in CLAUDE.md |
| CLI tool | bin/ directory, argparse/commander | Command reference in CLAUDE.md |
| Pipeline | pipeline.py, workflow files | Stage documentation, data flow |
| Library | lib/ or src/ with exports | API surface, deprecation patterns |
| Content project | Markdown-heavy, no src/ | Editorial patterns, style guide |
| Hobby/learning | Small, few files, early commits | Lighter structure, focus on decisions + gotchas |

---

## Pairs with visual-brief

If the [`visual-brief`](https://github.com/YOUR_USERNAME/visual-brief) skill
is also installed, health checks render as editorial-grade infographics
instead of plain text — gap analysis showing what's compounding vs what's stale.

The two skills are designed as companions:
- **compound-dev** is how you accumulate knowledge
- **visual-brief** is how you communicate it

---

## Origin

This skill synthesizes two sources:

1. Karpathy's [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
   pattern — the three-layer architecture (raw → wiki → schema), ingest/query/lint
   operations, interlinked wiki pages, and the philosophy that the LLM handles
   all the bookkeeping humans abandon.

2. A real-world gap analysis of the [AIweekly](https://github.com/brijoobopanna/AIweekly)
   newsletter pipeline — which revealed that pipeline engineering can be solid
   while the compounding layer is completely absent.

compound-dev adds what Karpathy's gist deliberately leaves out: metrics to
prove compounding is happening, a trust layer to prevent hallucination
propagation, auto-checkpointing so no manual discipline is required, and
skill packaging so it installs in one command.

### Karpathy alignment

| Karpathy's llm-wiki.md | compound-dev equivalent |
|---|---|
| Three layers: raw, wiki, schema | raw/ + wiki/ + CLAUDE.md |
| "The wiki is a persistent, compounding artifact" | wiki/ with interlinked pages and cross-references |
| "You never write the wiki" | Auto-checkpoint, session protocol |
| "index.md content-oriented, log.md chronological" | wiki/index.md + wiki/log.md |
| "Lint: contradictions, stale claims, orphans" | Health check with wiki quality + metrics |
| "Good answers filed back into the wiki" | "File this into the wiki" command |
| "Pick what's useful, ignore what isn't" | Three levels: minimal / standard / full |

## File structure

```
compound-dev/
├── SKILL.md              ← main skill file (read this first)
├── README.md             ← you are here
└── references/
    └── metrics-schema.md  ← .metrics.json schema + calculation formulas
```

## License

MIT
