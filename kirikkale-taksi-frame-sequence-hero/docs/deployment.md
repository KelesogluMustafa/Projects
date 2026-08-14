# Deployment Guide

## Requirements

- FFmpeg / FFprobe
- A web server capable of serving static files
- WordPress + Elementor for the production integration described here
- Source rotation video

## 1. Inspect the source video

From the project directory:

```bash
bash scripts/inspect-video.sh source.mp4
```

The documented production source was:

- 1280 × 720
- 24 fps
- 10 seconds
- 240 source frames

## 2. Generate the web frame sequence

```bash
bash scripts/extract-frames.sh source.mp4 frames
```

Expected output:

```text
frames/
├── taxi-001.webp
├── taxi-002.webp
├── ...
└── taxi-080.webp
```

The Canvas engine expects exactly this filename pattern by default.

## 3. Prepare the static package

Deploy the hero engine together with the generated `frames` directory:

```text
taxi-sequence/
├── taxi-sequence-hero.html
└── frames/
    ├── taxi-001.webp
    ├── taxi-002.webp
    ├── ...
    └── taxi-080.webp
```

For this repository, copy:

```text
src/taxi-sequence-hero.html
```

to the production `taxi-sequence/` folder and place the generated images beside it under `frames/`.

## 4. Hostinger layout

The documented production deployment uses:

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

The page can then be served from:

```text
/taxi-sequence/taxi-sequence-hero.html
```

## 5. Test the static hero first

Before Elementor integration, open the static hero directly in a browser and confirm:

- all 80 frames load
- the loading indicator disappears
- horizontal pointer movement changes the viewing angle
- the transition is smooth
- disabling `3D Görünüm` returns the taxi to the configured freeze frame

## 6. Elementor setup

Create a hero container with:

```text
CSS class: taxi-hero
Minimum height: 100vh
Overflow: hidden
```

Add an HTML widget and assign:

```text
CSS class: taxi-sequence-widget
```

Paste the contents of:

```text
integration/elementor-widget.html
```

into that HTML widget.

Create the normal Elementor content container and assign:

```text
CSS class: taxi-content
```

The documented desktop width is `45%` and the content layer uses a higher z-index than the iframe.

## 7. Production validation

Verify:

- hero iframe fills the entire hero
- text and CTA content render above the visual layer
- CTA elements remain clickable
- pointer interaction continues while hovering over Elementor content
- mobile layout has no horizontal overflow
- no frame requests return 404
- refresh does not leave the Canvas blank

## Optional ZIP package

A Hostinger-ready archive can be created with:

```bash
zip -qr taxi-sequence-package.zip taxi-sequence-hero.html frames
```
