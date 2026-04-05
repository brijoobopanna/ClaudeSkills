# How to Measure compound-dev Impact

## The honest truth

There are things you CAN measure and things you CAN'T. Being clear about
this upfront prevents you from making claims you can't back up.

### What you CAN measure (hard evidence)

These come from `git log`, the filesystem, and `.metrics.json`:

| Metric | Where it comes from | Why it matters |
|---|---|---|
| Wiki page count over time | `find wiki -name "*.md" \| wc -l` | Knowledge is accumulating or it isn't |
| Cross-references between pages | `grep -r "](" wiki/ \| grep -v http \| wc -l` | Isolated facts don't compound; linked facts do |
| Auto-checkpoint commits | `git log --oneline \| grep auto-checkpoint` | Session protocol is running or it isn't |
| Wiki lines added per week | `git diff --stat` on wiki/ | Growth rate of the knowledge base |
| Stale pages (>14 days) | File modification dates | Knowledge is being maintained or rotting |
| Orphan pages (no inlinks) | Cross-reference scan | Pages nobody links to are invisible |
| Session count | `.metrics.json` entries | Basic activity tracking |
| Cold start boolean per session | `.metrics.json` field | Did the session read state or start blank? |

### What you CAN'T measure (be honest)

| Claimed metric | Why you can't actually measure it |
|---|---|
| "Saved 3,200 tokens" | You don't have access to the API token counter from inside a skill |
| "2-3x more efficient" | No way to A/B test the same session with and without wiki |
| "Context reuse = high" | The LLM self-reports this — it might claim "high" to please you |
| "30-40% token savings" | Estimated from heuristics, not measured from API usage |

**The token savings estimates in .metrics.json are directional, not precise.**
They tell you the trend (improving or not) but the absolute numbers are rough.

---

## The measurement plan

### Week 0: Establish your baseline (BEFORE installing)

This is the most important step. Without a baseline, you can't prove anything.

**Do this before running `Set up compound-dev`:**

Run 3-5 normal Claude Code sessions on your project. For each one, note:

```
Session 1 (no compound-dev):
  Date: ____
  How long until Claude understood my project: ____ minutes
  Did I have to re-explain architecture? yes/no
  Did I have to re-explain prior decisions? yes/no
  How many times did Claude ask "what framework?" type questions: ____
  Approximate session length: ____ minutes
  What was accomplished: ____
```

Save this as `baseline.md` in your project. This is your "before" measurement.

### Week 1: Install and initialize

Run `Set up compound-dev`. Do 3-5 sessions. After each session, the auto-
checkpoint logs to `.metrics.json`. Run `./measure.sh` at end of week.

**What to watch for:**
- Does Claude read .project-state.md at session start? (check the chat)
- Does Claude reference wiki pages during work? (check the chat)
- Do you still have to re-explain things? (your subjective experience)

### Week 2-3: The compound effect should start showing

By now wiki/ should have 5-10+ pages. Cross-references should exist.

**What to watch for:**
- Claude says things like "based on the decision in wiki/decisions/..."
- You notice NOT having to re-explain something you told it weeks ago
- The health check shows compound ratio > 25%

Run `./measure.sh` weekly.

### Week 4: Compare against baseline

Pull out your `baseline.md` and compare:

```
BEFORE (week 0 average):
  Time to context:       [X] minutes
  Re-explanations:       [X] per session
  Session length:        [X] minutes

AFTER (week 4 average):
  Time to context:       [X] minutes (should be ~0 if protocol works)
  Re-explanations:       [X] per session (should be near 0)
  Session length:        [X] minutes (may be shorter, may be same but more done)
```

The strongest signal is **re-explanations dropping to near zero**. This is
something you feel directly — you stop saying "as I mentioned before" or
"we already decided to use JWT."

### Week 8: Full picture

Run `./measure.sh` and look at the overall score. A healthy project should be:

```
Grade A (80%+):
  ✓ 10+ wiki pages
  ✓ 5+ sessions logged
  ✓ Cold start rate < 5%
  ✓ Compound ratio > 50%
  ✓ Re-explanation rate < 10%
  ✓ 20+ cross-references
```

---

## The measurement script

Run `./measure.sh` in your project root. It reads git log + wiki/ + .metrics.json
and produces a scorecard with:

1. **Wiki growth** — page count, lines, words, cross-references, staleness
2. **Session metrics** — cold start rate, compound ratio, re-explanation rate
3. **Git evidence** — auto-checkpoint commits, wiki commit ratio
4. **Qualitative check** — overview.md exists, log.md has entries, orphan detection
5. **Overall score** — 0-100 with letter grade and green/yellow/red status

### Quick install

```bash
chmod +x measure.sh
./measure.sh
```

No dependencies beyond bash and python3 (for JSON parsing).

---

## What to share with the community

When you share your results (for the viral strategy), share HARD evidence only:

**Good to share:**
- Screenshot of `./measure.sh` output showing Grade A
- Wiki page count: "My project grew from 0 to 47 wiki pages in 6 weeks"
- Before/after: "Re-explanations went from 3 per session to 0"
- Git stats: "27% of my commits now touch wiki/ — knowledge is compounding"

**Don't share:**
- "Saved 50,000 tokens" — you can't prove this
- "3x more efficient" — you can't measure this precisely
- Any absolute token or dollar numbers

**The most compelling proof:**
Take your `baseline.md` (week 0) and your week 8 `./measure.sh` output,
and show them side by side. The contrast IS the story.

---

## Ongoing observability

After the initial 8-week period, shift to monthly health checks:

```bash
# Add to your calendar or cron
./measure.sh >> measurements-log.txt
```

**Warning signs to watch for:**
- Compound ratio dropping below 25% → sessions aren't contributing back
- Stale pages piling up → wiki is rotting, needs a lint pass
- Cold start rate creeping up → session protocol isn't being followed
- Orphan pages growing → wiki is fragmenting, needs cross-referencing

**The meta-metric:** Is the overall score going UP, STABLE, or DOWN over
months? Up = compounding. Stable = maintaining. Down = decaying. If it's
decaying, run a lint pass: "Health check the wiki and fix what's broken."
