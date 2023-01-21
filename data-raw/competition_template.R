## code to prepare `competition_template` dataset goes here

competition_template = read.csv("competition_template.csv", comment="#")

usethis::use_data(competition_template, overwrite = TRUE)
