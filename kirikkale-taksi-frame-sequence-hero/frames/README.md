# Frame Assets

This directory is reserved for the generated WebP frame sequence used by the Canvas renderer.

Expected production filenames:

```text
taxi-001.webp
taxi-002.webp
...
taxi-080.webp
```

The image sequence is generated from the source video with:

```bash
bash ../scripts/extract-frames.sh source.mp4 .
```

The original generated video and production image assets are intentionally not embedded in this documentation-only repository snapshot. Add the generated frames locally or in the deployment package when running the project.

If the number or naming pattern of frames changes, update `FRAME_COUNT`, `FRAME_PATH`, `FRAME_EXT`, and `PAD` in `src/taxi-sequence-hero.html` accordingly.
