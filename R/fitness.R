
#helper function
flip_dilution = function(
    dilution
){
  dilution=as.numeric(dilution)
  if (dilution > 1) {
    return (1/dilution)
  }
  return (dilution)
}


#' Calculates the relative fitness of two strains
#'
#' Function for calculating the relative fitness for one replicate of a co-culture competition experiment. This
#' is the base function used by fitnessR() on each row of data.
#' 
#' Dilution factors can be provided as values >1 or <1. For example, you can input
#' either 1E-2 or 1E2 for a transfer dilution of 0.1 mL into 10 mL or either 1E-6 or 1E6 for 
#' the final_dilution if you transferred 0.1 mL to 10 mL three times in making the test tube you plated from. 
#' 
#' The total volumes of the final and initial cultures are assumed to be equal. If they are not, then you can adjust the
#' transfer_dilution accordingly.
#'
#' @param transfer_dilution The total dilution factor for all serial transfers between the final and initial cultures. 
#'
#' @param strain1_initial_count Count of cells/colonies of reference strain1 at the beginning of the competition
#' @param strain1_initial_dilution Dilution of reference strain1 culture plated/analyzed at the beginning of the competition
#' @param strain1_initial_volume Volume of reference strain1 culture plated/analyzed at the beginning of the competition
#' 
#' @param strain1_final_count Count of cells/colonies of reference strain1 at the end of the competition
#' @param strain1_final_dilution Dilution of reference strain1 culture plated/analyzed at the end of the competition
#' @param strain1_final_volume Volume of reference strain1 culture plated/analyzed at the end of the competition
#' 
#' @param strain2_initial_count Count of cells/colonies of test strain2 at the beginning of the competition
#' @param strain2_initial_dilution Count of cells/colonies of test strain2 at the beginning of the competition
#' @param strain2_initial_volume Count of cells/colonies of test strain2 at the beginning of the competition
#'
#' @param strain2_final_count Count of cells/colonies of test strain2 at the end of the competition
#' @param strain2_final_dilution Count of cells/colonies of test strain2 at the end of the competition
#' @param strain2_final_volume Count of cells/colonies of test strain2 at the end of the competition
#' 
#' @return Relative fitness of test strain2 versus reference strain1
#' 
#' @examples
#' calculate_one_fitness(strain1_initial_count=150, strain2_initial_count=100, strain1_final_count=50, strain2_final_count=200, transfer_dilution=1E-2)
#' ## Returns 1.510974
#' 
#' @export
calculate_one_fitness = function(
    transfer_dilution=1,
    strain1_initial_count,
    strain1_initial_dilution=1,
    strain1_initial_volume=1,
    strain1_final_count,
    strain1_final_dilution=1,
    strain1_final_volume=1,
    strain2_initial_count,
    strain2_initial_dilution=1,
    strain2_initial_volume=1,
    strain2_final_count,
    strain2_final_dilution=1,
    strain2_final_volume=1
){
  
  # flip to be < 1 if needed
  transfer_dilution = flip_dilution(transfer_dilution)
  strain1_initial_dilution = flip_dilution(strain1_initial_dilution)
  strain1_final_dilution = flip_dilution(strain1_final_dilution)
  strain2_initial_dilution = flip_dilution(strain2_initial_dilution)
  strain2_final_dilution = flip_dilution(strain2_final_dilution)
  
  #Count of strain1 initial colonies
  strain1_initial_total = strain1_initial_count*strain1_initial_dilution*strain1_initial_volume
  strain1_final_total = strain1_final_count*strain1_final_dilution*strain1_final_volume/transfer_dilution
  
  #Count of strain2 initial colonies
  strain2_initial_total = strain2_initial_count*strain2_initial_dilution*strain2_initial_volume
  strain2_final_total = strain2_final_count*strain2_final_dilution*strain2_final_volume/transfer_dilution
  
  strain1_malthusian_parameter = log(strain1_final_total/strain1_initial_total)
  strain2_malthusian_parameter = log(strain2_final_total/strain2_initial_total)
  
  relative_fitness = strain2_malthusian_parameter/strain1_malthusian_parameter
  
  return(relative_fitness)
}

#' Calculates relative fitness given a data frame of cell/colony counts
#'
#' 
#'
#' @param input_df Input data frame. Must have these columns:
#' "strain1_initial_count", "strain1_final_count", "strain2_initial_count", "strain2_final_count".
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
    "strain1_initial_count",
    "strain1_initial_dilution",
    "strain1_initial_volume",
    "strain1_final_count",
    "strain1_final_dilution",
    "strain1_final_volume",
    "strain2_initial_count",
    "strain2_initial_dilution",
    "strain2_initial_volume",
    "strain2_final_count",
    "strain2_final_dilution",
    "strain2_final_volume"
  )
  
  required_competition_column_list = c(
    "strain1_initial_count", 
    "strain1_final_count",
    "strain2_initial_count",
    "strain2_final_count"
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
    cat(paste(c("Not all required columns were present in input:", required_competition_column_list), collapse="\n  "))
    errorCondition("INVALID INPUT")
    return()
  }
  
  input_competition_df = data.frame(input_df[,!(col_names %in% competition_columns_present_list)])
  
  #add defaults for missing columns
  #create all 1 df
  competition_df = data.frame( strain1_initial_count = rep(1, nrow(input_df) ))
  for (i in 1:length(competition_column_list)) {
    competition_df[,competition_column_list[i]] = rep(1, nrow(input_df))
  }
  #cover up the defaults with input data
  for (i in 1:length(competition_columns_present_list)) {
    competition_df[,competition_columns_present_list[i]] = input_df[,competition_columns_present_list[i]]
  }
  
  #flip all dilution factors to be >1  
  
  #warn if both >1 and < 1 values found for dilution factors
  dilution_factor_column_list = c(
    "transfer_dilution",
    "strain1_initial_dilution",
    "strain1_final_dilution",
    "strain2_initial_dilution",
    "strain2_final_dilution"
  )
  for (i in 1:length(dilution_factor_column_list)) {
    if ( (max(competition_df[,dilution_factor_column_list[i]]) > 1) && (max(competition_df[,dilution_factor_column_list[i]]) < 1)) {
      warning("Dilution factor column has values both >1 and <1, all will be flipped to <1:", dilution_factor_column_list[i], "\n")
    }
    competition_df[ , dilution_factor_column_list[i]] = sapply(competition_df[ , dilution_factor_column_list[i]], flip_dilution)
  }
  
  #perform fitness calculations
  relative_fitness = apply(competition_df, 1, function(X) {
    do.call(calculate_one_fitness,as.list(X))
  })

  #add back all metadata on the left, then calculated fitness values, then
  output_df = cbind(metadata_df, data.frame(relative_fitness=relative_fitness), competition_df)

  return(output_df)  
}

