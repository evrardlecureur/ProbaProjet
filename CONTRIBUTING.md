# Contributing

Thank you for your interest in this project. It is a student project of the
linear regression course at Polytech Nice Sophia (MAM3), written by three
students, and corrections, additional analyses and pull requests are welcome.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to contribute

- **Report a bug** or **suggest an improvement** with the
  [issue forms](https://github.com/evrardlecureur/ProbaProjet/issues/new/choose).
- **Report a security vulnerability** privately, as described in the
  [security policy](SECURITY.md). Please do not open a public issue for it.
- **Open a pull request** for a fix, an additional analysis, a figure or documentation.

For a larger change, for example a new section of the report, please open an
issue first so that we can agree on the approach.

## Development setup

Requires R 4.x with the packages `leaps`, `car`, `lmtest`, `MASS`, `sandwich`,
`boot` and `segmented`, and [Tectonic](https://tectonic-typesetting.github.io/)
to build the report. The datasets (`Data1.R` to `Data4.R`, `data5.RData` to
`data7.RData`) are provided by the instructor and are not in the repository.

```bash
git clone https://github.com/evrardlecureur/ProbaProjet.git
cd ProbaProjet
Rscript -e 'install.packages(c("leaps", "car", "lmtest", "MASS", "sandwich", "boot", "segmented"))'

Rscript code/script_romain.R        # after loading the datasets A to D
tectonic -X compile rapport.tex     # builds rapport.pdf
```

To check the Markdown files like the CI does:

```bash
npx markdownlint-cli2
lychee --offline --include-fragments .
```

## Coding guidelines

The repository provides an [`.editorconfig`](.editorconfig) file: most editors
apply its indentation and whitespace settings automatically.

- Each script keeps the two-part structure of the project: a `## partie étudiant`
  block (what a third-year student does by hand) followed by a `## partie IA`
  block (what the AI-assisted pass adds). Keep new analyses in the right block.
- Figures are saved in `figures/` with the name used by the report, so that
  `rapport.tex` and the code always match.
- Every section of the report ends with the comparison paragraph between the
  student approach and the AI contribution: keep it when adding a section.
- The scripts and the report are in French, the repository documentation in English.

## Pull request process

1. Create a branch from `main` with a descriptive name, for example
   `fix/figure-labels` or `docs/results-table`.
2. Keep commits focused, with a short summary in the imperative mood
   (for example "Add the residual plot of dataset C").
3. Open a pull request against `main`, fill in the template and add a label
   (`bug`, `enhancement`, `documentation`...): labels sort the release notes.
4. The CI must pass (`r`, `report`, `docs`) and another member of the team
   reviews the pull request before it is merged. The branch is not protected
   by GitHub (a setting reserved to the owner of the repository), so this is a
   team rule rather than an enforced one.
5. Update the README when the usage or the results change, and `CHANGELOG.md`
   under "Unreleased".

## Versioning and releases

The project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (`2.0.0`): incompatible change, for example a different layout of the repository;
- **MINOR** (`1.1.0`): new analysis, dataset or figure;
- **PATCH** (`1.0.1`): backward-compatible bug fix or correction of the report.

Releases are published from `main` with a `vX.Y.Z` tag. GitHub generates their
notes from the merged pull requests, grouped by label as configured in
[`.github/release.yml`](.github/release.yml), and the `version` field of
[`CITATION.cff`](CITATION.cff) is updated at the same time.
