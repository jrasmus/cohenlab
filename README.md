# cohenlab

https://cohenlab.com/

## Development

The site is the static HTML/CSS in `docs/`, published automatically by
[GitHub Pages](https://github.com/jrasmus/cohenlab/settings/pages) at
https://cohenlab.com/.

### Formatting and checks

- `npx prettier@3 --write docs/*.html docs/*.css` — format the site
  (a `.prettierrc` pins the style).
- `npx html-validate@9 docs/*.html` — HTML lint (accessibility, `lang`,
  `alt` on images, etc.; configured via `.htmlvalidate.json`).
- `scripts/linkcheck.sh` — verify every internal `href`/`src` in `docs/*.html`
  points at a file that exists. `scripts/linkcheck.sh external` also crawls
  external links (noisier — many legacy `marlenecohen.com` PDF links predate
  this site).

### Pre-commit hook

Every commit is autoformatted with Prettier and validated with html-validate
automatically. The hook lives in `.githooks/pre-commit`; if you clone this
repo, activate it with:

```sh
git config core.hooksPath .githooks
```
