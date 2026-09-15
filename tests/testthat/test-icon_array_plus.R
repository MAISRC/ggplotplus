icon_array_test_build = function(plot) {
  return(suppressMessages(ggplot2::ggplot_build(plot)))
}

icon_array_test_scale_labels = function(plot, aes) {
  built = icon_array_test_build(plot)
  scale = built$plot$scales$get_scales(aes)

  if(is.null(scale)) {
    return(NULL)
  }

  return(unname(scale$get_labels()))
}


test_that("icon_array_plus returns a buildable plot with the expected defaults", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))
  plot = ggplotplus:::icon_array_plus(vector)
  built = icon_array_test_build(plot)

  expect_true(inherits(plot, "ggplot2::ggplot"))
  expect_s3_class(built, "ggplot_built")
  expect_equal(nrow(built$data[[1]]), length(vector))
  expect_setequal(
    names(plot$layers[[1]]$mapping),
    c("x", "y", "shape", "fill")
  )
})


test_that("icon_array_plus supports each permitted aesthetic mapping", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))
  aesthetic_sets = list(
    "shape",
    "fill",
    "colour",
    "color",
    c("shape", "fill"),
    c("shape", "fill", "colour")
  )

  for(aeses in aesthetic_sets) {
    plot = ggplotplus:::icon_array_plus(vector, aeses = aeses)

    expect_s3_class(
      icon_array_test_build(plot),
      "ggplot_built"
    )
  }
})


test_that("icon_array_plus sorts by abundance before rescaling", {
  vector = c(rep("B", 51), rep("A", 49))

  sorted_plot = suppressMessages(
    ggplotplus:::icon_array_plus(vector, max_icons = 10)
  )
  conventional_plot = suppressMessages(
    ggplotplus:::icon_array_plus(
      vector,
      max_icons = 10,
      sort_descending = FALSE
    )
  )

  expect_identical(levels(sorted_plot$data$group), c("B", "A"))
  expect_identical(levels(conventional_plot$data$group), c("A", "B"))
})


test_that("icon_array_plus consolidates small groups while retaining missing values", {
  vector = c(
    rep("A", 30),
    rep("B", 20),
    rep("C", 10),
    rep("D", 8),
    rep("E", 6),
    rep("F", 4),
    rep(NA_character_, 12)
  )

  plot = ggplotplus:::icon_array_plus(
    vector,
    max_observed_groups = 3
  )
  counts = table(plot$data$group)

  expect_identical(levels(plot$data$group), c("A", "Other", "B", "Missing"))
  expect_equal(as.numeric(counts[c("A", "Other", "B", "Missing")]), c(30, 28, 20, 12))
})


###ENFORCES BOTH THAT MAX_ICONS IS A LIMIT AND ALSO THAT WE ONLY ROUND UP WHEN RESCALING AT REMAINDERS OF 0.5 AND ABOVE.
test_that("icon_array_plus treats max_icons as a limit rather than a target", {
  vector = c(rep("A", 37), rep("B", 32), rep("C", 31))
  plot = suppressMessages(
    ggplotplus:::icon_array_plus(vector, max_icons = 20)
    )
  expect_lte(nrow(plot$data), 20)
  expect_equal(nrow(plot$data), 19)
  expect_equal(as.numeric(table(plot$data$group)), c(7, 6, 6))
})

test_that("icon_array_plus applies named and unnamed labels to every mapped scale", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))
  expected_labels = c("Alpha", "Beta", "Gamma")
  label_sets = list(
    expected_labels,
    c(C = "Gamma", A = "Alpha", B = "Beta")
  )

  for(labels in label_sets) {
    plot = ggplotplus:::icon_array_plus(
      vector,
      aeses = c("shape", "fill", "colour"),
      legend_labels = labels
    )

    expect_identical(levels(plot$data$group), c("A", "B", "C"))
    expect_identical(icon_array_test_scale_labels(plot, "shape"), expected_labels)
    expect_identical(icon_array_test_scale_labels(plot, "fill"), expected_labels)
    expect_identical(icon_array_test_scale_labels(plot, "colour"), expected_labels)
  }
})


test_that("icon_array_plus permits duplicate display labels without merging groups", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))
  labels = c(A = "Same", B = "Same", C = "Different")
  plot = ggplotplus:::icon_array_plus(
    vector,
    legend_labels = labels
  )

  expect_identical(levels(plot$data$group), c("A", "B", "C"))
  expect_identical(
    icon_array_test_scale_labels(plot, "shape"),
    unname(labels)
  )
  expect_equal(length(unique(plot$data$group)), 3)
})


