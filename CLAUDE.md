# TapPanZeit (JUCE)

JUCE port (C++17, CMake, JUCE fetched via FetchContent, tag in `TPZ_JUCE_TAG`) of the Max for Live device in [zsteinkamp/m4l-TapPanZeit](https://github.com/zsteinkamp/m4l-TapPanZeit), which is the reference implementation. Produces VST3/AU/Standalone.

Releases live here (not in the m4l repo) because the `plugins` website syncs the m4l repo's GitHub releases.

## DSP facts (keep in sync with the M4L device)

- Taps are chained: tap N delays tap N-1's output, so tap N's delay = sum of per-tap delays 1..N. Implemented as one shared ring buffer read at cumulative offsets.
- Per-tap x = (i-1)/(N-1). Delay = timeBase × timeFn(x) × 1.25 (time function 0..1 displays as 0..125%; 100% is at y=0.8). Delays are whole samples (Max `delay~`).
- Pan is linear, pan=1 is **Left**: L gain = vol·pan, R gain = vol·(1−pan).
- Feedback = tap 1's raw (pre pan/vol) output × feedback, summed into the input.
- Dry/Wet/Feedback are 0–100% → linear 0..1 gain.
- Sync note values are fractions of a whole note (`noteWholeFractions()` in `PluginProcessor.cpp`, same order as the M4L `TimeNote` enum).
- Max `[function]` state is `domain, rangeMin, rangeMax, then (x, y, flag, curve)` per point; a point's curve shapes the segment ending at it; negative = fast start.

## Build / test

- `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release` then `cmake --build build --config Release --parallel`
- `TapPanZeitTests` is an offline impulse-response test of the processor; run it after DSP changes. CI runs it on macOS and Windows.
- CI: `.github/workflows/build.yml` builds on push; `v*` tags publish a GitHub Release with zipped VST3/AU.
- Validate the AU locally with `auval -v aufx Tpzt Zstk` after copying to `~/Library/Audio/Plug-Ins/Components/`.
