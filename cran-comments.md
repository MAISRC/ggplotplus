## **Update**

This is an update of an existing package. 

Since the last version, I have added one new exported function, `scale_focus_plus()`, along with its documentation, as I was able to graduate it out of experimental status since the last submission. The version number has been incremented to 0.5.6 to reflect this.

## Test environments

- Version: R 4.5.3 (2026-03-11 ucrt)

  - OS: Windows 11 x64 (build 26200)

  - System: x86_64, mingw32

- win-builder: R-release

- win-builder: R-devel

## R CMD check results

```         
── R CMD check results ─────────────────────────────────────────────── ggplotplus 0.5.6 ────
Duration: 48.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

```         
urlchecker::url_check()
✔ All URLs are correct!
```

```         
##I CHECKED THESE--I WOULDN'T CONSIDER ANY TO BE TYPOS.

  WORD                 FOUND IN
’s                 theme_plus.Rd:34,72
                     README.md:33,107
aes                  geom_point_plus.Rd:26
                     geom_point2.Rd:20
behaviour            geom_jitter_plus.Rd:91
colorbar             dot-aes_mapped_var_is_continuous.Rd:22
                     scale_continuous_plus.Rd:57
colorbars            dot-aes_mapped_var_is_continuous.Rd:21
colour               scale_continuous_plus.Rd:51
                     NEWS.md:15
coord                direct_labels_plus.Rd:124
directlabel          dot-apply_key_labels_plus.Rd:11
                     dot-directlabel_lines.Rd:36
                     dot-directlabel_points.Rd:37
distinguishability   NEWS.md:15
fillable             dot-standardize_pointplus_shape_names.Rd:19
                     geom_jitter_plus.Rd:100
geomPoint            GeomPointPlus.Rd:6
geoms                geom_jitter_plus.Rd:44
ggplot               direct_labels_plus.Rd:73,89,127
                     dot-aes_mapped_var_is_continuous.Rd:10
                     dot-directlabel_lines.Rd:32,51
                     dot-directlabel_points.Rd:33
                     dot-get_prebuild_aes_label.Rd:10
                     dot-guide_is_none_for_aes.Rd:10
                     dot-has_guide_none_for_aes.Rd:10
                     dot-has_plot_guide_none_for_aes.Rd:10
                     dot-merge_legend_override.Rd:10
                     dot-plot_data_names.Rd:10,18
                     dot-plot_has_mapped_aes.Rd:10,19
                     geom_jitter_plus.Rd:95
                     geom_point_plus.Rd:57
                     geom_point_plus_shapes.Rd:7,13,16
                     geom_point2.Rd:39
                     GeomPointPlus.Rd:17
                     ggplotplus-package.Rd:7,9
                     ggplotplus_to_cowplot.Rd:10
                     ggplotplus_to_patchwork.Rd:10,22
                     gridlines_plus.Rd:31
                     scale_continuous_plus.Rd:21,47,50,56,65,68
                     theme_plus.Rd:30,34,60,67,70,72
                     yaxis_title_plus.Rd:27,30
                     title:1
                     description:1
                     NEWS.md:7
                     README.md:8,49
                     README.qmd:25,67
Ggplot               theme_plus.Rd:5
                     yaxis_title_plus.Rd:5
ggproto              geom_jitter_plus.Rd:47
                     GeomPointPlus.Rd:14
ggrepel              direct_labels_plus.Rd:107,132
ggsave               theme_plus.Rd:60
gridline             gridlines_plus.Rd:39
Gridline             gridlines_plus.Rd:18,20,22
gridlines            gridlines_plus.Rd:24,34,35,36,39,43,44
                     NEWS.md:8
                     README.md:49
                     README.qmd:67
Gridlines            gridlines_plus.Rd:5
intersectionality    geom_point2.Rd:42
labelled             direct_labels_plus.Rd:22,26,39
                     dot-directlabel_lines.Rd:10
                     dot-directlabel_points.Rd:10,23
labelling            direct_labels_plus.Rd:56,110
                     dot-apply_key_labels_plus.Rd:16
linetypes            gridlines_plus.Rd:39
linewidth            gridlines_plus.Rd:39
noty                 gridlines_plus.Rd:39
ORCID                ggplotplus-package.Rd:20
overridable          direct_labels_plus.Rd:115
Overridable          theme_plus.Rd:5
pak                  README.md:12
                     README.qmd:29
params               geom_point_plus.Rd:46
                     geom_point2.Rd:30
pre                  dot-directlabel_lines.Rd:53
                     dot-get_prebuild_aes_label.Rd:5,13,16,31
                     scale_continuous_plus.Rd:67
Pre                  direct_labels_plus.Rd:122
prebuilt             geom_point_plus_shapes.Rd:16
proto                GeomPointPlus.Rd:6,17
README               README.md:1
rect                 theme_plus.Rd:45,79
Scalable             theme_plus.Rd:5
tibble               dot-directlabel_lines.Rd:30
                     dot-directlabel_points.Rd:31
UX                   add_shape_plus.Rd:20
                     dot-merge_legend_override.Rd:32
Vagle                README.md:125
                     README.qmd:128
```
