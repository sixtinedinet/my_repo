# fixed_pipeline.R
#
# Corrected version of broken_pipeline.R.
# Loads the built-in swiss dataset, keeps majority-Catholic provinces,
# summarises fertility / education / agriculture, and saves a scatter plot.

library(tidyverse)

# Load data
data(swiss)
df <- swiss

# Isolate provinces with Catholic percentage > 50 and flag them
high_catholic <- df |>
  filter(Catholic > 50) |>
  mutate(is_majority = TRUE)

# Calculate summary stats (na.rm kept consistent across all means/max)
summary_stats <- high_catholic |>
  summarize(
    avg_fertility = mean(Fertility, na.rm = TRUE),
    avg_education = mean(Education, na.rm = TRUE),
    max_ag = max(Agriculture, na.rm = TRUE),
    n_provinces = n(),
    .groups = "drop"
  )

# Plot the results
dir.create("outputs", showWarnings = FALSE)

p <- ggplot(summary_stats, aes(x = avg_fertility, y = avg_education)) +
  geom_point(color = "red", size = 3) +
  theme_minimal() +
  labs(
    title = "Fertility vs Education in Majority Catholic Swiss Provinces",
    x = "Average fertility",
    y = "Average education"
  )

ggsave("outputs/my_plot.png", p, width = 7, height = 7, dpi = 150)

# Also print the summary so the console run is informative
print(summary_stats)
