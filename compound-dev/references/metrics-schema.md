# Metrics Schema Reference

## .metrics.json

Append-only JSON file at project root. Sessions add entries, never remove.

### Schema

```json
{
  "project": "string",
  "initialized": "ISO 8601",
  "level": "minimal | standard | full",
  "sessions": [
    {
      "date": "ISO 8601",
      "duration_minutes": 25,
      "what_done": "one-line summary",
      "stage": "premise | scaffolding | building | polishing | maintaining",
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

### Key fields

**cold_start**: True if session began without reading .project-state.md.

**wiki_pages_read**: Which wiki/ pages were consulted. Measures knowledge reuse.

**wiki_pages_created**: New pages added. Measures knowledge growth.

**lines_added_to_wiki**: Objective line count via `git diff --stat` at session end.

**re_explanation_needed**: True if user had to re-explain prior context. Strongest signal of knowledge gap.

**estimated_tokens_saved**: Calculated from objective signals:
- state_read AND NOT re_explanation_needed → baseline × 0.40
- state_read AND re_explanation_needed → baseline × 0.15
- else → 0

### Health check formulas

```
cold_start_rate = count(cold_start=true) / total_sessions
context_reuse = count(wiki_pages_read non-empty) / total_sessions
compound_ratio = count(wiki_pages_updated non-empty) / total_sessions
wiki_freshness = for each page: days since last update (stale if >14)
```

### Thresholds

| Metric | Green | Yellow | Red |
|---|---|---|---|
| Cold start rate | < 5% | 5-20% | > 20% |
| Context reuse | > 70% | 40-70% | < 40% |
| Compound ratio | > 50% | 25-50% | < 25% |
| Wiki freshness | All < 14 days | 1-2 stale | 3+ stale |
