# Apollo + upstream Sunshine merge, build notes (2026-09-02)

Branch `merge-upstream-2026-09-02`: Apollo master `adc5c5a0` (2026-05-21) merged
with upstream LizardByte/Sunshine master `f61bf775` (2026-09-01). Fork point
`1a96d135` (2025-09-26). Merge commit `0a119697`, then review and build fixes
on top. Every Apollo feature was audited as present after the merge (permissions
and named devices, SudoVDA virtual display, server/client commands, input-only
mode, clipboard, OTP pairing, login page, branding).

## Submodules

* `third-party/moonlight-common-c` points at a LOCAL merge commit `79a871a0`
  (Apollo's fork + upstream `874ac95`). It is not on any remote. A fresh clone
  from GitHub cannot fetch it until it is pushed to a fork of
  ClassicOldSong/moonlight-common-c. On this box it is checked out in place.
* `third-party/Simple-Web-Server` stays on Apollo's fork (`request->userp`).
* All other submodules follow upstream.

## Building on Windows

MSYS2 lives in `C:\Users\Epyc1\msys64` (per-user install). From PowerShell:

```
C:\Users\Epyc1\msys64\msys2_shell.cmd -defterm -no-start -ucrt64 -full-path -here -c "bash build-msys2.sh deps"
C:\Users\Epyc1\msys64\msys2_shell.cmd -defterm -no-start -ucrt64 -full-path -here -c "bash build-msys2.sh configure"
C:\Users\Epyc1\msys64\msys2_shell.cmd -defterm -no-start -ucrt64 -full-path -here -c "bash build-msys2.sh build"
```

`deps` also needs, beyond docs/building.md: libtiff, libjpeg-turbo, libpng,
freetype, harfbuzz, libwebp, md4c, double-conversion (the static Qt plugins
link them) and python + python-jinja (glad's generator). Node.js comes from
the Windows PATH via `-full-path`. Boost 1.89 is fetched by CMake because
MSYS2 ships 1.91; FFmpeg comes prebuilt from LizardByte/build-deps.

Outputs: `build/sunshine.exe` (RelWithDebInfo, ~360 MB with debug info;
`strip` brings it to a normal size), `build/tools/sunshinesvc.exe`,
`build/assets/` (web UI, shaders, apps.json).

## Running a test instance beside the installed Apollo

`test-run/sunshine.conf` moves the port family to 48989 and keeps state in
`test-run/`. Start from `build/` so `assets/` resolves:

```
cd build && SUNSHINE_ASSETS_DIR=assets ./sunshine.exe ../test-run/sunshine.conf
```

Verified: web UI at https://localhost:48990 (redirects to /welcome), serverinfo
on 48989 reports the Apollo host, system tray created, log written.

## Installing over Apollo 0.4.6

Not done automatically. It means stopping `ApolloService`, backing up
`C:\Program Files\Apollo`, replacing `sunshine.exe`, `tools\sunshinesvc.exe` and
`assets\`, and starting the service again. The NSIS installer additionally
needs `nefconc.exe` in `src_assets/windows/drivers/sudovda/`, which the repo
does not ship.
