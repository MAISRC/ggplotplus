#' Subtle, Minimal Gridlines For When and Where They Help
#'
#' Adds light and easily ignored major gridlines along only axes mapped to
#' continuous variables. Minor gridlines are
#' blanked. This enables the benefits of gridlines (in instances where there are some) but minimizes visual clutter and cognitive load.
#'
#' `gridlines_plus()` ignores any theme instructions to blank major panel scales in either the x or y direction via, e.g., `theme_plus(panel.grid.major.y = ggplot2::element_blank())`. Instead, users can set, e.g., noty == TRUE to prevent gridlines from being drawn in a specific direction, even if that scale is continuous. Similarly, gridline color, linewidth, and linetypes should be set directly in `gridlines_plus()` instead of via `theme()`. Trying to do the latter will fail without error or warning!
#'
#' @param color Gridline color. Single character string. Default: `"gray90"`.
#' @param linewidth Gridline width (theme line units). Single numeric. Default: `1.2`.
#' @param linetype Gridline type. Single string (e.g., `"solid"`, `"dashed"`).
#' @param notx,noty Logicals indicating whether gridlines should not be drawn in a specific direction (i.e., the user wants those to be blank even when the axis is continuous). Default to FALSE (gridlines are added).
#' @param override_legend_alphasize Logical indicating whether, for any fill, color, and/or shape legends, to override the size and/or alpha values to the ggplotplus default values (1 and 5, respectively). Defaults to TRUE.
#' @param enable_coaching Logical indicating whether ggplotplus should perform certain automated checks for possible non-Universal graph design and provide coaching messages when these are detected. Defaults to TRUE.
#'
#' @return An ggplot class object for adding to a plot with `+`.
#'
#' @details
#' Under the hood, `gridlines_plus()` checks layer and/or global mappings to
#' see if `x` and/or `y` are continuous. It does this by inspecting the trained panel scales.
#' It then turns on **major** gridlines for continuous directions and explicitly
#' blanks gridlines for other axes (as well as **all minor** gridlines).

#' One interaction exists between `gridlines_plus()` and `theme_plus()`: If using
#' them in tandem, the `linewidth` provided to `gridlines_plus()` will be a
#' function of the scaling factor generated according to the `export_width` and
#' `export_height` inputs provided to `theme_plus()`. That is to say that the
#' final gridline widths may be bigger or small than those specified in
#' `gridlines_plus()` as a function of your intended output size.
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Petal.Length)) +
#'   ggplot2::geom_point() +
#'   theme_plus() + #WE DON'T RECOMMEND USING gridlines_plus() WITHOUT ALSO USING theme_plus()
#'   gridlines_plus()
#'
#' # Only y is continuous here (x is discrete) → y-only major gridlines
#' ggplot2::ggplot(mtcars, ggplot2::aes(factor(cyl), mpg)) +
#'   ggplot2::geom_boxplot() +
#'   gridlines_plus(color = "grey85", linewidth = 1, linetype = "dashed")
#'
#' # Works with derived continuous axes (histogram)
#' ggplot2::ggplot(mtcars, aes(mpg)) +
#'   ggplot2::geom_histogram() +
#'   gridlines_plus()
#'
#' @export
gridlines_plus = function(color = "gray90",
                          linewidth = 1.2,
                          linetype = "solid",
                          notx = FALSE,
                          noty = FALSE,
                          override_legend_alphasize = TRUE,
                          enable_coaching = TRUE) {
  GridlinesPlus(
    color = color,
    linewidth = linewidth,
    linetype = linetype,
    notx = notx,
    noty = noty,
    override_legend_alphasize = override_legend_alphasize,
    enable_coaching = enable_coaching
  )
}


#' Relocate a Y Axis Title to Above the Y Axis on a Ggplot and Turn it Horizontal.
#'
#' This function relocates the y axis title of a ggplot to the top, above the y axis line and left-justified to the left edge of the y axis labels, sort of like a plot subtitle. It also orients the text horizontally for space-efficiency and easy reading. This is otherwise difficult to do using `ggplot2`'s default styling tools.
#'
#' @param location A length-1 character string matching either "top" or "bottom" for the placement of the new y axis title. Defaults to `"top"`. `"bottom"` should generally only be used when the x axis labels have been moved to the top of the graph (uncommon).
#' @param nudgeTopLegendDown A length-1 logical indicating whether a top legend (box) (if any) should be moved down to align with the relocated y axis title (where they could clip into each other). Defaults to FALSE.
#'
#' @param nudgeHowMuch A length-1 positive integer indicating how much to nudge the top legend (box) (if any) down, if `nudgeTopLegendDown` == `TRUE`. Defaults to `20` points as a general guess and may need adjusting.
#' @param override_legend_alphasize Logical indicating whether, for any fill, color, and/or shape legends, to override the size and/or alpha values to the ggplotplus default values (1 and 5, respectively). Defaults to TRUE.
#' @param enable_coaching Logical indicating whether ggplotplus should perform certain automated checks for possible non-Universal graph design and provide coaching messages when these are detected. Defaults to TRUE.
#'
#' @return An ggplot class object for adding to a plot with `+`.
#' @examples
#' #WE DO NOT RECOMMEND USING yaxis_title_plus() WITHOUT theme_plus()
#' ggplot2::ggplot(iris, ggplot2::aes(x=Sepal.Length, y=Petal.Length)) +
#' ggplot2::geom_point() +
#' theme_plus() +
#' yaxis_title_plus()
#' @export
yaxis_title_plus = function(location = "top",
                            nudgeTopLegendDown = FALSE,
                            nudgeHowMuch = 20,
                            override_legend_alphasize = TRUE,
                            enable_coaching = TRUE) {
  YAxisTitlePlus(
    location = location,
    nudgeTopLegendDown = nudgeTopLegendDown,
    nudgeHowMuch = nudgeHowMuch,
    override_legend_alphasize = override_legend_alphasize,
    enable_coaching = enable_coaching
  )
}



#' Continuous Scales With Endpoint-Aware Breaks
#'
#' `scale_continuous_plus()` is an opinionated wrapper around ggplot2's
#' continuous x, y, colour, and fill scales. It chooses "pretty" breaks while
#' gently expanding the scale limits so breaks generally will appear near both
#' ends of the data range.
#'
#' This is useful because ggplot2's default continuous scales frequently will leave the ends of an
#' axis or colorbar visually unlabeled, making it look as if an endpoint break is
#' missing.
#'
#' @param scale Character string specifying which scale to modify. Options are
#'   `"x"`, `"y"`, `"colour"`/`"color"`, and `"fill"`.
#' @param ... Additional arguments passed to the corresponding ggplot2
#'   continuous scale function. Arguments such as `name`, `labels`, `guide`,
#'   `position`, and `expand` may be supplied. User-supplied `breaks`, `limits`,
#'   `n.breaks`, `trans`, and `transform` are ignored with a warning because
#'   this function controls those components directly.
#' @param thin.labels Logical. If `TRUE`, every other break label is blanked
#'   to reduce crowding. Defaults to `FALSE`.
#' @param pad.labels Character string, either `"start"` or `"end"`. Used when a
#'   user-supplied label vector is shorter than the internally computed break
#'   vector by one label (which must be assessed via trial and error currently). `"start"` pads a blank label at the beginning;
#'   `"end"` pads one at the end.
#' @param target.breaks Integer target number of major breaks. This is a target and
#'   not a guarantee because breaks are chosen using a "pretty" break algorithm.
#'   Default is `5`.
#' @param buffer_frac Numeric fraction of the data span used to decide whether a
#'   break is close enough to each endpoint. Default is `0.05`.
#' @param split_name Logical. If `TRUE`, spaces in a named `name` argument are
#'   replaced with line breaks. This can help long axis or legend titles fit
#'   better. Default is `FALSE`.
#'
#' @details
#' `scale_continuous_plus()` routes to one of
#' [ggplot2::scale_x_continuous()], [ggplot2::scale_y_continuous()],
#' [ggplot2::scale_colour_continuous()], or
#' [ggplot2::scale_fill_continuous()] based on `scale`.
#'
#' Unlike the ggplot2 defaults, this function intentionally controls `breaks`
#' and `limits`. If either is supplied through `...`, it's ignored with a
#' warning. Transformed scales are also not currently supported; pre-transform
#' the data or use ggplot2's scale functions directly when a transformed scale is
#' needed.
#'
#' User-supplied label vectors are supported, but endpoint-aware breaks can
#' sometimes create hidden outer breaks. When possible, this function pads label
#' vectors with blank labels to align them with the computed break vector in length. If
#' alignment is ambiguous by one label, use `pad.labels` to choose which side of the input labels vector to
#' pad.
#'
#' @return A ggplot2 continuous scale object.
#'
#' @examples
#' library(ggplot2)
#'
#' ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   scale_continuous_plus(scale = "x") +
#'   scale_continuous_plus(scale = "y")
#'
#' ggplot(iris, aes(Sepal.Width, Sepal.Length, fill = Petal.Length)) +
#'   geom_point(shape = 21) +
#'   scale_continuous_plus(scale = "x") +
#'   scale_continuous_plus(scale = "y") +
#'   scale_continuous_plus(scale = "fill")
#'
#' ggplot(iris, aes(Sepal.Width, Sepal.Length)) +
#'   geom_point() +
#'   scale_continuous_plus(
#'     scale = "y",
#'     name = "Sepal length",
#'     labels = LETTERS[1:5],
#'     pad.labels = "start"
#'   )
#'
#' @export
scale_continuous_plus =
  function(scale = NA,
           ...,
           thin.labels = FALSE,
           pad.labels = "start",
           target.breaks = 5,
           buffer_frac = 0.05,
           split_name = FALSE) {

  lookup = data.frame(
    incoming = c("fill", "color", "colour", "x", "y"),
    outgoing = c("scale_fill_continuous",
                 "scale_colour_continuous",
                 "scale_colour_continuous",
                 "scale_x_continuous",
                 "scale_y_continuous"
                )
  )

  if(is.na(scale)) { stop("A scale is required. Please provide one. The options are \"x\", \"y\", \"colour\", and \"fill\"") }

  user.args = list(...)

  any_user_breaks = .partial_match_user_arg(user.args, "breaks")
  any_user_limits = .partial_match_user_arg(user.args, "limits")
  bad = !is.null(any_user_breaks) | !is.null(any_user_limits)

  if(bad) {
    warning("This function sets opinionated breaks and limits, so yours were ignored. If you want to set these yourself, use ggplot2::scale_*_continuous().",
         call. = FALSE)
   user.args = .remove_partial_match_user_arg(user.args, "breaks")
   user.args = .remove_partial_match_user_arg(user.args, "limits")
  }

  any_nbreaks = .partial_match_user_arg(user.args, "n.breaks")

  if(!is.null(any_nbreaks)) {
    warning("Use the target.breaks argument instead of the n.breaks argument to control the target number of breaks.")
    user.args = .remove_partial_match_user_arg(user.args, "n.breaks")
  }

  any_trans = .partial_match_user_arg(user.args, "trans")

  if(!is.null(any_trans)) {
    warning(
      "A `trans` argument was supplied, but that argument is deprecated, so it was ignored.",
      call. = FALSE
    )
    user.args = .remove_partial_match_user_arg(user.args, "trans")
  }

  any_transform = .partial_match_user_arg(user.args, "transform")

  if(!is.null(any_transform)) {
  warning(
    "A `transform` argument was supplied, but `scale_continuous_plus()` does not currently support transformed scales, so your transform input was ignored. Pre-transform the data or use `ggplot2::scale_*_continuous(transform = ...)` instead.",
    call. = FALSE
  )
    user.args = .remove_partial_match_user_arg(user.args, "transform")
  }

  split_requested = isTRUE(split_name)
  any_name = .partial_match_user_arg(user.args, "name")
  if(split_requested && is.null(any_name)) {
    warning("`split_name` was set to TRUE but no named `name` argument was provided. Please provide a named `name` argument to use `split_name.")
    split_name = FALSE
  }

  if(split_requested &&
     !is.null(any_name)) {
    user.args = .remove_partial_match_user_arg(user.args, "name")
    user.args$name = gsub(" ", "\n", any_name)
  }

  args = user.args

  if(is.null(.partial_match_user_arg(args, "expand"))) {
    args$expand = c(0,0)
  }

  args$breaks = function(x) {
   .endpoint_breaks(x, n = target.breaks, buffer_frac = buffer_frac, Return = "breaks")
  }

  args$limits = function(x) {
    .endpoint_breaks(x, n = target.breaks, buffer_frac = buffer_frac, Return = "limits")
   }

  #MAKE USER LABEL DECISIONS IF ANY USER LABELS EXIST
  any_user_labels = .partial_match_user_arg(user.args, "labels")

  if (!is.null(any_user_labels) || thin.labels) {

  #DETERMINE WHAT KIND OF USER LABELS WERE GIVEN AND BRANCH
  user_label_mode =
    if (is.null(any_user_labels)) {
      "none"
    } else if (is.function(any_user_labels)) {
      "function"
    } else if (is.atomic(any_user_labels) || is.expression(any_user_labels)) {
      "vector"
    } else {
      stop("`labels` must be NULL, a function, or a vector/expression.", call. = FALSE)
    }

  args$labels = function(x) {

    labs = x #DEFAULT TO X, OVERRIDE AS NEEDED IF USER PROVIDED LABELS.

    if(user_label_mode != "none") {
    if(user_label_mode == "function") {
        labs = any_user_labels(x) #RUN USER LABELING FUNCTION
      } else {

        #OTHERWISE, USER PROVIDED VECTOR, SO LET'S ADDRESS THE 4 POSSIBILITIES:
        delta = length(x) - length(any_user_labels)

      if (delta == 0) { #1: THEY MATCH PERFECTLY, SO ROLL WITH THEM.
        labs = any_user_labels

      } else if (delta == 1) { #2: THEY MISS BY ONE, UNFORTUNATELY, SO EITHER PAD LEFT OR PAD RIGHT AS USER REQUESTS.
        if (pad.labels == "start") {
          labs = c("", any_user_labels)
        } else {
          labs = c(any_user_labels, "")
        }
      } else if (delta == 2) { ##3: THEY MISS BY TWO, SO PAD EITHER SIDE.
        labs = c("", any_user_labels, "")
      } else {
        stop( #4: GIVE UP AND CRY THAT THE LABELS DON'T MATCH.
          paste0( #THIS IS A NICE ERROR CHATGPT--TELLS YOU HOW MANY YOU SHOULD HAVE BEEN GOING FOR.
            "Custom labels could not be aligned to the computed breaks. ",
            "Expected ", length(x), " labels but received ", length(any_user_labels), "."
          ),
          call. = FALSE
        )
      }

      }
    }

    #IF THE USER WANTS EVERY OTHER REAL LABEL BLANKED...
    if(thin.labels) {

      #A LITTLE HARD TO GUESS WHAT TO DO IF THEY DIDN'T SPECIFY LABELS SINCE WE COULD BE OFF, BUT WE'LL JUST GUESS AND THEY CAN USE PAD.LABELS TO NUDGE IT.
      if(user_label_mode == "none") {
        if(pad.labels == "start") {
          labs[seq(from = 1, to = length(labs), by = 2)] = ""
        } else {
          labs[seq(from = 2, to = length(labs), by = 2)] = ""
        }
      } else {

      labs[is.na(labs)] = "" #GUARDS AGAINST GGPLOT TRAINING NONSENSE.
      first_real = which(labs != "")[1] #FIND THE FIRST "REAL" LABEL
      if(!is.na(first_real)) {
        blank_these = seq(from = first_real + 1,
                  to = length(labs),
                  by = 2)
        labs[blank_these] = ""
      }
     }
    }

    return(labs)
   }
  } #END LABEL SETTING SKIP

  do.call(lookup$outgoing[lookup$incoming == scale], args)
}