test_that("icon_array_plus validates legend label coverage and names", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))

  expect_error(
    ggplotplus:::icon_array_plus(vector, legend_labels = c("One", "Two")),
    "label for every displayed group"
  )
  expect_error(
    ggplotplus:::icon_array_plus(
      vector,
      legend_labels = c(X = "One", Y = "Two", Z = "Three")
    ),
    "correspond exactly"
  )
  expect_error(
    ggplotplus:::icon_array_plus(
      vector,
      legend_labels = c(A = "One", "Two", C = "Three")
    ),
    "correspond exactly"
  )
})


test_that("icon_array_plus follows its conditional discrete palette policy", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))
  fill_plot = ggplotplus:::icon_array_plus(vector, aeses = "fill")
  colour_plot = ggplotplus:::icon_array_plus(
    vector,
    aeses = c("fill", "colour")
  )
  override_plot = fill_plot +
    theme_plus(
      blank_axes = TRUE,
      end_discrete = 0.5,
      enable_coaching = FALSE
    )

  fill_values = unique(icon_array_test_build(fill_plot)$data[[1]]$fill)
  colour_mapped_fill_values = unique(
    icon_array_test_build(colour_plot)$data[[1]]$fill
  )
  override_values = unique(icon_array_test_build(override_plot)$data[[1]]$fill)

  expect_identical(tail(fill_values, 1), "#FDE725FF")
  expect_false(identical(fill_values, colour_mapped_fill_values))
  expect_false(identical(fill_values, override_values))
})


test_that("icon_array_plus respects shape selection rules", {
  vector = rep(c("A", "B", "C"), times = c(5, 3, 2))

  expect_s3_class(
    icon_array_test_build(
      ggplotplus:::icon_array_plus(
        vector,
        aeses = "shape",
        chosen_icon_shapes = c("circle", "square", "flower")
      )
    ),
    "ggplot_built"
  )
  expect_error(
    ggplotplus:::icon_array_plus(
      vector,
      aeses = "shape",
      chosen_icon_shapes = c("circle", "square")
    ),
    "at least as many unique values"
  )
  expect_error(
    ggplotplus:::icon_array_plus(
      vector,
      aeses = "fill",
      chosen_icon_shapes = c("circle", "square")
    ),
    "Only one"
  )
  expect_error(
    ggplotplus:::icon_array_plus(vector, chosen_icon_shapes = "not-a-shape"),
    "registered shape name"
  )
})


test_that("icon_array_plus rejects and removes internally controlled dot arguments", {
  vector = rep(c("A", "B"), each = 5)

  expect_warning(
    {
      mapping_plot = ggplotplus:::icon_array_plus(vector, mapping = NULL)
    },
    "constructs this input internally"
  )
  expect_s3_class(icon_array_test_build(mapping_plot), "ggplot_built")

  expect_warning(
    {
      colour_plot = ggplotplus:::icon_array_plus(
        vector,
        aeses = "colour",
        color = NULL
      )
    },
    "when .* is mapped via `aeses`"
  )
  expect_s3_class(icon_array_test_build(colour_plot), "ggplot_built")
})


test_that("icon_array_plus rejects representative invalid inputs", {
  valid_vector = rep(c("A", "B"), each = 5)

  expect_error(
    ggplotplus:::icon_array_plus(rep("A", 9)),
    "length 10 or greater"
  )
  expect_error(
    ggplotplus:::icon_array_plus(rep(NA_character_, 10)),
    "not all values"
  )
  expect_error(
    ggplotplus:::icon_array_plus(valid_vector, aeses = character(0)),
    "one or more"
  )
  expect_error(
    ggplotplus:::icon_array_plus(valid_vector, aeses = "alpha"),
    "one or more"
  )
  expect_error(
    ggplotplus:::icon_array_plus(valid_vector, max_icons = 9),
    "greater than 9"
  )
  expect_error(
    ggplotplus:::icon_array_plus(valid_vector, max_observed_groups = 0),
    "positive"
  )
  expect_error(
    ggplotplus:::icon_array_plus(valid_vector, sort_descending = NA),
    "TRUE or FALSE"
  )
})


test_that("icon_array_plus remains plusable", {
  vector = rep(c("A", "B"), each = 5)
  plot = ggplotplus:::icon_array_plus(vector) +
    ggplot2::annotate(
      "rect",
      xmin = 0.5,
      xmax = 1.5,
      ymin = 0.5,
      ymax = 2.5,
      fill = NA,
      colour = "red"
    )

  built = icon_array_test_build(plot)

  expect_length(built$data, 2)
  expect_s3_class(built, "ggplot_built")
})
