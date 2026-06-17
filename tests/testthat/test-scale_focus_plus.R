test_that("scale_focus_plus returns a ggplot2 scale for colour and fill", {

  group_var = c("a", "b", "c", "d")

  expect_s3_class(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a"),
    "Scale"
  )

  expect_s3_class(
    scale_focus_plus(aes = "color",
                     group_var = group_var,
                     focal_groups = "a"),
    "Scale"
  )

  expect_s3_class(
    scale_focus_plus(aes = "fill",
                     group_var = group_var,
                     focal_groups = "a"),
    "Scale"
  )
})


test_that("scale_focus_plus applies one shared non-focal color by default", {

  dat = data.frame(
    x = 1:4,
    y = 1:4,
    group = c("a", "b", "c", "d")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = "a")

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_length(unique(plot_cols[names(plot_cols) != "a"]), 1)
  expect_false(plot_cols["a"] %in% plot_cols[names(plot_cols) != "a"])
})


test_that("scale_focus_plus differentiates non-focal colors when requested", {

  dat = data.frame(
    x = 1:4,
    y = 1:4,
    group = c("a", "b", "c", "d")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = "a",
                     diff_nonfocal = TRUE)

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_length(unique(plot_cols[names(plot_cols) != "a"]), 3)
})


test_that("scale_focus_plus differentiates focal colors by default", {

  dat = data.frame(
    x = 1:5,
    y = 1:5,
    group = c("a", "b", "c", "d", "e")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = c("a", "b"))

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_false(identical(plot_cols["a"], plot_cols["b"]))
  expect_length(unique(plot_cols[c("c", "d", "e")]), 1)
})


test_that("scale_focus_plus can use one shared focal color", {

  dat = data.frame(
    x = 1:5,
    y = 1:5,
    group = c("a", "b", "c", "d", "e")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = c("a", "b"),
                     diff_focal = FALSE)

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_identical(unname(plot_cols["a"]), unname(plot_cols["b"]))
  expect_false(plot_cols["a"] %in% plot_cols[c("c", "d", "e")])
})


test_that("scale_focus_plus respects custom differentiated focal colors", {

  dat = data.frame(
    x = 1:5,
    y = 1:5,
    group = c("a", "b", "c", "d", "e")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = c("a", "b"),
                     custom_focal = c(a = "red", b = "blue"))

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_identical(unname(plot_cols["a"]), "red")
  expect_identical(unname(plot_cols["b"]), "blue")
})


test_that("scale_focus_plus respects one shared custom focal color", {

  dat = data.frame(
    x = 1:5,
    y = 1:5,
    group = c("a", "b", "c", "d", "e")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = c("a", "b"),
                     diff_focal = FALSE,
                     custom_focal = "purple")

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_identical(unname(plot_cols["a"]), "purple")
  expect_identical(unname(plot_cols["b"]), "purple")
})


test_that("scale_focus_plus respects custom differentiated non-focal colors", {

  dat = data.frame(
    x = 1:4,
    y = 1:4,
    group = c("a", "b", "c", "d")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = "a",
                     diff_nonfocal = TRUE,
                     custom_nonfocal = c(b = "gray20",
                                         c = "gray50",
                                         d = "gray80"))

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour
  names(plot_cols) = dat$group

  expect_identical(unname(plot_cols["b"]), "gray20")
  expect_identical(unname(plot_cols["c"]), "gray50")
  expect_identical(unname(plot_cols["d"]), "gray80")
})


test_that("scale_focus_plus works for fill scales", {

  dat = data.frame(
    group = c("a", "b", "c", "d"),
    value = c(5, 8, 3, 6)
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = group,
                                        y = value,
                                        fill = group)) +
    ggplot2::geom_col() +
    scale_focus_plus(aes = "fill",
                     group_var = dat$group,
                     focal_groups = "b",
                     custom_focal = "orange",
                     diff_focal = FALSE)

  built = ggplot2::ggplot_build(p)
  plot_fills = built$data[[1]]$fill
  names(plot_fills) = dat$group

  expect_identical(unname(plot_fills["b"]), "orange")
  expect_length(unique(plot_fills[names(plot_fills) != "b"]), 1)
})


test_that("scale_focus_plus forwards arguments to scale manual", {

  dat = data.frame(
    x = 1:4,
    y = 1:4,
    group = c("a", "b", "c", "d")
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_focus_plus(aes = "colour",
                     group_var = dat$group,
                     focal_groups = "a",
                     name = "My grouping variable",
                     breaks = c("a", "b"))

  built = ggplot2::ggplot_build(p)
  trained_scale = built$plot$scales$get_scales("colour")

  expect_equal(trained_scale$name, "My grouping variable")
  expect_equal(
    as.character(trained_scale$get_breaks()), #<--OTHERWISE, CHECKS THE POSITIONS ATTR.--THE LABELS ARE THE NAMES HERE.
    c("a", "b")
  )
})


test_that("scale_focus_plus warns and ignores user-provided values", {

  dat = data.frame(
    x = 1:4,
    y = 1:4,
    group = c("a", "b", "c", "d")
  )

  expect_warning(
    { #THE FIRST ARG NEEDS TO BE "OBJECT" SO WE CAN'T DO ASSIGNMENT "INSIDE" THAT ARG UNLESS WE BRACE TO SCOPE IT.
      scale_obj = scale_focus_plus(aes = "colour",
                                   group_var = dat$group,
                                   focal_groups = "a",
                                   values = c(a = "black",
                                              b = "black",
                                              c = "black",
                                              d = "black"))
    },
    regexp = "Don't provide a `values` argument"
  )

  p = ggplot2::ggplot(dat, ggplot2::aes(x = x,
                                        y = y,
                                        colour = group)) +
    ggplot2::geom_point(size = 4) +
    scale_obj

  built = ggplot2::ggplot_build(p)
  plot_cols = built$data[[1]]$colour

  expect_false(all(plot_cols == "black"))
})


test_that("scale_focus_plus rejects invalid inputs", {

  group_var = c("a", "b", "c")

  expect_error(
    scale_focus_plus(aes = "alpha",
                     group_var = group_var,
                     focal_groups = "a"),
    regexp = "'arg' should be one of"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = c("a", "a", "a"),
                     focal_groups = "a"),
    regexp = "Invalid `group_var`"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = 1),
    regexp = "Invalid `focal_groups`"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "z"),
    regexp = "must be present"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = c("a", "b", "c")),
    regexp = "not enough unique levels"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     gray_start = -0.1),
    regexp = "between"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     custom_focal = c(a = "red", b = "blue")),
    regexp = "Invalid `custom_focal`"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_nonfocal = TRUE,
                     custom_nonfocal = c(b = "gray20")),
    regexp = "Invalid `custom_nonfocal`"
  )
})


test_that("scale_focus_plus rejects invalid diff_focal and diff_nonfocal inputs", {

  group_var = c("a", "b", "c")

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_focal = NA),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_nonfocal = NA),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_focal = c(TRUE, FALSE)),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_nonfocal = c(TRUE, FALSE)),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_focal = 1),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_nonfocal = "yes"),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_focal = NULL),
    regexp = "length-1 logical"
  )

  expect_error(
    scale_focus_plus(aes = "colour",
                     group_var = group_var,
                     focal_groups = "a",
                     diff_nonfocal = NULL),
    regexp = "length-1 logical"
  )
})
