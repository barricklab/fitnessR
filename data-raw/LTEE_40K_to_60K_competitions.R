## code to prepare `LTEE_40K_to_60K_competitions` dataset goes here
library(dplyr)

## This file is
##   All.Hands.Concatenated.Data.csv
## From
##   https://doi.org/10.5061/dryad.gd3dq

LTEE_40K_to_60K_competitions = read.csv("LTEE_40K_to_60K_competitions.csv")

# Fix which is competitor 1
which_to_swap <- LTEE_40K_to_60K_competitions$Arabinose == "Negative"
LTEE_40K_to_60K_competitions[which_to_swap, c("Red.Pop", "White.Pop", "R.0", "W.0", "R.3", "W.3")] = LTEE_40K_to_60K_competitions[which_to_swap, c("White.Pop", "Red.Pop", "W.0", "R.0", "W.3", "R.3")]

#some rows have no counts!
LTEE_40K_to_60K_competitions =
  LTEE_40K_to_60K_competitions %>%
  filter(!is.na(R.0)) %>%
  filter(!is.na(W.0)) %>%
  filter(!is.na(R.3)) %>%
  filter(!is.na(W.3))

# Rename/add columns
#  Also gets rid of spaces in competitor names
LTEE_40K_to_60K_competitions =
  LTEE_40K_to_60K_competitions %>%
  rename(
    flask = Flask,
    generation = Generation,
    person = Person,
    date = Day.0.Date,
    competitor1 = Red.Pop,
    competitor2 = White.Pop,
    competitor1_initial_count = R.0,
    competitor2_initial_count = W.0,
    competitor1_final_count = R.3,
    competitor2_final_count = W.3,
    replicate = Replicate
    ) %>%
  mutate(
    transfer_dilution = 100,
    num_transfers = 3,
    initial_dilution = 100*100,
    initial_volume = 50,
    final_dilution = 100*100,
    final_volume = 50,
    competitor1 = gsub(" ", "", competitor1),
    competitor2 = gsub(" ", "", competitor2),
    ) %>%
  select(
    !Arabinose
  )

usethis::use_data(LTEE_40K_to_60K_competitions, overwrite = TRUE)

