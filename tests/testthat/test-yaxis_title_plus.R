test_that("yaxis_title_plus builds on unfaceted plots", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point() +
    theme_plus(enable_coaching = F) +
    yaxis_title_plus()

  expect_s3_class(ggplot2::ggplotGrob(p), "gtable")
})

test_that("yaxis_title_plus builds with facets and top strips", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length)) +
    geom_point() +
    facet_wrap(~Species) +
    theme_plus(enable_coaching = F) +
    yaxis_title_plus()

  expect_s3_class(ggplot2::ggplotGrob(p), "gtable")
})

test_that("gridlines_plus builds with continuous and discrete axes", {
  p = ggplot(iris, aes(Petal.Length, Species)) +
    geom_boxplot() +
    theme_plus(enable_coaching = F) +
    yaxis_title_plus() +
    gridlines_plus()

  expect_s3_class(ggplot2::ggplotGrob(p), "gtable")
})
