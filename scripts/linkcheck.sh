#!/bin/sh
# Check links in the site.
#   scripts/linkcheck.sh           — internal references only (fast, offline):
#                                    every href/src in docs/*.html must resolve
#                                    to a file in docs/
#   scripts/linkcheck.sh external  — crawl external http(s) links with
#                                    linkinator (network + sites rate-limiting
#                                    means some noise)
set -e
if [ "$1" = "external" ]; then
  npx --yes linkinator@6 docs/ --recurse --silent
  exit 0
fi

python3 - <<'EOF'
import re
import sys
from pathlib import Path

root = Path("docs")
broken = []
externalize = ("http:", "https:", "mailto:")

for page in sorted(root.glob("*.html")):
    for target in re.findall(r'(?:href|src)="([^"#]+)"', page.read_text()):
        if target.startswith(externalize):
            continue
        # anchors "<page>#section" and pure fragments "#id" are fine
        path = target.split("#", 1)[0]
        if path and not (root / path).exists():
            broken.append(f"{page}: {target}")

for css_url in re.findall(r'url\(["\']?([^"\')]*)["\']?\)', (root / "cohenlab.css").read_text()):
    if css_url.startswith(externalize) or not css_url or not (root / css_url).exists():
        if css_url and not css_url.startswith(externalize):
            broken.append(f"cohenlab.css: {css_url}")

if broken:
    print("\n".join(broken))
    sys.exit(1)
print("OK — all internal references resolve")
EOF
