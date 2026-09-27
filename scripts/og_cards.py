"""Draw the preview cards listed by _plugins/og_cards.rb.

Run after `jekyll build`. It reads .jekyll-cache/og-cards.json and writes one
1200x630 PNG per entry into _site. The GitHub Actions workflow runs it before
publishing; locally, run `python3 scripts/og_cards.py` after a build to see them.

Layout: the marque sits top left, with the title below. The bottom of
the card stays clear because X overlays the site's domain in the bottom-left
corner of preview images.
"""

import json
import sys
from itertools import combinations
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
MANIFEST = ROOT / ".jekyll-cache" / "og-cards.json"
SITE = ROOT / "_site"
FONTS = ROOT / "assets" / "fonts"
MARQUE = Path(__file__).resolve().parent / "og-marque.png"

W, H, PAD = 1200, 630, 80
PLUM, CREAM = "#7A4D68", "#F8F6F1"
MARQUE_SIZE = 56


def serif(size):
    font = ImageFont.truetype(str(FONTS / "fh-serif-roman.woff2"), size)
    font.set_variation_by_axes([600, 60])  # semibold, display optical size
    return font


def balanced_lines(words, font, max_width, lines_allowed):
    """Split words into the fewest lines that fit, keeping line lengths even."""
    for count in range(1, lines_allowed + 1):
        best = None
        for cuts in combinations(range(1, len(words)), count - 1):
            bounds = (0, *cuts, len(words))
            lines = [" ".join(words[a:b]) for a, b in zip(bounds, bounds[1:])]
            widths = [font.getlength(line) for line in lines]
            if max(widths) > max_width:
                continue
            spread = max(widths) - min(widths)
            if best is None or spread < best[0]:
                best = (spread, lines)
        if best:
            return best[1]
    return None


def fit_title(title, max_width):
    """Largest size that fits in two lines, then three, then four at the smallest size."""
    words = title.split()
    for lines_allowed, sizes in ((2, range(104, 59, -4)), (3, range(104, 47, -4)), (4, [48])):
        for size in sizes:
            font = serif(size)
            lines = balanced_lines(words, font, max_width, lines_allowed)
            if lines:
                return font, size, lines
    # A single word too long for the card: draw it at the smallest size anyway
    return serif(48), 48, [title]


def draw_card(title, out_path, marque):
    im = Image.new("RGB", (W, H), PLUM)
    draw = ImageDraw.Draw(im)

    im.paste(marque, (PAD, PAD), marque)

    font, size, lines = fit_title(title, W - 2 * PAD)
    y = PAD + MARQUE_SIZE + 44
    for line in lines:
        draw.text((PAD, y), line, font=font, fill=CREAM)
        y += round(size * 1.12)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    im.save(out_path, optimize=True)


def main():
    if not MANIFEST.exists():
        sys.exit(f"{MANIFEST} not found. Run `jekyll build` first.")
    cards = json.loads(MANIFEST.read_text(encoding="utf-8"))
    marque = Image.open(MARQUE).convert("RGBA").resize((MARQUE_SIZE, MARQUE_SIZE), Image.LANCZOS)
    for card in cards:
        draw_card(card["title"], SITE / card["path"].lstrip("/"), marque)
    print(f"Drew {len(cards)} preview cards")


if __name__ == "__main__":
    main()
