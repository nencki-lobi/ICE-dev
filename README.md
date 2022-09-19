# ICE development - Study 1

This repository contains materials from **Study 1** described in Marczak et al. (2022). The remaining materials accompanying this publication can be found here.

Please cite the corresponding publication when using these materials:

> Marczak, M., Wierzba, M., Zaremba, D., Kulesza, M., Szczypiński, J., Kossowski, B., Budziszewska, M., Michałowski, J., Klöckner, C.A., & Marchewka A. (2022) *Beyond Climate Anxiety: Development and Validation of the Inventory of Climate Emotions (ICE), a Measure of Various Emotions Experienced in Relation to Climate Change.*

## Contents

This repository contains the data and code used for the analysis in Study 1, including:
* [raw data](https://github.com/nencki-lobi/ICE-dev-S1/tree/main/01/input)
* [cleaned data](https://github.com/nencki-lobi/ICE-dev-S1/tree/main/02/output)
* analysis code.

## How to use

To reproduce the analysis for a given number of factors, run:

* 7 factors solution (see the HTML report [here](https://github.com/nencki-lobi/ICE-dev-S1/tree/main/S1_data_analysis_report_7_factors.html)):

```
rmarkdown::render("S1_data_analysis.Rmd", output_file = "S1_data_analysis_report_7_factors.html", params = list(factors = 7))
```

* 11 factors solution (see the HTML report [here](https://github.com/nencki-lobi/ICE-dev-S1/tree/main/S1_data_analysis_report_11_factors.html)):

```
rmarkdown::render("S1_data_analysis.Rmd", output_file = "S1_data_analysis_report_11_factors.html", params = list(factors = 11))
```

## Requirements

The following R packages are required: `knitr`, `dplyr`, `psych`, `EFA.dimensions`, `stringr`.

## Contact information:

Any problems or concerns regarding this repository should be reported to Małgorzata Wierzba (m.wierzba@nencki.edu.pl).
