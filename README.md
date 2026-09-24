# fixed_pipeline.R

Corrected version of `broken_pipeline.R`. The script loads the built-in `swiss` dataset, keeps provinces where `Catholic > 50`, flags them as majority-Catholic, computes mean fertility, mean education, and max agriculture for that group, then saves a scatter plot of fertility vs education to `outputs/my_plot.png`.

## Changelog

Bugs fixed from the original `broken_pipeline.R`:

- **Wrong package name** — `library(ggplot)` changed to relying on **`tidyverse`** (the package is `ggplot2`, already loaded by tidyverse; the bad library call was removed).
- **Typo in dataset name** — `df <- swis` changed to `df <- swiss`.
- **Invalid logical constant** — `mutate(is_majority = True)` changed to `mutate(is_majority = TRUE)` (`True` is not defined in R).
- **Broken `summarize()` parentheses** — `mean(Education, na.rm = T,` was missing its closing `)`, so `max_ag` was parsed as an argument to `mean()`; closed `mean()` properly and ended `summarize()` with its own `)`.
- **Inconsistent logical abbreviations** — `na.rm = T` changed to `na.rm = TRUE` for clarity.
- **Wrong operator for ggplot layers** — `ggplot(...) |> geom_point(...)` changed to `ggplot(...) + geom_point(...)` (ggplot2 layers must be added with `+`, not the pipe).
- **Missing `+` before `labs()`** — `labs(title = ...)` was a separate statement and never attached to the plot; chained it with `+`.
- **Missing output directory** — added `dir.create("outputs", showWarnings = FALSE)` so `ggsave("outputs/my_plot.png", plot)` does not fail when `outputs/` does not exist.
