test_that("ggplotplus plots convert to cowplot-compatible grobs", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length, fill = Species)) +
    geom_point_plus() +
    theme_plus(enable_coaching = F)

  expect_s3_class(ggplotplus_to_cowplot(p), "grob")
})

test_that("ggplotplus plots convert to patchwork elements when patchwork is installed", {
  skip_if_not_installed("patchwork")

  p = ggplot(iris, aes(Petal.Length, Sepal.Length, fill = Species)) +
    geom_point_plus() +
    theme_plus(enable_coaching = F)

  expect_s3_class(ggplotplus_to_patchwork(p), "wrapped_patch")
})