#' A Universal Design-Oriented Base Ggplot2 Theme With Scalable and Overridable Defaults
#'
#' `theme_plus()` returns a ggplot2 theme designed to make
#' publication-quality, accessible graphs easier to produce. It keeps all of
#' ggplot2’s normal behaviors (last theme wins; user overrides take precedence),
#' but bakes in opinionated defaults with Universal Design in mind. A few knobs
#' let you scale typography/lines, flip the legend layout, and switch the
#' background color if desired.
#'
#' Internally, text sizes are expressed with `rel()`, so they scale with
#' `base_font_size`. Line/rect line thicknesses start from `base_linewidth` and
#' `base_rectlinewidth` and scale similarly with `rel()`.
#'
#' The function builds
#' a  base theme, then *adds* any user overrides via
#' `theme(...)`, so the user's preferences always take precedence.
#'
#' @param ... Optional additional theme settings passed to [ggplot2::theme()]. These are applied *after* the base theme, so the theme's defaults only "win" when no matching settings are provided by the user
#'   (same as in ggplot2).
#' @param legend_pos Where to put the legend. `"top"` (default) creates a
#'   horizontal stripe at the top for the legend (box) when one is present;
#'   `"right"` uses a vertical legend at the right (ggplot2’s usual position)
#'   but with design modifications. `"bottom"` is also an option (largely same
#'   as `"top"`).
#' @param base_font_size Base text size (in points) for most text elements. These
#'   will scale via `rel()`. Default is `16`.
#' @param base_linewidth Baseline thickness for most **line** theme elements
#'   (e.g., axis lines and tick marks). Defaults to `1.2`. Specific elements
#'    may use `rel()` multipliers on top of this.
#' @param base_rectlinewidth Baseline line thickness for most **rect** theme elements
#'   (e.g., legend frames). Defaults to `1.2`.
#' @param line_color Default color for most line elements (axis lines, frames, etc.).
#'   Defaults to `"black"`.
#' @param text_color Default color for most text elements. Defaults to `"black"`.
#' @param background_color Background fill applied to the panel, plot, legend,
#'   and strip backgrounds. Defaults to a slightly warm white, `"#FFFEFD"`, to reduce eyestrain.
#' @param palette_discrete,palette_continuous Default viridis-family color palette codes ("A" through "H") to use for discrete and continuous scales, respectively.
#' @param begin_discrete,end_discrete,begin_continuous,end_continuous Numeric values ranging between 0 and 1 for where to begin drawing colors from a viridis palette for a discrete and continuous color scale, respectively.
#' @param export_width,export_height Length-1 numeric values indicating your intended export (most likely via ggplot2::ggsave()) width and height, respectively. This rescales font and line sizes internally to stay relatively appropriately for your intended export size.
#' @param override_legend_alphasize Logical indicating whether, for any fill, color, and/or shape legends, to override the size and/or alpha values to the ggplotplus default values (1 and 5, respectively). Defaults to TRUE.
#' @param enable_coaching Logical indicating whether ggplotplus should perform certain automated checks for possible non-Universal graph design and provide coaching messages when these are detected. Defaults to TRUE.
#' @param blank_axes Logical indicating whether x and y axis titles, labels, lines, and tick marks should be turned off. This will, in part, simulate the effects of `ggplot2::theme_void()` and is mainly used internally by `icon_array_plus()`.
#'
#' @return A ggplot2 theme object to add with `+`.
#'
#' @details
#'
#' One interaction exists between `gridlines_plus()` and `theme_plus()`: If using
#' them in tandem, the `linewidth` provided to `gridlines_plus()` will be a
#' function of the scaling factor generated according to the `export_width` and
#' `export_height` inputs provided to `theme_plus()`. That is to say that the
#' final gridline widths may be bigger or small than those specified in
#' `gridlines_plus()` as a function of your intended output size.
#'
#' @examples
#' # Basic use
#' library(ggplot2)
#' ggplot(iris, aes(Sepal.Length, Petal.Length, colour = Species)) +
#'   geom_point() +
#'   theme_plus()
#'
#' # Prefer the right-side legend and pure white background
#' ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_plus(legend_pos = "right", background_color = "white")
#'
#' # Scale text up and make lines a bit lighter
#' ggplot(iris, aes(Sepal.Length, Petal.Length)) +
#'   geom_point() +
#'   theme_plus(base_font_size = 18, base_linewidth = 1.0)
#'
#' # You can still override any element normally via theme()
#' ggplot(iris, aes(Sepal.Length, Petal.Length)) +
#'   geom_point() +
#'   theme_plus() +
#'   theme(axis.line = element_line(linewidth = 0.8))
#'
#' # But you could just as easily do so via theme_plus()
#' ggplot(iris, aes(Sepal.Length, Petal.Length)) +
#'   geom_point() +
#'   theme_plus(axis.line = element_line(linewidth = 0.8))
#'
#' @seealso [ggplot2::theme()], [ggplot2::theme_gray()], [ggplot2::theme_get()]
#' @export
theme_plus = function(...,
                      legend_pos = "top",
                      base_font_size = 16,
                      base_linewidth = 1.2,
                      base_rectlinewidth = 1.2,
                      line_color = "black",
                      text_color = "black",
                      background_color = "#FFFEFD",
                      palette_discrete = "D",
                      palette_continuous = "E",
                      begin_discrete = 0,
                      end_discrete = 0.72,
                      begin_continuous = 0,
                      end_continuous = 1,
                      export_width = 7.25,
                      export_height = 5.95,
                      override_legend_alphasize = TRUE,
                      enable_coaching = TRUE,
                      blank_axes = FALSE
                      ) {

  if(!is.logical(blank_axes) ||
     length(blank_axes) != 1L ||
     is.na(blank_axes)){
    stop("`blank_axes` must be TRUE or FALSE.")
  }

  if(blank_axes){
    blank_axis_theme = ggplot2::theme(
      axis.line = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      axis.title.x = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
    )
  } else {
    blank_axis_theme = ggplot2::theme()
  }

  #ONE ODD INTERACTION IS WITH strip.text(), WHICH CAN ONLY BE BLANKED BY HITTING X AND Y SEPARATELY. SOMETHING TO PONDER WHEN ADJUSTING SUBSCALES SEPARATELY...
  user_theme = ggplot2::theme(...)
  dots = rlang::list2(...)
  if(inherits(dots$strip.text, "element_blank")) {
    user_theme = user_theme +
      ggplot2::theme(
        strip.text.x = ggplot2::element_blank(),
        strip.text.y = ggplot2::element_blank()
      )
  }
  if(inherits(dots$axis.title, "element_blank")) {
    user_theme = user_theme +
      ggplot2::theme(
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank()
      )
  }
  if(inherits(dots$axis.text, "element_blank")) {
    user_theme = user_theme +
      ggplot2::theme(
        axis.text.x = ggplot2::element_blank(),
        axis.text.y = ggplot2::element_blank()
      )
  }


  gg_palette_theme = .theme_plus_palettes(palette_discrete,
                                          palette_continuous,
                                          begin_discrete,
                                          end_discrete,
                                          begin_continuous,
                                          end_continuous)

  ref_width = 6.25
  ref_height = 7.79

  scale_factor = sqrt((export_width * export_height) / (ref_width * ref_height))

  base_font_size = base_font_size * scale_factor
  base_linewidth = base_linewidth * scale_factor
  base_rectlinewidth = base_rectlinewidth * scale_factor

  #WE NOW USE THE REL() FUNCTION TO KEEP THINGS SCALED RELATIVE TO THE BASE_FONT_SIZE FOR CONVENIENCE

  default_theme = ggplot2::theme_gray(base_size = base_font_size,
                                      base_line_size = base_linewidth,
                                      base_rect_size = base_rectlinewidth
  ) +
    ggplot2::theme_sub_axis(
      line = ggplot2::element_line(color = line_color, linewidth = ggplot2::rel(1), lineend = "square"), #ADD THICK BLACK X AND Y AXIS LINES WITH SQUARE ENDS TO ENSURE THAT THEY APPEAR TO VISUALLY MEET.
      title = ggplot2::element_text(color = text_color, size = ggplot2::rel(1.125), face = "bold", family = "sans"),
      text = ggplot2::element_text(size = ggplot2::rel(1), color = text_color), #ENSURE AXIS LABELS ARE BLACK AND SIZE 16
      ticks.length = ggplot2::unit((0.2*scale_factor), "cm"), #INCREASE SIZE OF AXIS TICK MARKS TO BE MORE NOTICEABLE.
      ticks = ggplot2::element_line(color = line_color, linewidth = ggplot2::rel(0.75)),
    ) +
    ggplot2::theme_sub_axis_x(title = ggplot2::element_text(margin = ggplot2::margin(t = 10))) +
    ggplot2::theme_sub_axis_y(title = ggplot2::element_text(vjust = 0.5, margin = ggplot2::margin(r = 15), angle = 90)) +
    ggplot2::theme_sub_legend(
      box = "vertical", #<--MAKES MULTIPLE LEGENDS GO VERTICAL
      title = ggplot2::element_text(color = text_color, face = "bold", family = "sans", size = ggplot2::rel(1.12)),
      text = ggplot2::element_text(size = ggplot2::rel(1), color = text_color),
      key = ggplot2::element_rect(fill = "transparent", color = "white"),
      background = ggplot2::element_rect(color = NA, fill = background_color),
      ticks.length = ggplot2::unit((0.2*scale_factor), "cm"),
      ticks = ggplot2::element_line(color = "white", linewidth = ggplot2::rel(0.75), linetype = "solid"), #MAKE THE TICKS WHITE
      frame = ggplot2::element_rect(color = line_color, linewidth = ggplot2::rel(1)), #MAKE SOLID BLACK LINES FOR THE LEGEND BORDER FOR CONTINUOUS SCALES.
    ) +
    ggplot2::theme_sub_panel(
      border = ggplot2::element_blank(),
      grid = ggplot2::element_blank(), #ELIMINATE MAJOR AND MINOR GRIDLINES
      background = ggplot2::element_rect(fill = background_color, color = NA), #SWITCH FROM GRAY TO WHITE BACKGROUND
      spacing = ggplot2::unit(1, "cm"),
    ) +
    ggplot2::theme_sub_plot(
      background = ggplot2::element_rect(fill = background_color, color = NA),
      title = ggplot2::element_blank(),
      subtitle = ggplot2::element_blank(),
    ) +
    ggplot2::theme_sub_strip(
      background = ggplot2::element_rect(color = NA, fill = background_color),
      text = ggplot2::element_text(color = text_color, size = ggplot2::rel(1), face = "bold"),
      text.y = ggplot2::element_text(margin = ggplot2::margin(l=5), angle = 0),
      text.x = ggplot2::element_text(margin = ggplot2::margin(b=5)),
      placement = "outside", #THIS ALWAYS ENSURES THAT AXIS LABELS GO CLOSER TO THE AXIS THAN THE STRIP LABELS WOULD.
    ) +
    ggplot2::theme(
      geom = ggplot2::element_geom( #IN HERE IS WHERE WE CAN NOW ADD GENERAL GEOM_*-RELATED STYLE OPINIONS.
        pointsize = 5,
        pointshape = 21,
        borderwidth = 1.2,
        colour = "black",
        linetype = "solid",
        linewidth = 1.35
      ),
    )

  #THIS NEXT LINE ENSURES THAT WE JUST RETURN A THEME OPTION RIGHT AWAY SO GGPLOT2 CAN HANDLE ALL THE COLLISIONS AND ADDING AS IT NORMALLY WOULD. NO NEED FOR A GGPLOT.ADD DISPATCH!
  #WE COLLIDE WITH A BASE GGPLOT2 THEME LAST IN CASE THE USER PROVIDES ANY CUSTOM GGPLOT2 THEMING OF THEIR OWN HERE, AS A CONVENIENCE.
  theme_plus2add = default_theme + blank_axis_theme + .determine_legend_theme(legend_pos) + gg_palette_theme + user_theme

  ThemePlus(
    applyGeomDefaults = TRUE,
    theme2add = theme_plus2add,
    override_legend_alphasize = override_legend_alphasize,
    enable_coaching = enable_coaching,
    scale_factor = scale_factor #<--FOR ADJUSTING GRIDLINES_PLUS AS APPLICABLE.
  )

}



