#' Competition assay template
#'
#' Data frame template for entering a user's cell count data and
#' competition parameters for determining relative fitness using the
#' calculate_fitness() function.
#'
#' NOTE: If you used the same dilution procedure and analyzed the same volume
#' of sample at the initial and final timepoints then you can leave the
#' initial_dilution, initial_volume, final_dilution, and final_volume
#'columns as the DEFAULT values of 1 or delete them.
#'
#' @format ## `competition_template`
#' A data frame with 12 rows and 11 columns:
#' \describe{
#'   \item{competitor1}{the name of competitor 1 (e.g., strain or sample designation). Example: REL606}
#'   \item{competitor2}{the name of competitor 2 (e.g., strain or sample designation). Example: REL8604}
#'   \item{competitor1_initial_count}{competitor1_initial_count - the counts of competitor1 cells when the two competitors are mixed (e.g., colony counts). Example: 243}
#'   \item{competitor2_initial_count}{competitor2_initial_count - the counts of competitor2 cells when the two competitors are mixed (e.g., colony counts). Example: 128}
#'   \item{competitor1_final_count}{the counts of competitor1 cells after the competitors are co-cultured (e.g., colony counts). Example: 198}
#'   \item{competitor2_final_count}{the counts of competitor 2 cells after the competitors are co-cultured (e.g., colony counts). Example: 271}
#'   \item{transfer_dilution}{the overall dilution factor for all passages of the cells in co-culture. Example: 100  (If 2 x 50 µl of saturated cultures of each competitor were mixed into 9.9 mL of fresh medium and then the culture grew to saturation.)}
#'   \item{initial_dilution}{the dilution factor for the initial sample that was plated. Example: 10000  (If 2 x 50 µl of saturated cultures of each competitor were mixed into 9.9 mL of fresh medium, then 100 µl of this was diluted into 9.9 ml of sterile saline.)}
#'   \item{initial_volume}{volume of the initial dilution that was analyzed for counting each competitor.  The units on initial_volume and final_volume must be the same. Example: 80  (If 80 µL were plated.}
#'   \item{final_dilution}{the dilution factor for the initial sample that was plated. Example: 10,000 if 100 µl of final saturated cultures was diluted into 9.9 mL of sterile saline, then 100 µl of this was diluted into 9.9 ml of sterile saline. Example: 10000  (If 100 µl of final saturated cultures was diluted into 9.9 mL of sterile saline, then 100 µl of this was diluted into 9.9 ml of sterile saline.)}
#'   \item{final_volume}{volume of the initial dilution that was analyzed for counting each competitor. The units on initial_volume and final_volume must be the same. Example: 80  (If 80 µL were plated.)}
#' }
#'
#' @examples
#' # Write the template to a file that you can edit and use as input to calculate_fitness()
#' write.csv(competition_template, "my_competition_data.csv")
#'

"competition_template"

#' citT competition data
#'
#' Data showing the fitness effects of adding the rnk-citT module to the
#' genomes of Escherichia coli strains from the Long-Term Evolution Experiment.
#'
#' Reference
#'
#' Leon, D., D’Alton, S., Quandt, E.M., Barrick, J.E. (2018) Innovation in an
#' E. coli evolution experiment is contingent on maintaining adaptive potential
#' until competition subsides. *PLoS Genet.* 14:e1007348.
#'
#' @format ## `citT_competitions`
#' A data frame with 6 rows and 7 columns:
#' \describe{
#'   \item{competitor1}{Designation for strain without rnk-citT module}
#'   \item{competitor2}{Designation for strain with rnk-citT module}
#'   \item{other columns}{Competition data. See competition_template()}
#'   ...
#' }
#' @source <https://doi.org/10.1371/journal.pgen.1007348>
#'
#' @examples
#' calculate_fitness(citT_competitions)
#'
"citT_competitions"

#' LTEE 50,000 generation time course competition data
#'
#' Data showing the fitness effects of adding the rnk-citT module to the
#' genomes of Escherichia coli strains from the Long-Term Evolution Experiment.
#'
#' Reference
#'
#' Wiser M.J., Ribeck N., Lenski R.E. (2013) Long-term dynamics of adaptation
#' in asexual populations. *Science* 342:1364–1367.
#'
#' @format ## `LTEE_50K_time_course_competitions`
#' A data frame with 922 rows and 13 columns:
#' \describe{
#'   \item{competitor1}{Designation for ancestral strain}
#'   \item{competitor2}{Designation for evolved population}
#'   \item{other columns}{Competition data. See competition_template()}
#'   ...
#' }
#' @source <https://doi.org/10.1126/science.1243357>
#' @source <https://doi.org/10.5061/dryad.0hc2m>
#'
#' @examples
#' calculate_fitness(LTEE_50K_time_course_competitions)
#'
"LTEE_50K_time_course_competitions"

#' LTEE 50K versus 60K population competitions
#'
#' Data from competition experiments examining fitness changes in the E.coli LTEE
#' populations between 50,000 and 60,000 generations.
#'
#' Reference
#'
#' Lenski R.E., Wiser M.J., Ribeck N., Blount Z.D., Nahum J.R., Morris J.J.,
#' Zaman, L., Turner, C.B., Wade, B.D., Maddamsetti, R., Burmeister, A.R., Baird, E.J.,
#' Bundy, J., Grant, N.A., Card, K.J., Rowles, M., Weatherspoon, K., Papoulis, S.E.,
#' Sullivan, R., Clark, C., Mulka, J.S., Hajela, N. (2015) Sustained fitness gains and
#' variability in fitness trajectories in the long-term evolution experiment with
#' *Escherichia coli*. *Proc. Royal. Soc. B* 282:20152292.
#'
#' @format ## `LTEE_40K_to_60K_competitions`
#' A data frame with 1127 rows and 12 columns:
#' \describe{
#'   \item{competitor1}{Designation for 50K reference strain}
#'   \item{competitor2}{Designation for 60K population}
#'   \item{other columns}{Competition data. See competition_template()}
#'   ...
#' }
#' @source <https://doi.org/10.1098/rspb.2015.2292>
#' @source <https://doi.org/10.5061/dryad.gd3dq>
#'
#' @examples
#' calculate_fitness(LTEE_40K_to_60K_competitions)
#'
"LTEE_40K_to_60K_competitions"
