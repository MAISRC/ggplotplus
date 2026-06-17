library(ggplot2)
library(ggplotplus)

options(ggplotplus.enable_coaching = FALSE)

test_plots = list()

# 1. Basic scatter: point_plus + continuous x/y + y title + gridlines
test_plots$scatter_basic =
  ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  geom_point_plus() +
  geom_smooth(method = "loess", formula = y ~ x) +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y", name = "Sepal length")

# 2. Mapped shape palette
test_plots$scatter_shape =
  ggplot(iris, aes(Sepal.Width, Sepal.Length, shape = Species)) +
  geom_point_plus(aes(fill = Petal.Length), colour = "black") +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y") +
  scale_continuous_plus(scale = "fill")

# 3. User overrides geom defaults
test_plots$scatter_overrides =
  ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  geom_point_plus(shape = "flower", fill = "white", colour = "black", size = 7, alpha = 0.6) +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y")

# 4. Global mapping inherited by geom_point_plus
test_plots$global_mapping =
  ggplot(iris, aes(Sepal.Width, Sepal.Length, fill = Species, shape = Species)) +
  geom_point_plus(colour = "black") +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y")

# 5. Faceting: no yaxis_title_plus, but gridlines/scale/theme still active
test_plots$facet_scatter =
  ggplot(iris, aes(Sepal.Width, Sepal.Length, fill = Petal.Length)) +
  geom_point_plus(shape = "squircle", colour = "black") +
  facet_wrap(~ Species) +
  theme_plus() +
  gridlines_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y") +
  scale_continuous_plus(scale = "fill")

# 6. Boxplot defaults + continuous y
test_plots$boxplot =
  ggplot(iris, aes(Species, Sepal.Length)) +
  geom_boxplot() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "y", name = "Sepal length")

# 7. Violin defaults: quantiles/fill behavior
test_plots$violin =
  ggplot(iris, aes(Species, Sepal.Length)) +
  geom_violin() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "y")

# 8. Bar/col defaults: transparent fill behavior
test_plots$col =
  ggplot(mtcars, aes(factor(cyl), mpg)) +
  stat_summary(geom = "col", fun = mean) +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "y", name = "Mean mpg")

# 9. Histogram defaults + continuous x/y
test_plots$histogram =
  ggplot(mtcars, aes(mpg)) +
  geom_histogram(bins = 12) +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y", name = "Count")

# 10. Density defaults
test_plots$density =
  ggplot(mtcars, aes(mpg)) +
  geom_density() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y")

# 11. Smooth ribbon defaults
test_plots$smooth =
  ggplot(mtcars, aes(wt, mpg)) +
  geom_point_plus(shape = "oval") +
  geom_smooth(method = "lm", formula = y ~ x) +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y")

# 12. Ribbon/area defaults
test_plots$ribbon =
  ggplot(ggplot2::economics, aes(date, unemploy)) +
  geom_ribbon(aes(ymin = unemploy - 500, ymax = unemploy + 500)) +
  geom_line() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "y", name = "Unemployment")

# 13. Tile defaults + fill scale
test_plots$tile =
  ggplot(ggplot2::faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_tile() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y") +
  scale_continuous_plus(scale = "fill")

# 14. Custom labels vector on scale_continuous_plus
test_plots$custom_labels =
  ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  geom_point_plus(shape = "plus") +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(
    scale = "y",
    name = "Custom y labels",
    labels = LETTERS[1:5],
    thin.labels = FALSE
  )

# 15. Thin labels
test_plots$thin_labels =
  ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
  geom_point_plus(shape = "octagon") +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x", thin.labels = TRUE) +
  scale_continuous_plus(scale = "y", thin.labels = TRUE)

# 16. Coord flip: yaxis_title_plus should still kill/move correct label
test_plots$coord_flip =
  ggplot(iris, aes(Species, Sepal.Length)) +
  geom_boxplot() +
  coord_flip() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "y", name = "Sepal length")

# 17. Top legend interaction
test_plots$top_legend =
  ggplot(iris, aes(Sepal.Width, Sepal.Length, fill = Species, shape = Species)) +
  geom_point_plus(colour = "black") +
  theme_plus(legend.position = "top") +
  gridlines_plus() +
  yaxis_title_plus(nudgeTopLegendDown = TRUE) +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y")

# 18. Multiple continuous aesthetics
test_plots$multi_aes =
  ggplot(iris, aes(Sepal.Width, Sepal.Length, fill = Petal.Length, size = Petal.Width)) +
  geom_point_plus(shape = "waffle", colour = "black") +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y") +
  scale_continuous_plus(scale = "fill")

# 19. Line plot + direct group labeling
test_plots$line_plot =
  ggplot(Orange, aes(
    x = age,
    y = circumference,
    color = factor(Tree, levels = unique(sort(as.numeric(
      Tree
    ))))
  )) +
  geom_line() +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x", name = "Age (years)") +
  scale_continuous_plus(scale = "y", name = "Circumference (cm)") +
  labs(color = "Tree") +
  scale_color_discrete(guide = "none") +
  direct_labels_plus(
    data = Orange,
    x = age,
    y = circumference,
    group = Tree,
    placement = "right",
    geometry = "line",
    key_labels = paste("Tree", 1:5)
  )

