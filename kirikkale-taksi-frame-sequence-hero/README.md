# Kırıkkale Taksi — Interactive Frame Sequence Hero

An interactive hero experience for **kirikkaletaksicin.com.tr** that turns a pre-rendered taxi rotation video into a mouse-controlled, 3D-like frame sequence.

> This is **not** a real-time 3D GLB/mesh implementation. It is an **interactive turntable / frame-sequence scrub** built from optimized WebP frames rendered on an HTML5 Canvas.

## Overview

The project converts a 10-second, 1280×720, 24 fps source video into 80 optimized WebP frames. Those frames are preloaded in the browser and mapped to the horizontal mouse position. A lightweight easing loop interpolates between the current and target frame to keep the motion smooth.

The visual layer runs independently from WordPress/Elementor, so headings, text, phone information, and CTA buttons remain editable in Elementor.

## Highlights

- 10-second source video → 80 WebP frames
- HTML5 Canvas rendering
- Mouse X position → frame index mapping
- Eased transitions with `requestAnimationFrame`
- 3D View ON/OFF toggle
- Elementor iframe integration
- Parent ↔ iframe communication with `postMessage`
- Hostinger-compatible static deployment
- Responsive structure for desktop and mobile

## Architecture

```text
Gemini / Veo source video
        ↓
      FFmpeg
        ↓
  80 WebP frames
        ↓
HTML5 Canvas + JavaScript
        ↓
Mouse / postMessage control
        ↓
WordPress + Elementor hero
```

## Project structure

```text
kirikkale-taksi-frame-sequence-hero/
├── README.md
├── src/
│   └── taxi-sequence-hero.html
├── integration/
│   └── elementor-widget.html
├── scripts/
│   ├── extract-frames.sh
│   └── inspect-video.sh
├── docs/
│   ├── architecture.md
│   ├── deployment.md
│   └── performance-and-roadmap.md
└── frames/
    └── README.md
```

## Core configuration

| Parameter | Value | Purpose |
|---|---:|---|
| `FRAME_COUNT` | `80` | Total WebP frame count |
| `FREEZE_FRAME` | `40` | Static frame when 3D View is disabled |
| `EASE` | `0.12` | Transition smoothing factor |
| DPR cap | `1.5` | Performance control on high-density displays |
| Source video | `1280×720, 24 fps, 10 sec` | Original generated asset |
| Web sampling | `8 fps` | Produces 80 frames |

## Frame generation

```bash
ffmpeg -y -i source.mp4 \
  -vf "fps=8,scale=1280:-1" \
  -c:v libwebp \
  -lossless 0 \
  -compression_level 4 \
  -qscale 70 \
  -an \
  frames/taxi-%03d.webp
```

This creates:

```text
frames/taxi-001.webp
frames/taxi-002.webp
...
frames/taxi-080.webp
```

## How the interaction works

The horizontal pointer position is normalized to a 0–1 range:

```js
const progress = clientX / window.innerWidth;
```

Then mapped to the available frame range:

```js
targetFrame = progress * (FRAME_COUNT - 1);
```

Instead of jumping directly between frames, the current frame approaches the target frame gradually:

```js
currentFrame += (targetFrame - currentFrame) * EASE;
```

This produces the smooth, turntable-like effect.

## Elementor integration

The Canvas engine is deployed as a static HTML page and embedded in Elementor using an iframe. Elementor content stays in a separate foreground layer.

Recommended layering:

```text
taxi-hero
├── taxi-sequence-widget
│   └── iframe → taxi-sequence-hero.html
└── taxi-content
    ├── H1
    ├── description
    ├── phone
    └── CTA buttons
```

The parent page forwards pointer movement to the iframe via `postMessage`, so the taxi remains interactive even when the cursor is above Elementor text or CTA content.

## Hostinger deployment

```text
public_html/
└── taxi-sequence/
    ├── taxi-sequence-hero.html
    └── frames/
        ├── taxi-001.webp
        ├── taxi-002.webp
        ├── ...
        └── taxi-080.webp
```

Example production path:

```text
/taxi-sequence/taxi-sequence-hero.html
```

## Testing checklist

- Static hero URL loads successfully
- All 80 WebP frames load
- Mouse movement rotates the taxi smoothly
- 3D View toggle returns the taxi to the freeze frame
- Elementor content remains above the iframe
- CTA buttons remain clickable
- No horizontal overflow on mobile
- Refresh does not produce missing or broken frames

## Performance notes

The current version preloads all 80 frames at startup. This is simple and reliable, but it increases initial network cost. Possible improvements include:

- progressive / prioritized preloading
- separate lower-resolution mobile frame set
- AVIF evaluation
- 960 px or 720 px variants
- touch swipe support
- soft recentering when the pointer leaves the hero

See [`docs/performance-and-roadmap.md`](./docs/performance-and-roadmap.md).

## Status

**v1.1 — documented working prototype**

Completed:

- source video production
- 80-frame WebP extraction
- Canvas renderer
- mouse-controlled frame selection
- easing
- 3D View toggle
- Elementor integration
- Hostinger deployment structure

## Author

**Mustafa Kelesoglu**

GitHub: [@KelesogluMustafa](https://github.com/KelesogluMustafa)
