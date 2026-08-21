#!/usr/bin/env python3
"""Regenerate every packaged Pockito app icon from the official Kito artwork.

Run from `pockito-mobile/`:

    python3 tool/generate_app_icons.py

Why this exists
---------------
Platforms disagree about who draws the icon's shape. iOS and modern Android
apply their own mask and want full-bleed art; a launcher that does not mask
wants the rounding baked in; Android's adaptive icon wants a transparent
foreground inside a 66dp safe zone; and a PWA maskable icon wants the logo
inside the inner 80%. One file cannot satisfy all four, so this script derives
each of them from the single brand master.

So:

* Everything that can carry the master uses it unaltered, so each platform's
  own mask does the rounding. Nothing is recoloured or redrawn.
* The two variants that need transparency or a safe zone - the Android adaptive
  foreground and the PWA maskable icon - composite the transparent full-body
  pose, which carries the same wallet prop, over Pockito cobalt. The master is
  edge-to-edge artwork with no margin, so it cannot be shrunk into a safe zone
  without leaving a visible frame.
"""

from __future__ import annotations

import json
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent
MASTER = ROOT / "assets/brand/source/app-icon-master.png"

# The neutral full-body pose is the only transparent asset that also holds the
# cream wallet with its warm-gold button, so the two variants that need real
# transparency keep the same finance prop as the master.
KITO = ROOT / "assets/mascot/kito/full-body/kito-default.png"

# Fraction of Kito's height kept when cropping the full body down to the bust
# the master frames: head, leaf and wallet, without the feet.
BUST_HEIGHT = 0.80

# The brand master is already drawn edge to edge with no baked corners, so
# nothing needs cropping away before each platform applies its own mask.
CORNER_CROP = 0.0

# Sampled from the brand master's field: bright cobalt centre, deeper rim.
GRADIENT_INNER = (35, 141, 252)
GRADIENT_OUTER = (10, 100, 240)


def full_bleed(size: int) -> Image.Image:
    """The official icon at `size`, edge to edge."""
    master = Image.open(MASTER).convert("RGB")
    width, height = master.size
    inset_x = round(width * CORNER_CROP)
    inset_y = round(height * CORNER_CROP)
    cropped = master.crop((inset_x, inset_y, width - inset_x, height - inset_y))
    return cropped.resize((size, size), Image.LANCZOS)


def rounded(size: int, radius_ratio: float = 0.2237) -> Image.Image:
    """Full bleed art masked to the platform's rounded square, alpha corners.

    0.2237 is the iOS/Android superellipse corner ratio, which is what a
    launcher that does not apply its own mask expects to receive.
    """
    art = full_bleed(size).convert("RGBA")
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, size - 1, size - 1), radius=size * radius_ratio, fill=255
    )
    art.putalpha(mask)
    return art


def circular(size: int) -> Image.Image:
    """Full bleed art masked to a circle, for Android's round launcher icon."""
    art = full_bleed(size).convert("RGBA")
    mask = Image.new("L", (size * 4, size * 4), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, size * 4 - 1, size * 4 - 1), fill=255)
    art.putalpha(mask.resize((size, size), Image.LANCZOS))
    return art


def gradient_background(size: int) -> Image.Image:
    """Radial cobalt field matching the master, drawn edge to edge."""
    background = Image.new("RGB", (size, size), GRADIENT_OUTER)
    draw = ImageDraw.Draw(background)
    steps = size // 2
    for step in range(steps, 0, -1):
        ratio = step / steps
        color = tuple(
            round(inner + (outer - inner) * ratio)
            for inner, outer in zip(GRADIENT_INNER, GRADIENT_OUTER)
        )
        radius = size * 0.78 * ratio
        centre = size / 2
        draw.ellipse(
            (
                centre - radius,
                centre - radius,
                centre + radius,
                centre + radius,
            ),
            fill=color,
        )
    return background


