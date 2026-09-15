## **Update**

This is an update of an existing package. 

Since the last version, I have added one new exported function, `icon_array_plus()`, along with its documentation and helper functions, as I was able to graduate it out of experimental status since the last submission. The version number has been incremented to 0.5.7 to reflect this. I also made a small tweak to `theme_plus()` by adding a new parameter to it to facilitate an interaction between it and the new function.

## Test environments

- Version:                             
platform       x86_64-w64-mingw32               
arch           x86_64                           
os             mingw32                          
crt            ucrt                             
system         x86_64, mingw32                  
status                                          
major          4                                
minor          6.1                              
year           2026                             
month          06                               
day            24                               
svn rev        90187                            
language       R                                
version.string R version 4.6.1 (2026-06-24 ucrt)
nickname       Happy Hop    

  - OS: Windows 11 x64 (build 26200)

  - System: x86_64, mingw32

- win-builder: R-release

- win-builder: R-devel

## R CMD check results

```         
── R CMD check results ─────────────────────────────────────────────────────────────────────────────── ggplotplus 0.5.7 ────
Duration: 54.5s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

```         
> urlchecker::url_check()
✔ All URLs are correct!
```

```         
##I CHECKED THESE--I WOULDN'T CONSIDER ANY TO BE TYPOS.

> devtools::spell_check()
  WORD                 FOUND IN
’s                 theme_plus.Rd:35,75
                     README.md:21,84,239
aes                  geom_point_plus.Rd:26
                     geom_point2.Rd:20
behaviour            geom_jitter_plus.Rd:91
chroma               scale_focus_plus.Rd:102,128
CMD                  README.md:10
                     README.qmd:24
colorbar             dot-aes_mapped_var_is_continuous.Rd:22
                     scale_continuous_plus.Rd:57
colorbars            dot-aes_mapped_var_is_continuous.Rd:21
colour               icon_array_plus.Rd:113,138
                     scale_continuous_plus.Rd:51
                     scale_focus_plus.Rd:132
                     NEWS.md:17
coord                direct_labels_plus.Rd:124
                     dot-get_visible_panel_ranges.Rd:23
de                   scale_focus_plus.Rd:102,154
                     NEWS.md:11
directlabel          dot-apply_key_labels_plus.Rd:11
                     dot-directlabel_lines.Rd:36
                     dot-directlabel_points.Rd:37
distinguishability   NEWS.md:17
fillable             dot-standardize_pointplus_shape_names.Rd:19
                     geom_jitter_plus.Rd:100
GeomBar              dot-has_any_barCol_geom.Rd:18
geomPoint            GeomPointPlus.Rd:5
geoms                geom_jitter_plus.Rd:44
                     scale_focus_plus.Rd:133
ggplot               add_alttext_plus.Rd:5,14,17
                     direct_labels_plus.Rd:73,89,127
                     dot-aes_mapped_var_is_continuous.Rd:10
                     dot-directlabel_lines.Rd:32,51
                     dot-directlabel_points.Rd:33
                     dot-get_prebuild_aes_label.Rd:10
                     dot-get_visible_panel_ranges.Rd:10,11,27
                     dot-guide_is_none_for_aes.Rd:10
                     dot-has_any_barCol_geom.Rd:10,11
                     dot-has_guide_none_for_aes.Rd:10
                     dot-has_plot_guide_none_for_aes.Rd:10
                     dot-is_log10_transformed_scale.Rd:10,11,21,28
                     dot-merge_legend_override.Rd:10
                     dot-plot_data_names.Rd:10,18
                     dot-plot_has_mapped_aes.Rd:10,19
                     geom_jitter_plus.Rd:95
                     geom_point_plus.Rd:57
                     geom_point_plus_shapes.Rd:7,13,16
                     geom_point2.Rd:39
                     GeomPointPlus.Rd:13
                     ggplotplus-package.Rd:7,9
                     ggplotplus_to_cowplot.Rd:10
                     ggplotplus_to_patchwork.Rd:10,22
                     gridlines_plus.Rd:31
                     icon_array_plus.Rd:106,135
                     scale_continuous_plus.Rd:21,47,50,56,65,68
                     scale_focus_plus.Rd:86,95,96,97,100,132,135,149
                     theme_plus.Rd:31,35,61,70,73,75
                     yaxis_title_plus.Rd:27,30
                     title:1
                     description:1
                     NEWS.md:7
                     README.md:4,34
                     README.qmd:20,38
Ggplot               theme_plus.Rd:5
                     yaxis_title_plus.Rd:5
ggplot's             README.qmd:94
ggplot’s           README.md:99
ggproto              geom_jitter_plus.Rd:47
                     GeomPointPlus.Rd:10
ggrepel              direct_labels_plus.Rd:107,132
ggsave               theme_plus.Rd:61
Github               README.md:286
                     README.qmd:242
gridline             gridlines_plus.Rd:39,49
                     theme_plus.Rd:93
Gridline             gridlines_plus.Rd:18,20,22
gridlines            gridlines_plus.Rd:24,34,35,36,39,43,44
                     NEWS.md:8
                     README.md:105,131
                     README.qmd:98,119
Gridlines            gridlines_plus.Rd:5
intersectionality    geom_point2.Rd:42
labelled             direct_labels_plus.Rd:22,26,39
                     dot-directlabel_lines.Rd:10
                     dot-directlabel_points.Rd:10,23
                     README.md:131
                     README.qmd:119
labelling            direct_labels_plus.Rd:56,110
                     dot-apply_key_labels_plus.Rd:16
Lifecycle            README.md:12
                     README.qmd:25
linetypes            gridlines_plus.Rd:39
linewidth            gridlines_plus.Rd:39
                     scale_focus_plus.Rd:132
noty                 gridlines_plus.Rd:39
ORCID                ggplotplus-package.Rd:20,24
overridable          direct_labels_plus.Rd:115
Overridable          theme_plus.Rd:5
pak                  README.md:46
                     README.qmd:42
params               geom_point_plus.Rd:46
                     geom_point2.Rd:30
pre                  dot-directlabel_lines.Rd:53
                     dot-get_prebuild_aes_label.Rd:5,13,16,31
                     scale_continuous_plus.Rd:67
Pre                  direct_labels_plus.Rd:122
prebuilt             geom_point_plus_shapes.Rd:16
procedurally         direct_labels_plus.Rd:76
proto                GeomPointPlus.Rd:5,13
README               README.md:1
rect                 theme_plus.Rd:46,82
Scalable             theme_plus.Rd:5
tibble               dot-directlabel_lines.Rd:30
                     dot-directlabel_points.Rd:31
unintuitive          README.md:250
                     README.qmd:218
UX                   add_shape_plus.Rd:20
                     dot-merge_legend_override.Rd:32
Vagle                README.md:295
                     README.qmd:246
```
