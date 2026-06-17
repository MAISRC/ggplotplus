# ggplotplus 0.5.6

## Main features

* `geom_point_plus()`, a fill+color point geom with a more distinguishable custom shape palette, plus the ability to add custom shapes via `add_shape_plus()`.
* `geom_jitter_plus()`, a jittered wrapper around `geom_point_plus()`.
* `theme_plus()` for Universal Design-inspired ggplot2 defaults.
* `gridlines_plus()` and `yaxis_title_plus()` helpers for thoughtful gridlines on continuous scales only and horizontally oriented y-axis titles, respectively.
* `scale_continuous_plus()` for forcing labels near the endpoints of continuous scales.
* `direct_labels_plus()` for directly labeling point and line geometries as an alternative to a legend.
* `scale_focus_plus()` for using color to create a "focus mode" version of a graph to visually emphasize some groups and de-emphasize others.

## Latest features

* `direct_labels_plus()` added as an experimental/trial feature.
* `scale_focus_plus()` added as an experimental/trial feature.
* Coaching messages for plots with too many requested discrete colour, fill, or shape values for easy distinguishability.
* Coaching messages when scale titles appear to use raw column names instead of something potentially more human-readable.
* Added a session-level option, `ggplotplus.enable_coaching`, to disable coaching messages globally.
* Helper functions supporting use of `ggplotplus` graphs with `cowplot` and `patchwork`. See `ggplotplus_to_*`. 
