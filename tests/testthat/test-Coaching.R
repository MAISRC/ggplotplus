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
