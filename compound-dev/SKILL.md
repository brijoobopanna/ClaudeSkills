---
name: compound-dev
description: Make Claude Code sessions compound — every session builds on the last instead of starting from scratch. Implements Karpathy's LLM Wiki pattern for software engineering. Use this skill when starting a new project, onboarding to an existing codebase, or any time the user says "set up my project", "add project memory", "create CLAUDE.md", "help me structure this project", "I keep re-explaining things to Claude", "my sessions don't remember anything", "ingest this document", or "run a health check". Also trigger when the user asks about session efficiency, token usage, or wants to improve their Claude Code workflow. This skill creates and maintains a three-layer knowledge system: raw sources, an interlinked wiki, and a schema that governs it all — plus metrics to prove it's working.
---

# compound-dev

Make every Claude Code session build on the last one.

Implements Karpathy's [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
pattern for software engineering: raw sources are compiled into a persistent,
interlinked wiki maintained entirely by the LLM. You steer. The LLM writes.
Every session compounds.

---

## The core idea

Most Claude Code sessions work like RAG — the LLM rediscovers your project
from scratch every time. You re-explain the architecture, re-debate decisions,
re-discover patterns. Nothing accumulates.

compound-dev is different. The LLM **incrementally builds and maintains a
persistent wiki** — structured, interlinked markdown files that capture
decisions, patterns, gotchas, entities, and concepts. When you start a
session, the LLM reads the wiki and already knows. When you end a session,
new knowledge integrates into the existing wiki — updating entity pages,
noting contradictions, strengthening the synthesis.

**The wiki is a persistent, compounding artifact.** The cross-references are
already there. The contradictions have been flagged. The synthesis reflects
everything you've built. The wiki gets richer with every session.

---

## Three-layer architecture

Following Karpathy's pattern, compound-dev maintains three layers:

### Layer 1: Raw sources (your project)

Your source code, reference material, design specs, API docs. These are
immutable — the LLM reads from them but the wiki is separate.

### Layer 2: The wiki

LLM-generated, LLM-maintained markdown files. Summaries, entity pages,
concept pages, decision records, an overview, a synthesis. The LLM owns
this layer entirely. You read it; the LLM writes it.

### Layer 3: The schema

CLAUDE.md — tells the LLM how the wiki is structured, what the conventions
are, and what workflows to follow. You and the LLM co-evolve this over
time as you figure out what works.

---

## What this skill produces

### Modularity: pick your level

**Minimal** (5 minutes, immediate value):
```
your-project/
├── CLAUDE.md              ← schema: project identity + session protocol
└── .project-state.md      ← living state, updated every session
```

**Standard** (recommended):
```
your-project/
├── CLAUDE.md
├── .project-state.md
├── .metrics.json           ← session metrics log
└── wiki/
    ├── index.md            ← content-oriented catalog with one-line summaries
    ├── log.md              ← chronological, append-only, parseable
    ├── overview.md          ← living synthesis of the entire project
    ├── decisions/           ← one file per major decision
    ├── concepts/            ← patterns, architectures, approaches
    ├── entities/            ← tools, services, APIs, people
    └── gotchas/             ← traps and how to avoid them
```

**Full** (for teams and advanced projects):
```
your-project/
├── CLAUDE.md
├── .project-state.md
├── .metrics.json
├── raw/                    ← immutable reference material
│   └── [articles, specs, API docs, design docs]
└── wiki/
    ├── index.md
    ├── log.md
    ├── overview.md
    ├── drafts/              ← trust layer: unreviewed entries
    ├── decisions/
    ├── concepts/
    ├── entities/
    └── gotchas/
```

Tell Claude Code which level:
- `"Set up compound-dev minimal"` — just CLAUDE.md + state
- `"Set up compound-dev"` — standard with wiki/ and metrics
- `"Set up compound-dev full"` — everything including raw/ and trust layer

### Trust model (full level)

New wiki entries go to `wiki/drafts/` first. They become "live" only after
human review via the `review drafts` command. This prevents hallucinated
or low-quality entries from corrupting the knowledge base.

