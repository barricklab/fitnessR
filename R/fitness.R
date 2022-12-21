
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


#' Calculate the relative fitness of two competitors
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
#'
#' @param competitor1_initial_count Count of cells/colonies of reference competitor1 at the beginning of the competition
#' @param competitor1_final_count Count of cells/colonies of reference competitor1 at the end of the competition
#' @param competitor2_initial_count Count of cells/colonies of test competitor2 at the beginning of the competition
#' @param competitor2_final_count Count of cells/colonies of test competitor2 at the end of the competition
#'
#' @param transfer_dilution The total dilution factor for all serial transfers between the final and initial cultures
#'
#' @param initial_dilution Dilution of culture plated/analyzed at the beginning of the competition
#' @param initial_volume Volume of culture plated/analyzed at the beginning of the competition
#' @param final_dilution Dilution of culture plated/analyzed at the end of the competition
#' @param final_volume Volume of culture plated/analyzed at the end of the competition
#'
#' @return Relative fitness of test competitor2 versus reference competitor1
#'
#' @examples
#' calculate_one_fitness(competitor1_initial_count=150, competitor2_initial_count=100, competitor1_final_count=50, competitor2_final_count=200, transfer_dilution=1E-2)
#' ## Returns 1.510974
#'
#' @export
calculate_one_fitness = function(

    competitor1_initial_count,
    competitor1_final_count,
    competitor2_initial_count,
    competitor2_final_count,
    transfer_dilution=1,
    initial_dilution=1,
    initial_volume=1,
    final_dilution=1,
    final_volume=1
){

  line_number_text =""
  if(!is.na(pkg.env$error_line_number)) {
    line_number_text = paste0("ERROR encountered on row ", pkg.env$error_line_number, ".")
  }

  # error if missing values provided

  if(is.na(competitor1_initial_count)) {
    stop(paste(c("Missing value (NA or blank) provided for 'competitor1_initial_count'.", line_number_text), collapse=" "))
  }
  if(is.na(competitor1_final_count)) {
    stop(paste(c("Missing value (NA or blank) provided for 'competitor1_final_count'.", line_number_text), collapse=" "))
  }
  if(is.na(competitor2_initial_count)) {
    stop(paste(c("Missing value (NA or blank) provided for 'competitor2_initial_count'.", line_number_text), collapse=" "))
  }
  if(is.na(competitor2_final_count)) {
    stop(paste(c("Missing value (NA or blank) provided for 'competitor2_final_count'.", line_number_text), collapse=" "))
  }
  if(is.na(transfer_dilution)) {
    stop(paste(c("Missing value (NA or blank) provided for 'transfer_dilution'.", line_number_text), collapse=" "))
  }
  if(is.na(initial_dilution)) {
    stop(paste(c("Missing value (NA or blank) provided for 'initial_dilution'.", line_number_text), collapse=" "))
  }
  if(is.na(initial_volume)) {
    stop(paste(c("Missing value (NA or blank) provided for 'initial_volume'.", line_number_text), collapse=" "))
  }
  if(is.na(final_dilution)) {
    stop(paste(c("Missing value (NA or blank) provided for 'final_dilution'.", line_number_text), collapse=" "))
  }
  if(is.na(final_volume)) {
    stop(paste(c("Missing value (NA or blank) provided for 'final_volume'.", line_number_text), collapse=" "))
  }

  # flip to be < 1 if needed
  transfer_dilution = flip_dilution(transfer_dilution)
  initial_dilution = flip_dilution(initial_dilution)
  final_dilution = flip_dilution(final_dilution)

  #Count of competitor1 initial colonies
  competitor1_initial_total = competitor1_initial_count*initial_dilution*initial_volume
  competitor1_final_total = competitor1_final_count*final_dilution*final_volume*transfer_dilution

  #Count of competitor2 initial colonies
  competitor2_initial_total = competitor2_initial_count*initial_dilution*initial_volume
  competitor2_final_total = competitor2_final_count*final_dilution*final_volume*transfer_dilution

  #Error if number of either competitor decreased
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
    competitor1_initial_count,
    competitor1_final_count,
    competitor2_initial_count,
    competitor2_final_count,
    transfer_dilution=1,
    initial_dilution=1,
    initial_volume=1,
    final_dilution=1,
    final_volume=1,
    line_number
){

  pkg.env$error_line_number=line_number

  relative_fitness = (
    calculate_one_fitness(
      competitor1_initial_count=competitor1_initial_count,
      competitor1_final_count=competitor1_final_count,
      competitor2_initial_count=competitor2_initial_count,
      competitor2_final_count=competitor2_final_count,
      transfer_dilution=transfer_dilution,
      initial_dilution=initial_dilution,
      initial_volume=initial_volume,
      final_dilution=final_dilution,
      final_volume=final_volume
    )
  )

  pkg.env$error_line_number = NA

  return(relative_fitness)

}


#' Calculate relative fitness given a data frame of cell/colony counts
#'
#' See calculate_one_fitness() for a description of the calculations/inputs.
#'
#' @param input_df Input data frame. Must have these columns:
#' "competitor1_initial_count", "competitor1_final_count", "competitor2_initial_count", "competitor2_final_count".
#'
#'#' @param silent Input data frame. Suppress loading messages.
#'
#' @return Data frame with calculated columns added
#'
#' @examples
#' calculate_fitness(citT_competitions)
#'
#' @export
calculate_fitness = function(
  input_df,
  silent=FALSE
){

  output_df = input_df

  # The first thing we do is split out the competition data from other columns
  # and normalize and complete it by adding defaults that are missing
  col_names = names(input_df)

  #must be in the same order as parameters to calculate_fitness
  competition_column_list = c(
    "competitor1_initial_count",
    "competitor1_final_count",
    "competitor2_initial_count",
    "competitor2_final_count",
    "transfer_dilution",
    "initial_dilution",
    "initial_volume",
    "final_dilution",
    "final_volume"
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
    cat("INPUT DATA FRAME\n\n")
    cat("Metadata columns:", paste(metadata_columns_present_list, collapse = ", "), "\n\n")
  }

  metadata_df = data.frame(input_df[,!(col_names %in% competition_column_list)])

  #check required columns are present
  competition_columns_present_list = col_names[(col_names %in% competition_column_list)]

  if (!silent) {
    cat("Competition data columns found:", paste(competition_columns_present_list, collapse = ", "), "\n\n")
  }

  competition_columns_set_to_defaults = competition_column_list[!(competition_column_list %in% competition_columns_present_list)]

  if (!silent) {
    cat("Competition parameters set to default value of 1:", paste(competition_columns_set_to_defaults, collapse = ", "), "\n\n")
  }

  if (!silent) {
    cat("Number of rows:", paste(nrow(input_df), collapse = ", "), "\n\n")
  }

  if (!all(required_competition_column_list %in% required_competition_column_list)){
    stop(paste(c("Missing columns in input data frame. Required columns are:", required_competition_column_list), collapse="\n  "))
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
    "initial_dilution",
    "final_dilution"
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


