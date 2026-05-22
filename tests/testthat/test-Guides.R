test_that("constant alpha and size do not break legend building", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point(aes(fill = Species), shape = 21, alpha = 0.3, size = 1) +
    theme_plus(enable_coaching = F)

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("suppressed guides are not restored", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point(aes(fill = Species), shape = 21, alpha = 0.3, size = 1) +
    scale_fill_discrete(guide = "none") +
    theme_plus(enable_coaching = F)

  built = ggplot2::ggplot_build(p)

  expect_true(ggplotplus:::.guide_is_none_for_aes(p, "fill"))
  expect_s3_class(built, "ggplot_built")
})

test_that("user guide overrides are preserved", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point(aes(fill = Species), shape = 21, alpha = 0.3, size = 1) +
    guides(fill = guide_legend(override.aes = list(alpha = 0.8, size = 2))) +
    theme_plus(enable_coaching = F)

  built = ggplot2::ggplot_build(p)

  guide = built@plot@guides$guides[[1]]
  expect_equal(guide$params$override.aes$alpha, 0.8)
  expect_equal(guide$params$override.aes$size, 2)
})

test_that("merged fill and shape legends do not warn about duplicated override.aes", {
  p = ggplot(iris, aes(Sepal.Width, Sepal.Length, fill = Species, shape = Species)) +
    geom_point_plus(colour = "black") +
    theme_plus(legend.position = "top",
               enable_coaching = F)

  expect_warning(
    ggplot2::ggplot_build(p),
    regexp = NA
  )
})
