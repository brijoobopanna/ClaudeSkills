#!/bin/bash
# compound-dev measurement script
# Run weekly: ./measure.sh
# Produces an objective scorecard from git + wiki + metrics

set -e

echo "╔══════════════════════════════════════════════════════╗"
echo "║          compound-dev impact scorecard               ║"
echo "║          $(date +%Y-%m-%d)                                  ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# ── 1. Wiki growth ──
echo "── WIKI GROWTH ──"

if [ -d "wiki" ]; then
  WIKI_PAGES=$(find wiki -name "*.md" -not -path "wiki/drafts/*" | wc -l)
  WIKI_DRAFT_PAGES=$(find wiki/drafts -name "*.md" 2>/dev/null | wc -l)
  WIKI_LINES=$(find wiki -name "*.md" -not -path "wiki/drafts/*" -exec cat {} + 2>/dev/null | wc -l)
  WIKI_WORDS=$(find wiki -name "*.md" -not -path "wiki/drafts/*" -exec cat {} + 2>/dev/null | wc -w)
  CROSS_REFS=$(grep -r "\](" wiki/ --include="*.md" 2>/dev/null | grep -v "http" | wc -l)

  echo "  Pages (live):        $WIKI_PAGES"
  echo "  Pages (drafts):      $WIKI_DRAFT_PAGES"
  echo "  Total lines:         $WIKI_LINES"
  echo "  Total words:         $WIKI_WORDS"
  echo "  Cross-references:    $CROSS_REFS"

  # Pages by category
  for dir in decisions concepts entities people daily gotchas; do
    if [ -d "wiki/$dir" ]; then
      COUNT=$(find "wiki/$dir" -name "*.md" | wc -l)
      echo "    wiki/$dir/:    $COUNT pages"
    fi
  done

  # Staleness check
  echo ""
  echo "  Stale pages (>14 days since update):"
  STALE=0
  while IFS= read -r file; do
    DAYS_AGO=$(( ($(date +%s) - $(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null)) / 86400 ))
    if [ "$DAYS_AGO" -gt 14 ]; then
      echo "    ⚠ $(basename "$file") ($DAYS_AGO days)"
      STALE=$((STALE + 1))
    fi
  done < <(find wiki -name "*.md" -not -path "wiki/drafts/*" 2>/dev/null)
  if [ "$STALE" -eq 0 ]; then
    echo "    ✓ None — all pages fresh"
  fi
else
  echo "  ⚠ No wiki/ directory found. Run: Set up compound-dev"
fi

echo ""

# ── 2. Session metrics from .metrics.json ──
echo "── SESSION METRICS ──"

if [ -f ".metrics.json" ]; then
  # Use python for JSON parsing (available on most systems)
  python3 -c "
import json, sys
from datetime import datetime, timedelta

with open('.metrics.json') as f:
    data = json.load(f)

sessions = data.get('sessions', [])
total = len(sessions)
if total == 0:
    print('  No sessions logged yet.')
    sys.exit(0)

print(f'  Total sessions:      {total}')
print(f'  Initialized:         {data.get(\"initialized\", \"unknown\")}')
print(f'  Last session:        {sessions[-1].get(\"date\", \"unknown\")}')

# Cold start rate
cold = sum(1 for s in sessions if s.get('metrics', {}).get('cold_start', False))
cold_rate = (cold / total) * 100
marker = '✓' if cold_rate < 5 else ('⚠' if cold_rate < 20 else '✗')
print(f'  Cold start rate:     {cold_rate:.0f}% ({cold}/{total}) {marker} (target: <5%)')

# Context reuse rate
reuse = sum(1 for s in sessions if len(s.get('metrics', {}).get('wiki_pages_read', [])) > 0)
reuse_rate = (reuse / total) * 100
marker = '✓' if reuse_rate > 70 else ('⚠' if reuse_rate > 40 else '✗')
print(f'  Context reuse rate:  {reuse_rate:.0f}% ({reuse}/{total}) {marker} (target: >70%)')

# Compound ratio
updated = sum(1 for s in sessions
              if len(s.get('metrics', {}).get('wiki_pages_updated', []))
              + len(s.get('metrics', {}).get('wiki_pages_created', [])) > 0)
compound_rate = (updated / total) * 100
marker = '✓' if compound_rate > 50 else ('⚠' if compound_rate > 25 else '✗')
print(f'  Compound ratio:      {compound_rate:.0f}% ({updated}/{total}) {marker} (target: >50%)')

# Re-explanation rate
reexplain = sum(1 for s in sessions if s.get('metrics', {}).get('re_explanation_needed', False))
reexplain_rate = (reexplain / total) * 100
marker = '✓' if reexplain_rate < 10 else ('⚠' if reexplain_rate < 30 else '✗')
print(f'  Re-explanation rate: {reexplain_rate:.0f}% ({reexplain}/{total}) {marker} (target: <10%)')

