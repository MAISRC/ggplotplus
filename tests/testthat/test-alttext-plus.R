test_that("add_alttext_plus adds alt text to a plot", {

  p = ggplot2::ggplot(
    iris,
    ggplot2::aes(x = Sepal.Length, y = Petal.Length)
  ) +
    ggplot2::geom_point() +
    add_alttext_plus("A scatterplot of sepal length and petal length.")

  expect_equal(
    ggplot2::get_alt_text(p),
    "A scatterplot of sepal length and petal length."
  )

})


test_that("add_alttext_plus rejects invalid alt text", {

  invalid_text = list(
    NULL,
    character(),
    "",
    NA_character_,
    c("First description.", "Second description."),
    1
  )

  for(text in invalid_text) {
    expect_error(
      add_alttext_plus(text),
      "must be a length-one, non-empty character string",
      fixed = TRUE
    )
  }

})
