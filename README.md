# Inventory of Climate Emotions (ICE) development

This repository contains supplementary materials (data and code) associated with the manuscript describing the development of the Inventory of Climate Emotions (ICE). The remaining supplementary materials can be found on the accompanying [OSF website](https://osf.io/78d6u).

Please cite the corresponding publication when using these materials:

> Marczak, M., Wierzba, M., Zaremba, D., Kulesza, M., Szczypiński, J., Kossowski, B., Budziszewska, M., Michałowski, J., Klöckner, C.A., & Marchewka A. (2022) *Beyond Climate Anxiety: Development and Validation of the Inventory of Climate Emotions (ICE), a Measure of Various Emotions Experienced in Relation to Climate Change.*

## Contents

This repository contains data and code for the Studies 1-3 described in the manuscript, including:
* Study 1: [raw data](https://github.com/nencki-lobi/ICE-dev/tree/main/S1/01/input) | [cleaned data](https://github.com/nencki-lobi/ICE-dev/tree/main/S1/02/output) | [analysis code](https://github.com/nencki-lobi/ICE-dev/tree/main/S1_data_analysis.Rmd)
* Study 2: [raw data](https://github.com/nencki-lobi/ICE-dev/tree/main/S2/01/input) | [cleaned data](https://github.com/nencki-lobi/ICE-dev/tree/main/S2/02/output) | [analysis code](https://github.com/nencki-lobi/ICE-dev/tree/main/S2_data_analysis.Rmd)
* Study 3: [raw data](https://github.com/nencki-lobi/ICE-dev/tree/main/S3/01/input) | [cleaned data](https://github.com/nencki-lobi/ICE-dev/tree/main/S3/02/output) | [analysis code](https://github.com/nencki-lobi/ICE-dev/tree/main/S3_data_analysis.Rmd)


## How to use

To reproduce the analysis for Studies 1-3, run:

* Study 1, 7 factors solution ([HTML report](https://github.com/nencki-lobi/ICE-dev/tree/main/S1_data_analysis_report_7_factors.html)):

```
rmarkdown::render("S1_data_analysis.Rmd", output_file = "S1_data_analysis_report_7_factors.html", params = list(factors = 7))
```

* Study 1, 11 factors solution ([HTML report](https://github.com/nencki-lobi/ICE-dev/tree/main/S1_data_analysis_report_11_factors.html)):

```
rmarkdown::render("S1_data_analysis.Rmd", output_file = "S1_data_analysis_report_11_factors.html", params = list(factors = 11))
```

* Study 2 ([HTML report](https://github.com/nencki-lobi/ICE-dev/tree/main/S2_data_analysis_report.html)):

```
rmarkdown::render("S2_data_analysis.Rmd", output_file = "S2_data_analysis_report.html")
```

* Study 3 ([HTML report](https://github.com/nencki-lobi/ICE-dev/tree/main/S3_data_analysis_report.html)):

```
rmarkdown::render("S3_data_analysis.Rmd", output_file = "S3_data_analysis_report.html")
```

## Requirements

The following R packages are required: `astatur`, `car`, `coin`, `dplyr`, `gdata`, `ggsignif`, `gridExtra`, `Hmisc`, `knitr`,  `lavaan`, `mvnormalTest`, `psych`, `rNuggets`, `rptR`, `semTools`, `stats`, `stringr`, `tidyr`, `tidySEM`, `tidyverse`, `vegan`.

Optional, but useful for working with PostgreSQL databases: `RPostgreSQL`.

## Contact information:

If you would like to use Inventory of Climate Emotions (ICE) in your research please contact Michalina Marczak (michalina.marczak@ntnu.no).

Any problems or concerns regarding this repository should be reported to Małgorzata Wierzba (m.wierzba@nencki.edu.pl).