# Total estimated savings
saved = sum(s.get('metrics', {}).get('estimated_tokens_saved', 0) for s in sessions)
print(f'  Est. tokens saved:   ~{saved:,}')

# Trend: last 5 sessions
print()
print('  Last 5 sessions:')
for s in sessions[-5:]:
    m = s.get('metrics', {})
    read = len(m.get('wiki_pages_read', []))
    wrote = len(m.get('wiki_pages_updated', [])) + len(m.get('wiki_pages_created', []))
    print(f'    {s.get(\"date\",\"?\")[:10]} | read {read} pages | wrote {wrote} pages | {s.get(\"what_done\",\"?\")[:50]}')
" 2>/dev/null || echo "  ⚠ Could not parse .metrics.json (needs python3)"
else
  echo "  ⚠ No .metrics.json found. Run: Set up compound-dev"
fi

echo ""

# ── 3. Git evidence ──
echo "── GIT EVIDENCE ──"

if git rev-parse --git-dir > /dev/null 2>&1; then
  # Auto-checkpoint commits
  CHECKPOINTS=$(git log --oneline --all 2>/dev/null | grep -c "auto-checkpoint\|compound-dev\|docs: update state" || true)
  echo "  Auto-checkpoint commits:  $CHECKPOINTS"

  # Wiki-related commits in last 30 days
  WIKI_COMMITS=$(git log --oneline --since="30 days ago" -- wiki/ 2>/dev/null | wc -l || true)
  echo "  Wiki commits (30 days):   $WIKI_COMMITS"

  # Total commits in last 30 days (for ratio)
  TOTAL_COMMITS=$(git log --oneline --since="30 days ago" 2>/dev/null | wc -l || true)
  echo "  Total commits (30 days):  $TOTAL_COMMITS"

  if [ "$TOTAL_COMMITS" -gt 0 ]; then
    RATIO=$((WIKI_COMMITS * 100 / TOTAL_COMMITS))
    echo "  Wiki commit ratio:        ${RATIO}% of all commits touch wiki/"
  fi

  # First compound-dev commit (how long have you been using it)
  FIRST=$(git log --oneline --all --diff-filter=A -- CLAUDE.md 2>/dev/null | tail -1)
  if [ -n "$FIRST" ]; then
    echo "  First CLAUDE.md commit:   $FIRST"
  fi

  # wiki/ growth over time (commits that added files to wiki/)
  echo ""
  echo "  Wiki growth timeline (files added per week):"
  git log --since="8 weeks ago" --diff-filter=A --name-only --pretty=format:"%ad" --date=format:"%Y-W%V" -- "wiki/**/*.md" 2>/dev/null | \
    grep -E "^[0-9]{4}" | sort | uniq -c | sort -k2 || echo "    No wiki file additions tracked yet"
else
  echo "  ⚠ Not a git repository"
fi

echo ""

# ── 4. Qualitative check ──
echo "── QUALITATIVE CHECK ──"

if [ -f "wiki/overview.md" ]; then
  OVERVIEW_LINES=$(wc -l < wiki/overview.md)
  echo "  ✓ wiki/overview.md exists ($OVERVIEW_LINES lines)"
else
  echo "  ✗ No wiki/overview.md — run: generate an overview"
fi

if [ -f "wiki/log.md" ]; then
  LOG_ENTRIES=$(grep -c "^## \[" wiki/log.md 2>/dev/null || true)
  echo "  ✓ wiki/log.md exists ($LOG_ENTRIES entries)"
else
  echo "  ✗ No wiki/log.md — chronological record missing"
fi

if [ -f "wiki/index.md" ]; then
  INDEX_LINKS=$(grep -c "\](" wiki/index.md 2>/dev/null || true)
  echo "  ✓ wiki/index.md exists ($INDEX_LINKS links)"
else
  echo "  ✗ No wiki/index.md — content catalog missing"
fi

if [ -f ".project-state.md" ]; then
  STATE_AGE=$(( ($(date +%s) - $(stat -c %Y ".project-state.md" 2>/dev/null || stat -f %m ".project-state.md" 2>/dev/null)) / 86400 ))
  if [ "$STATE_AGE" -lt 7 ]; then
    echo "  ✓ .project-state.md updated $STATE_AGE days ago"
  else
    echo "  ⚠ .project-state.md is $STATE_AGE days old (should be <7)"
  fi
else
  echo "  ✗ No .project-state.md"
fi

# Orphan detection (wiki pages with no inbound links)
if [ -d "wiki" ]; then
  echo ""
  echo "  Orphan pages (no other page links to them):"
  ORPHANS=0
  for page in $(find wiki -name "*.md" -not -name "index.md" -not -name "log.md" -not -name "overview.md" -not -path "wiki/drafts/*" 2>/dev/null); do
    BASENAME=$(basename "$page")
    REFS=$(grep -rl "$BASENAME" wiki/ --include="*.md" 2>/dev/null | grep -v "$page" | wc -l)
    if [ "$REFS" -eq 0 ]; then
      echo "    ⚠ $page (0 inbound links)"
      ORPHANS=$((ORPHANS + 1))
    fi
  done
  if [ "$ORPHANS" -eq 0 ]; then
    echo "    ✓ None — all pages are linked"
  fi