#' Create and add a scatterplot layer to your `ggplot2` graph with new, distinctive shapes.
#'
#' This function behaves similarly to `ggplot2::geom_point()` except that it takes several new inputs: `shapes`, `n_shapes`, `chosen_shapes`, `legend_title`, `key_size`, and `show_shape_scale`. These are explained below.
#'
#' Collectively, these inputs allow `geom_point_plus()` to access and draw several new and distinctive shapes that are designed to be more readily distinguishable from one another when shape communicates difference.
#'
#' To see the special shapes available via this function run `geom_point_plus_shapes()`.
#'
#' Note: As of Version 0.5.2, shapes 21-25 in R's default shapes palette are now also available via `geom_point_plus_shapes()`; these are called "circle", "square", "diamond", "triangle_up", and "triangle_down", respectively, though they can also be referred to by number.
#'
#' @param mapping Set of aesthetic mappings created by aes(), as in `ggplot2::geom_point()`.
#' @param data The data to be displayed in this layer, as in `ggplot2::geom_point()`.
#' @param stat The statistical transformation to use on the data for this layer, as in `ggplot2::geom_point()`.
#' @param position A position adjustment to use on the data for this layer, as in `ggplot2::geom_point()`.
#' @param avail_shapes A named list of custom shapes to be drawn in place of `ggplot2`'s standard palette of shapes. Defaults to `NULL` and is replaced internally with the palette of shapes designed specifically for use in `geom_point_plus()`. This should probably not be changed unless users have created new shapes they would like to use instead.
#' @param n_shapes A length-1 integer corresponding to the number of distinct shapes the function is allowed to pull from the shapes palette specified to `avail_shapes`. Defaults to the length of `avail_shapes` and should probably not be changed.
#' @param chosen_shapes A character string referring by name to elements in the current shapes registry that the function should use to allocate shapes to values, e.g. `c("flower", "octagon", "squircle)`. These are provided internally to a `scale_shape_manual()` call and are meant to circumvent the need for such a call to specify a specific subset of shapes to be used from the new shapes palette. Defaults to `NULL`, i.e., shapes are pulled from `shapes.list` in order. Numerical values will use `ggplot2`'s default shapes instead.
#' @param legend_title A length-1 character string corresponding to the name to be used for the shape legend title (if any). This is passed internally to `scale_shape_manual()` and is meant to help circumvent the need for the user to specify any such call directly.
#' @param legend_labels A character vector corresponding to the names to be used for the shape legend labels (if any). This is passed internally to `scale_shape_manual()` and is meant to help circumvent the need for the user to specify any such call directly.
#' @param include_shape_legend Logical indicating whether a shape legend will be shown (one is always shown unless this is set to FALSE, even when shape is being mapped to a constant and thus a legend may not be appropriate).
#' @param ... Other arguments passed on to this layer()'s params argument, as in `ggplot2::geom_point()`.
#' @param na.rm Logical value controlling whether missing values should be removed from the data with a warning or silently, as in `ggplot2::geom_point()`.
#' @param show.legend Logical value controlling whether this layer should be included in the legend(s), as in `ggplot2::geom_point()`.
#' @param inherit.aes Logical controlling whether global aesthetics specified in `ggplot2::ggplot()` should be inherited locally by this layer or not, as in `ggplot2::geom_point()`.
#' @param show_shape_scale Logical controlling whether a call to `ggplot2::shape_scale_manual()` should be included as part of the function's operations. Generally, this should be set to `TRUE` unless shape is being mapped to a constant, in which case leaving this `TRUE` would trigger a legend that is redundant.
#' @return A ggplot2 layer object.
#' @examples
#' ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, fill = drat)) +
#' geom_point_plus(ggplot2::aes(shape = factor(gear)), size = 5)
# ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, fill = factor(cyl))) +
# geom_point_plus(ggplot2::aes(shape = factor(carb)),
# chosen_shapes = c("squircle", "lotus", "sunburst", "octagon", "plus", "oval"),
# size = 5, stroke = 0.4)
#' ggplot2::ggplot(iris, ggplot2::aes(Petal.Width, Petal.Length, fill = Species)) +
#' geom_point_plus(ggplot2::aes(shape = Species), size = 5, alpha = 0.7)
#'
#' @export
geom_point_plus = function(mapping = NULL,
                           data = NULL,
                           stat = "identity",
                           position = "identity",
                           avail_shapes = NULL, #A NAMED LIST OF SHAPES. DEFAULTS TO THOSE PROVIDED BY ggplotplus PLUS THOSE ADDED BY THE USER VIA ADD_SHAPE_PLUS. BUT NOT EVALUATED HERE--EVALUATED INSIDE FUNCTION ENVIRON.
                           n_shapes = length(avail_shapes), #HOW MANY DISTINCT SHAPES SHOULD BE PULLED FROM THE AVAILABLE PALETTE? DEFAULTS TO ALL OF THEM.
                           chosen_shapes = NULL, #WE PROVIDE DIRECT ACCESS TO THE VALUES ARGUMENT OF SCALE_SHAPE_MANUAL VIA THIS PARAMETER. THIS WAY, A USER NEEDN'T TACK ON AN ADDITIONAL CALL TO SCALE_SHAPE_MANUAL() TO CUSTOMIZE THE SHAPES USED.
                           legend_title = NULL, #WE ALSO PROVIDE DIRECT ACCESS TO THE TITLE ARGUMENT OF THE LEGEND, AS CHANGING THIS MANUALLY WOULD OTHERWISE REQUIRE ANOTHER CALL TO SCALE_SHAPE_DISCRETE AND THAT WOULD TRIGGER A WARNING AND RESET TO THE SHAPES PALETTE GGPLOT2 GENERALLY USES.
                           legend_labels = NULL, #SAME AS ABOVE.
                           include_shape_legend = TRUE, #WE PROVIDE DIRECT ACCESS TO WHETHER OR NOT A SHAPE LEGEND GETS SHOWN, FOR USE IN SINGLE-SHAPE SCATTERPLOTS WHERE THE CUSTOM SHAPES ARE USED INSTEAD OF GGPLOT2 DEFAULTS.
                           ...,
                           na.rm = FALSE,
                           show.legend = NA,
                           inherit.aes = TRUE,
                           show_shape_scale = TRUE) {

  #EVALUATES THE SHAPES REGISTRY HERE, UNLESS A DIFFERENT ONE IS PROVIDED.
  if(is.null(avail_shapes)) {
    avail_shapes = .pointplus_shapes()
  }

  dot_args = rlang::list2(...)

  #IF SHAPE IS NOT BEING MAPPED, JUST RETURN THE LAYER WITHOUT DRAWING ANY SCALE
  #THIS ONLY CHECKS MAPPING, WHICH IS LOCAL. IF SHAPE IS MAPPED GLOBALLY INSTEAD, A SCALE_SHAPE_MANUAL CALL IS PRETTY HARMLESS.
  shape_is_mapped = .has_mapped_aes(mapping, dot_args, "shape")

  chosen_shapes = .standardize_pointplus_shape_names(chosen_shapes) #SEE MIDDLEWARE FOR THIS HELPER.

  #IF CHOSEN_SHAPES IS A CONSTANT, PASS IT ALONG AS A CONSTANT AND NOT AN AES.
  if(!shape_is_mapped &&
     !is.null(chosen_shapes) &&
     length(chosen_shapes) == 1 &&
     is.character(chosen_shapes) &&
     chosen_shapes %in% names(avail_shapes)) {
    dot_args$shape = chosen_shapes
    chosen_shapes = NULL
  }

  #THIS FUNCTION IS MOSTLY JUST A WRAPPER TO GEOM_POINT2 INTERNALLY.
  geom_call = do.call(
    geom_point2,
    c(
      list(
        mapping = mapping,
        data = data,
        stat = stat,
        position = position,
        shapes = avail_shapes,
        na.rm = na.rm,
        show.legend = if(isTRUE(include_shape_legend)) {show.legend}  else {c(shape = FALSE)},
        inherit.aes = inherit.aes
      ),
      dot_args
    )
  )

  #HERE, SELECT THE EXACT SHAPES TO DRAW FROM THE SHAPES PALETTE, DEFAULTING TO THE SHAPES IN THE REGISTRY IN ORDER IF NO SPECIFIC SHAPES WERE CHOSEN.
  if(is.null(chosen_shapes) || length(chosen_shapes) == 0) {
    values = rep(names(avail_shapes), length.out = n_shapes)
  } else {
    values = rep(chosen_shapes, length.out = n_shapes)
  }

  #BUILD THE LEGEND IF WE'RE GOING TO, BUT ONLY PUT IN TITLE IF THE USER PROVIDED ONE.
  guide_obj = if(isTRUE(include_shape_legend)) {
    ggplot2::guide_legend()
  } else {
    "none"
  }

  scale_args = list(values = values, guide = guide_obj)

  #ADD THE SHAPE SCALE
  if(!is.null(legend_title)) {
  scale_args$name = legend_title
  }
  if(!is.null(legend_labels)) {
  scale_args$labels = legend_labels
  }

  scale_call = do.call(ggplot2::scale_shape_manual, scale_args)

  #AND ADD A SIZE SCALE TO MAKE THE DEFAULT SIZES A BIT HEFTIER.
  if(is.null(.partial_match_user_arg(dot_args, "size")) &&
     isTRUE(any(c("size") %in% names(mapping)))) {
    size_scale_call = ggplot2::scale_size(range = c(3, 5.5))
  } else {
    size_scale_call = NULL
  }

  #IF THE USER HAS MAPPED SHAPE GLOBALLY + DOES NOT WANT A SCALE_SHAPE_MANUAL CALL (BECAUSE THEY'VE MAYBE SET SHAPE TO A CONSTANT THERE), THIS WILL PREVENT THE SCALE FROM SHOWING BY SUPPRESSING THE SCALE CALL IF THEY'VE TOGGLED THIS.
  if(show_shape_scale == FALSE) {
    return(geom_call)
  }

  #BE MORE EXPLICIT ABOUT THE OUTPUT STRUCTURE.
  Filter(Negate(is.null), list(geom_call, scale_call, size_scale_call))

}


#' Jittered points with ggplotplus point shapes
#'
#' \code{geom_jitter_plus()} is a convenience wrapper around
#' \code{geom_point_plus()} that applies jittering to reduce overplotting.
#' It supports the same custom shape palette and fillable point rendering
#' as \code{geom_point_plus()} while exposing the familiar \code{width},
#' \code{height}, and \code{seed} arguments used by
#' \code{ggplot2::position_jitter()}.
#'
#' @inheritParams ggplot2::geom_point
#' @param width,height Amount of horizontal and vertical jitter. Passed to
#'   \code{ggplot2::position_jitter()} when \code{position = "jitter"}.
#' @param seed Random seed used by \code{ggplot2::position_jitter()} to make
#'   jittering reproducible. Defaults to \code{NA}, matching `ggplot2`.
#' @param ... Additional arguments passed to \code{geom_point_plus()}, including
#'   ggplotplus-specific arguments such as \code{chosen_shapes} and
#'   \code{legend_title}. See `?geom_point_plus` for details.
#'
#' @return A ggplot2 layer.
#'
#' @examples
#' ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
#'   geom_jitter_plus(
#'     ggplot2::aes(shape = Species, fill = Petal.Length),
#'     width = 0.15,
#'     seed = 1,
#'     colour = "black"
#'   )
#'
#' ggplot2::ggplot(iris, ggplot2::aes(Species, Sepal.Length)) +
#'   geom_jitter_plus(
#'     ggplot2::aes(shape = Species),
#'     chosen_shapes = c("plus", "flower", "lotus"),
#'     seed = 123
#'   )
#'
#' @export
geom_jitter_plus = function(mapping = NULL,
                            data = NULL,
                            stat = "identity",
                            position = "jitter",
                            ...,
                            width = NULL,
                            height = NULL,
                            seed = NA,
                            na.rm = FALSE,
                            show.legend = NA,
                            inherit.aes = TRUE) {

  #SANITIZING ANY PARTIAL MATCHING INPUTS.
  dot.args = list(...)
  anywidth = .partial_match_user_arg(args = dot.args, target = "width")
  if(length(anywidth) > 0) {
    width = anywidth
    dot.args = .remove_partial_match_user_arg(dot.args, "width")
  }
  anyheight = .partial_match_user_arg(args = dot.args, target = "height")
  if(length(anyheight) > 0) {
    width = anyheight
    dot.args = .remove_partial_match_user_arg(dot.args, "height")
  }
  anyseed = .partial_match_user_arg(args = dot.args, target = "seed")
  if(length(anyseed) > 0) {
    width = anyseed
    dot.args = .remove_partial_match_user_arg(dot.args, "seed")
  }

  #IF WIDTH OR HEIGHT IS NOT NULL, AND/OR SEED IS NOT NULL, AND WE'RE ON POSITION JITTER...
  if(!is.null(width) || !is.null(height) || !is.na(seed)) {
    if(!identical(position, "jitter")) {
      warning(
        "`width`, `height`, and `seed` are ignored when `position` is not \"jitter\".",
        call. = FALSE
      )
    } else { #...PASS TO GGPLOT'S POSITION_JITTER.
      position = ggplot2::position_jitter(
        width = width,
        height = height,
        seed = seed
      )
    }
  }

  #FROM THERE ON OUT, IT'S ALL GEOM_POINT_PLUS'S JOB.
  geom_point_plus(
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    ...,
    na.rm = na.rm,
    show.legend = show.legend,
    inherit.aes = inherit.aes
  )
}



