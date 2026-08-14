# Performance & Roadmap

## Current implementation

The documented v1.1 prototype uses:

- 80 WebP frames
- 1280 px source width for generated frames
- full upfront preload
- `requestAnimationFrame` only while moving toward the target frame
- Canvas DPR capped at `1.5`
- one shared frame set for desktop and mobile

## Current strengths

### Predictable rendering

The visual result closely matches the original generated source video because each angle is a pre-rendered frame.

### Lightweight runtime logic

The browser performs image preloading, frame selection, interpolation, and Canvas drawing. No scene graph, lighting, shaders, geometry, or model parsing is required.

### Controlled render loop

The animation loop stops when the current frame settles near the target. This avoids a permanently running render loop.

## Main performance cost

The largest cost is initial network transfer because all 80 images are loaded before the interaction is considered fully ready.

## Optimization opportunities

### 1. Progressive preloading

Load the center frame and nearby frames first, then continue outward in the background.

Potential order:

```text
40 → 39 → 41 → 38 → 42 → ...
```

This would make the initial hero useful sooner.

### 2. Mobile frame set

Generate a lower-resolution mobile sequence, for example:

```text
720 px or 960 px wide
```

The desktop implementation can continue using the larger set.

### 3. AVIF evaluation

AVIF may reduce transfer size further, but browser decode cost and real-world quality should be measured before replacing WebP.

### 4. Responsive frame positioning

The next visual phase should place the taxi more deliberately toward the right side of the hero while preserving a clean content area on the left.

### 5. Pointer leave behavior

When the cursor leaves the hero, the vehicle can softly return to the preferred center angle instead of remaining at the last selected frame.

### 6. Touch / swipe support

Mobile devices can map horizontal swipe gestures to frame progression.

### 7. Interaction sensitivity

Introduce a configurable sensitivity factor so the full frame range does not necessarily map to the entire viewport width.

## Roadmap

### Phase 1 — Completed

- source rotation video
- 80 WebP frame generation
- Canvas renderer
- mouse control
- eased motion
- 3D View toggle
- Hostinger deployment
- Elementor integration

### Phase 2 — Visual composition

- stronger right-side taxi positioning
- cleaner left-side copy area
- breakpoint-specific composition tuning

### Phase 3 — Performance

- optimized image dimensions
- separate mobile frame set
- progressive preload strategy

### Phase 4 — UX

- soft recentering
- touch swipe
- configurable movement sensitivity

### Phase 5 — Optional real-time 3D

If required in the future, the visual engine could be replaced by a GLB / Three.js implementation while keeping the existing Elementor foreground-content architecture.
