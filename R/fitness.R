
# used for silently setting line number
pkg.env <- new.env()

#helper function
flip_dilution = function(
    dilution
){
  dilution=as.numeric(dilution)
  if (dilution < 1) {
    return (1/dilution)
  }
  return (dilution)
}


#' Calculates the relative fitness of two competitors
#'
#' Function for calculating the relative fitness for one replicate of a co-culture competition experiment. This
#' is the base function used by fitnessR() on each row of data.
#'
#' Dilution factors can be provided as values > 1 or < 1. For example, you can input
#' either 1E-2 or 1E2 for a transfer dilution of 0.1 mL into 10 mL or either 1E-6 or 1E6 for
#' the final_dilution if you transferred 0.1 mL to 10 mL three times in making the test tube you plated from.
#' The output data frame will have all dilution factors converted to values > 1.
#'
#' The total volumes of the final and initial cultures are assumed to be equal. If they are not, then you can adjust the
#' transfer_dilution accordingly.
#'
#' @param transfer_dilution The total dilution factor for all serial transfers between the final and initial cultures.
#'
#' @param competitor1_initial_count Count of cells/colonies of reference competitor1 at the beginning of the competition
#' @param competitor1_initial_dilution Dilution of reference competitor1 culture plated/analyzed at the beginning of the competition
#' @param competitor1_initial_volume Volume of reference competitor1 culture plated/analyzed at the beginning of the competition
#'
#' @param competitor1_final_count Count of cells/colonies of reference competitor1 at the end of the competition
#' @param competitor1_final_dilution Dilution of reference competitor1 culture plated/analyzed at the end of the competition
#' @param competitor1_final_volume Volume of reference competitor1 culture plated/analyzed at the end of the competition
#'
#' @param competitor2_initial_count Count of cells/colonies of test competitor2 at the beginning of the competition
#' @param competitor2_initial_dilution Dilution of test competitor2 culture plated/analyzed at the beginning of the competition
#' @param competitor2_initial_volume Volume of test competitor2 plated/analyzed at the beginning of the competition
#'
#' @param competitor2_final_count Count of cells/colonies of test competitor2 at the end of the competition
#' @param competitor2_final_dilution Dilution of test competitor2 culture plated/analyzed at the end of the competition
#' @param competitor2_final_volume Volume of test competitor2 plated/analyzed at the end of the competition
#'
#' @return Relative fitness of test competitor2 versus reference competitor1
#'
#' @examples
#' calculate_one_fitness(competitor1_initial_count=150, competitor2_initial_count=100, competitor1_final_count=50, competitor2_final_count=200, transfer_dilution=1E-2)
#' ## Returns 1.510974
#'
#' @export
calculate_one_fitness = function(
    transfer_dilution=1,
    competitor1_initial_count,
    competitor1_initial_dilution=1,
    competitor1_initial_volume=1,
    competitor1_final_count,
    competitor1_final_dilution=1,
    competitor1_final_volume=1,
    competitor2_initial_count,
    competitor2_initial_dilution=1,
    competitor2_initial_volume=1,
    competitor2_final_count,
    competitor2_final_dilution=1,
    competitor2_final_volume=1
){

  # flip to be < 1 if needed
  transfer_dilution = flip_dilution(transfer_dilution)
  competitor1_initial_dilution = flip_dilution(competitor1_initial_dilution)
  competitor1_final_dilution = flip_dilution(competitor1_final_dilution)
  competitor2_initial_dilution = flip_dilution(competitor2_initial_dilution)
  competitor2_final_dilution = flip_dilution(competitor2_final_dilution)

  #Count of competitor1 initial colonies
  competitor1_initial_total = competitor1_initial_count/competitor1_initial_dilution*competitor1_initial_volume
  competitor1_final_total = competitor1_final_count/competitor1_final_dilution*competitor1_final_volume*transfer_dilution

  #Count of competitor2 initial colonies
  competitor2_initial_total = competitor2_initial_count/competitor2_initial_dilution*competitor2_initial_volume
  competitor2_final_total = competitor2_final_count/competitor2_final_dilution*competitor2_final_volume*transfer_dilution

  #Error if number of either competitor decreased
  line_number_text =""
  if(!is.na(pkg.env$error_line_number)) {
    line_number_text = paste0("ERROR encountered on row ", pkg.env$error_line_number, ".")
  }
  if (competitor1_final_total < competitor1_initial_total) {
    stop(paste(c("The final number of competitor1 is less than initial number of competitor1. Relative fitness cannot be calculated in this case.", line_number_text), collapse=" "))
  }

  if (competitor2_final_total < competitor2_initial_total) {
    stop(paste(c("The final number of competitor2 is less than the initial number of competitor2. Relative fitness cannot be calculated in this case. ", line_number_text), collapse=" "))
  }

  competitor1_malthusian_parameter = log(competitor1_final_total/competitor1_initial_total)
  competitor2_malthusian_parameter = log(competitor2_final_total/competitor2_initial_total)

  relative_fitness = competitor2_malthusian_parameter/competitor1_malthusian_parameter

  return(relative_fitness)
}