#' Add direct labels to grouped point or line plots
#'
#' [direct_labels_plus()] adds procedurally placed text labels to grouped
#' point or line plots as an alternative to using a legend, which might be
#' space-inefficient, off to one side away from where readers will see it,
#' or force readers to jump their focus long distances to align groups with
#' labels. The function is intended as a friendlier alternative to
#' manually placing group labels via [ggplot2::annotate()]. Labels are drawn
#' using [ggrepel::geom_label_repel()], so they'll repel one another as well
#' as the plotted data they're labeling (within reason).
#'
#' This function is experimental. It currently works best for ordinary
#' scatterplots and grouped line/path plots where each group has a visually
#' meaningful position in two-dimensional (x/y) space. It will not
#' work for every ggplot2 geometry, statistic, coordinate system, or faceting
#' arrangement.
#'
#' @param data A data frame containing the variables to be both plotted and
#' labelled. Most often, this will be the same data frame as supplied to
#' [ggplot2::ggplot()] but needn't be.
#' @param x,y Unquoted column names giving the x- and y-coordinates of the data
#' to be plotted and thus also labelled.
#' @param group Unquoted column name giving the grouping variable with which to
#' label the underlying data. Must be a single unquoted column name and not an
#' expression.
#' @param placement Where labels should be placed relative to each group.
#' One of "top", "right", "bottom", or "left". For geometry = "point", this
#' controls the target location used to choose a representative point from each
#' group. For geometry = "line", this chooses the endpoint or extreme point to
#' label. Experimenting with different placements to find the one that works
#' best for a particular graph is advised!
#' @param geometry The kind of geometry being labelled. Currently supports
#' "point" and "line".
#' @param adj_fact A single numeric value controlling how far label targets are
#' adjusted toward or away from the selected edge of each group. Values are
#' interpreted as a proportion of the group-specific x- or y-range. Positive
#' values move targets outward (towards the plot edge); negative values move
#' them inward. For geometry = "point", this changes the target spot used to
#' choose a particular point from each group to label, but does not move the
#' final label anchor away from the selected point. In practice, this is likely
#' not particularly useful for point geometries most of the time as a result.
#' @param key_labels Optional replacement contents for the labels. May be one
#' of:
#' \itemize{
#' \item NULL, in which case group values are used as labels (the default
#' behavior);
#' \item A labelling function;
#' \item a named character vector of the form
#' c("old_group_name" = "New label"); or
#' \item an unnamed character vector with one label per group. Unnamed
#' labels will be assigned to groups in alphanumeric order.
#' }
#' @param facet_vars Optional character vector of max length 2 (or else NULL)
#' giving one or two faceting variables you're using to facet your plot. When
#' supplied, label locations are calculated separately within each
#' group-by-facet combination. This is useful when adding direct labels to
#' faceted plots.
#' @param ... Additional arguments passed along to
#' [ggrepel::geom_label_repel()].
#'
#' @return A ggplot2 layer produced by [ggrepel::geom_label_repel()].
#'
#' @details
#' For point geometries, direct_labels_plus() calculates one label location
#' per group by finding the observed point closest to a group-specific target
#' positioned towards one of the "edges" of a group's cluster of points.
#' For "top" and "bottom" placement, the target is horizontally centered on
#' the group's median x-value and vertically placed near the group's maximum or
#' minimum y-value. For "left" and "right" placement, the same logic is
#' applied with x and y reversed.
#'
#' For line geometries, labels are placed at the group-specific endpoint or
#' extreme value implied by placement: the largest x-value for "right", the
#' smallest x-value for "left", the largest y-value for "top", and the
#' smallest y-value for "bottom". The final label anchor may then be adjusted
#' by adj_fact.
#'
#' To help labels repel from plotted points or lines, the function silently adds
#' empty-label rows at the original data coordinates. ggrepel does not draw
#' these empty labels, but still uses their positions when placing visible
#' labels. This helps to ensure, in general, that labels neither cover each other
#' nor the underlying data they're labelling.
#'
#' Currently, the function sets defaults for the following parameters of
#' [ggrepel::geom_label_repel()]: size (5), box.padding (0.5), max.overlaps
#' (Inf), segment.size (1), and min.segment.length (0). However, these are
#' overridable, if the user provides named arguments that at least partially
#' match.
#'
#' Known limitations:
#' \itemize{
#' \item Label locations are calculated in the raw data space supplied to the
#' function. Transformed scales, reversed axes, and non-Cartesian coordinate
#' systems may give unexpected results. Pre-transform data rather than entering
#' raw data and transforming later.
#' \item coord_flip(), coord_polar(), map projections, and other coordinate
#' transformations are not currently supported.
#' \item The function places labels according to the data values supplied in
#' `data`, not those subsequently generated by ggplot2 stat functions. For
#' example, to label fitted smooth lines like those from
#' [ggplot2::geom_smooth()], feed this function fitted values outputted from
#' such a function instead of the raw data.
#' \item Very dense plots or plots with many groups will likely still have
#' overlapping or poorly placed labels. ggrepel helps, but it cannot make a
#' crowded plot uncrowded. Alas.
#' \item Polygon, ribbon, area, segment, curve, and spatial geometries are not
#' currently supported but might be in the future.
#' }
#'
#' @examples
#' ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Sepal.Width, color = Species)) +
#' ggplot2::geom_point() +
#' direct_labels_plus(
#' data = iris,
#' x = Sepal.Length,
#' y = Sepal.Width,
#' group = Species,
#' placement = "right",
#' geometry = "point"
#' ) +
#' ggplot2::guides(color = "none")
#'
#' line_data = ChickWeight |>
#' dplyr::group_by(Diet, Time) |>
#' dplyr::summarize(weight = mean(weight), .groups = "drop")
#'
#' ggplot2::ggplot(line_data, ggplot2::aes(Time, weight, color = Diet)) +
#' ggplot2::geom_line(ggplot2::aes(group = Diet)) +
#' direct_labels_plus(
#' data = line_data,
#' x = Time,
#' y = weight,
#' group = Diet,
#' placement = "right",
#' geometry = "line",
#' adj_fact = 0.05
#' ) +
#' ggplot2::guides(color = "none")
#'
#' @export
direct_labels_plus = function(data,
                              x,
                              y,
                              group, #WHAT TO LABEL BY
                              placement = "top", #WHERE TO PLACE THE LABELS RELATIVE TO THE EDGES OF THE PLOT
                              geometry = "point", #LINES VS. POINTS
                              adj_fact = 0, #HOW MUCH TO MOVE THE LABELS TOWARDS THE EDGE (POSITIVE) OR CENTER (NEGATIVE) OF THE PLOT
                              key_labels = NULL, #WHAT TO PLACE INSIDE THE LABELS.
                              facet_vars = NULL,
                              ...) {

  #CONFIRM VALID ARGS
  placement = match.arg(placement, c("top", "right", "bottom", "left"))
  geometry = match.arg(geometry, c("point", "line"))


  ##EARLY FAILURE CHECKS
  if(!is.data.frame(data)) {
    stop("`data` must be a data frame.", call. = FALSE)
  }

  if(!is.null(facet_vars)) {

    if(!is.character(facet_vars) || length(facet_vars) > 2) {
      stop("`facet_vars` must be NULL or a character vector <= 2 column names.", call. = FALSE)
    }

    missing_facet_vars = setdiff(facet_vars, names(data))

    if(length(missing_facet_vars) > 0) {
      stop(
        "`facet_vars` contains column name(s) not found in `data`: ",
        paste(missing_facet_vars, collapse = ", "),
        call. = FALSE
      )
    }

  }

  if(!is.numeric(adj_fact) || length(adj_fact) != 1 || is.na(adj_fact)) {
    stop("`adj_fact` must be a single numeric value (a proportion of the horizontal/vertical range of the data to adjust the label targets by).", call. = FALSE)
  }

  group_quo = rlang::enquo(group)

  if(!rlang::quo_is_symbol(group_quo)) {
    stop("`group` must be a bare column name, not an expression.", call. = FALSE)
  }

  group_name = rlang::as_name(group_quo)

  #PASS TO CORRECT HELPER ACCORDING TO GEOMETRY
  if(geometry == "point") {

    label_data = .directlabel_points(data = data,
                                    x = {{x}},
                                    y = {{y}},
                                    group = {{group}},
                                    placement = placement,
                                    adj_fact = adj_fact,
                                    facet_vars = facet_vars)

  } else if(geometry == "line") {

    label_data = .directlabel_lines(data = data,
                                   x = {{x}},
                                   y = {{y}},
                                   group = {{group}},
                                   placement = placement,
                                   adj_fact = adj_fact,
                                   facet_vars = facet_vars)

  }

  if(nrow(label_data) == 0) {
    stop("No complete x/y/group observations are available for direct labeling.", call. = FALSE)
  }

  #TO REPEL AWAY FROM THE LINES/POINTS AS WELL AS OTHER LABELS, WE SILENTLY ADD THE GEOMETRIES AS LABEL-LESS ENTITIES
  invis_points =  data %>%
    dplyr::transmute(
      x = {{x}},
      y = {{y}},
      .label_plus = "",
      dplyr::across(dplyr::any_of(c(facet_vars, group_name)))
    )

  #IF USERS SUPPLIED CUSTOM LABELS, WE CAN APPLY THEM. A NAMED VEC OF OLD = NEW IS ADVISED.

  label_data$.label_plus = .apply_key_labels_plus(label_data = label_data$.label_plus, key_labels = key_labels)

  #BIND THE FAKE AND REAL LABEL DATA TOGETHER.
  all_label_data = dplyr::bind_rows(label_data, invis_points)

  ##PARTIAL MATCHING AND ARGUMENT COLLISIONS--TO SET DEFAULTS THAT ARE OVERRIDABLE.
  dot.args = list(...)
    any_size = .partial_match_user_arg(dot.args, "size")
    any_boxpad = .partial_match_user_arg(dot.args, "box.padding")
    any_maxover = .partial_match_user_arg(dot.args, "max.overlaps")
    any_segsize = .partial_match_user_arg(dot.args, "segment.size")
    any_minseg = .partial_match_user_arg(dot.args, "min.segment.length")

    if(length(any_size) > 0) { use_size = any_size; dot.args = .remove_partial_match_user_arg(dot.args, "size") } else { use_size = 5 }
    if(length(any_boxpad) > 0) { use_boxpad = any_boxpad; dot.args = .remove_partial_match_user_arg(dot.args, "box.padding") } else { use_boxpad = 0.5 }
    if(length(any_maxover) > 0) { use_maxover = any_maxover; dot.args = .remove_partial_match_user_arg(dot.args, "max.overlaps") } else { use_maxover = Inf }
    if(length(any_segsize) > 0) { use_segsize = any_segsize; dot.args = .remove_partial_match_user_arg(dot.args, "segment.size") } else { use_segsize = 1 }
    if(length(any_minseg) > 0) { use_minseg = any_minseg; dot.args = .remove_partial_match_user_arg(dot.args, "min.segment.length") } else { use_minseg = 0 }

  #THEN FINALLY PASS THIS ALL ALONG, ALONG WITH ANY DOT ARGS, TO GEOM_LABEL_REPEL.
  do.call(
    ggrepel::geom_label_repel,
    c(
      list(
    data = all_label_data,
    ggplot2::aes(x = x, y = y, label = .label_plus),
    color = "black",
    inherit.aes = FALSE,
    show.legend = FALSE,
    size = use_size,
    box.padding = use_boxpad,
    max.overlaps = use_maxover,
    segment.size = use_segsize,
    min.segment.length = use_minseg),
    dot.args
   )
  )

}

