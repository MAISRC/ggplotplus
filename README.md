# README
Dr. Alex Bajcz, Quantitative Ecologist, Minnesota Aquatic Invasive
Species Research Center (MAISRC)
2026-06-29

<img src="man/figures/ggplotplus_hex.png" alt="ggplotplus hex sticker" style="float: right; width: 180px;"/>

# *ggplotplus* – Universal Design additions for *ggplot2*

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/ggplotplus.png)](https://CRAN.R-project.org/package=ggplotplus)
[![R-CMD-check](https://github.com/MAISRC/ggplotplus/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MAISRC/ggplotplus/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

## What’s `ggplotplus` for?

`ggplot2` is an *extraordinarily* powerful graphics package, used by
perhaps millions to produce graphs for posters, presentations, papers,
and exploration. `ggplotplus` enhances `ggplot2` by:

1.  Providing tools that override many of `ggplot2`’s
    less-than-fully-accessible default design aspects so creating graphs
    that adhere to design best practices is easier and quicker.

2.  Enabling some design options–such as custom point shapes in
    scatterplots, direct group labeling, and relocation of the y-axis
    title–that are currently impossible via a single function call in
    `ggplot2`.

3.  Attempting to lower the learning curve and bandwidth required to
    make high-quality, Universal-Design-oriented graphs, ready for
    publication and sharing, using `ggplot2`.

In particular, `ggplotplus` is for anyone who wants or needs to use
`ggplot2` but has limited time, skill, energy, patience, experience,
etc. with which to devote to learning its many nuances. However, given
its evidence-based approach to graph design, the package is for everyone
who wants to build defensible, maximally consumable graphs quickly and
with a fraction of the fiddly customization often required to get a
typical ggplot up to the most exacting design standards. Plus,
`ggplotplus` has a few tricks to offer that, at present, aren’t
available via a single function call anywhere else–read on for details!

## Quick Start Guide

To begin using `ggplotplus`, first install the latest development
version from GitHub using the pak package:

``` r
# install.packages("devtools")  #IF NOT ALREADY INSTALLED
pak::pak("MAISRC/ggplotplus")
```

Or, alternatively, install the latest stable version from CRAN:

``` r
install.packages("ggplotplus")
```

Then, load it alongside `ggplot2`:

``` r
# install.packages("ggplot2")  #IF NOT ALREADY INSTALLED
library(ggplot2)
library(ggplotplus)
```

Once loaded, you can start layering its `_plus()` tools onto your
`ggplot2` calls to improve their design quickly and with minimal effort!

### Using the tools

Here’s a basic, default `ggplot2` as a point of comparison:

``` r
ggplot(iris, 
       mapping = aes(x = Petal.Length, 
                     y = Sepal.Length)) +
  geom_point(mapping = aes(color = Species)) 
```

![](README_files/figure-commonmark/point%20of%20comparison-1.png)

The biggest single change you can make to the design of your graphs via
`ggplotplus` is via its `theme_plus()` function, which overrides a suite
of `ggplot2`’s default design choices related to default color palettes,
common geometry layers, and layout parameters:

``` r
ggplot(iris, 
       mapping = aes(x = Petal.Length, 
                     y = Sepal.Length)) +
  geom_point(mapping = aes(color = Species)) + 
  theme_plus() #<--OVERHAULS THEME, GEOM, AND PALETTE RELATED DEFAULTS IN MANY WAYS. 
```

![](README_files/figure-commonmark/quick%20start%20use-1.png)

Do a quick comparison between this graph and the last one; `ggplotplus`
adjusts nearly every aspect’s of a ggplot’s design in an effort to make
them cleaner and more accessible.

### Taking it further

If you want to add thoughtful gridlines, polish the appearance of your
continuous scales, and/or move your y-axis title to somewhere more
thoughtful and easier to read, add `gridlines_plus()`,
`scale_continuous_plus()`, and `yaxis_title_plus()` to your calls,
respective:

``` r
ggplot(iris, 
       mapping = aes(x = Petal.Length, 
                     y = Sepal.Length)) +
  geom_point(mapping = aes(color = Species)) + 
  theme_plus() +
  scale_continuous_plus( #<--OVERHAULS AXIS BREAKS AND LIMITS (FOR CONTINUOUS SCALES ONLY!)
    scale = "x",
    name = "Petal length (cm)",
    thin.labels = TRUE) +  
  scale_continuous_plus(
    scale = "y", 
    name = "Sepal length (cm)") +
  yaxis_title_plus() + #<--RELOCATES AND RE-ORIENTS Y AXIS TITLE.
  gridlines_plus() + #<--ADDS THOUGHTFUL GRIDLINES, IF YOU *REALLY* WANT THEM.
  labs(color = expression(italic("Iris")*" species")) #<--THIS IS BASE GGPLOT2, BUT A NICE TOUCH!
```

![](README_files/figure-commonmark/even%20more%20tools-1.png)

Notice how, in this version, gridlines are subtle but still legible,
axes are more fully labelled, and the y-axis title is much easier to
spot and read.

## Thinking differently about graph design

Rather than using a legend at all, you can use `direct_labels_plus()` to
label the groups directly within the plotting area:

``` r
ggplot(iris, 
       mapping = aes(x = Petal.Length, 
                     y = Sepal.Length)) +
  geom_point(mapping = aes(color = Species)) + 
  theme_plus() +
  scale_continuous_plus(
    scale = "x",
    name = "Petal length (cm)",
    thin.labels = TRUE) +  
  scale_continuous_plus(
    scale = "y", 
    name = "Sepal length (cm)") +
  yaxis_title_plus() + 
  gridlines_plus() + 
  labs(color = expression(italic("Iris")*" species")) +
  direct_labels_plus(data = iris, #<--HELP THE FUNCTION UNDERSTAND HOW YOUR DATA LOOK...
                     x = Petal.Length,
                     y = Sepal.Length,
                     group = Species) + #<--...AND WHAT VARIABLE DETERMINES THE GROUPS.
  guides(color = "none") #<--OPTIONALLY, TURN THE LEGEND OFF.
```

![](README_files/figure-commonmark/direct%20labelling-1.png)

With this approach, the legend becomes optional, saving space,
increasing data density, and concentrating vital information close to
where the reader most needs and expects it.

Another option: Call the reader’s attention to one or some of the groups
over others. `scale_focus_plus()` makes doing this easy:

``` r
ggplot(iris, 
       mapping = aes(x = Petal.Length, 
                     y = Sepal.Length)) +
  geom_point(mapping = aes(color = Species)) + 
  theme_plus() +
  scale_continuous_plus(
    scale = "x",
    name = "Petal length (cm)",
    thin.labels = TRUE) +  
  scale_continuous_plus(
    scale = "y", 
    name = "Sepal length (cm)") +
  yaxis_title_plus() + 
  gridlines_plus() + 
  labs(color = expression(italic("Iris")*" species")) +
  scale_focus_plus(aes = "color", 
                   group_var = iris$Species, #<--HELP THE FUNCTION UNDERSTAND YOUR DATA.
                   focal_groups = "versicolor",
                   diff_nonfocal = TRUE #<--KEEP NON-FOCAL GROUPS DISTINCT.
                  )
```

![](README_files/figure-commonmark/focus%20plus-1.png)

In this version, our eyes can’t help but be drawn to the brightly
colored group first, helping us to understand the message of your graph
quicker.

### Try out new shapes

`ggplotplus` also introduces a new palette of shapes designed to be more
distinctive than base R’s point shapes. Access these via
`geom_point_plus()`:

``` r
ggplot(iris, 
       mapping = aes(x = Petal.Length, 
                     y = Sepal.Length)) +
  geom_point_plus( #<--SWITCH TO THIS FUNCTION TO ACCESS THE NEW SHAPES
    mapping = aes(shape = Species, #<--YOU MUST MAP SHAPE HERE TO A VARIABLE OR CONSTANT
                  fill = Species),
    chosen_shapes = c("squircle", #<--CHOOSE YOUR CUSTOM SHAPES, IF DESIRED.
                      "waffle",
                      "oval"),
    alpha = 0.7
    ) + 
  theme_plus() +
  scale_continuous_plus(
    scale = "x",
    name = "Petal length (cm)",
    thin.labels = TRUE) +  
  scale_continuous_plus(
    scale = "y", 
    name = "Sepal length (cm)") +
  yaxis_title_plus() +
  gridlines_plus() +
  labs(fill = expression(italic("Iris")*" species"), #<--WE NEED BOTH FILL AND SHAPE SCALES TO MATCH IN NAME EXACTLY FOR THEM TO COLLAPSE INTO 1.
       shape = expression(italic("Iris")*" species"))
```

![](README_files/figure-commonmark/new%20shapes-1.png)

The distinctiveness of these shapes makes them quick to distinguish,
even without the aid of differing colors.

The above graphs demonstrates how `ggplotplus`’s tools rethink the
default design features of `ggplot2`. The intention is to yield a more
universal product more quickly so you can spend less time fiddling with
your graphs and more time sharing them with a wider audience.

However, there’s a *lot* more to know! If you want to dive deeper,
[check out the full package
cookbook](https://maisrc.github.io/ggplotplus/).

## Development

`ggplotplus` is under active development. All current core functions are
expected to remain relatively stable, but some parameters, features, and
default settings may evolve, and addressing bugs, inconsistencies, and
gaps remains a high priority. User discretion and feedback is advised!
Please don’t hesitate to share bug reports or questionable performance
issues via the Issues feature on the package’s Github page.

## Acknowledgments

Thanks to Allan Cameron (@Allan Cameron) for answers to Stack Overflow
questions 79654995 and 79682150, which provided key coding elements
enabling the functionality of `yaxis_title_plus()` and
`geom_point_plus()`. Also, many thanks to Dr. Grant Vagle, who
frequently provided testing and feedback on the development of this
package.
