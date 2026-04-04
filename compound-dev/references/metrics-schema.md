# Metrics Schema Reference

## .metrics.json

The metrics file is a single JSON file at the project root. It is append-only
during normal operation — sessions add entries but never remove them.

### Full schema

```json
{
  "project": "string — project name",
  "initialized": "ISO 8601 datetime",
  "baseline_cold_start_tokens": "number — estimated tokens for a cold-start session",
  "sessions": [
    {
      "date": "ISO 8601 datetime",
      "duration_minutes": "number — approximate session length",
      "what_done": "string — one-line summary of what was accomplished",
      "stage": "string — premise | scaffolding | building | polishing | maintaining",
      "files_modified": ["list of files touched"],
      "commits": ["list of commit messages"],
      "metrics": {
        "cold_start": "boolean — did the session start without reading state?",
        "state_read": "boolean — was .project-state.md read at session start?",
        "files_read": ["list of all files read during session (objective)"],
        "docs_read": ["list of docs/ files consulted during session"],
        "docs_updated": ["list of docs/ files modified during session"],
        "drafts_created": "number — new draft entries created",
        "drafts_promoted": "number — drafts promoted to live this session",
        "decisions_logged": "number — new entries added to decisions",
        "patterns_captured": "number — new entries added to patterns",
        "gotchas_found": "number — new entries added to gotchas",
        "lines_added_to_docs": "number — total lines added to docs/ (objective)",
        "git_commits": "number — commits made this session (objective)",
        "re_explanation_needed": "boolean — did the user have to re-explain prior context?",
        "recovery_used": "boolean — was a checkpoint recovery used this session?",
        "estimated_tokens_saved": "number — rough estimate vs cold start"
      }
    }
  ]
}
```

### Field definitions

**cold_start**: True if the session began without reading .project-state.md.
This happens when: the file doesn't exist yet, the user skipped the protocol,
or Claude Code was invoked with a one-off command. Should be rare after setup.

**state_read**: True if .project-state.md was read at session start. This is
the primary efficiency driver — when true, Claude Code has immediate context.

**docs_read**: Which docs/ files were consulted during the session. Measures
knowledge reuse. Empty list = no prior knowledge was leveraged.

**docs_updated**: Which docs/ files were modified. Measures knowledge growth.
Empty list = the session didn't contribute back to the knowledge base.

**re_explanation_needed**: True if the user had to re-explain something that
should already be in docs/. This is the strongest signal of knowledge gap.
Detected when: user says something like "as I mentioned before", "we already
decided", or explicitly re-states prior decisions.

**lines_added_to_docs**: Objective count of lines added to docs/ files
(including drafts/). Measured via `git diff --stat` at session end.

**git_commits**: Number of commits this session. Objective, pulled from
`git log` at session end.

**estimated_tokens_saved**: Calculated from objective signals:
```
if state_read AND NOT re_explanation_needed:
  saved = baseline × 0.40  (state + docs prevented re-explanation)
elif state_read AND re_explanation_needed:
  saved = baseline × 0.15  (state helped somewhat)
else:
  saved = 0  (cold start, no savings)
```

### Calculation formulas for health check

```
cold_start_rate = count(sessions where cold_start=true) / total_sessions

context_reuse_rate = count(sessions where docs_read is non-empty) / total_sessions

session_continuity = count(sessions where state_read=true AND cold_start=false) / total_sessions

compound_ratio = count(sessions where docs_updated is non-empty) / total_sessions

total_estimated_savings = sum(sessions[].metrics.estimated_tokens_saved)

knowledge_growth = {
  decisions: count entries in docs/decisions.md,
  patterns: count entries in docs/patterns.md,
  gotchas: count entries in docs/gotchas.md,
  total_docs_size: sum of file sizes in docs/
}

docs_freshness = for each file in docs/:
  days_since_update = today - last_modified_date
  stale = days_since_update > 14
```

### Thresholds for health check recommendations

| Metric | Green | Yellow | Red |
|---|---|---|---|
| Cold start rate | < 5% | 5-20% | > 20% |
| Context reuse rate | > 70% | 40-70% | < 40% |
| Session continuity | > 90% | 70-90% | < 70% |
| Compound ratio | > 50% | 25-50% | < 25% |
| Docs freshness | All < 14 days | 1-2 files stale | 3+ files stale |
| Decision coverage | ≥ 1 per design session | Some gaps | Many undocumented choices |