calculate_one_fitness_wrapper = function(
    transfer_dilution=1,
    competitor1_initial_count,
    competitor1_initial_dilution=1,
    competitor1_initial_volume=1,
    competitor1_final_count,
    competitor1_final_dilution=1,
    competitor1_final_volume=1,
    competitor2_initial_count,
    competitor2_initial_dilution=1,
    competitor2_initial_volume=1,
    competitor2_final_count,
    competitor2_final_dilution=1,
    competitor2_final_volume=1,
    line_number
){

  pkg.env$error_line_number=line_number

  relative_fitness = (
    calculate_one_fitness(
      transfer_dilution=transfer_dilution,
      competitor1_initial_count=competitor1_initial_count,
      competitor1_initial_dilution=competitor1_initial_dilution,
      competitor1_initial_volume=competitor1_initial_volume,
      competitor1_final_count=competitor1_final_count,
      competitor1_final_dilution=competitor1_final_dilution,
      competitor1_final_volume=competitor1_final_volume,
      competitor2_initial_count=competitor2_initial_count,
      competitor2_initial_dilution=competitor2_initial_dilution,
      competitor2_initial_volume=competitor2_initial_volume,
      competitor2_final_count=competitor2_final_count,
      competitor2_final_dilution=competitor2_final_dilution,
      competitor2_final_volume=competitor2_final_volume
    )
  )

  pkg.env$error_line_number = NA

  return(relative_fitness)

}


#' Calculates relative fitness given a data frame of cell/colony counts
#'
#'
#'
#' @param input_df Input data frame. Must have these columns:
#' "competitor1_initial_count", "competitor1_final_count", "competitor2_initial_count", "competitor2_final_count".
#'
#' @return Data frame with calculated columns added
#'
#' @examples
#' calculate_fitness(citT_competitions)
#'
#' @export
calculate_fitness = function(
  input_df,
  silent=TRUE
){

  output_df = input_df

  # The first thing we do is split out the competition data from other columns
  # and normalize and complete it by adding defaults that are missing
  col_names = names(input_df)

  #must be in the same order as parameters to calculate_fitness
  competition_column_list = c(
    "transfer_dilution",
    "competitor1_initial_count",
    "competitor1_initial_dilution",
    "competitor1_initial_volume",
    "competitor1_final_count",
    "competitor1_final_dilution",
    "competitor1_final_volume",
    "competitor2_initial_count",
    "competitor2_initial_dilution",
    "competitor2_initial_volume",
    "competitor2_final_count",
    "competitor2_final_dilution",
    "competitor2_final_volume"
  )

  required_competition_column_list = c(
    "competitor1_initial_count",
    "competitor1_final_count",
    "competitor2_initial_count",
    "competitor2_final_count"
  )

  # split
  metadata_columns_present_list =  col_names[!(col_names %in% competition_column_list)]

  if (!silent) {
    cat("INPUT")
    cat("Metadata columns:", paste(metadata_columns_present_list, collapse = ", "), "\n")
  }

  metadata_df = data.frame(input_df[,!(col_names %in% competition_column_list)])

  #check required columns are present
  competition_columns_present_list = col_names[(col_names %in% competition_column_list)]

  if (!silent) {
    cat("Competition data columns:", paste(competition_columns_present_list, collapse = ", "), "\n")
  }

  if (!all(required_competition_column_list %in% required_competition_column_list)){
    stop(paste(c("Not all required columns were present in input:", required_competition_column_list), collapse="\n  "))
  }

  input_competition_df = data.frame(input_df[,!(col_names %in% competition_columns_present_list)])

  #add defaults for missing columns
  #create all 1 df
  competition_df = data.frame( competitor1_initial_count = rep(1, nrow(input_df) ))
  for (i in 1:length(competition_column_list)) {
    competition_df[,competition_column_list[i]] = rep(1, nrow(input_df))
  }
  #cover up the defaults with input data
  for (i in 1:length(competition_columns_present_list)) {
    competition_df[,competition_columns_present_list[i]] = input_df[,competition_columns_present_list[i]]
  }

  #add a line number for reporting errors
  competition_df$line_number=1:nrow(competition_df)

  #flip all dilution factors to be >1

  #warn if both >1 and < 1 values found for dilution factors
  dilution_factor_column_list = c(
    "transfer_dilution",
    "competitor1_initial_dilution",
    "competitor1_final_dilution",
    "competitor2_initial_dilution",
    "competitor2_final_dilution"
  )
  for (i in 1:length(dilution_factor_column_list)) {
    if ( (max(competition_df[,dilution_factor_column_list[i]]) > 1) && (max(competition_df[,dilution_factor_column_list[i]]) < 1)) {
      warning("Dilution factor column has values both >1 and <1, all will be flipped to <1:", dilution_factor_column_list[i], "\n")
    }
    competition_df[ , dilution_factor_column_list[i]] = sapply(competition_df[ , dilution_factor_column_list[i]], flip_dilution)
  }

  #perform fitness calculations
  relative_fitness = apply(competition_df, 1, function(X) {
    do.call(calculate_one_fitness_wrapper,as.list(X))
  })

  #remove line numbers
  competition_df$line_number <- NULL

  #add back all metadata on the left, then calculated fitness values, then calculation results
  output_df = cbind(metadata_df, data.frame(relative_fitness=relative_fitness), competition_df)

  return(output_df)
}


