# Architecture

## Purpose

The goal of the project is to create a photorealistic, interactive taxi hero without requiring a real-time 3D model or WebGL scene.

The solution uses a pre-rendered rotation video as its visual source, converts it into optimized WebP images, and renders those images through HTML5 Canvas according to pointer movement.

## Data flow

```text
Source video
   ↓
FFmpeg sampling
   ↓
80 WebP frames
   ↓
Preload in browser
   ↓
Pointer X → normalized progress
   ↓
Target frame
   ↓
Easing loop
   ↓
Canvas render
```

## Browser rendering model

The browser does not play a video. Instead, it loads the frame sequence and draws one image at a time onto the Canvas.

Pointer mapping:

```js
progress = clientX / window.innerWidth;
targetFrame = progress * (FRAME_COUNT - 1);
```

Easing:

```js
currentFrame += (targetFrame - currentFrame) * EASE;
```

The animation loop only continues until the current frame has settled near the target frame, reducing unnecessary continuous rendering.

## Elementor layering

```text
Hero (.taxi-hero)
├── Visual layer (.taxi-sequence-widget) — z-index: 1
│   └── iframe
│       └── Canvas frame engine
└── Content layer (.taxi-content) — z-index: 5
    ├── Heading
    ├── Description
    ├── Phone
    └── CTA buttons
```

This separation allows WordPress content editors to modify the content without editing the frame-sequence engine.

## Parent / iframe protocol

Elementor can intercept pointer events above the iframe. To maintain interaction across the entire hero, the parent page forwards the normalized horizontal pointer value.

### Pointer message

```js
{
  type: 'taxi-sequence-pointer',
  x: -1 // range: -1 to +1
}
```

### Toggle message

```js
{
  type: 'taxi-sequence-toggle',
  enabled: true
}
```

The iframe maps the received `x` value back to a 0–1 range before selecting a target frame.

## Key design decisions

### Frame sequence instead of real-time 3D

Benefits:

- photorealistic output identical to the generated video
- no GLB modeling pipeline
- no Three.js/WebGL scene setup
- simpler Elementor integration
- predictable visual output across browsers

Tradeoff:

- multiple image files must be downloaded before full interaction is available

### WebP format

WebP was selected to reduce file size while preserving sufficient hero-image quality.

### Device pixel ratio cap

Canvas rendering uses a maximum device-pixel ratio of `1.5` to prevent unnecessarily expensive buffers on very high-density screens.
