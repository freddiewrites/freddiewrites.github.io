---
layout: post
title: "Style Guide"
categories: reference
excerpt: A comprehensive guide to all styled elements available in posts.
---

This post demonstrates all the typographic and structural elements available for writing. Use it as a reference when composing new posts.

## Headings

Headings help structure content and create a clear hierarchy. Here's how each level looks:

### Third-Level Heading

Use H3 for major subsections within an H2 section.

#### Fourth-Level Heading

H4 works well for smaller groupings of content.

##### Fifth-Level Heading

H5 is useful for minor divisions.

###### Sixth-Level Heading

H6 appears in a muted tone, useful for annotations or minor notes.

## Paragraphs and Inline Elements

Regular paragraph text uses a serif typeface optimized for reading. The line length is constrained to approximately 65 characters for comfortable reading.

You can emphasize text with *italics* or make it **bold** for stronger emphasis. Combine them for ***bold italics*** when needed. You can also use <mark>highlighted text</mark> to draw attention to key phrases.

Links like [this one](#) use the accent color and transition smoothly on hover.

For technical writing, use `inline code` to reference variable names, file paths like `/usr/local/bin`, or short commands. Keyboard shortcuts can be shown as <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>.

Abbreviations like <abbr title="Hypertext Markup Language">HTML</abbr> show a dotted underline and reveal their meaning on hover.

You can also use <small>small text</small> for less prominent information, or superscripts for footnotes<sup>1</sup> and subscripts for chemical formulas like H<sub>2</sub>O.

## Lists

### Unordered Lists

Use unordered lists for items without a specific sequence:

- First item in the list
- Second item with more detail
- Third item containing a nested list:
  - Nested item one
  - Nested item two
  - Nested item three
- Fourth item back at the top level

### Ordered Lists

Use ordered lists when sequence matters:

1. First step in the process
2. Second step with additional context
3. Third step that includes sub-steps:
   1. Sub-step A
   2. Sub-step B
   3. Sub-step C
4. Final step to complete the process

## Blockquotes

Use blockquotes for quotations or to highlight important passages:

> Good design is as little design as possible. Less, but better, because it concentrates on the essential aspects, and the products are not burdened with non-essentials.
>
> Back to purity, back to simplicity.

Blockquotes can also include citations:

> The details are not the details. They make the design.
>
> <cite>Charles Eames</cite>

## Code Blocks

For longer code examples, use fenced code blocks:

```css
:root {
  --bg-color: #FAFAF8;
  --text-color: #2D2926;
  --link-color: #B5654A;
}

body {
  font-family: "Source Serif 4", Georgia, serif;
  line-height: 1.7;
  color: var(--text-color);
  background-color: var(--bg-color);
}
```

Code blocks scroll horizontally when content exceeds the container width, which is useful for longer lines.

## Tables

Tables are useful for presenting structured data:

| Feature | Free Plan | Pro Plan | Enterprise |
|:--------|:---------:|:--------:|:----------:|
| Projects | 3 | Unlimited | Unlimited |
| Storage | 1 GB | 100 GB | Custom |
| Support | Community | Email | Dedicated |
| API Access | No | Yes | Yes |
| SSO | No | No | Yes |

Tables use the UI font for better readability of data and include subtle row separators.

## Images

Images are displayed at full width with subtle rounded corners:

![A placeholder for demonstration](/assets/images/placeholder.jpg)

For images with captions, use the figure element:

<figure>
  <img src="/assets/images/placeholder.jpg" alt="Descriptive alt text">
  <figcaption>A caption describing the image and providing additional context.</figcaption>
</figure>

## Horizontal Rules

Use horizontal rules to separate major sections:

---

The rule above creates a clear visual break between sections without being too prominent.

## Definition Lists

Definition lists work well for glossaries or term explanations:

<dl>
  <dt>Typography</dt>
  <dd>The art and technique of arranging type to make written language legible, readable, and appealing when displayed.</dd>

  <dt>Kerning</dt>
  <dd>The adjustment of space between individual letter pairs in a piece of text.</dd>

  <dt>Leading</dt>
  <dd>The vertical space between lines of text, measured from baseline to baseline.</dd>
</dl>

## Combining Elements

Elements work together naturally. For example, a blockquote might contain a list:

> When writing for the web, remember these principles:
>
> 1. Keep sentences short
> 2. Use active voice
> 3. Front-load important information
> 4. Break up long paragraphs

Or a list might contain code:

- Set the primary color with `--link-color: #B5654A`
- Adjust spacing using the `--space-md` variable
- Apply transitions with `transition: color 150ms ease`

---

This style guide covers the core elements you'll use most often. The styling is designed to be readable, consistent, and visually cohesive across all content types.
