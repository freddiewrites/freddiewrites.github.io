# freddiewrites.github.io

My personal website, [freddiewrit.es](https://freddiewrit.es). It’s built with [Jekyll](https://jekyllrb.com) and hosted on GitHub Pages. Pushing to `main` rebuilds and publishes the site through the workflow in `.github/workflows/jekyll.yml`.

## Running it locally

You need Ruby and Bundler installed. Then, from this folder:

```sh
bundle install              # first time only, installs Jekyll and plugins
bundle exec jekyll serve    # builds the site and serves it at http://localhost:4000
```

The site rebuilds when you save a file. Refresh the browser to see changes. Changes to `_config.yml` need a restart (press Ctrl+C, then run the serve command again).

Locally, the site runs in development mode, which shows the style guide in post lists. To preview exactly what the live site shows, run `JEKYLL_ENV=production bundle exec jekyll serve`.

## Where things live

| Path | What it is |
| --- | --- |
| `_posts/` | Blog posts, named `YYYY-MM-DD-slug.md` |
| `index.markdown`, `about.markdown`, `posts.md`, `now.md`, `404.md` | Pages |
| `_layouts/` | Page templates (home, post, page, tag, now) |
| `_includes/` | Reusable pieces: header, footer, post lists, the logo |
| `_sass/` | Styles. `_variables.scss` holds colors, spacing and fonts |
| `assets/fonts/` | Self-hosted fonts (see the README in that folder) |
| `uploads/` | Images used in posts |
| `feed.xml`, `feed.json` | RSS (Atom) and JSON feeds |

## Writing a post

Create a file in `_posts/` named with the date and a short slug, like `2026-10-04-on-editing.md`, starting with front matter:

```yaml
---
layout: post
title: "On editing"
categories: thoughts
excerpt: One or two sentences for the homepage, feeds and social previews.
image: /uploads/2026/10/editing.jpg   # optional hero image
---
```

- **`excerpt`** shows on the homepage and in link previews. Always write one.
- **`categories`** become tags, like “in Thoughts,” and each one gets a page at `/tags/name/`. Existing ones: `thoughts`, `work`, `personal`.
- **`image`** is optional. It shows full width under the title and becomes the preview image when the post is shared. Posts without one use the fh image (`assets/images/social-image.png`) in link previews.

### Formatting

The style guide post (`_posts/2026-01-13-style-guide.markdown`) shows every element. It only appears on the live site if you know its URL. The ones specific to this site:

- **Section break:** a line of dashes (`---`) shows as `* * *`. Leave a blank line above and below it. Without the blank line above, Markdown turns the paragraph before it into a heading.
- **Pull quote:** add `{: .pullquote}` on the line directly after a blockquote.

  ```markdown
  > The line you want to pull out.
  {: .pullquote}
  ```

- **Image with a caption:**

  ```html
  <figure>
    <img src="/uploads/2026/10/photo.jpg" alt="What the photo shows" loading="lazy">
    <figcaption>Your caption</figcaption>
  </figure>
  ```

  Always describe the image in `alt`, for people using screen readers.

### Preparing images

Keep photos 1920px wide or smaller. On a Mac, the built-in `sips` command resizes one so its longest side is 1920px:

```sh
sips -Z 1920 photo.jpg
```

Optionally, save a 960px copy with `-960` added to the name. Phones then download the smaller file instead:

```sh
sips -Z 960 photo.jpg --out photo-960.jpg
```

For a hero image, the post template finds the `-960` copy automatically. For images in the body of a post, add `srcset` and `sizes` to the `<img>` tag, as in `_posts/2017-03-17-offscreen.markdown`.

## Updating the Now page

Now updates are posts with `tags: [now]` in their front matter. The `/now/` page always shows the most recent one, and they never appear in post lists or feeds. Add a new file in `_posts/` for each update rather than editing the old one.

```yaml
---
layout: post
tags: [now]
---
```
