test_that("coaching warns for too many discrete fill values", {
  dat = data.frame(
    x = seq_len(10),
    y = seq_len(10),
    g = factor(seq_len(10))
  )

  p = ggplot(dat, aes(x, y, fill = g)) +
    geom_point(shape = 21) +
    theme_plus(enable_coaching = TRUE)

  expect_message(
    ggplot2::ggplot_build(p),
    "discrete variable with > 7 levels"
  )
})

test_that("coaching can be disabled locally", {
  dat = data.frame(
    x = seq_len(10),
    y = seq_len(10),
    g = factor(seq_len(10))
  )

  p = ggplot(dat, aes(x, y, fill = g)) +
    geom_point(shape = 21) +
    theme_plus(enable_coaching = FALSE)

  expect_message(
    ggplot2::ggplot_build(p),
    regexp = NA
  )
})

test_that("coaching can be disabled globally", {
  old = options(ggplotplus.enable_coaching = FALSE)
  on.exit(options(old), add = TRUE)

  dat = data.frame(
    x = seq_len(10),
    y = seq_len(10),
    g = factor(seq_len(10))
  )

  p = ggplot(dat, aes(x, y, fill = g)) +
    geom_point(shape = 21) +
    theme_plus(enable_coaching = TRUE)

  expect_message(
    ggplot2::ggplot_build(p),
    regexp = NA
  )
})


test_that("bar/column coaching is quiet when ordinary baseline is visible", {

  plot_data = iris %>%
    dplyr::group_by(Species) %>%
    dplyr::summarize(mean_Sepal.Length = mean(Sepal.Length), .groups = "drop")

  p = ggplot2::ggplot(
    plot_data,
    ggplot2::aes(y = Species, x = mean_Sepal.Length, fill = Species)
  ) +
    ggplot2::geom_col() +
    theme_plus() +
    labs(fill = "A title", x = "Another title", y = "A third title")

  expect_message(
    print(p),
    NA
  )

})

test_that("bar/column coaching warns when coord_cartesian crops out ordinary baseline", {

  plot_data = iris %>%
    dplyr::group_by(Species) %>%
    dplyr::summarize(mean_Sepal.Length = mean(Sepal.Length), .groups = "drop")

  p = ggplot2::ggplot(
    plot_data,
    ggplot2::aes(y = Species, x = mean_Sepal.Length, fill = Species)
  ) +
    ggplot2::geom_col() +
    theme_plus() +
    ggplot2::coord_cartesian(xlim = c(4, 8))

  expect_message(
    print(p),
    "omitting 0 distorts"
  )

})

test_that("bar/column coaching is quiet when log10 baseline is visible", {

  plot_data = iris %>%
    dplyr::group_by(Species) %>%
    dplyr::summarize(mean_Sepal.Length = mean(Sepal.Length), .groups = "drop")

  p = ggplot2::ggplot(
    plot_data,
    ggplot2::aes(y = Species, x = mean_Sepal.Length, fill = Species)
  ) +
    ggplot2::geom_col() +
    theme_plus() +
    ggplot2::scale_x_log10() +
    labs(fill = "A title", x = "Another title", y = "A third title")

  expect_message(
    print(p),
    NA
  )

})

test_that("bar/column coaching warns when coord_cartesian crops out log10 baseline", {

  plot_data = iris %>%
    dplyr::group_by(Species) %>%
    dplyr::summarize(mean_Sepal.Length = mean(Sepal.Length), .groups = "drop")

  p = ggplot2::ggplot(
    plot_data,
    ggplot2::aes(y = Species, x = mean_Sepal.Length, fill = Species)
  ) +
    ggplot2::geom_col() +
    theme_plus() +
    ggplot2::scale_x_log10() +
    ggplot2::coord_cartesian(xlim = c(3, 8))

  expect_message(
    print(p),
    "omitting 0 distorts"
  )

})

test_that("bar/column coaching checks all visible panels", {

  plot_data = data.frame(
    group = rep(c("a", "b", "c"), 2),
    facet = rep(c("one", "two"), each = 3),
    value = c(2, 3, 4, 20, 30, 40)
  )

  p = ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = group, y = value)
  ) +
    theme_plus() +
    ggplot2::geom_col() +
    ggplot2::facet_wrap(ggplot2::vars(facet), scales = "free_y") +
    ggplot2::coord_cartesian(ylim = c(10, 45))

  expect_message(
    print(p),
    "omitting 0 distorts"
  )

})


test_that("bar/column coaching ignores non-bar geoms", {

  p = ggplot2::ggplot(
    iris,
    ggplot2::aes(x = Sepal.Length, y = Sepal.Width)
  ) +
    theme_plus() +
    ggplot2::geom_point() +
    labs(x = "A title", y = "Another title") +
    ggplot2::coord_cartesian(y = c(3, 5))

  expect_message(
    print(p),
    NA
  )

})
