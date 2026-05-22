test_that("scale_continuous_plus builds for x and y scales", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point() +
    scale_continuous_plus(scale = "x", name = "Petal length (cm)") +
    scale_continuous_plus(scale = "y", name = "Sepal length (cm)") +
    theme_plus(enable_coaching = F)

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("scale_continuous_plus supports thinned labels", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point() +
    scale_continuous_plus(scale = "x", thin.labels = TRUE)

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})
