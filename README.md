<p align="center"><img src="docs/icon.png" width="128" alt="ReRun icon"></p>

# ReRun

Play classic Windows games on a Mac with Apple silicon.
One button sets everything up, a second one plays.

ReRun downloads a Wine build, the graphics and video components the game needs,
and — for Steam games — the Steam client into a folder it manages, then plays the
game with **Play**: no bottles, wrappers or terminal.

**Step-by-step setup guide, from a fresh Mac to the first room:**
[studiocamera.app/guides/resident-evil-on-mac](https://studiocamera.app/guides/resident-evil-on-mac/)

## Supported games

| Game | Store | Status |
|------|-------|--------|
| Resident Evil HD Remaster (`bhd.exe`) | [Steam 304240](https://store.steampowered.com/app/304240/) | ✅ Playable, including movies |
| Resident Evil (1996, `Biohazard.exe`) | Japanese PC release (MediaKite) + [Classic REbirth](https://classicrebirth.com/index.php/downloads/resident-evil-classic-rebirth/) | ✅ Playable, SD or HD textures — ReRun 0.1.1+ |

More games are planned — each one gets the same care: its movies, full screen
and frame rate working out of the box.

## Requirements

- A Mac with Apple silicon, running **macOS 26** or later
- **Rosetta 2** (Wine runs as an x86_64 process)
- Your own copy of the game: HD Remaster on Steam, or the Japanese PC release
  of the 1996 game
- About **20 GB** of free space for Wine, Steam and the HD Remaster
  (about 1 GB for Wine alone, for the classic game)

Rosetta is a one-time install if you have never opened an Intel app:

```sh
softwareupdate --install-rosetta --agree-to-license
```

## Install

1. Download the latest `ReRun-<version>-macOS.zip` from
   [Releases](https://github.com/rafabertholdo/rerun/releases/latest).
2. Unzip it and move **ReRun.app** to `/Applications`.

ReRun is signed with a Developer ID and notarized by Apple, so it opens without
a Gatekeeper warning.

## Resident Evil HD Remaster

Pick **HD Remaster** at the top of the window.

1. **Set Up** — downloads Wine, the graphics and video components and Steam
   (about 250 MB) and creates a Windows environment.
2. **Install in Steam** — Steam opens; sign in and install
   Resident Evil HD Remaster. ReRun notices when the download finishes.
3. **Play** — Steam starts with the game.

Already have the game in **CrossOver, Whisky, Sikarugir, GameToMac or Pixel
Port**? ReRun finds that Steam and offers to copy it, sign-in and downloaded
game included, instead of downloading everything again.

## Resident Evil (1996)

The original PC port, played from a folder you put together. Classic REbirth
only supports the **Japanese release by MediaKite** — not the US or European
ones.

1. **Build the game folder.** Create a folder and copy `Biohazard.exe` and the
   `JPN` folder (inside `horr` on the CD) into it. Without the MediaKite CD, use
   the `Biohazard.exe` from Capcom's
   [1.01 patch](https://classicrebirth.com/index.php/download/biohazard-pc-cd-rom-patch-version-1-01/).
2. **Add Classic REbirth.** Extract the
   [Classic REbirth DLL](https://classicrebirth.com/index.php/download/resident-evil-dll-fix-for-classic-edition/)
   (1.1.3) next to `Biohazard.exe`.
3. **HD textures (optional).** Copy the contents of the
   [Resident Evil HD mod](https://www.moddb.com/mods/resident-evil-hd-mod/downloads/resident-evil-hd-mod)
   into the folder — it's the `hires` folder that matters. Optionally add the
   [high-quality video pack](https://www.moddb.com/downloads/re1-classic-rebirth-high-quality-video-pack).
4. **In ReRun**, pick **Classic (1996)**. Press **Set Up** if you haven't (for the
   classic game it installs Wine only, no Steam), then **Choose Game Folder**.
5. **HD textures** on or off, then **Play**. The first time, Classic REbirth's
   Configuration window opens: set *Resolution* to *Fullscreen* and press OK.
   Untick *Always boot in configure mode* to skip it next time.

```
Biohazard PC/
├── Biohazard.exe
├── ddraw.dll        ← Classic REbirth
├── JPN/
└── hires/           ← HD mod (optional)
```

**What ReRun changes in the folder.** Nothing you put there is modified.

- It writes `Biohazard-rerun.exe` beside the original and plays that copy. The
  game always picks the third Direct3D device, which is the hardware one on
  Windows, but Wine lists only two, so the original stops with *"Failed to
  initialize the DirectX"*. The copy picks Wine's hardware device — one byte.
- With **HD textures** on, it downloads
  [HD Loader](https://github.com/Madxbio97/bio1hd-rework)'s `dsound.dll` (pinned
  to a commit and checksum) into the folder. The HD mod's own `bio1hd.asi`
  writes past its texture buffer and crashes under Wine, so ReRun never loads
  `.asi` mods; HD Loader reads the same `hires` pack.

## Options

- **Graphics** (HD Remaster) — *OpenGL (WineD3D)* or *Vulkan (DXVK)* through MoltenVK to Metal.
  Try the other one if the game stutters or draws incorrectly.
- **Full screen** (HD Remaster) — plays borderless at your display's resolution. The game
  always runs at 60 FPS.
- **Settings → Data folder** — where Wine, Steam and the game live
  (default `~/Library/Application Support/ReRun`). Choose it before setting up.
- **Settings → Metal performance HUD** — frame rate and GPU overlay.
- **HD textures** (classic) — the `hires` pack through HD Loader, or the
  original look.
- **⋯ menu** — open Steam or choose the game folder, show logs, or stop the game.

## Troubleshooting

- **Black screen after the Capcom logo** — the game's movies need GStreamer.
  ReRun installs it; if you pointed ReRun at a data folder from another tool,
  run Set Up again.
- **"This Biohazard.exe isn't a version ReRun knows"** — it isn't the Japanese
  1.01 executable (SHA-256 `25be34d4f4586e9ec84e39412915ae1de38af1fc5924c02824d38e15c8406458`).
  Use the one from Capcom's 1.01 patch.
- **HD is on but the classic game looks original** — the `hires` folder isn't
  next to `Biohazard.exe`. If only some rooms stay low-resolution, those
  textures aren't in the pack for your Classic REbirth build.
- **ReRun keeps asking for access to a removable volume** — your data or game
  folder is on an external drive; allow it in System Settings → Privacy &
  Security → Files & Folders → ReRun.
- **Anything else** — *⋯ → Show Logs* opens the Wine and Steam logs. Please
  attach them to an [issue](https://github.com/rafabertholdo/rerun/issues).

## How it works

| Component | Source |
|-----------|--------|
| Wine 11 (x86_64, wow64, with winegstreamer) | [Sikarugir engines](https://github.com/Sikarugir-App/Engines) |
| GStreamer + gst-libav, MoltenVK, DXVK-macOS (d9vk), gnutls | [Sikarugir wrapper template](https://github.com/Sikarugir-App/Wrapper) |
| Steam client | Valve's `SteamSetup.exe` |
| HD Loader (classic, HD textures) | [bio1hd-rework](https://github.com/Madxbio97/bio1hd-rework) |

Every download is pinned to a SHA-256 checksum and resumes after an interruption.

## Credits

ReRun stands on [Wine](https://www.winehq.org), [Sikarugir](https://github.com/Sikarugir-App),
[DXVK-macOS](https://github.com/Gcenx/DXVK-macOS), [MoltenVK](https://github.com/KhronosGroup/MoltenVK)
and [GStreamer](https://gstreamer.freedesktop.org). The classic game runs on
[Classic REbirth](https://classicrebirth.com) by Gemini, with HD textures from the
Resident Evil HD mod and [HD Loader](https://github.com/Madxbio97/bio1hd-rework).

ReRun is not affiliated with Capcom or Valve. Resident Evil is a trademark of
Capcom; Steam is a trademark of Valve. You need to own the games you play. ReRun doesn't include or download the
games, Classic REbirth or the HD texture pack.

---

Made by [Rafael Bertholdo](https://studiocamera.app/about/).
