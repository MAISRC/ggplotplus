baseGG = ggplot2::ggplot(data = iris,
                         mapping = ggplot2::aes(x = Petal.Length,
                                                y = Sepal.Length)) +
  ggplot2::geom_point(mapping = ggplot2::aes(fill = Species),
                      shape = 21) +
  ggplot2::theme_bw()

ggplot2::ggsave(filename = "baseGG.png",
                plot = baseGG,
                dpi = 600,
                width = 7,
                height = 5.26)


lm1 = lm(Sepal.Length ~ Petal.Length * Species, data = iris)
summary(lm1)
anova(lm1)

ggplotplusGG = ggplot2::ggplot(data = iris,
                               mapping = ggplot2::aes(x = Petal.Length,
                                                      y = Sepal.Length)) +
  ggplotplus::geom_point_plus(mapping = ggplot2::aes(fill = Species,
                                                     shape = Species),
                              alpha = 0.5, legend_labels = c("Iris setosa", "I. versicolor", "I. virginica")) +
  ggplotplus::theme_plus(export_width = 7,
                         export_height = 5.26,
                         legend.text = element_text(face = "italic")) +
  ggplotplus::gridlines_plus() +
  ggplotplus::yaxis_title_plus() +
  ggplotplus::scale_continuous_plus(scale = "x",
                                    name = "Petal length (cm)",
                                    thin.labels = TRUE) +
  ggplotplus::scale_continuous_plus(scale = "y",
                                    name = "Sepal length (cm)",
                                    thin.labels = TRUE) +
  ggplot2::labs(fill = "", shape = "") +
  annotate(geom = "text", x = 1.1, y = 7.75, label = 'F["Petal length × Species"] == 1.68', parse = TRUE, size = 5.5, hjust = 0) +
  annotate(geom = "text", x = 1.1, y = 7.4, label = 'italic(p) == 0.190', parse = TRUE, size = 5.5, hjust = 0) +
  scale_fill_viridis_d(labels = c("Iris setosa", "I. versicolor", "I. virginica"))

ggplot2::ggsave(filename = "ggplotplusGG.png",
                plot = ggplotplusGG,
                dpi = 600,
                width = 7,
                height = 5.26)


ggplotplusGreyMode = ggplot2::ggplot(data = iris,
                                     mapping = ggplot2::aes(x = Petal.Length,
                                                            y = Sepal.Length)) +
  ggplotplus::geom_point_plus(mapping = ggplot2::aes(fill = Species,
                                                     shape = Species),
                              alpha = 0.8, legend_labels = c("Iris setosa", "I. versicolor", "I. virginica")) +
  ggplotplus::theme_plus(export_width = 7,
                         export_height = 5.26,
                         legend.text = element_text(face = "italic")) +
  ggplotplus::gridlines_plus() +
  ggplotplus::yaxis_title_plus() +
  ggplotplus::scale_continuous_plus(scale = "x",
                                    name = "Petal length (cm)",
                                    thin.labels = TRUE) +
  ggplotplus::scale_continuous_plus(scale = "y",
                                    name = "Sepal length (cm)",
                                    thin.labels = TRUE) +
  ggplot2::labs(fill = "", shape = "") +
  annotate(geom = "text", x = 1.1, y = 7.75, label = 'F["Petal length × Species"] == 1.68', parse = TRUE, size = 5.5, hjust = 0) +
  annotate(geom = "text", x = 1.1, y = 7.4, label = 'italic(p) == 0.190', parse = TRUE, size = 5.5, hjust = 0) +
  scale_fill_manual(values = c("gray70", viridis(1, begin = 0.7, end = 0.7), "gray70"),
                    labels = c("Iris setosa", "I. versicolor", "I. virginica"))

ggplot2::ggsave(filename = "ggplotplusGreyMode.png",
                plot = ggplotplusGreyMode,
                dpi = 600,
                width = 7,
                height = 5.26)

ggplot2::ggsave(filename = "ggplotplusShapes.png",
                plot = geom_point_plus_shapes(),
                dpi = 600,
                width = 7,
                height = 5.26)
