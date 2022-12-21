## code to prepare `LTEE_50K_time_course_competitions` dataset goes here
library(dplyr)

## This file is
##   Concatenated.LTEE.data.all
## From
##   https://doi.org/10.5061/dryad.0hc2m

LTEE_50K_time_course_competitions = read.csv("LTEE_50K_time_course_competitions.csv")

# Fix which is competitor 1
which_to_swap <- LTEE_50K_time_course_competitions$White.Pop == "607"
LTEE_50K_time_course_competitions[which_to_swap, c("Red.Pop", "White.Pop", "Red.0", "White.0", "Red.", "White.1")] = LTEE_50K_time_course_competitions[which_to_swap, c("White.Pop", "Red.Pop", "White.0", "Red.0", "White.1", "Red.1")]

# Rename/add columns
LTEE_50K_time_course_competitions=
  LTEE_50K_time_course_competitions %>%
  rename(
    generation=Generation,
    competitor1=Red.Pop,
    competitor2=White.Pop,
    competitor1_initial_count=Red.0,
    competitor2_initial_count=White.0,
    competitor1_final_count=Red.1,
    competitor2_final_count=White.1,
    replicate=Rep,
    complete=Complete,
    mutator.ever=Mutator.Ever,
    population=Population,
    count1_dilution_factor=D.0,
    count2_dilution_factor=D.1
    ) %>%
  select(
    -Fitness
  )

usethis::use_data(LTEE_50K_time_course_competitions, overwrite = TRUE)
