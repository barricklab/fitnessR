## code to prepare `LTEE_50K_vs_60K_competitions` dataset goes here
library(dplyr)

## This file is
##   All.Hands.Concatenated.Data.csv
## From
##   https://doi.org/10.5061/dryad.gd3dq

LTEE_50K_vs_60K_competitions = read.csv("LTEE_50K_vs_60K_competitions.csv")

# Fix which is competitor 1
which_to_swap <- LTEE_50K_vs_60K_competitions$Arabinose == "Negative"
LTEE_50K_vs_60K_competitions[which_to_swap, c("Red.Pop", "White.Pop", "R.0", "W.0", "R.3", "W.3")] = LTEE_50K_vs_60K_competitions[which_to_swap, c("White.Pop", "Red.Pop", "W.0", "R.0", "W.3", "R.3")]

# Rename/add columns
LTEE_50K_vs_60K_competitions=
LTEE_50K_vs_60K_competitions %>%
  rename(
    flask=Flask,
    generation=Generation,
    person=Person,
    date=Day.0.Date,
    competitor1=Red.Pop,
    competitor2=White.Pop,
    competitor1_initial_count=R.0,
    competitor2_initial_count=W.0,
    competitor1_final_count=R.3,
    competitor2_final_count=W.3,
    replicate=Replicate
    ) %>%
  mutate(
    transfer_dilution=100*100*100
    ) %>%
  select(
    -Arabinose
  )

usethis::use_data(LTEE_50K_vs_60K_competitions, overwrite = TRUE)
