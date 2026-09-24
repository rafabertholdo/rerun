<p align="center"><img src="docs/icon.png" width="128" alt="ReRun icon"></p>

# ReRun

Play classic Windows games from your Steam library on a Mac with Apple silicon.
One button sets everything up, a second one plays.

ReRun downloads a Wine build, the graphics and video components the game needs,
and the Steam client into a folder it manages. You sign in to Steam, install the
game there as usual, and press **Play** — no bottles, wrappers or terminal.

## Supported games

| Game | Store | Status |
|------|-------|--------|
| Resident Evil HD Remaster (`bhd.exe`) | [Steam 304240](https://store.steampowered.com/app/304240/) | ✅ Playable, including movies |

ReRun only runs Resident Evil HD Remaster today. More games are planned — each
one gets the same care: its movies, full screen and frame rate working out of
the box.

## Requirements

- A Mac with Apple silicon, running **macOS 26** or later
- **Rosetta 2** (Wine runs as an x86_64 process)
- Your own copy of the game on Steam
- About **20 GB** of free space for Wine, Steam and the game

## Install

1. Download the latest `ReRun-<version>-macOS.zip` from
   [Releases](https://github.com/rafabertholdo/rerun/releases/latest).
2. Unzip it and move **ReRun.app** to `/Applications`.

ReRun is signed with a Developer ID and notarized by Apple, so it opens without
a Gatekeeper warning.

## Using it

1. **Set Up** — downloads Wine, the graphics and video components and Steam
   (about 250 MB) and creates a Windows environment.
2. **Install in Steam** — Steam opens; sign in and install
   Resident Evil HD Remaster. ReRun notices when the download finishes.
3. **Play** — Steam starts with the game.

Already have the game in **CrossOver, Whisky, Sikarugir, GameToMac or Pixel
Port**? ReRun finds that Steam and offers to copy it, sign-in and downloaded
game included, instead of downloading everything again.

### Options

- **Graphics** — *OpenGL (WineD3D)* or *Vulkan (DXVK)* through MoltenVK to Metal.
  Try the other one if the game stutters or draws incorrectly.
- **Full screen** — plays borderless at your display's resolution. The game
  always runs at 60 FPS.
- **Settings → Data folder** — where Wine, Steam and the game live
  (default `~/Library/Application Support/ReRun`). Choose it before setting up.
- **Settings → Metal performance HUD** — frame rate and GPU overlay.
- **⋯ menu** — open Steam, show logs, or stop Steam and the game.

## Troubleshooting

- **Black screen after the Capcom logo** — the game's movies need GStreamer.
  ReRun installs it; if you pointed ReRun at a data folder from another tool,
  run Set Up again.
- **Anything else** — *⋯ → Show Logs* opens the Wine and Steam logs. Please
  attach them to an [issue](https://github.com/rafabertholdo/rerun/issues).

## How it works

| Component | Source |
|-----------|--------|
| Wine 11 (x86_64, wow64, with winegstreamer) | [Sikarugir engines](https://github.com/Sikarugir-App/Engines) |
| GStreamer + gst-libav, MoltenVK, DXVK-macOS (d9vk), gnutls | [Sikarugir wrapper template](https://github.com/Sikarugir-App/Wrapper) |
| Steam client | Valve's `SteamSetup.exe` |

Every download is pinned to a SHA-256 checksum and resumes after an interruption.

## Credits

ReRun stands on [Wine](https://www.winehq.org), [Sikarugir](https://github.com/Sikarugir-App),
[DXVK-macOS](https://github.com/Gcenx/DXVK-macOS), [MoltenVK](https://github.com/KhronosGroup/MoltenVK)
and [GStreamer](https://gstreamer.freedesktop.org).

ReRun is not affiliated with Capcom or Valve. Resident Evil is a trademark of
Capcom; Steam is a trademark of Valve. You need to own the games you play.

---

Made by [Rafael Bertholdo](https://studiocamera.app/about/).
