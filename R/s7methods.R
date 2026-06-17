# METHODS DISPATCHING -----------------------------------------------------
#' Ensures our plot carries the ggplotplus intent storage and class info into subsequence S7 dispatch methods.
#' @param plot A `ggplot` object.
#'
#' @return The same `ggplot` object, with `plot@ggplotplus` ensured to exist.
#'
#' @details
#' This does **not** build, modify, or draw the plot. It only prepares the
#' object so the custom S7 methods of ggplotplus can
#' later read the recorded intents during dispatch.
#'
#' @keywords internal
#' @noRd
.ensure_ggplotplus_plot = function(plot) {

  if(!inherits(plot, "GGPlotPlusPlot")) {
    plot = S7::convert(plot, GGPlotPlusPlot)
  }

  if(is.null(plot@ggplotplus)) {
    plot@ggplotplus = GGPlotPlusState()
  }

  plot
}

# S7 UPDATE_GGPLOT METHODS ------------------------------------------------
# update_ggplot = ggplot2::update_ggplot #JUST TO GET AROUND THE PARSER FOR TESTING!****

#' Add gridlines_plus() intent to a ggplot object
#'
#' Internal S7 method for adding `GridlinesPlus` objects to ggplot2 plots.
#' Ensures the plot carries ggplotplus state, then stores the gridline intent
#' for resolution during plot building after scales have been trained.
#'
#' @keywords internal
#' @noRd
S7::method(update_ggplot, #REGISTER A NEW SPECIFIC VERSION OF THE GENERIC UPDATE_GGPLOT2 METHOD
           list(GridlinesPlus, ggplot2::class_ggplot)) <- function(object, plot, ...) { #NOTE THAT THE SYNTAX HERE WITH THE ARROW OPERATOR IS ESSENTIAL
    plot = .ensure_ggplotplus_plot(plot) #ALWAYS RUN FIRST TO MAKE SURE GGPlotPlus_State exists
    plot@ggplotplus@grid = object #THE OBJECT IS THE INCOMING BITS AND BOBS FROM gridlines_plus. SINCE ITS A CLEARLY DEFINED S7 CLASS OBJECT ALREADY, WE USE @ TO REFER TO IT AND ALSO HAVE NO NEED TO UNPACK IT HERE.

    if(is.null(plot@ggplotplus@general_intents$override_legend_alphasize) || plot@ggplotplus@general_intents$override_legend_alphasize) { #THIS ENSURES ANY FALSE PERPETUATES.
      plot@ggplotplus@general_intents$override_legend_alphasize = object@override_legend_alphasize
    }
    if(is.null(plot@ggplotplus@general_intents$enable_coaching) ||
       plot@ggplotplus@general_intents$enable_coaching) {
      plot@ggplotplus@general_intents$enable_coaching = object@enable_coaching
    }
    return(plot)
}


#' Add yaxis_title_plus() intent to a ggplot object
#'
#' Internal S7 method for adding `YAxisTitlePlus` objects to ggplot2 plots.
#' Ensures the plot carries ggplotplus state, applies any margin or legend
#' nudging needed before layout, and stores the y-axis title intent for
#' resolution during gtable construction.
#'
#' @keywords internal
#' @noRd
S7::method(update_ggplot,
           list(YAxisTitlePlus, ggplot2::class_ggplot)) <- function(object, plot, ...) {

  plot = .ensure_ggplotplus_plot(plot)

  #IF BUNDLING THE NUDGE FUNCTION, IMPLEMENT HERE.
  if(isTRUE(object@nudgeTopLegendDown)) {
    plot = plot + .nudge_top_legend_down(howMuch = object@nudgeHowMuch)
  }

  plot@ggplotplus@y_axis_title = object
  if(is.null(plot@ggplotplus@general_intents$override_legend_alphasize) ||
     plot@ggplotplus@general_intents$override_legend_alphasize) { #THIS ENSURES ANY FALSE PERPETUATES.
    plot@ggplotplus@general_intents$override_legend_alphasize = object@override_legend_alphasize
  }
  if(is.null(plot@ggplotplus@general_intents$enable_coaching) ||
     plot@ggplotplus@general_intents$enable_coaching) {
    plot@ggplotplus@general_intents$enable_coaching = object@enable_coaching
  }
  return(plot)
}