#' Turn on a "focus mode" to highlight specific discrete groups
#'
#' `scale_focus_plus()` is a wrapper for ggplot2 manual scale functions that
#' helps a user quickly create a discrete scale that highlights one or more
#' focal groups while de-emphasizing all other groups via chroma (grayness),
#' size, line width, or transparency. This is useful when a graph would
#' ideally call attention to specific groups without removing the broader
#' context and transparency provided by the remaining groups. This reduces
#' cognitive load by allowing non-essential information to "fall into the
#' background" to be readily ignored, increasing the reading rate, and it also
#' helps to signpost for the reader where the "message" is within the plot.
#'
#' By default, when `aes` is set to `fill` or `color`, focal groups are assigned
#' visually prominent colors from the Universal-Design-oriented viridis color
#' palette via `viridisLite::viridis()`, while non-focal groups are assigned a
#' shared gray.
#'
#' By default, focal groups are differentiated from one another, while
#' non-focal groups are not. These defaults are intended to support a common
#' graph-design pattern: show all groups, but make the intended comparison
#' the reader ought to make obvious.
#'
#' Note: the default values for `gray_start`, `gray_end`, `saturated_start`, and
#' `saturated_end` intentionally map to different regions of the lightness (light
#' to dark) scale so as to render the colors still distinguishable in grayscale
#' by virtue of variance in lightness. This variance should be maintained for
#' accessibility even if different inputs are provided.
#'
#' Focus can also be drawn via the aesthetics of size, line width, and alpha,
#' as these aesthetics are useful in many situations where variance in chroma is
#' not.
#'
#' @param aes A character vector indicating which aesthetics should receive
#'   focus scales. Each value must be one of `"color"`, `"colour"`, `"fill"`,
#'   `"size"`, `"linewidth"`, or `"alpha"`. Supply one value to create one
#'   scale or multiple values as a convenience to focus via several
#'   aesthetics at once. Duplicate aesthetics are not allowed; `"color"` and
#'   `"colour"` are considered equivalent.
#' @param group_var A character vector or factor containing the grouping variable
#'   mapped to `aes` in the plot.
#' @param focal_groups A character vector giving the group value(s) in the
#' `group_var` to be emphasized. All values must be present in `group_var`.
#' @param diff_nonfocal Logical. If `TRUE`, non-focal groups are assigned
#'   different aesthetic values. If `FALSE`, all non-focal groups receive the
#'   same value. Defaults to `FALSE`.
#' @param diff_focal Logical. If `TRUE`, focal groups are assigned different
#'   aesthetic values. If `FALSE`, all focal groups receive the same value.
#'   Defaults to `TRUE`.
#' @param gray_start,gray_end Numeric values between 0 and 1 controlling the
#'   range of gray values used for non-focal groups when `custom_nonfocal_cols`
#'   is `NULL`. Lower values are darker and higher values are lighter. `gray_start`
#'   must be less than or equal to `gray_end`.
#' @param saturated_start,saturated_end Numeric values between 0 and 1 controlling the
#'   portions of the viridis palette used for focal groups when `custom_focal_cols`
#'   is `NULL`. By default, `scale_focus_plus()` draws from the darker and lighter
#'   ends of the palette while avoiding the middle, as humans are generally more
#'   drawn to very bright and very dark colors. `saturated_end` must be less than
#'   or equal to `saturated_start`.
#' @param custom_focal_cols Optional custom color(s) for focal group(s). When
#'   `diff_focal = TRUE`, this must be a named character vector whose names
#'   match the unique values in `focal_groups`. When `diff_focal = FALSE`,
#'   this must be a character vector of length 1.
#' @param custom_nonfocal_cols Optional custom color(s) for non-focal group(s). When
#'   `diff_nonfocal = TRUE`, this must be a named character vector whose names
#'   match the non-focal values in `group_var`. When `diff_nonfocal = FALSE`,
#'   this must be a character vector of length 1.
#' @param size_start,size_end Positive numeric values controlling the most and
#'   least prominent point sizes, respectively. `size_start` is assigned at the
#'   focal end of the scale and must be greater than `size_end`.
#' @param linewidth_start,linewidth_end Positive numeric values controlling the
#'   most and least prominent line widths, respectively. `linewidth_start` is
#'   assigned at the focal end of the scale and must be greater than
#'   `linewidth_end`.
#' @param alpha_start,alpha_end Numeric values between 0 and 1 controlling the
#'   most and least prominent alpha values, respectively. `alpha_start` is
#'   assigned at the focal end of the scale and must be greater than
#'   `alpha_end`.
#' @param ... Additional arguments passed to each corresponding ggplot2 manual
#'   scale. Do not supply `values` or `aesthetics`; `scale_focus_plus()`
#'   constructs those arguments internally. When `aes` contains multiple
#'   aesthetics, every argument in `...` is passed to every generated scale.
#'   Arguments such as `labels`, `name`, and `guide` can therefore be shared
#'   conveniently. To pass different arguments to different scales, use
#'   multiple separate `scale_focus_plus()` calls instead.
#'
#' @details
#' `scale_focus_plus()` is a convenience wrapper around
#' ggplot2 manual scales for colour, fill, size, linewidth, and alpha. It does
#' not alter the data or add any geoms. Instead, it constructs a named vector of
#' aesthetic values from `group_var` and `focal_groups`, then passes that vector
#' to the appropriate ggplot2 manual scale.
#'
#' Supplying multiple values to `aes` is shorthand for adding multiple separate
#' `scale_focus_plus()` calls with the same focal settings and `...` arguments
#' to be applied to all of them. Calling each aesthetic separately instead is
#' useful when, for example, the scales need different names, guides, breaks,
#' or labels.
#'
#' This function is most useful when the focal/non-focal distinction is the
#' primary visual message, and all non-focal groups may be secondary. When
#' individual non-focal groups must remain distinguishable, set
#' `diff_nonfocal = TRUE` or provide `custom_nonfocal_cols` values.
#'
#' Scales apply to every layer that maps or inherits the selected aesthetic. To
#' focus point size without also invoking ggplot2's backwards-compatible `size`
#' behavior for lines, map `size` locally inside the point layer rather than in
#' the plot's global aesthetic mapping (i.e., `geom_point(aes(size = ...))`).
#'
#' Although `scale_focus_plus()` is designed for discrete data, it can also be
#' used when the data requiring (de-)emphasis is continuous. In those cases,
#' first create a discrete grouping variable in the data, then map that variable
#' to the selected aesthetic. For example, a continuous measurement could be
#' converted to groups such as `"High cover"` and `"Other"` before calling
#' `scale_focus_plus()`. See the examples section.
#'
#' @return A ggplot2 scale object when `aes` contains one aesthetic, or a list
#'   of ggplot2 scale objects when `aes` contains multiple aesthetics. Either
#'   return value can be added directly to a ggplot with `+`.
#'
#' @examples
#' lake_dat = data.frame(
#'   year = rep(2012:2020, times = 5),
#'   lake = rep(paste("Lake", LETTERS[1:5]), each = 9),
#'   cpue = c(
#'     10, 12, 13, 14, 16, 18, 19, 21, 23,
#'     18, 17, 16, 16, 15, 14, 13, 13, 12,
#'     8, 9, 11, 13, 16, 20, 24, 27, 30,
#'     22, 21, 21, 20, 19, 18, 18, 17, 17,
#'     12, 13, 13, 15, 15, 16, 17, 18, 20
#'   )
#' )
#'
#' ggplot2::ggplot(
#'   lake_dat,
#'   ggplot2::aes(x = year,
#'                y = cpue,
#'                colour = lake,
#'                group = lake)
#' ) +
#'   ggplot2::geom_line(linewidth = 1) +
#'   ggplot2::geom_point(size = 2) +
#'   scale_focus_plus(aes = "colour",
#'              group_var = lake_dat$lake,
#'              focal_groups = c("Lake A", "Lake C"))
#'
#' # Focus through several aesthetics with one convenience call. Arguments in
#' # ... (here, guide) are shared by every generated scale.
#' ggplot2::ggplot(
#'   lake_dat,
#'   ggplot2::aes(x = year,
#'                y = cpue,
#'                colour = lake,
#'                group = lake)
#' ) +
#'   ggplot2::geom_line(ggplot2::aes(linewidth = lake)) +
#'   ggplot2::geom_point(ggplot2::aes(size = lake, alpha = lake)) +
#'   scale_focus_plus(aes = c("colour", "linewidth", "size", "alpha"),
#'                    group_var = lake_dat$lake,
#'                    focal_groups = c("Lake A", "Lake C"),
#'                    diff_focal = FALSE,
#'                    guide = "none")
#'
#' # Use separate calls when the scales need different arguments.
#' ggplot2::ggplot(
#'   lake_dat,
#'   ggplot2::aes(x = year, y = cpue, group = lake)
#' ) +
#'   ggplot2::geom_point(
#'     ggplot2::aes(colour = lake, size = lake)
#'   ) +
#'   scale_focus_plus(aes = "colour",
#'                    group_var = lake_dat$lake,
#'                    focal_groups = "Lake A",
#'                    name = "Highlighted lake") +
#'   scale_focus_plus(aes = "size",
#'                    group_var = lake_dat$lake,
#'                    focal_groups = "Lake A",
#'                    guide = "none")
#'
#' # One can use a shared focal color and a custom non-focal gray.
#' ggplot2::ggplot(
#'   lake_dat,
#'   ggplot2::aes(x = year,
#'                y = cpue,
#'                colour = lake,
#'                group = lake)
#' ) +
#'   ggplot2::geom_line(linewidth = 1) +
#'   scale_focus_plus(aes = "colour",
#'              group_var = lake_dat$lake,
#'              focal_groups = c("Lake A", "Lake C"),
#'              diff_focal = FALSE,
#'              custom_focal_cols = "#440154",
#'              custom_nonfocal_cols = "gray70")
#'
#' cover_dat = data.frame(
#'   taxon = c("Native plants",
#'             "Starry stonewort",
#'             "Eurasian watermilfoil",
#'             "Curly-leaf pondweed"),
#'   mean_cover = c(62, 28, 18, 11)
#' )
#'
#' ggplot2::ggplot(
#'   cover_dat,
#'   ggplot2::aes(x = taxon,
#'                y = mean_cover,
#'                fill = taxon)
#' ) +
#'   ggplot2::geom_col() +
#'   scale_focus_plus(aes = "fill",
#'              group_var = cover_dat$taxon,
#'              focal_groups = "Starry stonewort") +
#'   ggplot2::labs(x = NULL,
#'                 y = "Mean percent cover")
#'
#' # Focal groups can also be created from continuous variables. Here's how:
# site_dat = data.frame(
#   site = paste("Site", 1:12),
#   mean_cover = c(4, 8, 12, 15, 18, 24, 31, 38, 45, 52, 67, 73)
# )
#
# site_dat$cover_group = ifelse(site_dat$mean_cover >= 50,
#                              "High cover",
#                              "Other")
#
# ggplot2::ggplot(
#   site_dat,
#   ggplot2::aes(x = site,
#                y = mean_cover,
#                fill = cover_group)
# ) +
#   ggplot2::geom_col() +
#   scale_focus_plus(aes = "fill",
#                    group_var = site_dat$cover_group,
#                    focal_groups = "High cover",
#                    diff_focal = FALSE,
#                    custom_focal_cols = "#440154",
#                    custom_nonfocal_cols = "gray75") +
#   ggplot2::labs(x = NULL,
#                 y = "Mean percent cover",
#                 fill = NULL)
#' @export
scale_focus_plus = function(aes,
                            group_var,
                            focal_groups,
                            diff_nonfocal = FALSE, #<--USE DIFFERENT SHADES FOR GROUPS WITHIN THE FOCAL OR NON-FOCAL GROUPS?
                            diff_focal = TRUE,
                            gray_start = 0.35, #<--ADJUST EXACT COLORS USED.
                            gray_end = 0.65,
                            saturated_start = 0.75,
                            saturated_end = 0.25,
                            custom_focal_cols = NULL,
                            custom_nonfocal_cols = NULL,
                            size_start = 6.5,
                            size_end = 3.5,
                            linewidth_start = 2,
                            linewidth_end = 0.6,
                            alpha_start = 1,
                            alpha_end = 0.35,
                            ...) { #<--PASS THRU TO SCALE_*_MANUAL()

  ##GENERAL, AES-AGNOSTIC EARLY FAILS
  validAes = c("color", "colour", "fill", "size", "linewidth", "alpha")

  if(!is.character(aes) ||
     length(aes) < 1L ||
     anyNA(aes) ||
     any(is.null(aes))) {
    stop("`aes` must contain only one or more supported aesthetics. See ?scale_focus_plus for details.")
  }

  aes = vapply(aes, function(a) {
    match.arg(a, validAes)  #BY DOING IT THIS WAY, WE WILL ACTUALLY TRIGGER AN ERROR IF ANY INPUT WERE TO FAIL FOR ANY REASON (IT'S BOGUS, IT'S MISTYPED, ETC.)
  }, character(1))

  #NORMALIZE TO ONE COLOR SPELLING
  aes[aes == "color"] = "colour"

  if(anyDuplicated(aes)) {
    stop("`aes` must not contain duplicate aesthetics (`color` and `colour` would be considered equivalent in this sense)")
  }


  if(all(!is.character(group_var),
         !is.factor(group_var)) ||
     length(unique(group_var)) <= 1) {
    stop("Invalid `group_var`: Must be a character or factor with more than one level.")
  }

  if(!is.character(focal_groups) ||
     length(unique(focal_groups)) == 0) {
    stop("Invalid `focal_groups`: Must be a character of length >= 1.")
  }

  if(!is.logical(diff_nonfocal) || length(diff_nonfocal) != 1 || is.na(diff_nonfocal) ||
     !is.logical(diff_focal) || length(diff_focal) != 1 || is.na(diff_focal)) {
    stop("Both `diff_nonfocal` and `diff_focal` must be length-1 logicals.")
  }

  if(any(is.na(group_var))) {
    stop("Invalid `group_var`: Missing values are not currently supported.")
  }

  if(any(is.na(focal_groups))) {
    stop("Invalid `focal_groups`: Missing values are not allowed.")
  }


  #COLOR-SPECIFIC EARLY FAILS
  if(any(aes %in% c("color", "colour", "fill"))) {

    if(!is.numeric(gray_start) || !is.numeric(gray_end) ||
       !is.numeric(saturated_start) || !is.numeric(saturated_end) ||
       length(gray_start) != 1 || length(gray_end) != 1 ||
       length(saturated_start) != 1 || length(saturated_end) != 1) {
      stop("`saturated_start`, `saturated_end`, `gray_start`, and `gray_end` must all be length-1 numeric values between 0 and 1 (inclusive).")
    }

    if(!.is_between(gray_start, range = c(0,1)) ||
       !.is_between(gray_end, range = c(0,1)) ||
       !.is_between(saturated_start, range = c(0,1)) ||
       !.is_between(saturated_end, range = c(0,1))) {
      stop("`saturated_start`, `saturated_end`, `gray_start`, and `gray_end` must all be length-1 numeric values between 0 and 1 (inclusive).")
    }

    if(gray_start > gray_end) {
      stop("`gray_start` must be less than or equal to `gray_end`.")
    }

    if(saturated_end > saturated_start) {
      stop("`saturated_end` must be less than or equal to `saturated_start`.")
    }
  }

  #NON-COLOR SPECIFIC EARLY FAILS
  if("size" %in% aes) {
    if(!is.numeric(size_start) || !is.numeric(size_end) ||
       length(size_start) != 1 || length(size_end) != 1 ||
       !is.finite(size_start) || !is.finite(size_end) ||
       size_start <= 0 || size_end <= 0) {
      stop("`size_start` and `size_end` must be length-1, finite, positive numeric values.")
    }
    if(size_start <= size_end) {
      stop("`size_start` must be greater than `size_end` to ensure focal groups are larger.")
    }
  }

  if("linewidth" %in% aes) {
    if(!is.numeric(linewidth_start) || !is.numeric(linewidth_end) ||
       length(linewidth_start) != 1 || length(linewidth_end) != 1 ||
       !is.finite(linewidth_start) || !is.finite(linewidth_end) ||
       linewidth_start <= 0 || linewidth_end <= 0) {
      stop("`linewidth_start` and `linewidth_end` must be length-1, finite, positive numeric values.")
    }
    if(linewidth_start <= linewidth_end) {
      stop("`linewidth_start` must be greater than `linewidth_end` to ensure focal groups have wider lines.")
    }
  }

  if("alpha" %in% aes) {
    if(!is.numeric(alpha_start) || !is.numeric(alpha_end) ||
       length(alpha_start) != 1 || length(alpha_end) != 1 ||
       !.is_between(alpha_start, range = c(0,1)) ||
       !.is_between(alpha_end, range = c(0,1))) {
      stop("`alpha_start` and `alpha_end` must be length-1 numeric values between 0 and 1 (inclusive).")
    }
    if(alpha_start <= alpha_end) {
      stop("`alpha_start` must be greater than `alpha_end` to ensure focal groups are more opaque.")
    }
  }

  dot.args = list(...) #NO NEED FOR PARTIAL MATCHING OR COLLISIONS BECAUSE I'M NOT PASSING ANYTHING BUT OVERRIDE-ABLE DEFAULT VALUES TO THE SCALE FUNCTION(S)

  any_values = any(pmatch(names(dot.args), "values", nomatch = 0L) > 0L) #EXCEPT FOR THIS. THIS FORMAT CHECKS NAMES RATHER THAN VALUES SO PEOPLE CAN'T PASS NULL THRU FOR A NAMED AESTHETIC AND SQUEEZE IT BY.

  if(any_values) {
    dot.args = .remove_partial_match_user_arg(dot.args, "values")
    warning("Don't provide a `values` argument to `scale_focus_plus`. It constructs `values` internally using your other inputs. ")
  }

  any_aesthetics = any(pmatch(names(dot.args), "aesthetics", nomatch = 0L) > 0L) #AND THIS.

  if(any_aesthetics) {
    dot.args = .remove_partial_match_user_arg(dot.args, "aesthetics")
    warning("Don't provide an `aesthetics` argument to `scale_focus_plus`. Use `aes` instead.")
  }

  ##CONVENIENCE OBJS, TIDYING, AND SECONDARY FAIL STATES.

  allGroups = unique(group_var)
  allFocal = unique(focal_groups)
  allNonfocal = setdiff(allGroups, allFocal)
  numFocalGroups = length(allFocal)
  numNonFocal = length(allGroups) - numFocalGroups


  if(any(!focal_groups %in% allGroups)) {
    stop("All values in `focal_groups` must be present within the levels of `group_var`.")
  }

  if(numNonFocal < 1) {
    stop("There are not enough unique levels in `group_var` for a 'focus mode' to make sense given your input to `focal_groups`.")
  }


  #HAPPY PATH FOR COLOR-RELATED AESTHETICS
  finalReturn = list()

  for(a in seq_along(aes)) {

  if(aes[a] %in% c("color", "colour", "fill")) {

  if(!is.null(custom_focal_cols)) {

    bad_custom_focal =
      !is.character(custom_focal_cols) ||
      if(diff_focal) {
        !rlang::is_named(custom_focal_cols) ||
          !identical(sort(names(custom_focal_cols)), sort(allFocal))
      } else {
        length(custom_focal_cols) != 1
      }

    if(bad_custom_focal) {
      stop(
        "Invalid `custom_focal_cols` argument: It must be a named character vector equal in name and number to the unique, differentiated groups in `focal_groups` when `diff_focal = TRUE`, or a character vector of length 1 when `diff_focal = FALSE`.",
        call. = FALSE
      )
    }
  }

  if(!is.null(custom_nonfocal_cols)) {

    bad_custom_nonfocal =
      !is.character(custom_nonfocal_cols) ||
      if(diff_nonfocal) {
        !rlang::is_named(custom_nonfocal_cols) ||
          !identical(sort(names(custom_nonfocal_cols)), sort(allNonfocal))
      } else {
        length(custom_nonfocal_cols) != 1
      }

    if(bad_custom_nonfocal) {
      stop(
        "Invalid `custom_nonfocal_cols` argument: It must be a named character vector equal in name and number to the unique, differentiated, non-focal groups in `group_var` when `diff_nonfocal = TRUE`, or a character vector of length 1 when `diff_nonfocal = FALSE`.",
        call. = FALSE
      )
    }
  }

  ##HAPPY PATH--CHOOSE COLORS ACCORDING TO INPUTS

  if(is.null(custom_nonfocal_cols)) {

    #CHOOSE GRAYS--DEFAULTS TO SMALL VARIANCE IN THE MIDDLE GRAY RANGE.
    if(isTRUE(diff_nonfocal)) {
      nonfocal_cols = grDevices::gray.colors(numNonFocal, start = gray_start, end = gray_end)
    } else {
      gray_val = mean(c(gray_start, gray_end), na.rm = T)
      nonfocal_cols = grDevices::gray.colors(numNonFocal, start = gray_val,
                                             end = gray_val)
    }

  } else {

    if(isTRUE(diff_nonfocal)) {
      nonfocal_cols = custom_nonfocal_cols[as.character(allNonfocal)]
    } else {
      nonfocal_cols = rep(custom_nonfocal_cols[[1]], length.out = numNonFocal)
    }

  }

  if(is.null(custom_focal_cols)) {

    #CHOOSE VIRIDIS VALS--DEFAULTS TO LARGE VARIANCE IN LIGHT/DARK RANGES.
    n_focal_each = 64

    viridisCensored = c(
      viridisLite::viridis(n = n_focal_each, begin = saturated_start, end = 1),
      viridisLite::viridis(n = n_focal_each, begin = 0, end = saturated_end)
    )

    if(isTRUE(diff_focal)) {
      focal_cols = viridisCensored[seq(from = 1,
                                       to = length(viridisCensored),
                                       length.out = numFocalGroups)]
    } else {
      focal_cols = rep(viridisCensored[1], times = numFocalGroups)
    }

  } else {

    if(isTRUE(diff_focal)) {
      focal_cols = custom_focal_cols[as.character(allFocal)]
    } else {
      focal_cols = rep(custom_focal_cols[[1]], length.out = numFocalGroups)
    }

  }

  all_cols = c(nonfocal_cols, focal_cols)
  names(all_cols) = c(as.character(allNonfocal),
                      as.character(allFocal))

  scale2call = paste0("scale_", aes[a], "_manual")


  addThisCall = do.call(scale2call, args = c(list(
    values = all_cols
  ),
  dot.args
  ))

  finalReturn[[length(finalReturn) + 1L]] = addThisCall #THIS FORMAT IS LESS APT TO BREAK THAN c().

  }

  #HAPPY PATH FOR NON-COLOR-RELATED AESTHETICS
  if(aes[a] %in% c("size", "linewidth", "alpha")) {

    valsFocal = ifelse(diff_focal, length(allFocal), 1)
    valsNonfocal = ifelse(diff_nonfocal, length(allNonfocal), 1)
    valsNum = valsFocal + valsNonfocal

    if(aes[a] == "size") { startVal = size_start; endVal = size_end }
    if(aes[a] == "linewidth") { startVal = linewidth_start; endVal = linewidth_end }
    if(aes[a] == "alpha") { startVal = alpha_start; endVal = alpha_end }

    customVals = seq(from = startVal, to = endVal, length.out = valsNum)

    if(length(customVals) == 2) {
      customVals = rep(customVals, times = c(length(allFocal), length(allNonfocal)))
    }

    if(length(customVals) > 2 &&
       length(customVals) < length(c(allFocal, allNonfocal))) {
      if(diff_focal) {
        customVals = c(
          customVals[seq_len(length(customVals) - 1L)],
          rep(customVals[length(customVals)], times = length(allNonfocal))
        )
      } else {
        customVals = c(
          rep(customVals[1], times = length(allFocal)),
          customVals[seq.int(2L, length(customVals))]
        )
      }
    }

    names(customVals) = c(as.character(allFocal), as.character(allNonfocal))

    addThisCall = do.call(ggplot2::scale_discrete_manual, args = c(list(
      values = customVals,
      aesthetics = aes[a]
    ),
    dot.args
    ))

    finalReturn[[length(finalReturn) + 1L]] = addThisCall
   }
  }

  #PRESERVES A SCALE OBJECT RETURN IF THERE'S ONLY 1 SCALE TO RETURN (FOR BACKWARDS COMPATABILITY)
  if(length(finalReturn) == 1L) {
    return(finalReturn[[1]])
  }

  return(finalReturn)

}


