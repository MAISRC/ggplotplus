# library(ggplot2)
# library(colorspace)
# library(ggplotplus)
# library(patchwork)
#
# set.seed(123)
#
# n = 50
#
# d = data.frame(
#   x = rnorm(n),
#   y = rnorm(n),
#   uncertainty = runif(n, 0, 1),
#   se_x = runif(n, 0.05, 0.25),
#   se_y = runif(n, 0.05, 0.25)
# )
#
# base = ggplot(d, aes(x, y)) +
#   coord_equal() +
#   theme_minimal() +
#   labs(
#     x = "x",
#     y = "y"
#   ) +
#   theme_plus()
#
#
#
# p1 = base +
#   geom_point(
#     aes(alpha = uncertainty),
#     size = 4
#   ) +
#   scale_alpha(
#     range = c(1, 0),
#   ) +
#   labs(
#     alpha = "Uncertainty"
#   )
#
# p2 = base +
#   geom_point(
#     aes(size = uncertainty)
#   ) +
#   scale_size(
#     range = c(7, 1.5),
#     limits = c(0, 1)
#   ) +
#   labs(
#     size = "Uncertainty"
#   )
#
# p3 = base +
#   geom_rect(
#     aes(
#       xmin = x - 2 * se_x,
#       xmax = x + 2 * se_x,
#       ymin = y - 2 * se_y,
#       ymax = y + 2 * se_y
#     ),
#     fill = NA,
#     colour = "#bbb",
#     linewidth = 0.5
#   ) +
#   geom_point(
#     size = 2
#   )
# chroma_pal = colorspace::hex(
#   colorspace::polarLUV(
#     L = rep(50, 100),
#     C = seq(100, 0, length.out = 100),
#     H = rep(250, 100)
#   ),
#   fixup = TRUE
# )
#
# p4 = base +
#   geom_point(
#     aes(colour = uncertainty),
#     size = 4
#   ) +
#   scale_colour_gradientn(
#     colours = chroma_pal,
#     limits = c(0, 1)
#   ) +
#   labs(
#     colour = "Uncertainty"
#   )
#
# (ggplotplus_to_patchwork(p1) | ggplotplus_to_patchwork(p2) | ggplotplus_to_patchwork(p4))
#
#
#
#
#




# icon array prototyping --------------------------------------------------




#
# testDF = .iconarrayize(sample(LETTERS[1:3], 36, replace = T))
#
# ggplot(testDF, aes(x, y, fill = group, shape = group)) +
#   geom_point_plus(size = 10) +
#   theme_plus(blank_axes = T, enable_coaching = F)
#
# testDF2 = .iconarrayize(sample(LETTERS[1:4], 93, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)))
#
# ggplot(testDF2, aes(x = x, y = y, fill = group, shape = group)) +
#   geom_point_plus(size = 10) +
#   theme_plus(blank_axes = T, enable_coaching = F, begin_discrete = 0, end_discrete = 1)
#
# testDF3 = .iconarrayize(sample(LETTERS[1:4], 138, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)))
#
# ggplot(testDF3, aes(x, y, fill = group, shape = group)) +
#   geom_point_plus(size = 10) +
#   theme_plus(blank_axes = T, enable_coaching = F, begin_discrete = 0, end_discrete = 1)
#
# testDF4 = .iconarrayize(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = F)
#
# ggplot(testDF4, aes(x, y, fill = group, shape = group)) +
#   geom_point_plus(size = 10) +
#   theme_plus(blank_axes = T, enable_coaching = F, begin_discrete = 0, end_discrete = 1)
#




#TEST 1
icon_array_plus(vector = sample(LETTERS[1:3], 36, replace = T))

#TEST 2
icon_array_plus(sample(LETTERS[1:4], 93, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)))

#TEST 3
icon_array_plus(sample(LETTERS[1:4], 138, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)))

#TEST 4
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = F)

#TEST 5
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T)

#TEST 6
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T, aeses = c("color", "shape"))

#TEST 7
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T, aeses = c("shape"))

#TEST 8
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T, aeses = c("fill"))

#TEST 9
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower")

#TEST 10
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", icon_size = 5)

#TEST 11
icon_array_plus(sample(LETTERS[1:7], 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.08)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", include_legend = F)

#TEST 12
icon_array_plus(sample(c(LETTERS[1:6], NA), 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.3)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", na_label = "Whoops!")

#TEST 13
icon_array_plus(sample(c(LETTERS[1:6], NA), 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.3)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", other_label = "Damn.")

#TEST 14
icon_array_plus(sample(c(LETTERS[1:6], NA), 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.3)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", other_label = "Damn.", legend_title = "All them groups!")

#TEST 15
icon_array_plus(sample(c(LETTERS[1:6], NA), 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.3)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", other_label = "Damn.", legend_title = "All them groups!", legend_icon_size = 12)

#TEST 16
icon_array_plus(sample(c(LETTERS[1:6], NA), 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.3)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", other_label = "Damn.", legend_title = "All them groups!", legend_icon_size = 12, max_observed_groups = 3)

#TEST 17
icon_array_plus(sample(c(LETTERS[1:6], NA), 74, replace = T, prob = c(0.1, 0.3, 0.4, 0.2, 0.1, 0.05, 0.3)), consolidate_small_groups = T, aeses = c("fill"), chosen_icon_shapes = "flower", other_label = "Damn.", legend_title = "All them groups!", legend_icon_size = 12, max_observed_groups = 3, max_icons = 48)

#TEST 18
{set.seed(475)
testV = sample(LETTERS[1:3], 36, replace = T)
}
icon_array_plus(vector = testV, sort_descending = F)

#TEST 19
icon_array_plus(vector = testV)

#TEST 20
icon_array_plus(vector = testV, legend_labels = c("Yes", "No", "Maybe"))

#TEST 21
icon_array_plus(vector = testV, legend_labels = c("C" = "Highest", "A" = "Middle", "B" = "Lowest"))

#TEST 21
icon_array_plus(vector = testV, legend_labels = c("Yes", "No", "Maybe"), sort_descending = F)

#TEST 22
icon_array_plus(sample(LETTERS[1:4], 138, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)), max_icons = 138)

#TEST 23
icon_array_plus(aeses = c("shape", "fill", "colour"), vector = sample(LETTERS[1:4], 138, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)), max_icons = 138)

#TEST 24
icon_array_plus(aeses = c("shape", "fill"), vector = sample(LETTERS[1:4], 138, replace = T, prob = c(0.1, 0.3, 0.4, 0.2)), max_icons = 138) + theme_plus(blank_axes = T, end_discrete = 0.5)