#' Add theme_plus() to a ggplot object
#'
#' Internal S7 method for adding `ThemePlus` objects to ggplot2 plots. Ensures
#' the plot carries ggplotplus state, applies the completed ggplot2 theme, and
#' stores theme-related intent for later geom-default adjustments during plot-
#' building.
#'
#' @keywords internal
#' @noRd
S7::method(update_ggplot,
           list(ThemePlus, ggplot2::class_ggplot)) <- function(object, plot, ...) {

             plot = .ensure_ggplotplus_plot(plot)

             plot = plot + object@theme2add #<-APPLY THE DEFAULT THEME.

             plot@ggplotplus@theme = object

             ##MANAGE LEGEND KEY OVERRIDE AND COACHING OVERRIDE
             if(is.null(plot@ggplotplus@general_intents$override_legend_alphasize) || plot@ggplotplus@general_intents$override_legend_alphasize) { #THIS ENSURES ANY FALSE PERPETUATES.
               plot@ggplotplus@general_intents$override_legend_alphasize = object@override_legend_alphasize
             }
             if(is.null(plot@ggplotplus@general_intents$enable_coaching) ||
                plot@ggplotplus@general_intents$enable_coaching) {
               plot@ggplotplus@general_intents$enable_coaching = object@enable_coaching
             }

             return(plot)
}

# S7 BUILD_GGPLOT METHOD --------------------------------------------------
# ggplot_build = ggplot2::ggplot_build #SAME****

