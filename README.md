<p align="center"><img src="docs/icon.png" width="128" alt="ReRun icon"></p>

# ReRun

Play classic Windows games on a Mac with Apple silicon —
Resident Evil HD Remaster, the original Resident Evil and GTA2.
One button sets everything up, a second one plays.

ReRun downloads a Wine build, the graphics and video components the game needs,
and — for Steam games — the Steam client into a folder it manages, then plays the
game with **Play**: no bottles, wrappers or terminal.

🌐 **Website:** [studiocamera.app/rerun](https://studiocamera.app/rerun/)
📖 **Step-by-step setup guides, from a fresh Mac to the first room:**
[Resident Evil HD Remaster](https://studiocamera.app/guides/resident-evil-hd-remaster-on-mac/) ·
[Resident Evil (1996)](https://studiocamera.app/guides/resident-evil-1996-on-mac/) ·
[GTA2](https://studiocamera.app/guides/gta2-on-mac/)

## Supported games

| Game | Store | Status | Setup |
|------|-------|--------|-------|
| Resident Evil HD Remaster (`bhd.exe`) | [Steam 304240](https://store.steampowered.com/app/304240/) | ✅ Playable, including movies | [Guide](https://studiocamera.app/guides/resident-evil-hd-remaster-on-mac/) |
| Resident Evil (1996, `Biohazard.exe`) | Japanese PC release (MediaKite) + [Classic REbirth](https://classicrebirth.com/index.php/downloads/resident-evil-classic-rebirth/) | ✅ Playable, SD or HD textures — ReRun 0.1.1+ | [Guide](https://studiocamera.app/guides/resident-evil-1996-on-mac/) |
| GTA2 (`gta2.exe`) | Version 9.6: Rockstar's 2004 freeware release or a patched retail copy | ✅ Playable — widescreen with the [gta2dx9](https://github.com/gebdag/gta2-rtx-remix) renderer (freeware release) or 4:3, dusk or noon, optional HD textures — ReRun 0.1.4+ | [Guide](https://studiocamera.app/guides/gta2-on-mac/) |

More games are planned — each one gets the same care: its movies, full screen
and frame rate working out of the box.

## Requirements

- A Mac with Apple silicon, running **macOS 26** or later
- **Rosetta 2** (Wine runs as an x86_64 process)
- Your own copy of the game: HD Remaster on Steam, the Japanese PC release
  of the 1996 game, or GTA2 9.6 (the freeware release for widescreen)
- About **20 GB** of free space for Wine, Steam and the HD Remaster
  (about 1 GB for Wine alone, for the classic game and GTA2)

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

Pick **HD Remaster** at the top of the window. Illustrated steps:
[the HD Remaster setup guide](https://studiocamera.app/guides/resident-evil-hd-remaster-on-mac/).

1. **Set Up** — downloads Wine, the graphics and video components and Steam
   (about 250 MB) and creates a Windows environment.
2. **Install in Steam** — Steam opens; sign in and install
   Resident Evil HD Remaster. ReRun notices when the download finishes.
3. **Play** — Steam starts with the game.

Turn on **Door skip** to cut the door animations between rooms. ReRun downloads
[ThirteenAG's door skip plugin](https://github.com/ThirteenAG/RE0.RE1.DoorSkipPlugin)
(pinned to its checksum) with the Ultimate ASI Loader as `dinput8.dll` into the
game folder; turning it off removes the plugin again.

Already have the game in **CrossOver, Whisky, Sikarugir, GameToMac or Pixel
Port**? ReRun finds that Steam and offers to copy it, sign-in and downloaded
game included, instead of downloading everything again.

## Resident Evil (1996)

The original PC port, played from a folder you put together. Classic REbirth
only supports the **Japanese release by MediaKite** — not the US or European
ones. Full walkthrough:
[the Resident Evil (1996) setup guide](https://studiocamera.app/guides/resident-evil-1996-on-mac/).

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

## GTA2

Version 9.6, played from its folder. Step by step:
[the GTA2 setup guide](https://studiocamera.app/guides/gta2-on-mac/).

Two builds carry that version: the **2004 freeware release** Rockstar gave away
(installer [archived on the Internet Archive](https://archive.org/details/gta2_rockstar-classics),
1.6 MB `gta2.exe`) and **1999 retail copies** patched to 9.6 (3.5 MB `gta2.exe`).
Both play; only the freeware one works with the widescreen renderer.

> **Correction:** ReRun 0.1.2 and its docs said they played the freeware
> release, but that version was tested with a retail copy. Both share the same
> `dmavideo.dll`, so the freeware release plays too; 0.1.3 was tested with both.

1. Put the GTA2 folder (the one with `gta2.exe` and a `player` folder with the
   save slots) anywhere on your Mac.
2. **Widescreen (optional, freeware release only)** — from the
   [gta2dx9 release](https://github.com/gebdag/gta2-rtx-remix/releases), copy
   `gta2dx9.dll`, `gta2dx9_vid.dll` and the `gta2dx9*.ini` files into the folder.
   **Keep the game's own `d3ddll.dll` and `dmavideo.dll`** — the zip has copies
   under those names, and ReRun needs the originals when Widescreen is off.
3. **In ReRun**, pick **GTA2**. Press **Set Up** if you haven't (Wine only, no
   Steam), then **Choose Game Folder**.
4. **Widescreen** on or off, then **Play**.
   - **On** — ReRun's build of gta2dx9 draws the game at 16:9 at your display's
     resolution, with the intro movie.
   - **Off** (or without gta2dx9) — GTA2's own renderer, 4:3 at 1280×960, no
     intro movies. Wine keeps that mode in the top left corner, so ReRun covers
     the rest of the screen, the menu bar and the Dock in black while the game
     is in front.
5. **Dusk** — on, the levels' dusk lit by street lamps and headlights; off, noon.
   Works with both renderers.
6. **HD textures** (widescreen only) — the city's tiles upscaled 4× with
   [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN). The pack is made on
   your Mac from your own copy of the game the first time you play with it on:
   a few minutes, about 400 MB in a `gta2hd` folder beside the game.

```
GTA2/
├── gta2.exe          ← freeware build for widescreen
├── d3ddll.dll        ← the game's own
├── dmavideo.dll      ← the game's own
├── gta2dx9.dll       ← optional, widescreen
├── gta2dx9_vid.dll   ← optional, widescreen
├── gta2dx9.ini       ← optional, widescreen
├── player/
└── data/
```

**What ReRun changes.** Nothing you put in the folder is modified; ReRun writes
copies beside it and keeps the video settings in the Wine prefix's registry.
Controls, sound and your name stay the game's own.

- GTA2 only runs in 16-bit color and switches to 640×480 for its menus, a mode
  Wine's Mac driver doesn't list, so ReRun plays it in a Wine virtual desktop
  whose own mode list has it.
- GTA2 lays out its HUD for a 4:3 screen as wide as the real one. On a 16:9
  display the mission messages (text and portrait) were drawn below the bottom
  edge — on Windows too. ReRun always gives the game a 4:3 screen size: with
  gta2dx9 that only lays out the HUD, and the world is still drawn at 16:9.
- **Widescreen** plays `gta2dx9-rerun.dll`, ReRun's build of gebdag's
  renderer, copied beside the folder's `gta2dx9.dll` (which stays as it came).
  The original only lights the city through RTX Remix, so it was always
  daylight; ReRun's build lights dusk with Direct3D's own lights, up to eight
  lamps and headlights at a time, and can draw the HD textures pack.
- It also writes `gta2-rerun.exe`, a copy of `gta2.exe` with one check
  patched. Losing focus, GTA2 closes its screen and minimizes itself, and Wine
  never restores it, so switching apps froze the game; the copy keeps running
  in the background. gta2dx9 presents into a child of the game's window
  (`own_window=1` in `gta2dx9.ini`), which ReRun's helper sizes to the screen:
  its default always-on-top window stayed above every Mac app.
- **GTA2's own renderer** uses `dmavideo-rerun.dll`, beside the game's
  `dmavideo.dll`: the game takes exclusive full screen before changing the
  display mode, and under Wine every mode switch then drew into a drawable of
  the old size — a black screen. The copy swaps those two calls. ReRun's helper
  restores the window the game minimizes on losing focus, and the game reopens
  its screen when it's active again. The intro movies are off: the Bink player
  faults on them under Wine.
- **No more freezes.** Before 0.1.4, GTA2 could stop drawing and responding
  after anything from a minute to two hours, in every mode, with the game
  waiting forever on Wine's Direct3D command thread. ReRun now turns that
  thread off for GTA2 only (`csmt=0` in the Wine prefix), so Direct3D runs on
  the game's own thread. Widescreen at dusk, which froze within minutes, has run
  30 minutes clean.

**Why no ray tracing.** gta2dx9 was written for RTX Remix, which path traces
through Vulkan ray tracing and NVIDIA's DLSS, NRD and RTXDI. MoltenVK has no
ray-tracing pipelines and none of NVIDIA's libraries run on a Mac, so ReRun uses
the renderer without Remix and lights dusk itself, with Direct3D's lights.

## Options

- **Graphics** (HD Remaster) — *OpenGL (WineD3D)* or *Vulkan (DXVK)* through MoltenVK to Metal.
  Try the other one if the game stutters or draws incorrectly.
- **Full screen** (HD Remaster) — plays borderless at your display's resolution. The game
  always runs at 60 FPS.
- **Settings → Data folder** — where Wine, Steam and the game live
  (default `~/Library/Application Support/ReRun`). Choose it before setting up.
- **Settings → Metal performance HUD** — frame rate and GPU overlay.
- **Door skip** (HD Remaster) — skips the door animations between rooms.
- **HD textures** (classic) — the `hires` pack through HD Loader, or the
  original look.
- **Widescreen** (GTA2, with gta2dx9 in the folder) — 16:9, or GTA2's own 4:3.
- **Dusk** (GTA2) — the levels' dusk with lamps and headlights, or noon.
- **HD textures** (GTA2 widescreen) — the city's tiles upscaled 4×, made from
  your game's files on first use.
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
- **"This GTA2 folder's Dmavideo.dll isn't GTA2 9.6's"** — the folder isn't
  version 9.6, or the gta2dx9 zip replaced `dmavideo.dll`. Put the game's own back.
- **"The gta2dx9 renderer needs the freeware release's gta2.exe"** — the folder
  has a retail `gta2.exe`. Use the freeware release, or turn Widescreen off.
- **GTA2 froze** — update to ReRun 0.1.4 or later, then play again; it turns
  off the Direct3D command thread that hung. If it still freezes, leave it
  frozen and attach *⋯ → Show Logs* to an issue.
- **GTA2 says "Unable to open file: player\plyslot0.dat"** — the folder has no
  `player` folder. Copy it from an installed GTA2.
- **Anything else** — *⋯ → Show Logs* opens the Wine and Steam logs. Please
  attach them to an [issue](https://github.com/rafabertholdo/rerun/issues).

## How it works

| Component | Source |
|-----------|--------|
| Wine 11 (x86_64, wow64, with winegstreamer) | [Sikarugir engines](https://github.com/Sikarugir-App/Engines) |
| GStreamer + gst-libav, MoltenVK, DXVK-macOS (d9vk), gnutls | [Sikarugir wrapper template](https://github.com/Sikarugir-App/Wrapper) |
| Steam client | Valve's `SteamSetup.exe` |
| HD Loader (classic, HD textures) | [bio1hd-rework](https://github.com/Madxbio97/bio1hd-rework) |
| Door skip plugin + Ultimate ASI Loader (HD Remaster) | [RE0.RE1.DoorSkipPlugin](https://github.com/ThirteenAG/RE0.RE1.DoorSkipPlugin) |
| gta2dx9 renderer (GTA2 widescreen): ReRun's build ships in the app, you add the rest | [gta2-rtx-remix](https://github.com/gebdag/gta2-rtx-remix) (MIT) |
| Real-ESRGAN x4plus, ncnn/Vulkan (GTA2 HD textures) | [Real-ESRGAN v0.2.5.0](https://github.com/xinntao/Real-ESRGAN) (BSD-3-Clause) |

Every download is pinned to a SHA-256 checksum and resumes after an interruption.

## Credits

ReRun stands on [Wine](https://www.winehq.org), [Sikarugir](https://github.com/Sikarugir-App),
[DXVK-macOS](https://github.com/Gcenx/DXVK-macOS), [MoltenVK](https://github.com/KhronosGroup/MoltenVK)
and [GStreamer](https://gstreamer.freedesktop.org). The classic game runs on
[Classic REbirth](https://classicrebirth.com) by Gemini, with HD textures from the
Resident Evil HD mod and [HD Loader](https://github.com/Madxbio97/bio1hd-rework).
Door skip is [ThirteenAG](https://github.com/ThirteenAG)'s plugin. GTA2's
widescreen renderer is [gebdag](https://github.com/gebdag)'s gta2dx9, and its HD
textures are upscaled with [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)
by Xintao Wang et al.

ReRun is not affiliated with Capcom, Rockstar or Valve. Resident Evil is a trademark of
Capcom; GTA2 is a trademark of Take-Two Interactive; Steam is a trademark of Valve. You need to own the games you play. ReRun doesn't include or download the
games, Classic REbirth or the Resident Evil HD texture pack. It includes its own
build of gta2dx9 (MIT license); GTA2's HD textures are made from your copy of the
game on your Mac, never downloaded.

---

Made by [Rafael Bertholdo](https://studiocamera.app/about/).