#' Create an icon array from frequency data
#'
#' `icon_array_plus()` turns a vector of categorical observations into an
#' icon array, a plot representing frequencies using differentiated icons.
#' Each icon represents one observation unless the data are rescaled to remain
#' at or below `max_icons`. Groups can be distinguished using the fill, colour,
#' and/or custom shape aesthetics available through [geom_point_plus()].
#'
#' @param vector A vector of at least 10 observations to tabulate. The vector
#' must not be a list or contain only missing values. Each distinct non-missing
#' value is treated as one group; missing values are retained as an additional,
#' separate group.
#' @param aeses A character vector containing one or more of `"shape"`,
#' `"fill"`, and `"colour"`. `"color"` is accepted as an alias for
#' `"colour"`. Each selected aesthetic is mapped to the icon grouping variable.
#' Defaults to `c("shape", "fill")`.
#' @param max_icons A length-one finite integer greater than 9 giving the
#' maximum number of icons to draw. This is a limit, not a target. When the
#' input contains more observations, group frequencies are scaled
#' proportionally and can produce fewer than `max_icons` icons. In other words,
#' partial icons are not drawn. Defaults to `100`.
#' @param max_observed_groups A positive, length-one integer giving the maximum
#' number of non-missing groups to display when `consolidate_small_groups` is
#' `TRUE`. The generated `other_label` group counts toward this maximum, while
#' a missing-value group does not. Defaults to `5`.
#' @param consolidate_small_groups Logical indicating whether the least
#' frequent groups should be combined into an `other_label` group when the
#' number of observed non-missing groups exceeds `max_observed_groups`.
#' Defaults to `TRUE`.
#' @param sort_descending Logical indicating whether groups should be arranged
#' from greatest to least in observed frequencies. Sorting uses frequencies before
#' any rescaling to `max_icons`. If `FALSE`, standard ordering based on
#' alphanumeric ordering is used. Defaults to `TRUE`.
#' @param other_label A non-missing ,length-one character value used to label the
#' group created by consolidation. Defaults to `"Other"`. When consolidation
#' is required, the value provided must not already occur as an observed group.
#' @param na_label A non-missing, length-one character value used to label the
#' group containing missing observations. Defaults to `"Missing"`. If missing
#' observations occur, the value provided must not also occur as an observed group.
#' @param icon_size A positive, length-one, finite number controlling the size of
#' icons passed to [geom_point_plus()]. Defaults to `10`.
#' @param chosen_icon_shapes An optional character vector naming shapes in the
#' current `geom_point_plus()` shape registry. When shape is mapped, these
#' values determine the shape sequence; if shape is the only grouping
#' aesthetic, enough unique shapes must be supplied to distinguish every
#' displayed group. When shape is not mapped, exactly one shape can be supplied
#' and is used for every icon. The default constant shape is `"square"`, yielding
#' a standard "waffle plot."
#' @param include_legend Logical indicating whether a legend should be displayed.
#' Defaults to `TRUE`.
#' @param legend_title A non-missing, length-one character value used as the
#' title for the legend. Defaults to `"Group"`.
#' @param legend_labels An optional character vector containing one display
#' label for every group that remains after consolidation and rescaling. An
#' unnamed vector is matched to groups in plotted order. A named vector can be
#' supplied in any order, but its names must correspond exactly to the
#' post-processing group names, including `other_label` and `na_label` when
#' those groups are displayed.
#' @param ... Additional fixed-aesthetic and graphical parameters passed to
#' [geom_point_plus()]. Inputs controlled internally by `icon_array_plus()`,
#' such as `mapping`, `data`, `stat`, `position`, `size`, `shape`, and legend or
#' shape-scale controls, are ignored with a warning. A fixed `fill` or `colour`
#' can be supplied only when that aesthetic is not included in `aeses`.
#' Unnamed arguments are ignored.
#' @param max_aspect A length-one finite number of at least 1 limiting how many
#' times wider than tall a non-square candidate layout may be. Layout selection
#' minimizes unused positions first and then favors more nearly square arrays
#' among tied candidates. Defaults to `2.5`.
#' @param legend_icon_size A positive, length-one, finite number controlling icon
#' size in the legend. Defaults to `10`.
#'
#' @details
#' If the input contains more than `max_icons` observations, frequencies are
#' scaled proportionally. Fractional counts of at least half an icon are
#' eligible to round up so long as total icons remain below `max_icons`; smaller
#' fractions are omitted (no partial icons are drawn). Rescaling can therefore
#' remove very small groups and does not necessarily produce exactly `max_icons`
#' icons. The function stops if fewer than 10 icons would remain, as such a
#' small number of icons is not typically a good use case for an icon array.
#'
#' When consolidation is enabled, the most frequent non-missing groups are
#' retained and the remaining groups are combined under `other_label`. Missing
#' values remain separate from this process and can therefore produce one more
#' displayed group than `max_observed_groups`.
#'
#' The selected layout minimizes empty positions while excluding excessively
#' wide layouts according to `max_aspect`. Icons begin at the upper-left, fill
#' downward within each column, and then proceed from left to right.
#'
#' The returned object is a complete plot object: no call to `ggplot2::ggplot()`
#' is needed! But it remains possible to add ggplot2 layers, scales, labels, and
#' themes with `+`. Axes are blanked using [theme_plus()] with
#' `blank_axes = TRUE`.
#' When colour is not mapped, the discrete fill palette is extended through to
#' the yellow end of the viridis scale because icons retain a dark outline by
#' default that maintains contrast. Adding another `theme_plus()` call later can
#' override palette settings; use `blank_axes = TRUE` in that call to retain the
#' icon-array axis treatment.
#'
#' @return A complete ggplot2 plot containing the generated icon-array data, a
#' [geom_point_plus()] layer, grouping guides, and an axis-free [theme_plus()].
#'
#' @examples
#' outcomes = c(
#'   rep("Yes", 62),
#'   rep("No", 25),
#'   rep("Unsure", 13)
#' )
#'
#' icon_array_plus(outcomes)
#'
#' icon_array_plus(
#'   outcomes,
#'   aeses = c("shape", "fill"),
#'   chosen_icon_shapes = c("circle", "square", "flower"),
#'   legend_title = "Response",
#'   legend_labels = c(
#'     Yes = "Yes",
#'     No = "No",
#'     Unsure = "Not sure"
#'   )
#' )
#'
#' # Custom shapes can turn a conventional waffle plot into a true icon array.
#' head_angles = seq(0, 2 * pi, length.out = 33)[-33]
#' silhouette_head = data.frame(
#'   x = 0.09 * cos(head_angles),
#'   y = 0.31 + 0.09 * sin(head_angles),
#'   piece = 1
#' )
#'
#' male_body = data.frame(
#'   x = c(-0.11, -0.22, -0.30, -0.23, -0.16, -0.14, -0.04,
#'          0.00,  0.04,  0.14,  0.16,  0.23,  0.30,  0.22,  0.11),
#'   y = c( 0.18,  0.12, -0.08, -0.11,  0.02, -0.38, -0.38,
#'         -0.14, -0.38, -0.38,  0.02, -0.11, -0.08,  0.12,  0.18),
#'   piece = 2
#' )
#' male_silhouette = rbind(silhouette_head, male_body)
#'
#' female_body = data.frame(
#'   x = c(-0.08, -0.18, -0.28, -0.21, -0.14, -0.25,
#'          0.25,  0.14,  0.21,  0.28,  0.18,  0.08),
#'   y = c( 0.18,  0.11, -0.08, -0.11,  0.01, -0.25,
#'         -0.25,  0.01, -0.11, -0.08,  0.11,  0.18),
#'   piece = 2
#' )
#' female_legs = data.frame(
#'   x = c(-0.12, -0.03, -0.03, -0.12,
#'          0.03,  0.12,  0.12,  0.03),
#'   y = c(-0.25, -0.25, -0.40, -0.40,
#'         -0.25, -0.25, -0.40, -0.40),
#'   piece = rep(3:4, each = 4)
#' )
#' female_silhouette = rbind(silhouette_head, female_body, female_legs)
#'
#' add_shape_plus(
#'   "example_male_silhouette",
#'   male_silhouette,
#'   overwrite = TRUE
#' )
#' add_shape_plus(
#'   "example_female_silhouette",
#'   female_silhouette,
#'   overwrite = TRUE
#' )
#'
#' shop_visits = c(rep("Female", 78), rep("Male", 22))
#'
#' icon_array_plus(
#'   shop_visits,
#'   chosen_icon_shapes = c(
#'     "example_female_silhouette",
#'     "example_male_silhouette"
#'   ),
#'   legend_title = "Shop visits"
#' )
#'
#' @seealso [geom_point_plus()], [add_shape_plus()], [theme_plus()]
#' @export
icon_array_plus = function(
    vector,
    aeses = c("shape", "fill"),
    max_icons = 100,
    max_observed_groups = 5,
    consolidate_small_groups = TRUE,
    sort_descending = TRUE, #IF FALSE, WILL RESPECT STANDARD ALPHANUMERIC ORDERING, NOT FIRST APPEARANCE ORDERING.
    other_label = "Other",
    na_label = "Missing",
    icon_size = 10,
    chosen_icon_shapes = NULL,
    include_legend = TRUE,
    legend_title = "Group",
    legend_labels = NULL, #IF A NAMED VECTOR, MUST BE GROUP NAMES POST-PROCESSING WHICH MIGHT SUBSUME THE na_label AND/OR other_label NAMES.
    ...,
    max_aspect = 2.5,
    legend_icon_size = 10
) {

  #EARLY FAILS

  if(is.null(vector) ||
     all(is.na(vector)) ||
     is.list(vector) ||
     length(vector) < 10 ||
     length(table(vector)) < 1
  ) {
    stop("`vector` must be a vector of length 10 or greater, not all values of which are NA.")
  }

  if(is.null(aeses) ||
     !is.character(aeses) ||
     any(is.na(aeses))) {
    stop("`aeses` must be a character vector containing one or more of \"shape\", \"fill\", and \"colour\".")
  }

  aeses[aeses == "color"] = "colour"
  aeses = unique(aeses)
  bad_aeses = setdiff(aeses, c("shape", "fill", "colour"))
  if(length(aeses) < 1 ||                                                                                  length(aeses) > 3 ||                                                                                  length(bad_aeses) > 0) {
    stop("`aeses` must be one or more of \"shape\", \"fill\", and \"colour\".")
  }

  if(is.null(max_observed_groups) ||
     length(max_observed_groups) != 1 ||
     !is.numeric(max_observed_groups) ||
     is.na(max_observed_groups) ||
     !is.finite(max_observed_groups) ||
     max_observed_groups < 1 ||
     max_observed_groups %% 1 != 0
  ) {
    stop("`max_observed_groups` must be a positive length-one finite integer.")
  }

  #FAIL EARLYS
  if(is.null(max_icons) ||
     any(is.na(max_icons)) ||
     !is.numeric(max_icons) ||
     length(max_icons) != 1 ||
     !is.finite(max_icons) ||
     max_icons < 10 ||
     max_icons %% 1 != 0) {
    stop("`max_icons` must be a length-one numeric finite integer greater than 9.")
  }

  if(is.null(na_label) ||
     length(na_label) != 1 ||
     is.na(na_label) ||
     !is.character(na_label)
  ) {
    stop("`na_label` must be a non-missing length-one character value.")
  }

  if(is.null(consolidate_small_groups) ||
     length(consolidate_small_groups) != 1 ||
     is.na(consolidate_small_groups) ||
     !is.logical(consolidate_small_groups)
  ) {
    stop("`consolidate_small_groups` must be TRUE or FALSE.")
  }

  if(is.null(sort_descending) ||
     length(sort_descending) != 1 ||
     is.na(sort_descending) ||
     !is.logical(sort_descending)
  ) {
    stop("`sort_descending` must be TRUE or FALSE.")
  }

  if(is.null(other_label) ||
     length(other_label) != 1 ||
     is.na(other_label) ||
     !is.character(other_label)
  ) {
    stop("`other_label` must be a non-missing length-one character value.")
  }

  if(is.null(max_aspect) ||
     length(max_aspect) != 1L ||
     !is.numeric(max_aspect) ||
     is.na(max_aspect) ||
     !is.finite(max_aspect) ||
     max_aspect < 1
  ) {
    stop("`max_aspect` must be a length-one finite numeric value of at least 1.")
  }

  if(is.null(icon_size) ||
     length(icon_size) != 1 ||
     !is.numeric(icon_size) ||
     is.na(icon_size) ||
     !is.finite(icon_size) ||
     icon_size <= 0
  ) {
    stop("`icon_size` must be a positive length-one finite number.")
  }

  if(is.null(legend_icon_size) ||
     length(legend_icon_size) != 1 ||
     !is.numeric(legend_icon_size) ||
     is.na(legend_icon_size) ||
     !is.finite(legend_icon_size) ||
     legend_icon_size <= 0
  ) {
    stop("`legend_icon_size` must be a positive length-one finite number.")
  }

  if(is.null(include_legend) ||
     length(include_legend) != 1 ||
     is.na(include_legend) ||
     !is.logical(include_legend)
  ) {
    stop("`include_legend` must be TRUE or FALSE.")
  }

  if(is.null(legend_title) ||
     length(legend_title) != 1 ||
     is.na(legend_title) ||
     !is.character(legend_title)
  ) {
    stop("`legend_title` must be a non-missing length-one character value.")
  }

  if(!is.null(legend_labels)) {

    if(!is.character(legend_labels) ||
       any(is.na(legend_labels))) {
      stop("If provided, `legend_labels` must be a character vector with no missing entries.")
    }

  }


  if(!is.null(chosen_icon_shapes)) {

    chosen_icon_shapes = .standardize_pointplus_shape_names(chosen_icon_shapes)

    if(any(is.na(chosen_icon_shapes)) ||
       length(chosen_icon_shapes) < 1 ||
       any(!chosen_icon_shapes %in% names(.pointplus_shapes()))
    ) {
      stop("Every `chosen_icon_shapes` value provided must be a registered shape name.")
    }
  }

  #GEN ICON ARRAY DF
  icon_df = .iconarrayize(
    vector = vector,
    max_icons = max_icons,
    na_label = na_label,
    max_aspect = max_aspect,
    consolidate_small_groups = consolidate_small_groups,
    other_label = other_label,
    max_observed_groups = max_observed_groups,
    sort_descending = sort_descending
  )

  shape_is_mapped = "shape" %in% aeses
  num_groups_drawn = length(unique(icon_df$group))

  if(shape_is_mapped) {

    if(identical(aeses, "shape") &&
       !is.null(chosen_icon_shapes) &&
       length(unique(chosen_icon_shapes)) < num_groups_drawn) {
      stop("If `shape` is your only aes, provide at least as many unique values to `chosen_icon_shapes` as will be displayed to keep groups distinguishable.")
    }

    num_shapes_registered = length(.pointplus_shapes())

    if(num_groups_drawn > num_shapes_registered) {
      stop("Not enough shapes registered in the `pointplus_shapes` palette to draw unique shapes for that many groups! Consolidate groups or use `add_shape_plus()` to add additional shapes.")
    }
  }

  drawn_groups = levels(icon_df$group)

  if(!is.null(legend_labels)) {

    if(length(legend_labels) != length(drawn_groups)) {
      stop("If provided, `legend_labels` must contain a label for every displayed group.")
    }

    if(is.null(names(legend_labels))) {
      names(legend_labels) = drawn_groups
    } else {

      if(any(is.na(names(legend_labels))) ||
         any(names(legend_labels) == "") ||
         anyDuplicated(names(legend_labels)) ||
         !dplyr::setequal(names(legend_labels), drawn_groups)) {
        stop("If `legend_labels` is named, those names must correspond exactly with those of the displayed groups.")
      }
    }

    legend_labels = legend_labels[drawn_groups] #THIS JUST PUTS "NAMED ORDER" INTO "PLOTTED ORDER," WHICH ISN'T NECESSARY BUT IS NICE.
  }

  dot.args = list(...)

  legend_labeler = function(x) {
    return(unname(legend_labels[x]))
  }

  #NEED TO PREVENT SOME ...S FROM GOING THRU...

  any_mapping = .partial_match_user_arg_index(dot.args, "mapping")
  if(length(any_mapping) == 1) {
    dot.args = dot.args[-any_mapping]
    warning("Don't provide a `mapping` input to `icon_array_plus()`. It constructs this input internally.")
  }
  any_data = .partial_match_user_arg_index(dot.args, "data")
  if(length(any_data) == 1) {
    dot.args = dot.args[-any_data]
    warning("Don't provide `data` to `icon_array_plus()`. It constructs this input internally. Did you mean `vector`?")
  }
  any_stat = .partial_match_user_arg_index(dot.args, "stat")
  if(length(any_stat) == 1) {
    dot.args = dot.args[-any_stat]
    warning("Don't provide a `stat` input to `icon_array_plus()`. It determines this input internally.")
  }
  any_position = .partial_match_user_arg_index(dot.args, "position")
  if(length(any_position) == 1) {
    dot.args = dot.args[-any_position]
    warning("Don't provide a `position` input to `icon_array_plus()`. It determines this input internally.")
  }
  any_inherit = .partial_match_user_arg_index(dot.args, "inherit.aes")
  if(length(any_inherit) == 1) {
    dot.args = dot.args[-any_inherit]
    warning("Don't provide a `inherit.aes` input to `icon_array_plus()`. It determines this input internally.")
  }
  any_size = .partial_match_user_arg_index(dot.args, "size")
  if(length(any_size) == 1) {
    dot.args = dot.args[-any_size]
    warning("Don't provide a `size` input to `icon_array_plus()`. Use `icon_size` instead.")
  }
  any_chosenshapes = .partial_match_user_arg_index(dot.args, "chosen_shapes")
  if(length(any_chosenshapes) == 1) {
    dot.args = dot.args[-any_chosenshapes]
    warning("Don't provide a `chosen_shapes` input to `icon_array_plus()`. Use `chosen_icon_shapes` instead.")
  }
  any_shapescale = .partial_match_user_arg_index(dot.args, "show_shape_scale")
  if(length(any_shapescale) == 1) {
    dot.args = dot.args[-any_shapescale]
    warning("Don't provide a `show_shape_scale` input to `icon_array_plus()`. This parameter is controlled internally.")
  }
  any_showlegend = .partial_match_user_arg_index(dot.args, "show.legend")
  if(length(any_showlegend) == 1) {
    dot.args = dot.args[-any_showlegend]
    warning("Don't provide a `show.legend` input to `icon_array_plus()`. Use `include_legend` instead.")
  }
  any_availshapes = .partial_match_user_arg_index(dot.args, "avail_shapes")
  if(length(any_availshapes) == 1) {
    dot.args = dot.args[-any_availshapes]
    warning("Don't provide a `avail_shapes` input to `icon_array_plus()`.")
  }
  any_nshapes = .partial_match_user_arg_index(dot.args, "n_shapes")
  if(length(any_nshapes) == 1) {
    dot.args = dot.args[-any_nshapes]
    warning("Don't provide a `n_shapes` input to `icon_array_plus()`.")
  }
  any_shape = .partial_match_user_arg_index(dot.args, "shape")
  if(length(any_shape) == 1) {
    dot.args = dot.args[-any_shape]
    warning("Don't provide a `shape` input to `icon_array_plus()`. Use `chosen_icon_shapes` instead.")
  }
  any_shapelegend = .partial_match_user_arg_index(dot.args, "include_shape_legend")
  if(length(any_shapelegend) == 1) {
    dot.args = dot.args[-any_shapelegend]
    warning("Don't provide a `include_shape_legend` input to `icon_array_plus()`. Use `include_legend` instead.")
  }
  if("fill" %in% aeses) {
    any_fill = .partial_match_user_arg_index(dot.args, "fill")
    if(length(any_fill) == 1) {
      dot.args = dot.args[-any_fill]
      warning("Don't provide a separate `fill` input to `icon_array_plus()` when `\"fill\"` is provided to `aeses`.")
    }
  }
  if("colour" %in% aeses) {
    any_color = .partial_match_user_arg_index(dot.args, "color")
    if(length(any_color) == 1) {
      dot.args = dot.args[-any_color]
      warning("Don't provide a separate `color` input to `icon_array_plus()` when `\"colour\"` (or `\"color\"`) is mapped via `aeses`.") #CODEX, PLEASE STOP WHINING ABOUT THIS :)
    }
    any_colour = .partial_match_user_arg_index(dot.args, "colour")
    if(length(any_colour) == 1) {
      dot.args = dot.args[-any_colour]
      warning("Don't provide a separate `colour` input to `icon_array_plus()` when `\"colour\"` is provided to `aeses`.")
    }
  }

  #REMOVE ALL UNNAMED ARGS
  dot_arg_names = names(dot.args)
  if(is.null(dot_arg_names)) { dot_arg_names = rep("", length(dot.args)) }
  unnamed_args = is.na(dot_arg_names) | dot_arg_names == ""

  if(any(unnamed_args)) {
    dot.args = dot.args[!unnamed_args]
    message("Unnamed arguments to icon_array_plus() were removed.")
  }


  #THIS APPROACH ONLY ADDS AESTHETICS THAT ACTUALLY SHOULD GET MAPPED--OTHERWISE, WE MIGHT ACCIDENTALLY MAP THEM TO AN EXPRESSION THAT RESOLVES TO NULL LATER, WHICH IS STILL A MAPPING AS FAR AS GGPLOT2 IS CONCERNED.
  mapping_args = list(
    x = quote(.data$x),
    y = quote(.data$y)
  )
  for(i in aeses) {
    mapping_args[[i]] = quote(.data$group)
  }

  icon_mapping = do.call(ggplot2::aes, mapping_args)

  #WE WANT TO OVERRIDE THE DEFAULT SUCH THAT A SQUARE IS THE SINGULAR ICON USED UNLESS OTHERWISE SPECIFIED.
  icon_shapes = chosen_icon_shapes

  if(!shape_is_mapped) {
    if(is.null(icon_shapes)) {
      icon_shapes = "square"
    }
    if(length(icon_shapes) != 1L) {
      stop("Only one `chosen_icon_shapes` value should be supplied when shape is not being mapped.")
    }
  }

  #ASSEMBLED, SCRUBBED "PARTS LIST."
  point_args = c(
    list(
      mapping = icon_mapping,
      chosen_shapes = icon_shapes,
      size = icon_size,
      show_shape_scale = shape_is_mapped,
      show.legend = include_legend,
      legend_labels = if(shape_is_mapped && !is.null(legend_labels)) {
        legend_labeler
      } else {
        NULL
      }
    ),
    dot.args
  )

  point_layer = do.call(geom_point_plus, point_args)

  #ASSEMBLE COMPLETE PLOT OBJ.
  plot = ggplot2::ggplot(data = icon_df) +
    point_layer +
    guides(
      fill = if("fill" %in% aeses) { guide_legend(override.aes = list(size = legend_icon_size), title = legend_title) } else { NULL },
      colour = if("colour" %in% aeses) { guide_legend(override.aes = list(size = legend_icon_size), title = legend_title) } else { NULL },
      shape = if("shape" %in% aeses) { guide_legend(override.aes = list(size = legend_icon_size), title = legend_title) } else { NULL }
    )

  if("fill" %in% aeses && !is.null(legend_labels)) {
    plot = plot + scale_fill_discrete(labels = legend_labeler)
  }
  if("colour" %in% aeses && !is.null(legend_labels)) {
    plot = plot + scale_colour_discrete(labels = legend_labeler)
  }

  if("colour" %in% aeses) {
    plot = plot + theme_plus(blank_axes = TRUE)
  } else {
    plot = plot + theme_plus(blank_axes = TRUE, end_discrete = 1)
  }

  return(plot)

}


