
# Shared minimal test data ------------------------------------------------

point_data = data.frame(
  x     = c(1, 2, 3, 4, 5, 6),
  y     = c(1, 3, 2, 6, 5, 7),
  group = c("A", "A", "A", "B", "B", "B")
)

line_data = data.frame(
  x     = c(1, 2, 3, 1, 2, 3),
  y     = c(1, 3, 2, 4, 6, 5),
  group = c("A", "A", "A", "B", "B", "B")
)

facet_data = data.frame(
  x      = c(1, 2, 3, 4, 1, 2, 3, 4),
  y      = c(1, 2, 3, 4, 5, 6, 7, 8),
  group  = c("A", "A", "B", "B", "A", "A", "B", "B"),
  panel  = c("p1", "p1", "p1", "p1", "p2", "p2", "p2", "p2")
)


# .directlabel_points() ---------------------------------------------------

test_that(".directlabel_points returns one row per group", {
  result = ggplotplus:::.directlabel_points(
    data      = point_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "top",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(nrow(result), 2L)
  expect_setequal(result$.label_plus, c("A", "B"))
})

test_that(".directlabel_points returns required columns", {
  result = ggplotplus:::.directlabel_points(
    data      = point_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "top",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_true(all(c("x", "y", ".label_plus", "group") %in% names(result)))
})

test_that(".directlabel_points works for all four placements", {
  for(placement in c("top", "bottom", "left", "right")) {
    result = ggplotplus:::.directlabel_points(
      data      = point_data,
      x         = x,
      y         = y,
      group     = group,
      placement = placement,
      adj_fact  = 0,
      facet_vars = NULL
    )
    expect_equal(nrow(result), 2L, info = paste("placement =", placement))
  }
})

test_that(".directlabel_points top placement picks from near the max y", {
  result = ggplotplus:::.directlabel_points(
    data      = point_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "top",
    adj_fact  = 0,
    facet_vars = NULL
  )

  # For group A (y = 1, 3, 2), closest to max y = 3 should be row with y = 3
  expect_equal(result$y[result$.label_plus == "A"], 3)
  # For group B (y = 6, 5, 7), closest to max y = 7 should be row with y = 7
  expect_equal(result$y[result$.label_plus == "B"], 7)
})

test_that(".directlabel_points bottom placement picks from near the min y", {
  result = ggplotplus:::.directlabel_points(
    data      = point_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "bottom",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(result$y[result$.label_plus == "A"], 1)
  expect_equal(result$y[result$.label_plus == "B"], 5)
})

test_that(".directlabel_points right placement picks from near the max x", {
  result = ggplotplus:::.directlabel_points(
    data      = point_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "right",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(result$x[result$.label_plus == "A"], 3)
  expect_equal(result$x[result$.label_plus == "B"], 6)
})

test_that(".directlabel_points with facet_vars returns one row per group-facet combo", {
  result = ggplotplus:::.directlabel_points(
    data       = facet_data,
    x          = x,
    y          = y,
    group      = group,
    placement  = "top",
    adj_fact   = 0,
    facet_vars = "panel"
  )

  expect_equal(nrow(result), 4L) # 2 groups * 2 panels
})

test_that(".directlabel_points doesn't error when a group has a single point (zero range)", {
  single_point_data = data.frame(
    x     = c(1, 2, 3, 5),
    y     = c(1, 2, 3, 5),
    group = c("A", "A", "A", "B") # B has one point
  )

  expect_no_error(
    ggplotplus:::.directlabel_points(
      data      = single_point_data,
      x         = x,
      y         = y,
      group     = group,
      placement = "top",
      adj_fact  = 0,
      facet_vars = NULL
    )
  )
})


# .directlabel_lines() ----------------------------------------------------

test_that(".directlabel_lines returns one row per group", {
  result = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "right",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(nrow(result), 2L)
  expect_setequal(result$.label_plus, c("A", "B"))
})

test_that(".directlabel_lines right placement picks the max-x row per group", {
  result = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "right",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(result$x[result$.label_plus == "A"], 3)
  expect_equal(result$x[result$.label_plus == "B"], 3)
})

test_that(".directlabel_lines left placement picks the min-x row per group", {
  result = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "left",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(result$x[result$.label_plus == "A"], 1)
  expect_equal(result$x[result$.label_plus == "B"], 1)
})

test_that(".directlabel_lines top placement picks the max-y row per group", {
  result = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "top",
    adj_fact  = 0,
    facet_vars = NULL
  )

  # Group A: y = 1, 3, 2 -> max is 3
  expect_equal(result$y[result$.label_plus == "A"], 3)
  # Group B: y = 4, 6, 5 -> max is 6
  expect_equal(result$y[result$.label_plus == "B"], 6)
})

test_that(".directlabel_lines bottom placement picks the min-y row per group", {
  result = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "bottom",
    adj_fact  = 0,
    facet_vars = NULL
  )

  expect_equal(result$y[result$.label_plus == "A"], 1)
  expect_equal(result$y[result$.label_plus == "B"], 4)
})

test_that(".directlabel_lines adj_fact shifts anchor outward for right placement", {
  result_no_adj = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "right",
    adj_fact  = 0,
    facet_vars = NULL
  )

  result_adj = ggplotplus:::.directlabel_lines(
    data      = line_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "right",
    adj_fact  = 0.1,
    facet_vars = NULL
  )

  expect_true(all(result_adj$x > result_no_adj$x))
})

test_that(".directlabel_lines with facet_vars returns one row per group-facet combo", {
  result = ggplotplus:::.directlabel_lines(
    data       = facet_data,
    x          = x,
    y          = y,
    group      = group,
    placement  = "right",
    adj_fact   = 0,
    facet_vars = "panel"
  )

  expect_equal(nrow(result), 4L)
})


# .apply_key_labels_plus() ------------------------------------------------

test_that(".apply_key_labels_plus returns data unchanged when key_labels is NULL", {
  labels = c("A", "B", "A", "B")
  expect_equal(ggplotplus:::.apply_key_labels_plus(labels, NULL), labels)
})

test_that(".apply_key_labels_plus applies a function to labels", {
  labels = c("a", "b", "a")
  result = ggplotplus:::.apply_key_labels_plus(labels, toupper)
  expect_equal(result, c("A", "B", "A"))
})

test_that(".apply_key_labels_plus swaps labels using a named vector", {
  labels = c("A", "B", "A")
  result = ggplotplus:::.apply_key_labels_plus(labels, c("A" = "Group A", "B" = "Group B"))
  expect_equal(result, c("Group A", "Group B", "Group A"))
})

test_that(".apply_key_labels_plus errors when a named vector is missing a group", {
  labels = c("A", "B", "C")
  expect_error(
    ggplotplus:::.apply_key_labels_plus(labels, c("A" = "Group A", "B" = "Group B")),
    regexp = "missing replacement"
  )
})

test_that(".apply_key_labels_plus errors when a named vector has any unnamed elements", {
  labels = c("A", "B")
  expect_error(
    ggplotplus:::.apply_key_labels_plus(labels, c("A" = "Group A", "Group B")),
    regexp = "must have names"
  )
})

test_that(".apply_key_labels_plus assigns unnamed vector in alphanumeric order with a message", {
  labels = c("B", "A", "B", "A")
  expect_message(
    result <- ggplotplus:::.apply_key_labels_plus(labels, c("Alpha", "Beta")),
    regexp = "alphanumeric"
  )
  # A -> Alpha, B -> Beta
  expect_equal(result, c("Beta", "Alpha", "Beta", "Alpha"))
})

test_that(".apply_key_labels_plus errors when unnamed vector length doesn't match group count", {
  labels = c("A", "B", "C")
  expect_error(
    ggplotplus:::.apply_key_labels_plus(labels, c("X", "Y")),
    regexp = "one label per group"
  )
})


# direct_labels_plus() input validation -----------------------------------

test_that("direct_labels_plus errors when data is not a data frame", {
  expect_error(
    direct_labels_plus(data = "not a data frame", x = x, y = y, group = group),
    regexp = "data frame"
  )
})

test_that("direct_labels_plus errors on invalid placement", {
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = group, placement = "diagonal"),
    regexp = "arg"
  )
})

