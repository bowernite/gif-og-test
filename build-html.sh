#!/usr/bin/env bash
# Generate one HTML page per GIF in gifs/, plus an index.
# Each page sets og:image to its sibling gif, og:title to the size label.
set -euo pipefail
cd "$(dirname "$0")"
BASE_URL="${BASE_URL:-}"  # e.g. https://bowernite.github.io/gif-og-test

links=""
for f in gifs/*.gif; do
  [ -e "$f" ] || continue
  label=$(basename "$f" .gif)
  size=$(wc -c < "$f" | tr -d ' ')
  out="${label}.html"
  img_url="${BASE_URL}/${f}"
  page_url="${BASE_URL}/${out}"
  cat > "$out" <<EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>GIF og:image test — ${label} (${size} bytes)</title>
    <meta property="og:type" content="website" />
    <meta property="og:title" content="og:image GIF test — ${label}" />
    <meta property="og:description" content="Animated GIF og:image, ${size} bytes. Testing how platforms render this size." />
    <meta property="og:image" content="${img_url}" />
    <meta property="og:image:type" content="image/gif" />
    <meta property="og:image:width" content="1200" />
    <meta property="og:image:height" content="630" />
    <meta property="og:url" content="${page_url}" />
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:image" content="${img_url}" />
    <style>
      body { font: 14px/1.5 -apple-system, system-ui, sans-serif; max-width: 720px; margin: 2rem auto; padding: 0 1rem; color: #222; }
      img { max-width: 100%; border: 1px solid #ccc; }
      code { background: #f4f4f4; padding: 0 4px; border-radius: 3px; }
    </style>
  </head>
  <body>
    <h1>GIF og:image test — ${label}</h1>
    <p>File: <code>${f}</code> · Size: <strong>${size}</strong> bytes</p>
    <img src="${f}" alt="${label}" />
    <p><a href="./">← all sizes</a></p>
  </body>
</html>
EOF
  links="${links}        <li><a href=\"${out}\">${label}</a> — ${size} bytes · <a href=\"${f}\">raw gif</a></li>\n"
done

cat > index.html <<EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>GIF og:image size ladder</title>
    <meta property="og:title" content="GIF og:image size ladder" />
    <meta property="og:description" content="Test pages for animated GIF og:image rendering at varying file sizes." />
    <style>
      body { font: 14px/1.5 -apple-system, system-ui, sans-serif; max-width: 720px; margin: 2rem auto; padding: 0 1rem; color: #222; }
      li { margin: .4rem 0; }
      code { background: #f4f4f4; padding: 0 4px; border-radius: 3px; }
    </style>
  </head>
  <body>
    <h1>GIF og:image size ladder</h1>
    <p>Paste each page URL into Slack / Discord / iMessage / LinkedIn / X / WhatsApp / Teams to see how each platform handles animated GIF <code>og:image</code> at varying file sizes.</p>
    <ul>
$(printf "%b" "$links")    </ul>
    <p>Click the unfurl dropdown in Slack to see <em>Unfurled by</em> attribution — should say "Slack", not an app name.</p>
  </body>
</html>
EOF

echo "built $(ls *.html | wc -l | tr -d ' ') html files"
