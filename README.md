# gif-og-test

Test pages for how platforms render animated GIF `og:image` at varying file sizes. Paste each page URL into Slack, Discord, iMessage, LinkedIn, X, WhatsApp, Teams, etc. to see where animation works and where it breaks.

## Pages

Live at: https://bowernite.github.io/gif-og-test/

| Page | GIF size |
| --- | --- |
| [108kb](https://bowernite.github.io/gif-og-test/108kb.html) | 108 KB |
| [407kb](https://bowernite.github.io/gif-og-test/407kb.html) | 407 KB |
| [928kb](https://bowernite.github.io/gif-og-test/928kb.html) | 928 KB |
| [1.9mb](https://bowernite.github.io/gif-og-test/1.9mb.html) | 1.9 MB |
| [4.1mb](https://bowernite.github.io/gif-og-test/4.1mb.html) | 4.1 MB |
| [9.3mb](https://bowernite.github.io/gif-og-test/9.3mb.html) | 9.3 MB |

Each page is a minimal HTML file with `og:image` pointing at its sibling GIF. Dimensions: 1200×630. Same encoder pipeline as a real demo unfurl (palettegen + paletteuse).

## Regenerate

```bash
./generate.sh                                  # (re)generate GIFs into gifs/
BASE_URL="https://bowernite.github.io/gif-og-test" ./build-html.sh
```

Requires ffmpeg on PATH.