#' Demo plot showing geom_point_plus() shapes
#'
#' A prebuilt ggplot object displaying the nine custom point shapes designed specifically for use in `geom_point_plus()`. As of Version 0.5.2, other shapes are also available, but those are not shown via this function. See the documentation for `geom_point_plus()` for details.
#'
#' @format A ggplot object.
#'
#' @return Returns a ggplot2 graph showing the ggplotplus shapes palette.
#'
#' @export
geom_point_plus_shapes = function() {

  ggplot2::ggplot(data = data.frame(x = rep(c(0.5,1.5,2.5), each = 3),
                                                           y = rep(c(1,2,3), times = 3),
                                                           shape = factor(1:9))) +
  geom_point_plus(ggplot2::aes(x = .data$x, y = .data$y, shape = .data$shape, fill = .data$shape), chosen_shapes = c("squircle", "octagon", "flower", "economy", "plus", "waffle", "oval", "sunburst", "lotus"),
                  size = 10, stroke = 1)+
  ggplot2::theme_minimal() +
  ggplot2::lims(y=c(0.5, 3.5), x = c(0.4, 3)) +
  ggplot2::annotate("text", x = 0.8, y = 1, label = "Closed\nRounded\nUncrossed", size = 4) +
  ggplot2::annotate("text", x = 0.8, y = 2, label = "Closed\nPointed\nUncrossed", size = 4) +
  ggplot2::annotate("text", x = 0.8, y = 3, label = "Closed\nRounded\nCrossed", size = 4) +
  ggplot2::annotate("text", x = 1.8, y = 1, label = "Open\nPointed\nUncrossed", size = 4) +
  ggplot2::annotate("text", x = 1.82, y = 2, label = "Intermediate", size = 4) +
  ggplot2::annotate("text", x = 1.8, y = 3, label = "Open\nPointed\nCrossed", size = 4) +
  ggplot2::annotate("text", x = 2.8, y = 1, label = "Open\nRounded\nUncrossed", size = 4) +
  ggplot2::annotate("text", x = 2.8, y = 2, label = "Closed\nPointed\nCrossed", size = 4) +
  ggplot2::annotate("text", x = 2.8, y = 3, label = "Open\nRounded\nCrossed", size = 4) +
  ggplot2::theme(legend.position = "none",
                 axis.text = ggplot2::element_blank(),
                 axis.title = ggplot2::element_blank(),
                 axis.line = ggplot2::element_blank(),
                 axis.ticks = ggplot2::element_blank(),
                 axis.title.x = ggplot2::element_blank(),
                 axis.title.y = ggplot2::element_blank(),
                 panel.grid = ggplot2::element_blank()) +
  ggplot2::annotate("text", x = 0.5, y = 0.7, label = "squircle", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 0.5, y = 1.7, label = "octagon", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 0.5, y = 2.7, label = "flower", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 1.5, y = 0.7, label = "economy", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 1.5, y = 1.7, label = "plus", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 1.5, y = 2.7, label = "waffle", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 2.5, y = 0.7, label = "oval", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 2.5, y = 1.7, label = "sunburst", size = 5, fontface = 'bold') +
  ggplot2::annotate("text", x = 2.5, y = 2.7, label = "lotus", size = 5, fontface = 'bold')
}


