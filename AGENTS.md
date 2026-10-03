# Agent guide

Freddie Harrison’s personal site, [freddiewrit.es](https://freddiewrit.es). Jekyll 4.3, hosted on GitHub Pages. Pushing to `main` builds and deploys it through `.github/workflows/jekyll.yml`. There’s no test suite. A clean build is the check.

`README.md` is the human-facing guide (running locally, writing posts, images, preview cards, the Now page). Read it when a task touches those areas. This file covers what an agent needs on top of that.

## About the owner

Freddie is a writer and marketer learning to code. Explain what you changed and why in plain language. Ask before structural changes (new layouts, plugins, dependencies, build steps).

## Map

| Path | What it is |
| --- | --- |
| `_config.yml` | Site settings, permalinks (`/journal/:year/:slug/`), plugins, `exclude` list |
| `_posts/` | Posts, `YYYY-MM-DD-slug.md` or `.markdown` |
| `index.markdown` | Homepage intro text (layout `home`) |
| `about.markdown`, `posts.md`, `now.md`, `404.md`, `newsletter.html` | Pages |
| `feed.xml`, `feed.json` | Hand-written Liquid feeds, not a plugin |
| `_layouts/` | `default` wraps everything; `home`, `post`, `page`, `tag`, `now` extend it |
| `_includes/` | Header, footer, post lists, newsletter form, logo SVG |
| `_sass/` | `_variables.scss` (colors, spacing, fonts, dark mode), `_base`, `_layout`, `_components` |
| `assets/css/main.scss` | Entry point that pulls in the partials |
| `assets/js/newsletter.js` | The only JavaScript: form validation for the newsletter |
| `_plugins/` | `hero_images.rb` (hero size and srcset), `og_cards.rb` (preview card list) |
| `scripts/og_cards.py` | Draws preview cards after the build (Python + Pillow) |
| `uploads/YYYY/MM/` | Post images, with optional `-960` copies for small screens |

## Build and check

```sh
bundle install
JEKYLL_ENV=production bundle exec jekyll build   # what the live site builds
python3 scripts/og_cards.py                       # optional, needs: pip3 install -r scripts/requirements.txt
```

Output goes to `_site/` (gitignored, as are `.jekyll-cache/` and `vendor/`). After a change, build in production mode and inspect the relevant HTML in `_site/`. For visual changes, serve `_site/` and screenshot it with Playwright if available, checking both light and dark mode and a phone width.

In the Claude Code cloud container, `bundle exec jekyll` can fail with “command not found: jekyll” even after `bundle install`. This works instead:

```sh
JEKYLL_ENV=production bundle exec ruby -e 'load Gem.bin_path("jekyll","jekyll")' build
```

## Rules that aren’t obvious from one file

- **Hidden posts.** Now updates (`tags: [now]`) never appear in lists or feeds. The “Style Guide” post is hidden in production only. This filter is repeated in `_includes/visible-posts.html`, `feed.xml` and `feed.json`, and `_layouts/tag.html`, `_layouts/now.html` and `_plugins/og_cards.rb` check for `now` too. Change them together. Use `{% include visible-posts.html %}` for any new post list.
- **Categories are tags.** `categories:` in front matter drives the “in Thoughts” links and the `/tags/name/` pages (jekyll-archives). Existing ones: `thoughts`, `work`, `personal`. `tags:` is only used for `now`.
- **Every post needs `excerpt`.** It shows on the homepage, in feeds and in link previews.
- **Images.** `image:` in front matter becomes the hero and the share image. Without one, `og_cards.rb` assigns a generated card. Always write `alt` text for body images.
- **Social preview defaults** are in `_config.yml` under `defaults`. jekyll-seo-tag renders the meta tags from `{% seo %}` in `_includes/head.html`.
- **Styles.** Use the CSS custom properties in `_variables.scss`. Don’t hardcode colors or spacing. Any new color needs a dark-mode value in the `prefers-color-scheme: dark` block. The stylesheet link is cache-busted automatically.
- **Feeds** rewrite root-relative URLs to absolute ones through `_includes/absolute-urls.html`. Keep links and image paths in posts root-relative (`/uploads/...`).
- **Newsletter** posts to Buttondown and opens in a new tab. The fields live in `_includes/newsletter-fields.html`, shared by the homepage panel and `/newsletter/`.
- **Email in the footer** is HTML-entity encoded to deter scrapers. Keep it that way.
- **New repo-only files** (docs, scripts) must be added to `exclude` in `_config.yml` so they aren’t published. Jekyll already skips dotfiles and `_`-prefixed paths.
- **Don’t edit `Gemfile.lock` by hand.** Use `bundle` commands.

## Content and copy

- Posts are Freddie’s own writing. Don’t reword them unless asked. When asked to proofread, fix errors and leave the voice alone.
- Use curly quotes and apostrophes (’ “ ”) in copy, as the existing content does.
- The site is set to `en-GB` and older posts use British spelling. Don’t change spelling in existing content without asking.

## Git and PRs

- Work on a branch and open a PR into `main`. PRs are squash-merged, so `main` reads as one commit per change.
- Commit titles are short, plain-English, imperative sentences that describe the visible result, like “Shrink footer text slightly” or “Add a newsletter signup page linked from the footer.” Use the body to explain why.
- Merging to `main` deploys the live site. Never push straight to `main`.
