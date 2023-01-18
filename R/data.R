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
#'   \item{other columns}{Competition data}
#'   ...
#' }
#' @source <https://doi.org/10.1371/journal.pgen.1007348>
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
#'   \item{other columns}{Competition data}
#'   ...
#' }
#' @source <https://doi.org/10.1126/science.1243357>
#' @source <https://doi.org/10.5061/dryad.0hc2m>
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
#'   \item{other columns}{Competition data}
#'   ...
#' }
#' @source <https://doi.org/10.1098/rspb.2015.2292>
#' @source <https://doi.org/10.5061/dryad.gd3dq>
"LTEE_40K_to_60K_competitions"
