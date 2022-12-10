## code to prepare `citT_competitions` dataset goes here

citT_competitions = read.csv("citT_competitions.csv")

usethis::use_data(citT_competitions, overwrite = TRUE)
