# Visual Elements Reference

CSS snippets for every element type in a visual-brief.

## Boxes

### Standard box
```css
.box {
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: 6px;
  padding: 1.25rem 1.1rem;
  box-shadow: 0 2px 12px rgba(45,30,15,0.06);
}
```

### Hero box (centerpiece, accent background)
```css
.box.hero {
  background: var(--accent);
  color: #fff;
  border-color: var(--accent);
  box-shadow: 0 4px 24px rgba(45,30,15,0.1);
}
.box.hero .box-detail { color: rgba(255,255,255,0.85); }
.box.hero .annotation { color: rgba(255,255,255,0.6); }
```

### Gate box (review/decision point)
```css
.box.gate {
  background: var(--accent);
  color: #fff;
  text-align: center;
  border-color: var(--accent);
}
.box.gate .gate-label {
  font-family: var(--mono);
  font-size: 0.65rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  opacity: 0.8;
}
```

### Approved/live box (trusted, green-tinted)
```css
.box.approved {
  background: var(--approved-bg, #E8F5E9);
  border-color: var(--approved, #2D6A4F);
}
.box.approved .box-title { color: var(--approved, #2D6A4F); }
```

### Future/planned box (dashed, no fill)
```css
.box.future {
  border: 2px dashed var(--border);
  background: transparent;
}
```

---

## Containers

### Grouping zone (dashed outline, wraps related boxes)
```css
.zone {
  border: 1.5px dashed var(--border);
  border-radius: 12px;
  padding: 1.5rem;
  background: transparent;
  position: relative;
}
.zone-label {
  font-family: var(--mono);
  font-size: 0.65rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--text-muted);
  margin-bottom: 0.75rem;
}
```

### Colored zone (for multi-zone layouts)
```css
.zone.ingest  { background: var(--zone-ingest);  border-color: #E8C4B8; }
.zone.engine  { background: var(--zone-engine);  border-color: #C4B5FD; }
.zone.store   { background: var(--zone-store);   border-color: #A7F3D0; }
.zone.tools   { background: var(--zone-tools);   border-color: #BBF7D0; }
.zone.output  { background: var(--zone-output);  border-color: #FDE68A; }
```

---

## Arrows

### Solid arrow (primary flow)
```css
.arrow {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 0 0.5rem;
  min-width: 50px;
}
.arrow-line {
  width: 24px;
  height: 2px;
  background: var(--border);
  position: relative;
}
.arrow-line::after {
  content: '';
  position: absolute;
  right: -1px;
  top: -4px;
  width: 0; height: 0;
  border-top: 5px solid transparent;
  border-bottom: 5px solid transparent;
  border-left: 6px solid var(--border);
}
```

### Dashed arrow (secondary/rejection flow)
```css
.arrow-dashed .arrow-line {
  background: none;
  border-top: 2px dashed #ccc;
  height: 0;
}
.arrow-dashed .arrow-line::after {
  border-left-color: #ccc;
}
```

### Vertical arrow (for layered flows)
```css
.arrow-down {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 0.5rem 0;
}
.arrow-down .arrow-line {
  width: 2px;
  height: 24px;
  background: var(--border);
}
.arrow-down .arrow-line::after {
  right: auto; top: auto;
  bottom: -1px; left: -4px;
  border-left: 5px solid transparent;
  border-right: 5px solid transparent;
  border-top: 6px solid var(--border);
  border-bottom: none;
}
```

### Arrow label
```css
.arrow-label {
  font-family: var(--mono);
  font-size: 0.6rem;
  color: var(--text-muted);
  margin-bottom: 4px;
  letter-spacing: 0.05em;
}
```

---

## Tags and pills

### Tag inside a box
```css
.tag {
  display: inline-block;
  font-size: 0.65rem;
  padding: 0.15rem 0.5rem;
  border-radius: 12px;
  background: rgba(0,0,0,0.06);
  font-family: var(--sans);
}
.tag.accent {
  background: var(--accent-light);
  color: var(--accent);
}
```

---

## Section headers

```css
.section-header {
  display: flex;
  align-items: baseline;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
  border-bottom: 1px solid var(--border);
  padding-bottom: 0.5rem;
}
.section-label {
  font-family: var(--mono);
  font-size: 0.7rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  font-weight: 600;
}
.section-note {
  font-size: 0.75rem;
  color: var(--text-muted);
  font-style: italic;
}
```

---

## Compound loop strip

```css
.loop-strip {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 1rem 1.5rem;
  margin-top: 1.5rem;
}
.loop-step {
  text-align: center;
  font-size: 0.85rem;
  font-weight: 600;
  padding: 0 1rem;
}
.loop-step .muted {
  display: block;
  font-size: 0.7rem;
  font-weight: 400;
  color: var(--text-muted);
  font-style: italic;
}
.loop-step.accent { color: var(--accent); }
.loop-arrow {
  color: var(--text-muted);
  font-size: 0.8rem;
  padding: 0 0.25rem;
}
```

---

## Callout (thesis)

```css
.callout {
  background: var(--accent);
  color: #fff;
  padding: 1.5rem 2rem;
  border-radius: 6px;
  display: flex;
  gap: 1.5rem;
  align-items: baseline;
}
.callout-label {
  font-family: var(--mono);
  font-size: 0.65rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  white-space: nowrap;
  opacity: 0.8;
  font-weight: 600;
}
.callout p {
  font-size: 0.95rem;
  line-height: 1.6;
}
```

---

## Feedback tag

```css
.feedback-tag {
  font-family: var(--mono);
  font-size: 0.65rem;
  letter-spacing: 0.05em;
  color: var(--accent);
  background: var(--accent-light);
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  border: 1px solid rgba(139,37,0,0.15);
  display: inline-block;
}
```

---

## Title block

```css
.title-block { margin-bottom: 3rem; position: relative; }

.author-label {
  font-family: var(--mono);
  font-size: 0.7rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--accent);
  font-weight: 600;
  display: block;
  margin-bottom: 0.75rem;
}

.title-block h1 {
  font-family: var(--sans);
  font-size: 2.2rem;
  font-weight: 700;
  line-height: 1.2;
  max-width: 500px;
  margin-bottom: 0.75rem;
}

.subtitle {
  font-size: 0.95rem;
  color: var(--text-muted);
}

.highlight-quote {
  font-size: 1rem;
  font-weight: 600;
  color: var(--accent);
}
```

---

## Responsive

```css
@media (max-width: 768px) {
  .pipeline { flex-direction: column; }
  .arrow { flex-direction: row; padding: 0.5rem 0; }
  .support-grid { grid-template-columns: 1fr; }
  .zone-columns { flex-direction: column; }
  .loop-strip { flex-wrap: wrap; }
  h1 { font-size: 1.5rem; }
}
```
