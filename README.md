# Inventory of Climate Emotions (ICE) development

This repository contains supplementary materials (data and code) associated with the manuscript describing the development of the Inventory of Climate Emotions (ICE). The remaining supplementary materials can be found on the accompanying [OSF website](https://osf.io/78d6u).

Please cite the corresponding publication when using these materials:

> Marczak, M., Wierzba, M., Zaremba, D., Kulesza, M., Szczypiński, J., Kossowski, B., Budziszewska, M., Michałowski, J., Klöckner, C.A., & Marchewka A. (2023). *Beyond climate anxiety: Development and validation of the Inventory of Climate Emotions (ICE): A measure of multiple emotions experienced in relation to climate change.* Global Environmental Change, 83, 102764. [https://doi.org/10.1016/j.gloenvcha.2023.102764](https://doi.org/10.1016/j.gloenvcha.2023.102764)

## Contents

This repository contains data and code for the Studies 1-2 described in the manuscript, including:
* Study 1: [raw data](https://github.com/nencki-lobi/ICE-dev/tree/main/S1/01/input) | [cleaned data](https://github.com/nencki-lobi/ICE-dev/tree/main/S1/02/output) | [analysis code](https://github.com/nencki-lobi/ICE-dev/tree/main/S1_data_analysis.Rmd)
* Study 2: [raw data](https://github.com/nencki-lobi/ICE-dev/tree/main/S2/01/input) | [cleaned data](https://github.com/nencki-lobi/ICE-dev/tree/main/S2/02/output) | [analysis code](https://github.com/nencki-lobi/ICE-dev/tree/main/S2_data_analysis.Rmd)

## How to use

To reproduce the analysis for Studies 1-2, run:

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

## Requirements

The following R packages are required: `astatur`, `car`, `coin`, `corrtable`, `gdata`, `ggsignif`, `gridExtra`, `Hmisc`, `knitr`,  `lavaan`, `mvnormalTest`, `psych`, `rNuggets`, `semTools`, `stats`, `tidySEM`, `tidyverse`, `vegan`.

Optional, but useful for working with PostgreSQL databases: `RPostgreSQL`.

## Contact information:

If you would like to use Inventory of Climate Emotions (ICE) in your research please contact Michalina Marczak (michalina.marczak@ntnu.no).

Any problems or concerns regarding this repository should be reported to Małgorzata Wierzba (m.wierzba@nencki.edu.pl).
