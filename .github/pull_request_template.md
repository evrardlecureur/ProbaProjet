## Summary

<!-- What does this pull request change, and why? Link the related issue, for example "Closes #12". -->

## Type of change

- [ ] Bug fix
- [ ] New analysis, figure or section of the report
- [ ] Documentation
- [ ] CI, dependencies or tooling

## Checklist

- [ ] The R scripts still parse (`Rscript -e 'parse("code/script_romain.R")'`) and run on the datasets
- [ ] `tectonic -X compile rapport.tex` builds the report
- [ ] New figures are saved in `figures/` and referenced in the report
- [ ] `npx markdownlint-cli2` and `lychee --offline --include-fragments .` pass (if Markdown files changed)
- [ ] `CHANGELOG.md` is updated under "Unreleased"
