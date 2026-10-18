# AGENTS.md

Instructions for AI agents (and humans) working in this repository.

## Project overview

Static HTML/CSS site for the Marlene Cohen Laboratory, served from `docs/`
via GitHub Pages at <https://cohenlab.com/>. No build step, no dependencies,
no npm project — everything runs via `npx`.

## Essential commands

```sh
npx prettier@3 --write docs/*.html docs/*.css    # format
npx html-validate@9 docs/*.html                  # HTML lint
scripts/linkcheck.sh                             # internal links resolve
scripts/linkcheck.sh external                    # also crawl external links
```

## Checks to run before finishing any task

1. **Format** touched HTML/CSS/Markdown files with Prettier.
2. **Lint** touched HTML with html-validate.
3. **Check links** with `scripts/linkcheck.sh` after adding/removing files,
   renaming images, or editing `href`/`src` attributes.
4. Any HTML you write/edit must pass html-validate with no new errors.

These all run automatically in the pre-commit hook (see below), but run them
yourself before declaring work done.

## Pre-commit hook

`.githooks/pre-commit` (activated with `git config core.hooksPath .githooks`)
formats staged HTML/CSS/Markdown and blocks the commit if html-validate
fails or `.DS_Store` is staged. Never bypass it with `--no-verify` unless the
user explicitly asks.

## Conventions

- Pages live in `docs/`: `index.html`, `people.html`, `publications.html`,
  `awards.html`, `cohen_commission.html`, plus `cohenlab.css`.
- Keep the 2-space indentation Prettier produces; don't hand-reformat.
- All pages have the same header/nav; the current page is marked
  `<li class="current">`. New pages should include the same header and the
  Google Analytics script block.
- **people.html** lists people alphabetically by last name. Each entry uses
  the `.person` / `.photo` / `.text` / `.name` / `.title` / `.degree`
  structure. Photos follow the `first_last.jpg` (full-size, wrapped in an
  `<a>`) and `first_last_s.jpg` (100×150 thumbnail, 2:3 portrait crop)
  naming pattern. Every `<img>` needs an `alt`.
- **publications.html** lists publications newest-first, each in a
  `<div class="pub">`. Authors use initials ("Ruff DA"); Marlene's name is
  wrapped in `<span class="me">Cohen MR</span>`. Titles link to the PubMed
  entry, DOI, or PDF when available.
- **awards.html** lists awards newest-first as `<li>Name - Award (year)</li>`.

## Image processing

Convert/crop new photos to match existing ones:

```sh
# thumbnail: center-crop to 2:3, output 200x300 JPEG (or 100x150)
sips -s format jpeg -c 1471 980 input.tif --out thumb.jpg
sips --resampleHeightWidth 300 200 thumb.jpg
```

Note: `sips -c` takes `<height> <width>` (center crop). Crop from the
center; check the result visually — faces must stay framed.
