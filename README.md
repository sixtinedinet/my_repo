# fixed_pipeline.R

Corrected version of `broken_pipeline.R` from the CSS bootcamp exercises.

## What the script does

The script builds a small, reproducible data pipeline on the built-in **`swiss`** dataset (Swiss cantons / provinces, 47 rows):

1. **Load data** — attaches `swiss` from base R and copies it to `df`.
2. **Filter** — keeps provinces where `Catholic > 50` (majority-Catholic cantons; 18 rows).
3. **Mutate** — adds a logical flag `is_majority = TRUE` on those rows.
4. **Summarise** — computes for that subset:
   - `avg_fertility` — mean of `Fertility`
   - `avg_education` — mean of `Education`
   - `max_ag` — maximum of `Agriculture`
   - `n_provinces` — how many provinces are in the subset
5. **Plot** — draws a single-point scatter of average fertility vs average education with `ggplot2`, a minimal theme, and axis/title labels.
6. **Save** — writes the figure to `outputs/my_plot.png` (creating `outputs/` if needed) and prints the summary table to the console.

## Requirements

- R (≥ 4.x)
- [tidyverse](https://www.tidyverse.org/) (pulls in `dplyr` and `ggplot2`)

```r
install.packages("tidyverse")
```

## How to run

From the repository root:

```bash
Rscript fixed_pipeline.R
```

Or in R / RStudio / Positron:

```r
source("fixed_pipeline.R")
```

**Expected output**

- Console: a one-row tibble with `avg_fertility`, `avg_education`, `max_ag`, `n_provinces`
- File: `outputs/my_plot.png`

## Files

| File | Role |
|------|------|
| `broken_pipeline.R` | Original script with intentional bugs (for the exercise) |
| `fixed_pipeline.R` | Corrected, runnable version |
| `README.md` | This document |
| `outputs/my_plot.png` | Plot produced by running the fixed script |

## Changelog — bugs fixed from `broken_pipeline.R`

- **Wrong package name** — `library(ggplot)` does not exist; the package is `ggplot2`, which tidyverse already loads. The bad `library()` call was removed.
- **Typo in dataset name** — `df <- swis` changed to `df <- swiss` (`swis` is not an object).
- **Invalid logical constant** — `mutate(is_majority = True)` changed to `mutate(is_majority = TRUE)`. R’s boolean literals are `TRUE` / `FALSE` (or `T` / `F`); `True` is undefined and errors.
- **Broken `summarize()` parentheses** — `mean(Education, na.rm = T,` was missing its closing `)`, so `max_ag = max(Agriculture)` was parsed as further arguments to `mean()` and the `summarize()` call was never closed. Each summary expression is now a complete, properly parenthesised statement, and `summarize()` has its own closing `)`.
- **Inconsistent logical abbreviations** — `na.rm = T` standardised to `na.rm = TRUE` everywhere for readability.
- **Missing `na.rm` on other summaries** — `mean(Fertility)` and `max(Agriculture)` now also use `na.rm = TRUE` so behaviour stays consistent if missing values appear.
- **Wrong operator for ggplot layers** — `ggplot(...) |> geom_point(...)` changed to `ggplot(...) + geom_point(...)`. ggplot2 layers must be combined with `+`; the native pipe `|>` is for function calls, not for adding geoms/themes.
- **Missing `+` before `labs()`** — `labs(title = ...)` was a separate statement (a no-op) and never attached to the plot. It is now chained with `+`, and x/y axis titles were added.
- **Variable shadowed `plot()`** — the graphics object was named `plot`, which masks `base::plot()`. Renamed to `p`.
- **Missing output directory** — `ggsave("outputs/my_plot.png", ...)` fails if `outputs/` does not exist. Added `dir.create("outputs", showWarnings = FALSE)` before saving.
- **Unused summary columns never shown** — added `n_provinces = n()`, `.groups = "drop"`, and `print(summary_stats)` so a console run shows what was computed.
- **Plot sizing** — `ggsave()` now gets explicit `width`, `height`, and `dpi` so the PNG size does not depend on the active device.

## Original bugs (quick reference)

| # | Location in `broken_pipeline.R` | Bug |
|---|----------------------------------|-----|
| 1 | L4 | `library(ggplot)` — package does not exist |
| 2 | L8 | `swis` — typo for `swiss` |
| 3 | L13 | `True` — not valid R |
| 4 | L19–21 | Unclosed `mean()` / `summarize()` |
| 5 | L19 | `na.rm = T` (style) + missing `na.rm` elsewhere |
| 6 | L24 | `|>` used to attach `geom_point()` |
| 7 | L27 | `labs()` not joined with `+` |
| 8 | L24 | Object named `plot` masks `plot()` |
| 9 | L29 | `outputs/` may not exist |
