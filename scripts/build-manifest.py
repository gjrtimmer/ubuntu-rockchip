#!/usr/bin/env python3
"""Assemble download-site manifest.json from per-image part files.

Each part file (one per board/suite/flavor, emitted by the build job) is a JSON
object with the keys listed in REQUIRED below. This merges them into a single
manifest the download site reads:

    { version, generated, base_url, images: [ <part>, ... ] }

Download URL for an image is composed client-side as `base_url + image.filename`,
so `filename` is the image's path relative to base_url (e.g. "24.04/rock-5b/...img.xz").

Usage:
    build-manifest.py <out.json> <base_url> <version> <parts_dir>

Exits non-zero (failing CI) if no parts are found or any part is missing a key.
"""
import datetime
import glob
import json
import os
import sys

REQUIRED = {
    "board", "board_name", "soc", "maker", "suite",
    "suite_version", "flavor", "filename", "size", "sha256",
}


def main() -> int:
    if len(sys.argv) != 5:
        print(__doc__)
        return 2
    out, base_url, version, parts_dir = sys.argv[1:5]

    files = sorted(glob.glob(os.path.join(parts_dir, "*.json")))
    parts = [json.load(open(f)) for f in files]
    if not parts:
        print(f"ERROR: no manifest parts found in {parts_dir}", file=sys.stderr)
        return 1

    bad = [p.get("filename", "?") for p in parts if REQUIRED - set(p)]
    if bad:
        print(f"ERROR: parts missing required keys: {bad}", file=sys.stderr)
        return 1

    parts.sort(key=lambda p: (p["board_name"], p["suite"], p["flavor"]))
    generated = os.environ.get("GENERATED") or \
        datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    manifest = {
        "version": version,
        "generated": generated,
        "base_url": base_url,
        "images": parts,
    }
    with open(out, "w") as f:
        json.dump(manifest, f, indent=2)
    print(f"manifest: {len(parts)} images -> {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