def kito_layer(box: int) -> Image.Image:
    """Transparent Kito, cropped to the bust and fitted inside `box`."""
    kito = Image.open(KITO).convert("RGBA")
    kito = kito.crop(kito.getchannel("A").getbbox())
    # Match the master's framing: an icon reads better at 48 px without feet.
    kito = kito.crop((0, 0, kito.width, round(kito.height * BUST_HEIGHT)))
    kito = kito.crop(kito.getchannel("A").getbbox())
    width, height = kito.size
    scale = box / max(width, height)
    return kito.resize((round(width * scale), round(height * scale)), Image.LANCZOS)


def safe_zone_icon(size: int, coverage: float) -> Image.Image:
    """Kito on the brand field, confined to the central `coverage`.

    The master is edge-to-edge artwork with no margin, so it cannot simply be
    shrunk: there is no background to extend, and pasting it onto any invented
    field leaves a visible frame. A maskable icon is meant to be a logo on a
    brand field anyway, so this composites the transparent pose — the one that
    also carries the wallet — over Pockito cobalt.
    """
    canvas = gradient_background(size).convert("RGBA")
    kito = kito_layer(round(size * coverage))
    canvas.alpha_composite(
        kito, ((size - kito.width) // 2, (size - kito.height) // 2)
    )
    return canvas


def transparent_safe_zone(size: int, coverage: float) -> Image.Image:
    """Kito alone on a transparent square, for the adaptive foreground."""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    kito = kito_layer(round(size * coverage))
    canvas.alpha_composite(
        kito, ((size - kito.width) // 2, (size - kito.height) // 2)
    )
    return canvas


def save(image: Image.Image, path: Path, *, opaque: bool = False) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if opaque:
        image = image.convert("RGB")
    image.save(path)
    print(f"  {path.relative_to(ROOT)}  {image.size[0]}x{image.size[1]}")


def main() -> None:
    print("iOS (opaque, full bleed - iOS applies its own mask)")
    appicon = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    entries = json.loads((appicon / "Contents.json").read_text())["images"]
    for entry in entries:
        filename = entry.get("filename")
        if not filename:
            continue
        points = float(entry["size"].split("x")[0])
        scale = int(entry["scale"].rstrip("x"))
        save(full_bleed(round(points * scale)), appicon / filename, opaque=True)

    print("Android legacy launcher icons (alpha corners)")
    densities = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
    res = ROOT / "android/app/src/main/res"
    for density, size in densities.items():
        save(rounded(size), res / f"mipmap-{density}/ic_launcher.png")
        save(circular(size), res / f"mipmap-{density}/ic_launcher_round.png")

    print("Android adaptive foreground (66dp of a 108dp canvas)")
    # 432 px is 108dp at xxxhdpi; 66/108 keeps Kito inside the safe zone that
    # every launcher mask is guaranteed to show.
    save(
        transparent_safe_zone(432, 66 / 108),
        res / "drawable-nodpi/kito_avatar_foreground.png",
    )

    print("Web")
    web = ROOT / "web"
    for size in (192, 512):
        save(rounded(size), web / f"icons/Icon-{size}.png")
        # Maskable icons are cropped to a circle of 80% of the canvas. A
        # square inscribed in that circle is ~70% of the canvas, and the master
        # is square, so 70% is the largest size guaranteed to survive any mask.
        save(safe_zone_icon(size, 0.70), web / f"icons/Icon-maskable-{size}.png")
    save(rounded(32), web / "favicon.png")

    print("In-app brand mark (PkMark clips its own corners)")
    for path in (
        ROOT / "assets/brand/app-icon.png",
        # The mascot library keeps its own copy so KitoAsset.appIcon and the
        # brand asset can never disagree.
        ROOT / "assets/mascot/kito/runtime/kito-app-icon.png",
    ):
        save(full_bleed(512), path, opaque=True)


if __name__ == "__main__":
    main()
