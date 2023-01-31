## code to prepare `citT_competitions` dataset goes here

citT_competitions = read.csv("citT_competitions.csv")

citT_competitions =
  citT_competitions %>%
  mutate(
    num_transfers = 3,
    initial_dilution = 100*100,
    initial_volume = 50,
    final_dilution = 100*100,
    final_volume = 50,
  )

usethis::use_data(citT_competitions, overwrite = TRUE)