test_that("direct_labels_plus errors on invalid geometry", {
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = group, geometry = "ribbon"),
    regexp = "arg"
  )
})

test_that("direct_labels_plus errors when group is an expression rather than a bare name", {
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = toupper(group)),
    regexp = "bare column name"
  )
})

test_that("direct_labels_plus errors when adj_fact is not a single numeric", {
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = group, adj_fact = "a lot"),
    regexp = "numeric"
  )
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = group, adj_fact = c(0.1, 0.2)),
    regexp = "numeric"
  )
})

test_that("direct_labels_plus errors when facet_vars contains more than two names", {
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = group, facet_vars = c("a", "b", "c")),
    regexp = "<= 2"
  )
})

test_that("direct_labels_plus errors when facet_vars names are not in data", {
  expect_error(
    direct_labels_plus(data = point_data, x = x, y = y, group = group, facet_vars = "nonexistent"),
    regexp = "not found"
  )
})


# direct_labels_plus() output ---------------------------------------------

test_that("direct_labels_plus returns a ggplot2 layer", {
  layer = direct_labels_plus(
    data      = point_data,
    x         = x,
    y         = y,
    group     = group,
    placement = "top",
    geometry  = "point"
  )

  expect_true(inherits(layer, "Layer"))
})

test_that("direct_labels_plus builds successfully for point geometry", {
  p = ggplot2::ggplot(point_data, ggplot2::aes(x, y, color = group)) +
    ggplot2::geom_point() +
    direct_labels_plus(
      data      = point_data,
      x         = x,
      y         = y,
      group     = group,
      placement = "top",
      geometry  = "point"
    )

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("direct_labels_plus builds successfully for line geometry", {
  p = ggplot2::ggplot(line_data, ggplot2::aes(x, y, color = group)) +
    ggplot2::geom_line(ggplot2::aes(group = group)) +
    direct_labels_plus(
      data      = line_data,
      x         = x,
      y         = y,
      group     = group,
      placement = "right",
      geometry  = "line"
    )

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("direct_labels_plus with key_labels named vector builds without error", {
  p = ggplot2::ggplot(point_data, ggplot2::aes(x, y, color = group)) +
    ggplot2::geom_point() +
    direct_labels_plus(
      data       = point_data,
      x          = x,
      y          = y,
      group      = group,
      placement  = "top",
      geometry   = "point",
      key_labels = c("A" = "Group A", "B" = "Group B")
    )

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("direct_labels_plus with facet_vars builds without error", {
  p = ggplot2::ggplot(facet_data, ggplot2::aes(x, y, color = group)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~panel) +
    direct_labels_plus(
      data       = facet_data,
      x          = x,
      y          = y,
      group      = group,
      placement  = "top",
      geometry   = "point",
      facet_vars = "panel"
    )

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("direct_labels_plus passes dot args through to geom_label_repel", {
  # size is one of the overridable ggrepel defaults; passing a custom value
  # should not produce an error or warning
  expect_no_error(
    direct_labels_plus(
      data      = point_data,
      x         = x,
      y         = y,
      group     = group,
      placement = "top",
      geometry  = "point",
      size      = 3
    )
  )
})
