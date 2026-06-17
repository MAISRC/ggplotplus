

# SAMPLE PLOTS ------------------------------------------------------------




library(tidyr)

set.seed(123)

lake_dat = tidyr::expand_grid(
  year = 2012:2025,
  lake = paste("Lake", LETTERS[1:10])
) %>%
  dplyr::group_by(lake) %>%
  dplyr::mutate(
    baseline = runif(1, 10, 35),
    slope = runif(1, -0.5, 1.2),
    zebra_mussel_cpue = baseline + slope * (year - min(year)) + rnorm(dplyr::n(), 0, 3)
  ) %>%
  dplyr::ungroup()

ggplot(lake_dat,
       aes(x = year,
           y = zebra_mussel_cpue,
           colour = lake,
           group = lake)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_focus_plus(aes = "colour",
                   group_var = lake_dat$lake,
                   focal_groups = c("Lake C", "Lake H")) +
  labs(
    x = "Year",
    y = "Zebra mussel CPUE",
    colour = "Lake",
    title = "Default scale_focus_plus() behavior",
    subtitle = "Two focal lakes differentiated; all other lakes shown in shared gray"
  ) +
  theme_plus()


set.seed(456)

cover_dat = tidyr::expand_grid(
  lake = paste("Lake", LETTERS[1:12]),
  taxon = c("Native plants", "Starry stonewort", "Eurasian watermilfoil")
) %>%
  dplyr::mutate(
    mean_cover = dplyr::case_when(
      taxon == "Native plants" ~ runif(dplyr::n(), 25, 70),
      taxon == "Starry stonewort" ~ runif(dplyr::n(), 0, 35),
      taxon == "Eurasian watermilfoil" ~ runif(dplyr::n(), 0, 25)
    )
  )

ggplot(cover_dat,
       aes(x = lake,
           y = mean_cover,
           fill = taxon)) +
  geom_col(position = "dodge",
           width = 0.75) +
  scale_focus_plus(aes = "fill",
                   group_var = cover_dat$taxon,
                   focal_groups = "Starry stonewort",
                   diff_focal = FALSE,
                   diff_nonfocal = FALSE) +
  labs(
    x = NULL,
    y = "Mean percent cover",
    fill = "Taxon",
    title = "Single focal taxon in a grouped bar chart",
    subtitle = "Position distinguishes taxa; color mainly directs attention"
  ) +
  theme_plus() +
  theme(axis.text.x = element_text(angle = 45,
                                   hjust = 1))

set.seed(789)

site_dat = data.frame(
  site = paste0("Site ", 1:30),
  treatment = rep(c("Control",
                    "Low dose",
                    "Medium dose",
                    "High dose",
                    "Removal",
                    "Restoration"),
                  each = 5),
  response = c(
    rnorm(5, 45, 7),
    rnorm(5, 48, 7),
    rnorm(5, 55, 7),
    rnorm(5, 62, 7),
    rnorm(5, 50, 7),
    rnorm(5, 66, 7)
  )
)

ggplot(site_dat,
       aes(x = treatment,
           y = response,
           colour = treatment)) +
  geom_jitter(width = 0.12,
              height = 0,
              size = 3,
              alpha = 0.85) +
  stat_summary(fun = mean,
               geom = "point",
               size = 6,
               shape = 18,
               show.legend = FALSE) +
  scale_focus_plus(aes = "colour",
                   group_var = site_dat$treatment,
                   focal_groups = c("High dose", "Restoration"),
                   diff_focal = TRUE,
                   diff_nonfocal = TRUE,
                   gray_start = 0.25,
                   gray_end = 0.75,
                   guide = "none") +
  labs(
    x = NULL,
    y = "Response",
    colour = "Treatment",
    title = "Stress test: differentiated focal and non-focal groups",
    subtitle = "Useful for checking ordering, legend behavior, and gray separability"
  ) +
  theme_plus()
