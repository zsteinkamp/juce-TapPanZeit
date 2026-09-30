# TapPanZeit (VST3 / AU)

A native plugin port of the [TapPanZeit Max for Live device](https://github.com/zsteinkamp/m4l-TapPanZeit): a multitap (up to 128) delay with drawable control over inter-tap timing, pan position, and volume. It can serve as a simple delay, a strange reverb, or an incredibly complicated combination of the two.

Built with [JUCE](https://juce.com). Formats: VST3 (macOS + Windows), AU (macOS), and a Standalone app.

## Download & Install

Grab the latest installer from the [Releases page](../../releases).

- **Windows:** run `TapPanZeit-<version>-Windows-Setup.exe`. It installs the VST3 into `C:\Program Files\Common Files\VST3\`. Because the installer isn't code-signed, Windows SmartScreen may say "Windows protected your PC" — click **More info → Run anyway**. Uninstall from Settings → Apps.
- **macOS:** open `TapPanZeit-<version>-macOS.pkg`. It installs the VST3 into `/Library/Audio/Plug-Ins/VST3/` and the Audio Unit into `/Library/Audio/Plug-Ins/Components/` (click **Customize** to install just one). Because the installer isn't notarized yet, macOS will first refuse to open it — go to **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** next to the TapPanZeit message.

Then rescan plug-ins in your DAW; TapPanZeit is listed under **Zack Steinkamp**.

<details>
<summary>Manual install (zip files)</summary>

- **Windows:** copy `TapPanZeit.vst3` into `C:\Program Files\Common Files\VST3\`.
- **macOS:** copy `TapPanZeit.vst3` into `~/Library/Audio/Plug-Ins/VST3/` and/or `TapPanZeit.component` into `~/Library/Audio/Plug-Ins/Components/`, then clear the download quarantine flag:

  ```sh
  xattr -dr com.apple.quarantine ~/Library/Audio/Plug-Ins/VST3/TapPanZeit.vst3 ~/Library/Audio/Plug-Ins/Components/TapPanZeit.component
  ```

</details>

## Usage

- **Taps** — how many taps are in the tap field.
- **Time Base** — the delay between each tap, in ms (Free) or as a note value (Sync).
- **Time / Pan / Volume** — per-tap curves. Click to add a point, drag to move, shift-click to remove, alt-drag a segment to curve it. The icons above each curve load preset shapes. Teal bars show each tap's live level.
- **Dry Vol / Wet Vol** — mix of input and tap output.
- **Feedback** — how much of the first tap's output is fed back into the input.
- **Preset** — 16 slots saved with your project. Click to recall, shift-click to store, alt-click to clear.

Differences from the M4L device: total delay across all taps is capped at 120 s, delay-time changes glide instead of jumping, and the segment curve shape closely approximates (but is not identical to) Max's `[function]` curve mode.

## Building

Requires CMake 3.22+ and a C++17 compiler (Xcode on macOS, Visual Studio 2022 on Windows). JUCE is downloaded automatically at configure time.

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release --parallel
./build/TapPanZeitTests_artefacts/Release/TapPanZeitTests   # offline DSP checks
```

Outputs land in `build/TapPanZeit_artefacts/Release/{VST3,AU,Standalone}/`. For a universal macOS build add `-DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"`.

## Releases

GitHub Actions builds macOS (universal) and Windows on every push. Pushing a tag like `v1` also publishes a GitHub Release with the installers (`installer/macos/build-pkg.sh`, `installer/windows/TapPanZeit.iss`) and zipped plugins attached:

```sh
git tag v1 && git push origin v1
```

## License

GPLv3 — see [LICENSE](LICENSE). JUCE is used under the AGPLv3.