#' Build a ggplotplus plot
#'
#' Internal S7 method for building `GGPlotPlusPlot` objects. Applies deferred
#' ggplotplus build-stage behavior before delegating to ggplot2's ordinary plot
#' build machinery.
#'
#' This method currently patches theme-plus geom defaults into layers before
#' building, applies scale-aware gridline theme adjustments after scales are
#' trained, and forwards any gtable-stage y-axis title intent by converting the
#' built object to `GGPlotPlusBuilt`.
#'
#' @keywords internal
#' @noRd
S7::method(ggplot_build, GGPlotPlusPlot) <- function(plot, ...) {



## ALPHA/SIZE LEGEND OVERRIDES OPERATIONS -----------------------------

  #INTENT: WHEN A USER HAS A LEGEND FOR SHAPE, FILL, AND/OR COLOR, AND THEY SET SIZE AND/OR ALPHA TO SMALL VALUES, THESE SMALL VALUES ALSO APPLY *UNNECESSARILY* TO THE KEYS IN THE LEGEND, MAKING THEM HARDER TO READ.
  #HERE, WE DETERMINE IF SUCH ANY OF THE FORMER SCALES HAVE BEEN MAPPED AND OVERRIDE THE DEFAULT AES FOR THE LEGEND KEYS FOR THOSE SCALES FOR ALL AESTHETICS WITHIN C("ALPHA", "SIZE") THAT HAVEN'T ALSO BEEN MAPPED, UNLESS THE USER HAS REQUESTED WE DON'T.

  should_we_override = plot@ggplotplus@general_intents$override_legend_alphasize
  if(should_we_override &&
     !isTRUE(plot@ggplotplus@general_intents$legend_alphasize_override_applied)) { #<--FAIL EARLY

    #CHECK FOR MAPPED SCALES
  has_fill_mapped = .plot_has_mapped_aes(plot, c("fill")) #<--GO SEE MIDDLEWARE.R FOR THIS HELPER.
  has_colour_mapped = .plot_has_mapped_aes(plot, c("colour"))
  has_shape_mapped = .plot_has_mapped_aes(plot, c("shape"))
  has_alpha_mapped = .plot_has_mapped_aes(plot, c("alpha"))
  has_size_mapped = .plot_has_mapped_aes(plot, c("size"))

  if(any(has_fill_mapped, has_colour_mapped, has_shape_mapped) && #YES, WE HAVE THESE.
     any(!has_alpha_mapped, !has_size_mapped) #AND WE LACK AT LEAST ONE OF THESE.
  ) {

    override_list = list()
    if(!has_alpha_mapped) {
      override_list$alpha = 1 #ADD SIZE AND/OR ALPHA AS APPROPRIATE
    }
    if(!has_size_mapped) {
      override_list$size = 5
    }

    #THEN, SELECTIVELY OVERRIDE RELEVANT LEGENDS.
    if(length(override_list) > 0) {

      target_aes = character(0)

      #FIGURE OUT WHICH OUT OF FILL, COLOUR, AND SHAPE ARE BEING MAPPED...
      if(has_fill_mapped && !.guide_is_none_for_aes(plot, "fill") &&
         !.aes_mapped_var_is_continuous(plot, "fill")) { #<--DON'T DO THIS WHEN MAPPED TO A CONTINUOUS VARIABLE!
        target_aes = c(target_aes, "fill")
      }

      if(has_colour_mapped && !.guide_is_none_for_aes(plot, "colour") &&
         !.aes_mapped_var_is_continuous(plot, "colour")) {
        target_aes = c(target_aes, "colour")
      }

      if(has_shape_mapped && !.guide_is_none_for_aes(plot, "shape")) {
        target_aes = c(target_aes, "shape")
      }

      if(length(target_aes) > 0) {

        all_target_aes = target_aes

        #JUNCTION ALL TARGET LABELS WITH THE LABELS OF THE TARGET AES SCALES.
        target_labels = vapply(target_aes, function(aes_name) {
          .get_prebuild_aes_label(plot, aes_name)
        }, character(1))


        #IF THE LABELS ARE DUPLICATED FOR ANY TWO OR MORE OF THESE SCALES, NO NEED TO OVERRIDE.AES FOR BOTH, AS THOSE SCALES ARE LIKELY TO COLLAPSE.
        keep_aes = target_aes[!duplicated(target_labels)]
        drop_aes = setdiff(all_target_aes, keep_aes) #NOTE WHICH THESE ARE.

        #THEN, CHECK THE ONES WE'RE GOING TO NOT MANIPULATE FOR ANY override.aes() CONDITIONS AND DROP THOSE SO THERE IS ONLY THE ONE. THIS SHOULD BE OK BECAUSE THE LEGENDS SHOULD BE PLANNING TO COLLAPSE.
        for(aes_name in drop_aes) {
          guide = plot@guides$guides[[aes_name]]

          if(!is.null(guide) && inherits(guide, "GuideLegend")) {
            guide$params$override.aes = list()
            plot = plot + ggplot2::guides(!!aes_name := guide)
          }
        }

        #THEN APPLY THE OVERRIDE.AES OVERRIDES.
        if("fill" %in% keep_aes) {
          plot = plot + ggplot2::guides(
            fill = .merge_legend_override(plot, "fill", override_list)
          )
        }

        if("colour" %in% keep_aes) {
          plot = plot + ggplot2::guides(
            colour = .merge_legend_override(plot, "colour", override_list)
          )
        }

        if("shape" %in% keep_aes) {
          plot = plot + ggplot2::guides(
            shape = .merge_legend_override(plot, "shape", override_list)
          )
        }
      }
    }

  }
  plot@ggplotplus@general_intents$legend_alphasize_override_applied = TRUE #MAKES THIS IDEMPOTENT TO ONLY RUN EVER THE ONCE, NO MATTER HOW MANY BUILDS OCCUR.

  }#/END OVERRIDING LEGEND DEFAULTS FOR SIZE/ALPHA


##    THEME PLUS GEOM DEFAULTS OPERATIONS -------------------------------

  if(.s7_prop_is_true(plot@ggplotplus@theme, "applyGeomDefaults")) {

    plotLayers = plot$layers #ID ALL LAYERS (GEOM) IN THIS PLOT...
    if(length(plotLayers) > 0) { #POSSIBLE THEY PUT IN NO GEOMS, IN WHICH CASE THERE'D BE NO LAYERS.
    for(layer in 1:length(plotLayers)) { #GO LAYER BY LAYER

    thisLayer = plotLayers[[layer]] #ISOLATE THIS LAYER
    geom2match = class(thisLayer$geom)[1] #GET THE CLASS TYPE OF THIS GEOM
    geom2match = tolower(sub("^Geom", "", geom2match)) #YANK OUT THE GEOM BIT AND COERCE TO LOWER.

    defaults2use = geom_plus_defaults[[geom2match]] #GRAB THE DEFAULTS FOR IT FROM OUR GLOBAL OBJ.
    if(is.null(defaults2use)) { next } #SKIP IF NONE.

    if(length(defaults2use$aes) > 0) { #IF THIS GEOM HAS AES DEFAULTS...
    for(aes in 1:length(defaults2use$aes)) { #GO ONE BY ONE THRU THEM

      currAes2Check = names(defaults2use$aes[aes]) #GET NAME OF CURR AES

      if(any( #IF THE USER HAS ALREADY SPECIFIED SOMETHING FOR THIS AES, SKIP.
        currAes2Check %in% names(thisLayer$mapping),
        (currAes2Check %in% names(plot$mapping) && isTRUE(thisLayer$inherit.aes)),
        currAes2Check %in% names(thisLayer$aes_params)
      )) { next }

      #OTHERWISE, INSERT DEFAULT INTO OBJ.
      plot$layers[[layer]]$aes_params[[currAes2Check]] = defaults2use$aes[[aes]]

      }#END AES DEFAULTS LOOP

    } #END AES DEFAULTS REGION

    if(length(defaults2use$params$geom_params) > 0) {
      for(Gparam in 1:length(defaults2use$params$geom_params)) {

        currParam2Check = names(defaults2use$params$geom_params[Gparam])

        if(.param_is_already_set(thisLayer, currParam2Check)) {
          next
        }

        #OTHERWISE, INSERT DEFAULT INTO OBJ.
        plot$layers[[layer]]$geom_params[[currParam2Check]] = defaults2use$params$geom_params[[Gparam]]
      }
    }
    if(length(defaults2use$params$stat_params) > 0) {
      for(Sparam in 1:length(defaults2use$params$stat_params)) {

        currParam2Check = names(defaults2use$params$stat_params[Sparam])

        if(any( #FEWER PLACES TO LOOK FOR LAYER PARAMETERS...
          currParam2Check %in% names(thisLayer$stat_params)
        )) { next }

        #OTHERWISE, INSERT DEFAULT INTO OBJ.
        plot$layers[[layer]]$stat_params[[currParam2Check]] = defaults2use$params$stat_params[[Sparam]]

        }

      }#END PARAM DEFAULTS LOOP

    } #END LAYER BY LAYER GEOM DEFAULTS CHECK
   } #NO LAYERS/NO LAYERS CHECK

  } #END THEME PLUS GEOM DEFAULTS REGION


    plain_plot = S7::convert(plot, ggplot2::class_ggplot) #CONVERT TO REGULAR OLD class_ggplot TO BUILD GENERICALLY.
    built = ggplot2::ggplot_build(plain_plot, ...)

##     GRIDLINES PLUS OPERATIONS ----------------------------------------

    grid_intents = plot@ggplotplus@grid # CONVENIENCE OBJ
    if(!is.null(grid_intents)) {

      #IF USING THEME_PLUS IN TANDEM, ADJUST THE LINEWIDTHS ACCORDING TO THE PROPAGATED SCALE_FACTOR.
      if(!is.null(plot@ggplotplus@theme)) {
        grid_intents@linewidth = grid_intents@linewidth * plot@ggplotplus@theme@scale_factor
      }

      grid_theme = .apply_gridlines_plus(built, grid_intents) #<--GO SEE MIDDLEWARE.R FOR THIS HELPER.

      built$plot = built$plot + grid_theme

    } #END GRIDLINES_PLUS OPERATIONS


    should_we_coach = plot@ggplotplus@general_intents$enable_coaching &&
      .ggplotplus_coaching_enabled()

    if(should_we_coach) {

##     GUIDING MESSAGES CONCERNING OVER-RELIANCE ON DISCRETE SHAPE AND COLOR --------

    #***I THINK THIS WORKS, BUT IT LOOKS LIKE USING ggplot2::get_guide_data() COULD MAYBE HAVE BEEN EASIER.
    plot_scales = built@plot@scales$scales
    discrete_plus_FCS = Filter(function(x) { inherits(x, "ScaleDiscrete") &&
                                         any(c("fill", "colour", "shape") %in% x$aesthetics) }, plot_scales)

    warned_colour_fill = FALSE

    if(length(discrete_plus_FCS)) {
      for(i in 1:length(discrete_plus_FCS)) {
        uniqVals = length(unique(discrete_plus_FCS[[i]]$range$range))
        if(any(c("fill", "colour") %in% discrete_plus_FCS[[i]]$aesthetics) &&
           uniqVals > 7 &&
           warned_colour_fill == FALSE) {
          message("\nNote: You've mapped color and/or fill to a discrete variable with > 7 levels. Even when using a color palette designed for maximum contrast and discernability (such as viridis), most humans are not able to readily distinguish all colors from one another in any palette beyond about 7 colors. Consider using a different visual channel, filtering or consolidating to a smaller number of levels, or layering on a second visual channel (such as shape or line type). Alternatively, consider shuffling the color values to make dissimilar colors appear nearer to one another to facilitate comparisons. Also, consider using scale_focus_plus() or direct_labels_plus() in these circumstances. Set enable_coaching to FALSE to disable these messages.")
          warned_colour_fill = TRUE
        }
        if("shape" %in% discrete_plus_FCS[[i]]$aesthetics &&
           uniqVals > 9) {
          message("\nNote: You've mapped shape to a discrete variable with > 9 levels. Even when using a shape palette designed for maximum contrast and discernability (such as that available via geom_point_plus()), most humans are not able to readily distinguish all shapes from one another in any palette beyond about 9 shapes. Consider using a different visual channel, filtering or consolidating to a smaller number of levels, or layering on a second visual channel (such as color or angle of orientation). Alternatively, consider shuffling the shape values to make dissimilar shapes appear nearer to one another to facilitate comparisons. Also, consider using scale_focus_plus() or direct_labels_plus() in these circumstances. Set enable_coaching to FALSE to disable these messages.")
        }
      }
    }

##     GUIDING MESSAGES AROUND RENAMING SCALES TO BE MORE INFORMATIVE --------

    plot_labs = ggplot2::get_labs(built)
    plot_labs = plot_labs[vapply(plot_labs, is.character, logical(1))]
    plot_labs = unlist(plot_labs, use.names = TRUE)

    scale_labs = intersect(
      names(plot_labs),
      c("x", "y", "colour", "color", "fill", "shape", "size", "alpha",
        "linetype", "linewidth")
    )

    data_names = .plot_data_names(built@plot)

    unchanged_labs = scale_labs[plot_labs[scale_labs] %in% data_names]

    length_these = length(unchanged_labs)

    if(length_these) {
      combined = ifelse(length_these == 1, unchanged_labs, paste0(unchanged_labs, collapse = " and "))

      message(sprintf(
        "\nNote: For your %s scale(s), you didn't apparently set a title different than the name of the column mapped to that scale. This is not generally recommended. Column names tend to be machine- rather than human-readable, lack typical spacing, capitalization, and punctuation usage, and they tend to lack units. Consider using ggplot2::labs() to provide these scales with new, human-readable and informative titles. Set enable_coaching to FALSE to disable these messages.",
        combined
      ))
    }

##     GUIDING MESSAGES AROUND BAR/COL GRAPHS CONTAINING 0 --------

    #GIST: CHECK IF BAR/COL GEOM, THEN CHECK WHICH AXIS IS CONTINUOUS. IF ONLY 1, GET VISIBLE RANGE, THEN DETERMINE IF LOG-10 TRANSFORMED. COMPARE VISIBLE RANGE TO TARGET VAL AND FLAG IF TARGET VAL NOT W/IN RANGE.
    barCol_check = .has_any_barCol_geom(built)

    if(barCol_check) {

      x_is_cont = .aes_mapped_var_is_continuous(built@plot, "x")
      y_is_cont = .aes_mapped_var_is_continuous(built@plot, "y")

      if(sum(x_is_cont, y_is_cont) == 1) {

        cont_axis = if(x_is_cont) "x" else "y"

        visible_ranges = .get_visible_panel_ranges(built, cont_axis)

        target = 0
        if(.is_log10_transformed_scale(built, cont_axis)) {
          target = 1
          visible_ranges = lapply(visible_ranges, function(x) 10^x)
        }

       target_in = vapply(visible_ranges, function(x) { .is_between(x, target) }, logical(1))

       if(any(!target_in)) {

         message("In your bar/column chart, at least one visible continuous panel scale doesn't show 0 (or 1, if log10-transformed). Often, omitting 0 distorts a small effect size into appearing larger. This is probably a result of setting limits inside of `ggplot2::coord_cartesian()`. Set enable_coaching to FALSE to disable these messages.")

       }

      }
    }

    } #/END COACHING SECTION


    #REGISTERING INTENT TO MOVE ALONG TO THE GTABLE METHOD FOR YAXIS TITLE PLUS AS NEEDED.
    if(!is.null(plot@ggplotplus@y_axis_title)) {
      built = S7::convert(built, GGPlotPlusBuilt)
      built@y_axis_title = YAxisTitlePlus(
          location = plot@ggplotplus@y_axis_title@location
        )
    }

    return(built)

}



# S7 GTABLE METHOD --------------------------------------------------------

# ggplot_gtable = ggplot2::ggplot_gtable #SAME****


#' Convert a ggplotplus built plot to a gtable
#'
#' Internal S7 method for converting `GGPlotPlusBuilt` objects to gtables.
#' Delegates first to ggplot2's ordinary gtable construction, then applies any
#' deferred ggplotplus layout edits that require access to the completed gtable.
#'
#' This method currently supports `yaxis_title_plus()`, which moves the y-axis
#' title into a custom row above or below the panel region.
#'
#' @keywords internal
#' @noRd
S7::method(ggplot_gtable, GGPlotPlusBuilt) <- function(data, ...) {

  plain_data = S7::convert(data, ggplot2::class_ggplot_built) #CONVERT TO REGULAR OLD class_ggplot TO GTABLE GENERICALLY.
  gtable = ggplot2::ggplot_gtable(plain_data)

  yaxis_intents = data@y_axis_title # CONVENIENCE OBJ

  ###Y-AXIS TITLE PLUS OPERATIONS
  if(is.null(yaxis_intents)) {
  return(gtable)
  }

  gtable = .apply_yaxis_title_plus(data, gtable, yaxis_intents)

  return(gtable)

}