For solo developers who trust their sessions, auto-promote can be enabled
in CLAUDE.md.

---

## Operations

### Ingest

When new reference material is added — an article, a library doc, a design
spec, an API reference — tell Claude Code: **"Ingest this into the wiki."**

Claude Code will:
1. Read the source material
2. Discuss key takeaways with you
3. Write a summary page in wiki/
4. Update wiki/index.md
5. Update relevant entity and concept pages across the wiki
6. Add cross-references and backlinks
7. Note any contradictions with existing wiki content
8. Append to wiki/log.md

A single source might touch 5-10 wiki pages. This is the compounding
mechanism — new knowledge integrates with existing knowledge, not just
piles up next to it.

### Session (automatic)

Every session follows a built-in protocol:

**Start:**
1. Read CLAUDE.md (schema)
2. Read .project-state.md (current state)
3. Read wiki/index.md (what's in the wiki)
4. Run `git log --oneline -5` (recent history)
5. Confirm understanding before proceeding

**During work:**
- Reference relevant wiki pages when prior decisions or patterns apply
- Note new decisions, patterns, or gotchas as they emerge

**End (auto-checkpoint):**
1. Update .project-state.md
2. Add new wiki entries (to drafts/ if full level, direct if standard)
3. Update wiki/index.md
4. Append to wiki/log.md
5. Append objective metrics to .metrics.json
6. Commit: `docs: auto-checkpoint [date]`

The session-end runs **automatically** — Claude Code detects when a session
is ending and commits without asking permission.

### Query

Ask questions against the wiki. Claude Code reads wiki/index.md, finds
relevant pages, reads them, and synthesizes an answer.

Important: **good answers can be filed back into the wiki.** A comparison
you asked for, an analysis, a connection you discovered — these shouldn't
disappear into chat history. Tell Claude Code: "File this into the wiki."

### Lint (health check)

Tell Claude Code: **"Run a health check"** or **"Lint the wiki"**

Claude Code checks:

**Knowledge quality (from Karpathy's pattern):**
- Contradictions between wiki pages
- Stale claims superseded by newer information
- Orphan pages with no inbound links
- Important concepts mentioned but lacking their own page
- Missing cross-references between related pages
- Data gaps that could be filled with investigation
- Suggestions for new questions to investigate

**Metrics (compound-dev's addition):**
- Cold start rate, context reuse rate, compound ratio
- Docs freshness (stale files)
- Session continuity and token savings estimate

The combined lint is more thorough than either system alone.

```
PROJECT HEALTH — [project name]
Initialized: [date] | Sessions: [count] | Last session: [date]

WIKI QUALITY
  Pages:               [X] total ([X] entities, [X] concepts, [X] decisions)
  Cross-references:    [X] links between pages
  Contradictions:      [X] flagged
  Orphan pages:        [X] (no inbound links)
  Stale pages:         [X] (not updated in >2 weeks)
  Suggested topics:    [list concepts mentioned but lacking pages]

EFFICIENCY
  Cold start rate:     [X]% (target: <5%)
  Context reuse:       [X]% (target: >70%)
  Compound ratio:      [X]% (target: >50%)

ESTIMATED SAVINGS
  Total sessions:      [X]
  Tokens saved:        ~[X]K (vs cold-start baseline)
```

If `visual-brief` skill is installed, render as a gap analysis infographic.

---

## Wiki conventions

### Page structure

Every wiki page follows this format:

```markdown
---
created: 2026-04-05
updated: 2026-04-05
sources: [list of raw/ files or sessions that contributed]
tags: [auth, security, api]
---

# Page Title

[Content]

## Related
- [link to related page 1](../concepts/related.md)
- [link to related page 2](../entities/tool.md)
```

### Linking and cross-references

Every wiki page should link to related pages:
- `[see JWT decision](../decisions/auth-jwt.md)` in a concept page
- `[related: caching pattern](../concepts/caching.md)` in a decision page

When updating a page, check: does any existing page reference this topic?
If so, add a backlink.

### Contradiction handling

When new information contradicts an existing wiki page:
- DO NOT silently overwrite
- Add a `## Contradiction` section noting both claims with sources
- Flag in wiki/log.md: `## [date] contradiction | [topic]`
- Surface in next health check

### wiki/overview.md

A living synthesis page. Updated after every ingest and periodically
during lint passes. Contains:
- Project thesis (2-3 sentences)
- Key decisions and their rationale (summary, not full detail)
- Active patterns and their usage frequency
- Known risks and open questions
- Links to the most important wiki pages

This is the page a new team member reads first.

### wiki/log.md

Append-only chronological record. Every entry uses a parseable header:

```
## [2026-04-05] ingest | Added React Router docs
Updated: wiki/concepts/routing.md, wiki/entities/react-router.md

## [2026-04-05] session | Implemented auth module
Decisions: chose JWT (see wiki/decisions/auth-jwt.md)
Patterns: middleware chain (see wiki/concepts/middleware.md)

## [2026-04-06] lint | Health check
Found: 2 stale, 1 contradiction, 3 orphans. Fixed stale pages.
```

Parseable with: `grep "^## \[" wiki/log.md | tail -5`

---

## Metrics and observability

### .metrics.json schema

```json
{
  "project": "project-name",
  "initialized": "2026-04-05T10:00:00Z",
  "level": "standard",
  "sessions": [
    {
      "date": "2026-04-05T10:00:00Z",
      "duration_minutes": 25,
      "what_done": "Set up authentication module",
      "stage": "building",
      "metrics": {
        "cold_start": false,
        "state_read": true,
        "wiki_pages_read": ["decisions/auth-jwt.md", "concepts/middleware.md"],
        "wiki_pages_updated": ["concepts/middleware.md"],
        "wiki_pages_created": ["entities/jsonwebtoken.md"],
        "lines_added_to_wiki": 45,
        "cross_references_added": 3,
        "git_commits": 4,
        "re_explanation_needed": false,
        "contradictions_found": 0,
        "estimated_tokens_saved": 3200
      }
    }
  ]
}
```

### Key metrics

| Metric | What it proves | Target |
|---|---|---|
| Cold start rate | Sessions start informed, not blank | < 5% |
| Wiki pages read per session | Prior knowledge is being reused | > 2 pages |
| Wiki pages updated per session | New knowledge feeds back | > 0.5 avg |
| Cross-references added | Wiki is becoming interlinked | Growing |
| Contradictions surfaced | Quality is being maintained | Tracked |
| re_explanation_needed | User doesn't repeat themselves | Rare |
| Compound ratio | Sessions contribute to the wiki | > 50% |

See `references/metrics-schema.md` for full calculation formulas.

---

## Adapting to project types

The skill detects project type and adjusts wiki structure:

| Type | Detection | Wiki adjustments |
|---|---|---|
| Web app | package.json with react/next/vue | entities/ for components, concepts/ for state patterns |
| CLI tool | bin/ directory, argparse/commander | entities/ for commands, concepts/ for arg parsing |
| Pipeline | pipeline.py, workflow files | entities/ for pipeline stages, concepts/ for data flow |
| Library | lib/ or src/ with exports | entities/ for API surface, concepts/ for deprecation |
| Research | markdown-heavy, papers, references | entities/ for papers/authors, concepts/ for topics |
| Content | newsletter, blog, wiki | entities/ for sources, concepts/ for editorial patterns |

### Domain examples (from Karpathy's gist)

This pattern applies far beyond code:

- **Research** — reading papers, building a wiki with evolving thesis
- **Reading a book** — chapter summaries, character pages, theme pages
- **Business** — fed by Slack threads, meeting notes, customer calls
- **Competitive analysis** — entity pages per competitor, comparison pages
- **Course notes** — concept pages per lecture, connections between topics

The wiki structure adapts to any knowledge domain. Code projects use
decisions/concepts/entities/gotchas. Research projects might use
topics/papers/authors/hypotheses. The schema (CLAUDE.md) defines the
structure for your specific domain.

---

## Karpathy alignment

| Karpathy's llm-wiki.md | compound-dev implementation |
|---|---|
| Three layers: raw, wiki, schema | raw/ (optional) + wiki/ + CLAUDE.md |
| "The wiki is a persistent, compounding artifact" | wiki/ with interlinked pages, cross-references |
| "You never write the wiki — the LLM maintains all of it" | Auto-checkpoint, session protocol |
| "Knowledge compiled once and kept current" | Ingest integrates across pages, contradictions flagged |
| "index.md content-oriented, log.md chronological" | wiki/index.md + wiki/log.md |
| "Lint: contradictions, stale claims, orphan pages" | Health check with wiki quality + metrics |
| "Good answers filed back into the wiki" | "File this into the wiki" command |
| "Pick what's useful, ignore what isn't" | Modular: minimal / standard / full |
| "Intentionally abstract" | Opinionated but configurable (compound-dev's choice) |

### What compound-dev adds beyond llm-wiki

| Addition | Why |
|---|---|
| .metrics.json with objective metrics | Prove compounding is happening, not just hope |
| Trust layer (wiki/drafts/) | Prevent hallucinations from corrupting the wiki |
| Auto-checkpoint at session end | No manual discipline required |
| Project-type detection | Adapts wiki structure to domain |
| Multi-agent support | Teams and swarms can share a wiki |
| Installable as a skill | One command vs copy-pasting a gist |
| Health check with thresholds | Defines "healthy" with numbers, not vibes |
| overview.md synthesis page | The executive summary Karpathy implies but doesn't specify |

---

## Team and multi-agent usage

### For teams (multiple humans)

- Each session should `git pull` before reading state
- Wiki entries include frontmatter with `author:` field
- Conflicting entries flagged during `review drafts`
- Health check reports per-contributor compound ratios

### For multi-agent systems (OpenClaw, Hermes, swarms)

```
Agent outputs → raw capture → wiki/drafts/ → review gate → wiki/ (live)
```

- Each agent writes to `wiki/drafts/[agent-name]/`
- Supervisor agent or human reviews and promotes
- Per-agent briefings: filter wiki/ by author/tag
- Contradiction detection prevents hallucination propagation

### MCP integration (future, v2)

```
Tools:
  read_state()           → .project-state.md content
  read_wiki_index()      → wiki/index.md content
  read_page(path)        → specific wiki page
  add_draft(entry)       → write to wiki/drafts/
  promote_draft(id)      → move from drafts to live
  get_health()           → metrics + wiki quality summary
  get_briefing(role)     → filtered wiki for a specific role
```

---

## Interaction with other skills

| Skill | Integration |
|---|---|
| `visual-brief` | Health check renders as gap analysis infographic |
| `frontend-design` | Concepts from wiki/concepts/ inform component decisions |
| `skill-creator` | When patterns crystallize, suggest creating a skill |
| Any skill | compound-dev provides the memory layer; others provide capabilities |

---

## Anti-patterns

- ❌ Skipping session-start protocol (reading state + wiki index)
- ❌ Decisions without context ("chose X" — why? what alternatives?)
- ❌ Silently overwriting contradictions instead of flagging them
- ❌ Wiki pages with no cross-references (isolated knowledge doesn't compound)
- ❌ Massive single files — split at ~50 entries, create new pages
- ❌ Bypassing drafts/ in multi-agent contexts
- ❌ Never running lint (the wiki needs maintenance like any codebase)
- ❌ Treating the wiki as documentation (it's a living knowledge base, not docs)

---

## Why this works

The tedious part of maintaining a knowledge base is not the reading or
the thinking — it's the bookkeeping. Updating cross-references, keeping
summaries current, noting contradictions, maintaining consistency. Humans
abandon wikis because the maintenance burden grows faster than the value.

The LLM doesn't get bored. It doesn't forget to update a cross-reference.
It can touch 10 files in one pass. The wiki stays maintained because the
cost of maintenance is near zero.

Your job is to curate sources, direct the work, ask good questions, and
think about what it all means. The LLM's job is everything else.

---

## File structure

```
compound-dev/
├── SKILL.md                ← this file (read first)
├── README.md               ← install guide + usage
└── references/
    └── metrics-schema.md    ← .metrics.json schema + calculation formulas
```