#' Add a custom shape for geom_point_plus()
#'
#' Registers a custom point shape for use with \code{geom_point_plus()}.
#' Custom shapes are defined by a data frame of connected polygon coordinates
#' and, once validated, are stored in a session-level shape registry.
#'
#' A shape must be supplied as a data frame with columns \code{x}, \code{y},
#' and \code{piece}. The \code{x} and \code{y} columns define the vertices of
#' the shape, centered around \code{0, 0}. Coordinates should generally be
#' scaled to about \code{+/-0.4} to match the scaling of built-in point shapes.
#' The \code{piece} column identifies separate polygon pieces within the same
#' shape to generate "holes," as appropriate.
#'
#' For inspiration and to model inputs, see `ggplotplus_shapes_list` for the
#' structure of the built-in point shapes.
#'
#' @param name A single character string giving the name of the new shape.
#' @param shape A data frame with columns \code{x}, \code{y}, and \code{piece}.
#' @param overwrite Logical. If \code{FALSE}, the default, an error is returned
#'   when \code{name} already exists in the shape registry. If \code{TRUE}, the
#'   existing shape is replaced with the newly provided shape. Useful if, e.g.,
#'   you'd like to scale an existing shape up or down in size.
#' @param ... Additional arguments. Partial argument matching is supported for
#' friendly UX.
#'
#' @return Invisibly returns the registered shape name.
#'
#' @examples
#' test_star = data.frame(
#'   x = c(0.000,  0.118,  0.380,  0.190,  0.235,
#'         0.000, -0.235, -0.190, -0.380, -0.118),
#'   y = c(0.400,  0.124,  0.124, -0.047, -0.324,
#'        -0.153, -0.324, -0.047,  0.124,  0.124),
#'   piece = 1
#' )
#'
#' add_shape_plus("test_star", test_star)
#'
#' @export
add_shape_plus = function(name = NULL,
                                    shape = NULL,
                                    overwrite = FALSE,
                          ...) {

  #TRY TO PARTIAL MATCH NAME FIRST.
  dot.args = list(...)
  if(length(dot.args) > 0) {
  any_name = .partial_match_user_arg(dot.args, "name")
  if(length(any_name) > 0) {
    name = any_name
    dot.args = .remove_partial_match_user_arg(dot.args, "name")
  }

  #IF UNNAMED FIRST ARG COULD REASONABLY BE NAME, PUT IN THAT FORMAL NAME.
  if(is.character(dot.args[[1]]) &&
     length(dot.args[[1]]) == 1) {
    name = dot.args[[1]]
    dot.args[[1]] = NULL
   }

  }

  #SAFETY CHECK--DO WE HAVE A SINGLE CHARACTER NAME THAT ISN'T BLANK?
  if(!is.character(name) || length(name) != 1 || is.na(name) || name == "") {
    stop("`name` must be a single non-missing character string. Give your new shape a name!", call. = FALSE)
  }


  name = trimws(name)
  name = .standardize_pointplus_shape_names(name) #PREVENTS A USER FROM ADDING A "21" OR SOMETHING.

  if(name == ".initialized") {
    stop("`.initialized` is reserved for internal ggplotplus use. Do not call shapes by that name.", call. = FALSE)
  }

  .initialize_pointplus_shape_registry()

  #HANDLES SITUATION WHERE A USER TRIES TO ADD A SHAPE WE'VE ALREADY GOT.
  if(exists(name, envir = .pointplus_shape_registry, inherits = FALSE) && !overwrite) {
    stop(
      "A pointplus shape named `", name, "` already exists. ",
      "Use `overwrite = TRUE` to replace it.",
      call. = FALSE
    )
  }


  #NOW, DO THE SAME CLEANING ON SHAPE
  if(length(dot.args) > 0) {
    any_shape = .partial_match_user_arg(dot.args, "shape")
    if(length(any_shape) > 0) {
      shape = any_shape
      dot.args = .remove_partial_match_user_arg(dot.args, "shape")
    }

    #IF UNNAMED FIRST REMAINING ARG COULD REASONABLY BE SHAPE, PUT IN THAT FORMAL NAME.
    if(is.data.frame(dot.args[[1]]) &&
       ncol(dot.args[[1]]) >= 3 &&
       all(c("x", "y", "piece") %in% names(dot.args[[1]]))) { #<--SHOULD BE THREE COLS W/ THESE NAMES AT LEAST.
      shape = dot.args[[1]]
      dot.args[[1]] = NULL
    }

  }

  shape = .validate_pointplus_shape(shape, name = name) #NOW ACTUALLY TRY TO USE THE SHAPE THEY'VE GIVEN.

  assign(name, shape, envir = .pointplus_shape_registry) #IF WE GET THIS FAR, ADD THE SHAPE TO THE REGISTRY.

  #MAKE SURE TO PRESERVE THE INTENDED ORDER AND APPEND USER-ADDED SHAPES TO THE END.
  if(!name %in% .pointplus_shape_registry$.order) {
    .pointplus_shape_registry$.order = c(.pointplus_shape_registry$.order, name)
  }

  if(length(dot.args) > 0) {
    dot.args = NULL
    warning("Additional, ambiguous arguments were provided but not used. ")
  }

  invisible(name) #AN INVISIBLE RETURN FOR SAFETY.
}


#' Add Alternative Text to a ggplot
#'
#' Adds alternative text to a ggplot object for use by screen readers and other
#' tools. This is a convenience wrapper for `ggplot2::labs(alt = text)`.
#'
#' @param text A length-one, non-empty character string containing the intended
#'   alternative text.
#'
#' @return A ggplot2 labels object for adding to a plot with `+`.
#'
#' @details
#' Useful alternative text generally identifies the chart type, the variables
#' shown, and the main trends or takeaways that a sighted reader could readily
#' discern from examining the plot.
#'
#' @examples
#' ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Petal.Length)) +
#'   ggplot2::geom_point() +
#'   add_alttext_plus(
#'     "Scatterplot showing a positive relationship between sepal and petal length."
#'   )
#'
#' @export
add_alttext_plus = function(text) {

  if(!is.character(text) ||
     length(text) != 1L ||
     is.na(text) ||
     text == "") {
    stop("`text` must be a length-one, non-empty character string!",
         call. = FALSE)
  }

  return(ggplot2::labs(alt = text))

}


#' Convert a ggplotplus plot into a grob
#'
#' Convenience helper for converting ggplotplus plot objects into grobs using
#' \code{ggplot2::ggplotGrob()}.
#'
#' This is primarily intended for compatibility with packages such as
#' \pkg{cowplot} that may not yet fully recognize custom S7 plot subclasses
#' during internal dispatch.
#'
#' @param plot A ggplot or ggplotplus plot object.
#'
#' @return A grob object suitable for use with grid-based plotting utilities
#'   such as \code{cowplot::plot_grid()}.
#'
#' @examples
#' p = ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Petal.Length, colour = Species)) +
#'   geom_point_plus()
#'
##' if(requireNamespace("cowplot", quietly = TRUE)) {
#'
#' cowplot::plot_grid(
#'   ggplotplus_to_cowplot(p),
#'   ggplotplus_to_cowplot(p)
#' )
#' }
#'
#' @export
ggplotplus_to_cowplot = function(plot) {
  ggplot2::ggplotGrob(plot)
}


#' Convert a ggplotplus plot into a patchwork-compatible element
#'
#' Convenience helper for converting ggplotplus plot objects into
#' patchwork-compatible wrapped elements.
#'
#' This helper is primarily intended for compatibility with \pkg{patchwork},
#' whose plot-composition operators may not yet fully recognize custom S7
#' plot subclasses under ggplot2 4.x.
#'
#' Internally, the plot is first converted into a grob using
#' \code{ggplotplus_to_cowplot()}, then wrapped using
#' \code{patchwork::wrap_elements()}.
#'
#' @param plot A ggplot or ggplotplus plot object.
#'
#' @return A patchwork-compatible wrapped plot element.
#'
#' @examples
#' if(requireNamespace("patchwork", quietly = TRUE)) {
#'
#' p1 = ggplot2::ggplot(iris, ggplot2::aes(Sepal.Length, Petal.Length, colour = Species)) +
#'   geom_point_plus()
#'
#' p2 = ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, shape = factor(cyl))) +
#'   geom_point_plus()
#'
#' (ggplotplus_to_patchwork(p1) |
#'   ggplotplus_to_patchwork(p2)) +
#'   patchwork::plot_annotation(
#'     title = "ggplotplus + patchwork"
#'   )
#' }
#' @details
#' This helper requires the \pkg{patchwork} package, but ggplotplus does not
#' import patchwork. Users only need patchwork installed if they want to compose
#' ggplotplus plots with patchwork.
#' @export
ggplotplus_to_patchwork = function(plot) {

  if(!requireNamespace("patchwork", quietly = TRUE)) {
    stop(
      "`ggplotplus_to_patchwork()` requires the patchwork package. ",
      "Install it with `install.packages(\"patchwork\")`.",
      call. = FALSE
    )
  }

  patchwork::wrap_elements(full = ggplotplus_to_cowplot(plot))
}
