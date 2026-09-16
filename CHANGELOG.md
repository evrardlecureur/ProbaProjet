# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- CI: syntax check of the R scripts, report built with Tectonic (PDF as artifact), markdownlint and lychee, dependency review and CodeQL on the workflows
- Dependabot for the GitHub Actions
- MIT License, contributing guide, code of conduct, security policy, citation metadata, issue forms and pull request template
- README rewritten in English: the project, the student-versus-AI structure, what each dataset teaches, getting started, repository structure and quality checks

### Changed

- Report: the name of the third author filled in, the date frozen to the submission date instead of `\today`

## [1.0.0] - 2026-05-29

Version submitted at the end of the project.

### Added

- Simple regression on datasets A to D: least squares, Student test on the slope, studentized residuals, QQ-plot, Kolmogorov-Smirnov test, outliers, small sample and V-shaped relation, prediction intervals
- Multiple regression, polynomial regression and one- and two-way ANOVA on datasets E, D and G
- Variable selection on datasets E, F and G: exhaustive search on the adjusted R², forward, backward and stepwise methods, AIC
- AI-assisted pass on each part: Cook's distance, robust regression, robust standard errors, bootstrap, segmented regression, VIF, Breusch-Pagan, Tukey and Levene tests
- LaTeX report with a student-versus-AI comparison in each section, 27 figures

[Unreleased]: https://github.com/evrardlecureur/ProbaProjet/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/evrardlecureur/ProbaProjet/releases/tag/v1.0.0
