# Visual Elements Reference

CSS snippets for visual-brief components.

## Fonts
```css
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&family=DM+Sans:wght@300;400;500;600;700&display=swap');
:root { --mono: 'IBM Plex Mono', monospace; --sans: 'DM Sans', sans-serif; }
```

## Color palettes

### Warm editorial
```css
:root { --accent: #8B2500; --accent-light: rgba(139,37,0,0.08); --bg: #FAF5F0;
  --card: #FFFFFF; --text: #2D2D2D; --text-muted: #8A8078; --border: #E5DDD4; }
```

### Status-based (gap analysis)
```css
.box.have    { background: #E1F5EE; border-color: #5DCAA5; }
.box.missing { background: #FAECE7; border-color: #F0997B; }
.box.priority { background: #EEEDFE; border-color: #AFA9EC; }
.box.ghost   { border: 2px dashed #ccc; background: transparent; opacity: 0.7; }
```

## Boxes
```css
.box      { background: var(--card); border: 1px solid var(--border); border-radius: 6px;
            padding: 1.25rem; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
.box.hero { background: var(--accent); color: #fff; box-shadow: 0 4px 24px rgba(0,0,0,0.1); }
.box.gate { background: var(--accent); color: #fff; text-align: center; }
.box.future { border: 2px dashed var(--border); background: transparent; }
```

## Section headers
```css
.section-label { font-family: var(--mono); font-size: 0.7rem; letter-spacing: 0.15em;
                 text-transform: uppercase; font-weight: 600; }
```

## Arrows
```css
.arrow-line { width: 24px; height: 2px; background: var(--border); position: relative; }
.arrow-line::after { content: ''; position: absolute; right: -1px; top: -4px;
  border-top: 5px solid transparent; border-bottom: 5px solid transparent;
  border-left: 6px solid var(--border); }
```

## Compound loop strip
```css
.loop-strip { display: flex; align-items: center; justify-content: center;
  background: var(--card); border: 1px solid var(--border); border-radius: 8px;
  padding: 1rem 1.5rem; }
.loop-step { text-align: center; font-weight: 600; padding: 0 1rem; }
.loop-step.accent { color: var(--accent); }
```

## Callout
```css
.callout { background: var(--accent); color: #fff; padding: 1.5rem 2rem;
  border-radius: 6px; display: flex; gap: 1.5rem; align-items: baseline; }
```

## Responsive
```css
@media (max-width: 768px) { .pipeline { flex-direction: column; }
  .support-grid { grid-template-columns: 1fr; } h1 { font-size: 1.5rem; } }
```
