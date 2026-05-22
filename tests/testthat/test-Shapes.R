test_that("geom_point_plus builds with default shapes", {
  p = ggplot(iris, aes(Petal.Length, Sepal.Length, shape = Species)) +
    geom_point_plus()

  expect_s3_class(ggplot2::ggplot_build(p), "ggplot_built")
})

test_that("base fillable shape numbers are standardized", {
  expect_equal(
    ggplotplus:::.standardize_pointplus_shape_names(c("21", 22, "plus")),
    c("circle", "square", "plus")
  )
})

test_that("NULL shape choices remain NULL", {
  expect_null(ggplotplus:::.standardize_pointplus_shape_names(NULL))
})

test_that("custom shapes validate and register", {
  test_star = data.frame(
    x = c(0.000, 0.118, 0.380, 0.190, 0.235,
          0.000, -0.235, -0.190, -0.380, -0.118),
    y = c(0.400, 0.124, 0.124, -0.047, -0.324,
          -0.153, -0.324, -0.047, 0.124, 0.124),
    piece = 1
  )

  expect_silent(add_shape_plus("test_star", test_star, overwrite = TRUE))
  expect_true("test_star" %in% names(ggplotplus:::.pointplus_shapes()))
})

test_that("invalid custom shapes error helpfully", {
  bad_shape = data.frame(x = c(0, 1), y = c(0, 1))

  expect_error(
    add_shape_plus("bad_shape", bad_shape),
    "missing"
  )
})
