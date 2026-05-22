library(ggplot2)
library(ggplotplus) #INSTALL USING THE INSTRUCTIONS AVAILABLE ON THE PACKAGE'S GITHUB ACCOUNT.
#FIGURE 1: BASE GGPLOT. OTHER THAN USING THE THEME_BW() THEME AND A SPECIFIC SCATTERPLOT POINT SHAPE, THE CONDITIONS OF THIS GRAPH LARGELY REPRESENT THOSE OF A DEFAULT GGPLOT GRAPH AS WELL AS, BY EXTENTION, THE AVERAGE GRAPH PUBLISHED IN AN ECOLOGICAL JOURNAL.
baseGG = ggplot2::ggplot(data = iris, #IRIS FLOWER DATA
                         mapping = ggplot2::aes(x = Petal.Length, #MAPPING CONTINUOUS DATA TO THE TWO PRIMARY POSITIONAL SCALES.
                                                y = Sepal.Length)) +
  ggplot2::geom_point(mapping = ggplot2::aes(fill = Species), #SPECIES DIFFERENTIATED BY POINT FILL COLORS.
                      shape = 21) + #A POINT WITH SEPARATE OUTLINE AND FILL COLOR CHANNELS.
  ggplot2::theme_bw() #A BUILT-IN BLACK AND WHITE GGPLOT2 THEME.

#SAVE THIS GRAPH AS A PNG FILE WITH SPECIFIC RESOLUTION.
ggplot2::ggsave(filename = "baseGG.png",
                plot = baseGG,
                dpi = 600,
                width = 7,
                height = 5.26)


#CODE TO RUN A SIMPLE REGRESSION MODEL TO GENERATE STATISTICS FOR INCORPORATION INTO THE ANNOTATION IN THE PLOT BELOW.
lm1 = lm(Sepal.Length ~ Petal.Length * Species, data = iris)
anova(lm1)


#FIGURE 2: GGPLOTPLUS-AUGMENTED GGPLOT. THIS DEMONSTRATES THE CORE FUNCTIONALITIES OF THE GGPLOTPLUS PACKAGE THAT MOVE THE GRAPH A LONG WAYS TOWARDS BEING UNIVERSALLY DESIGNED.
ggplotplusGG = ggplot2::ggplot(data = iris,
                               mapping = ggplot2::aes(x = Petal.Length,
                                                      y = Sepal.Length)) +
  ggplotplus::geom_point_plus(mapping = ggplot2::aes(fill = Species,
                                                     shape = Species), #DOUBLE-MAPPING SHAPE AND COLOR FOR ENHANCED DISTINGUISHABILITY. ACCESS TO A CUSTOM PALETTE OF DISTINGUISHABLE SHAPES IS ALSO AFFORDED.
                              alpha = 0.5, #SEMI-TRANSPARENCY TO REVEAL OVERPLOTTED POINTS.
                              legend_labels = c("Iris setosa", "I. versicolor", "I. virginica")) + #USING MORE CONVENTIONAL/COMPLETE SPECIES NAMES FOR GREATER UNIVERSALITY.
  ggplotplus::theme_plus(export_width = 7, #TAILORING ELEMENT SIZING TO FINAL EXPORT SIZE OF GRAPH.
                         export_height = 5.26,
                         legend.text = element_text(face = "italic")) + #ITALICIZING SPECIES NAMES ACCORDING TO CONVENTION
  ggplotplus::gridlines_plus() + #VERY MINIMAL GRIDLINES (OPTIONAL; SHOWN ONLY AS DEMONSTRATION)
  ggplotplus::yaxis_title_plus() + #ROTATE AND RELOCATE Y AXIS TITLE TO TOP OF GRAPH.
  ggplotplus::scale_continuous_plus(scale = "x", #FORCE X AND Y AXIS SCALES TO HAVE LABELS AT OR NEAR THE LIMITS OF THE DATA MAPPED TO THEM.
                                    name = "Petal length (cm)", #PROVIDE CUSTOM AXIS LABEL FOR ENHANCED READABILITY.
                                    thin.labels = TRUE) + #BLANK EVERY OTHER LABEL TO REDUCE COGNITIVE LOAD.
  ggplotplus::scale_continuous_plus(scale = "y",
                                    name = "Sepal length (cm)",
                                    thin.labels = TRUE) +
  ggplot2::labs(fill = "", shape = "") + #ELIMINATE SELF-EVIDENCE SCALE TITLE.
  annotate(geom = "text", x = 1.1, y = 7.75, label = 'F["Petal length × Species"] == 1.68', parse = TRUE, size = 5.5, hjust = 0) + #ADD STATISTICAL METADATA TO REAPPROPRIATE EXCESS VOID SPACE IN THE PLOTTING AREA.
  annotate(geom = "text", x = 1.1, y = 7.4, label = 'italic(p) == 0.190', parse = TRUE, size = 5.5, hjust = 0) +
  scale_fill_viridis_d(labels = c("Iris setosa", "I. versicolor", "I. virginica"))


##SAVE FIGURE TO FILE.
ggplot2::ggsave(filename = "ggplotplusGG.png",
                plot = ggplotplusGG,
                dpi = 600,
                width = 7,
                height = 5.26)

#FIGURE 3: GGPLOTPLUS'S CUSTOM SHAPES PALETTE.
ggplot2::ggsave(filename = "ggplotplusShapes.png",
                plot = geom_point_plus_shapes(),
                dpi = 600,
                width = 7,
                height = 5.26)


#FIGURE SM1: USE OF (DE-)SATURATION TO DRAW FOCUS TOWARDS AND AWAY FROM CERTAIN ELEMENTS IN ACCORDANCE WITH A GRAPH'S PURPOSE
ggplotplusGreyMode = ggplot2::ggplot(data = iris,
                                     mapping = ggplot2::aes(x = Petal.Length,
                                                            y = Sepal.Length)) +
  ggplotplus::geom_point_plus(mapping = ggplot2::aes(fill = Species,
                                                     shape = Species),
                              alpha = 0.8, l#MODEST TRANSPARENCY
                              egend_labels = c("Iris setosa", "I. versicolor", "I. virginica")) +
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
  scale_fill_manual(values = c("gray70", viridis(1, begin = 0.7, end = 0.7), "gray70"), #ONLY ONE OF THE THREE GROUPS GETS TO BE A VIVID, PURE COLOR--THE OTHERS ARE MADE LIGHT GRAY.
                    labels = c("Iris setosa", "I. versicolor", "I. virginica"))

#SAVE PLOT TO FILE.
ggplot2::ggsave(filename = "ggplotplusGreyMode.png",
                plot = ggplotplusGreyMode,
                dpi = 600,
                width = 7,
                height = 5.26)

