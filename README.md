# fitnessR
An R package for calculating relative fitness from co-culture competition assay data.


## Installation

### From GitHub

To install the current version of this package directly from GitHub, run this command in R:
```R
install.packages("devtools")
devtools::install_github("barricklab/fitnessR")
```

### From a Source Package

To install a version of this package from a source release downloaded from GitHub, run this 
command in R with your current working directory as the main directory of the uncompressed source release:

```R
install.packages("devtools")
devtools::install()
```

## Quick Start

Download the [competition_template.csv](fitnessR/data-raw/competition_template.csv) file and fill it in as directed by the comments in the file.

Calculate relative fitness by running these commands in R:
```R
library(fitnessR)
competition_data = read.csv("competition_template.csv")
processed_competition_data = calculate_fitness(competition_data)
write.csv(processed_competition_data, "competition_template.csv")
```

## More Information

See the [Introduction to fitnessR Vignette](https://htmlpreview.github.io/?https://github.com/barricklab/fitnessR/blob/main/vignettes/introduction.html) for more detailed examples that include calculating confidence intervals on relative fitness estimates and plotting competition data.