fi

echo ""

# ── 5. Overall score ──
echo "── OVERALL SCORE ──"

python3 -c "
import json, sys

score = 0
max_score = 0
details = []

# Wiki exists
max_score += 10
import os
if os.path.isdir('wiki'):
    pages = len([f for dp, dn, fn in os.walk('wiki') for f in fn if f.endswith('.md') and 'drafts' not in dp])
    if pages >= 10:
        score += 10; details.append('✓ Wiki has 10+ pages (+10)')
    elif pages >= 3:
        score += 5; details.append(f'⚠ Wiki has {pages} pages (+5, need 10+)')
    else:
        details.append(f'✗ Wiki has only {pages} pages (+0)')
else:
    details.append('✗ No wiki/ directory (+0)')

# Metrics exist
max_score += 10
if os.path.isfile('.metrics.json'):
    with open('.metrics.json') as f:
        data = json.load(f)
    sessions = data.get('sessions', [])
    if len(sessions) >= 5:
        score += 10; details.append(f'✓ {len(sessions)} sessions logged (+10)')
    elif len(sessions) >= 1:
        score += 5; details.append(f'⚠ {len(sessions)} sessions logged (+5, need 5+)')
    else:
        details.append('✗ No sessions logged (+0)')

    # Cold start rate
    max_score += 20
    total = len(sessions)
    if total > 0:
        cold = sum(1 for s in sessions if s.get('metrics',{}).get('cold_start', False))
        rate = cold / total
        if rate < 0.05:
            score += 20; details.append(f'✓ Cold start rate {rate*100:.0f}% (+20)')
        elif rate < 0.20:
            score += 10; details.append(f'⚠ Cold start rate {rate*100:.0f}% (+10)')
        else:
            details.append(f'✗ Cold start rate {rate*100:.0f}% (+0)')

    # Compound ratio
    max_score += 20
    if total > 0:
        updated = sum(1 for s in sessions
                      if len(s.get('metrics',{}).get('wiki_pages_updated',[])) +
                         len(s.get('metrics',{}).get('wiki_pages_created',[])) > 0)
        rate = updated / total
        if rate > 0.50:
            score += 20; details.append(f'✓ Compound ratio {rate*100:.0f}% (+20)')
        elif rate > 0.25:
            score += 10; details.append(f'⚠ Compound ratio {rate*100:.0f}% (+10)')
        else:
            details.append(f'✗ Compound ratio {rate*100:.0f}% (+0)')

    # Re-explanation rate
    max_score += 20
    if total > 0:
        reexp = sum(1 for s in sessions if s.get('metrics',{}).get('re_explanation_needed', False))
        rate = reexp / total
        if rate < 0.10:
            score += 20; details.append(f'✓ Re-explanation rate {rate*100:.0f}% (+20)')
        elif rate < 0.30:
            score += 10; details.append(f'⚠ Re-explanation rate {rate*100:.0f}% (+10)')
        else:
            details.append(f'✗ Re-explanation rate {rate*100:.0f}% (+0)')
else:
    max_score += 60  # skip session-dependent scores
    details.append('✗ No .metrics.json (+0)')

# Cross-references
max_score += 20
import subprocess
try:
    result = subprocess.run(['grep', '-r', '](', 'wiki/', '--include=*.md'],
                          capture_output=True, text=True)
    refs = len([l for l in result.stdout.split('\n') if l and 'http' not in l])
    if refs >= 20:
        score += 20; details.append(f'✓ {refs} cross-references (+20)')
    elif refs >= 5:
        score += 10; details.append(f'⚠ {refs} cross-references (+10, need 20+)')
    else:
        details.append(f'✗ {refs} cross-references (+0)')
except:
    details.append('? Could not count cross-references')

pct = (score / max_score * 100) if max_score > 0 else 0
grade = 'A' if pct >= 80 else 'B' if pct >= 60 else 'C' if pct >= 40 else 'D' if pct >= 20 else 'F'

print(f'  Score: {score}/{max_score} ({pct:.0f}%) — Grade: {grade}')
print()
for d in details:
    print(f'  {d}')
print()
if pct >= 80:
    print('  🟢 Compounding is working. Knowledge is accumulating.')
elif pct >= 50:
    print('  🟡 Partially compounding. Check weak areas above.')
else:
    print('  🔴 Not yet compounding. Focus on logging sessions and growing wiki.')
" 2>/dev/null || echo "  (needs python3 for scoring)"

echo ""
echo "Run this weekly to track progress. Share results to help the community."
