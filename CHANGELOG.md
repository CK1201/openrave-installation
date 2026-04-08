## [unreleased] - 2026-04-08
### Features
- Added Ubuntu 24.04 support to the installation scripts.
- Switched Ubuntu 24.04 to Python 3 bindings and system OpenSceneGraph packages.

### Design Rationale
- Ubuntu 24.04 no longer ships Python 2, `qt5-default`, `mlocate`, or `liboctave-dev`, so the install flow now maps those requirements to supported 24.04 packages.
- OpenRAVE's current `production` branch supports Python 3 bindings; using that path avoids reviving deprecated Python 2 tooling on a modern distribution.
- Using the distro-provided OpenSceneGraph package on Ubuntu 24.04 is more reliable than rebuilding the older pinned OSG release against newer Qt and compiler toolchains.

### Notes & Caveats
- Ubuntu 24.04 uses a newer Bullet package than the version OpenRAVE's Bullet plugin expects, so the main install succeeds without that optional plugin.
- Ubuntu 24.04 also skips the optional FCL collision plugin because the installed FCL headers do not match OpenRAVE's legacy `fclrave` integration.
- A Python `.pth` shim is written on Ubuntu 24.04 so `python3` can resolve the OpenRAVE package installed under `/usr/local/lib/python3/dist-packages`.
- Older Ubuntu releases keep their previous installation paths unchanged.
