# jobseekeR

As one of my side-projects, the JobseekeR is a simple shiny-based job searching webapp.

### Instructions
It is easily to use this webapp:
  + Step 1: Enter the position you want to search in the upper-left text box.
  + Step 2: Choose Indeed.com as the platform you want to use (temporarily it is the only platform that jobseekeR supports).
  + Step 3: Set filters as you want to.
    + *for the demo on the [shinyapps.io](https://nowhere.shinyapps.io/jobseekeR/), considering to the quality of the default processors procided in the backend is not that powerful enough, you'd better do not set too many records, 30 - 60 are the recommended options*.
  + Step 4: Click the `Search` button and then wait for a moment and observe your results freely.

<img src = "https://jackho327.github.io/jobseekeR/www/indeed_demo.gif" /><br>

*To enjoy the logistics feature, please open your shiny app in browser and allow the location tracker; Or directly deploy it to your shinyapps portal.*

### Supported Platforms:.
  *Temporarily, it is one-directional and single-platform, in the future, there will be multi-platform-integrated information be provided.*
  + [Indeed](www.indeed.com).
      * ~~Version 0.1.0~~.
      * [Version 0.1.1](https://nowhere.shinyapps.io/jobseekeR/).
        * Add multicore computation.
          * Enjoy this feature by downloading the github-version, the demo in [shinyapps.io](https://nowhere.shinyapps.io/jobseekeR/) only support the single processor because of the free-tier plan.
        * A few bug fixes and update the new html extraction schema.
  + [Glassdoor](www.glassdoor.com) (*to be cont'd*).
  + TBA.

### Packages (Testing & Production):.
  + [shiny](https://shiny.rstudio.com/).
  + [shinyjs](https://github.com/daattali/shinyjs).
  + [dplyr](https://github.com/tidyverse/dplyr).
  + [stringr](https://github.com/tidyverse/stringr).
  + [leaftlet](https://rstudio.github.io/leaflet/).
  + [plotly](https://plot.ly/r/).
  + [rvest](https://cran.r-project.org/web/packages/rvest/index.html).
  + [curl](https://cran.r-project.org/web/packages/curl/index.html).
  + [data.table](https://cran.r-project.org/web/packages/data.table/index.html).
  + [ggmap](https://github.com/dkahle/ggmap).
  + [shinysky](https://github.com/AnalytixWare/ShinySky).
  + [parallel](http://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf).
  + [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html).

### Native System Info:

```r
> sessionInfo().
R version 3.3.3 (2017-03-06).
Platform: x86_64-w64-mingw32/x64 (64-bit).
Running under: Windows >= 8 x64 (build 9200).

locale:.
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252.
[3] LC_MONETARY=English_United States.1252 LC_NUMERIC=C.
[5] LC_TIME=English_United States.1252.

attached base packages:.
[1] parallel  stats     graphics  grDevices utils     datasets  methods   base.

other attached packages:.
 [1] bindrcpp_0.2         ggmap_2.7            shinysky_0.1.2.
 [4] plyr_1.8.4           RJSONIO_1.3-0        data.table_1.10.4-3.
 [7] shinyjs_1.0          dplyr_0.7.4          plotly_4.7.1.
[10] ggplot2_2.2.1        leaflet_1.1.0        stringr_1.2.0.
[13] rvest_0.3.2          xml2_1.1.1           shiny_1.0.5.
[16] RevoUtilsMath_10.0.0 RevoUtils_10.0.3     RevoMods_11.0.0.
[19] MicrosoftML_1.3.0    mrsdeploy_1.1.0      RevoScaleR_9.1.0.
[22] lattice_0.20-35      rpart_4.1-11         curl_2.7.
[25] jsonlite_1.5.

loaded via a namespace (and not attached):.
 [1] Rcpp_0.12.14           tidyr_0.7.2            png_0.1-7.
 [4] assertthat_0.2.0       digest_0.6.14          foreach_1.4.4.
 [7] mime_0.5               R6_2.2.2               httr_1.3.1.
[10] pillar_1.1.0           RgoogleMaps_1.4.1      rlang_0.1.6.
[13] lazyeval_0.2.1         geosphere_1.5-7        proto_1.0.0.
[16] selectr_0.3-1          htmlwidgets_0.9        RCurl_1.95-4.10.
[19] munsell_0.4.3          httpuv_1.3.5           pkgconfig_2.0.1.
[22] htmltools_0.3.6        tibble_1.4.1           mrupdate_1.0.1.
[25] codetools_0.2-15       XML_3.98-1.9           CompatibilityAPI_1.1.0.
[28] viridisLite_0.2.0      bitops_1.0-6           grid_3.3.3.
[31] xtable_1.8-2           gtable_0.2.0           magrittr_1.5.
[34] scales_0.5.0           stringi_1.1.6          mapproj_1.2-5.
[37] reshape2_1.4.3         sp_1.2-6               rjson_0.2.15.
[40] iterators_1.0.9        tools_3.3.3            glue_1.2.0.
[43] purrr_0.2.4            maps_3.2.0             crosstalk_1.0.0.
[46] jpeg_0.1-8             rsconnect_0.8.5        yaml_2.1.14.
[49] colorspace_1.3-2       bindr_0.1.
```