# 20. Scatter plot + direct group labeling + faceting
iris$Petal.Width.binned = ggplot2::cut_interval(iris$Petal.Width, n = 4)

test_plots$direct_labeling =
  ggplot(iris, aes(Sepal.Width, Sepal.Length, shape = Species)) +
  geom_point_plus(aes(fill = Petal.Length),
                  colour = "black",
                  include_shape_legend = F) +
  theme_plus(strip.text = element_blank()) +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "x") +
  scale_continuous_plus(scale = "y") +
  scale_continuous_plus(scale = "fill") +
  direct_labels_plus(
    data = iris,
    x = Sepal.Width,
    y = Sepal.Length,
    group = Species,
    facet_vars = "Petal.Width.binned",
    placement = "right",
    geometry = "point",
    adj_fact = 0,
    key_labels = c("setosa" = "I win", "virginica" = "You win", "versicolor" = "We all win"),
    fontface = "italic",
    size = 5,
    box.padding = 0.5,
    segment.size = 1,
    min.segment.length = 0
  ) +
  facet_grid(. ~ Petal.Width.binned)

#21. Geom col test
test_plots$geom_col =
  ggplot(iris %>% dplyr::group_by(Species) %>% dplyr::summarize(mean_Sepal.Length = mean(Sepal.Length)),
         aes(x = Species, mean_Sepal.Length, fill = Species)) +
  geom_bar(stat = "identity") +
  theme_plus() +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus(scale = "y", name = "Mean Sepal Length (cm)")

#22. Default scale_focus_plus functionality coupled with other package tools.
test_plots$base_focus_plus =
  ggplot2::ggplot(diamonds, ggplot2::aes(x = clarity, fill = clarity)) +
theme_plus(enable_coaching = F) +
  ggplot2::geom_bar() +
  ggplot2::labs(x = "Clarity", y = "Count", fill = "Clarity") +
  scale_focus_plus(
    aes = "fill",
    group_var = diamonds$clarity,
    focal_groups = c("SI2", "VS2", "VVS2", "IF"),
    diff_focal = TRUE,
    diff_nonfocal = FALSE,
    labels = LETTERS[1:8],
    name = "Relabel\nlegend"
  ) +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus("y", "Rename", buffer_frac = 0.1)

test_plots$focus_plus_custom =
  ggplot2::ggplot(diamonds, ggplot2::aes(x = clarity, fill = clarity)) +
  theme_plus(enable_coaching = F) +
  ggplot2::geom_bar() +
  ggplot2::labs(x = "Clarity", y = "Count", fill = "Clarity") +
  scale_focus_plus(
    aes = "fill",
    group_var = diamonds$clarity,
    focal_groups = c("SI2", "VS2", "VVS2", "IF"),
    diff_focal = FALSE,
    diff_nonfocal = TRUE,
    guide = "none"
  ) +
  gridlines_plus() +
  yaxis_title_plus() +
  scale_continuous_plus("y", "Rename", buffer_frac = 0.1)

# Smoke test: build all plots
plot_build_results = lapply(names(test_plots), function(nm) {
  message("Building: ", nm)
  ggplot2::ggplot_build(test_plots[[nm]])
})

# Optional visual pass
for(nm in names(test_plots)) {
  message("Printing: ", nm)
  print(test_plots[[nm]])
}

# Optional save pass
# dir.create("ggplotplus_test_outputs", showWarnings = FALSE)
# for(nm in names(test_plots)) {
#   ggsave(
#     filename = file.path("ggplotplus_test_outputs", paste0(nm, ".png")),
#     plot = test_plots[[nm]],
#     width = 7,
#     height = 5,
#     dpi = 150
#   )
# }



# add-on packages to ggplot2 ----------------------------------------------
#
# library(cowplot)
# library(ggplotify)
# library(aplot)
#
# p1 = ggplot(
#   iris,
#   aes(Sepal.Length, Petal.Length, colour = Species)
# ) +
#   geom_point_plus() +
#   theme_plus()
#
# p1 = ggplotplus_to_cowplot(p1)
#
# p2 = ggplot(
#   mtcars,
#   aes(wt, mpg, shape = factor(cyl))
# ) +
#   geom_point_plus(size = 3) +
#   theme_plus()
#
# p2 = ggplotplus_to_cowplot(p2)
#
# cowplot::plot_grid(
#   p1, p2,
#   labels = c("A", "B"),
#   ncol = 2
# )
#
# library(patchwork)
#
# p1 = ggplot(
#   iris,
#   aes(Sepal.Length, Petal.Length, fill = Species)
# ) +
#   geom_point_plus(shape = 21, size = 4) +
#   theme_plus()
#
# p1 = ggplotplus_to_patchwork(p1)
#
# p2 = ggplot(
#   mtcars,
#   aes(wt, mpg, colour = factor(gear))
# ) +
#   geom_point_plus(size = 3) +
#   theme_plus()
#
# p2 = ggplotplus_to_patchwork(p2)
#
# (ggplotplus_to_patchwork(p1) | ggplotplus_to_patchwork(p2)) +
#   plot_annotation(
#     title = "ggplotplus + patchwork test"
#   )
