################################################################################
# Database for Economic Policy Uncertainty
################################################################################

# File path for the EPU RDS 
path_rds_epu <- paste0(path_rds_folder, "series_store_epu.rds")

# Check if the RDS file exists
rds_epu_exists <- file.exists(path_rds_epu)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_epu_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_epu)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for EPU inputs
input_epu <- subset(input_database, source == "epu")

# The EPU series are updated every Day
if (update_needed) {
  # Reformat epu data 
  series_epu <- reformate_data_epu(tribble = input_epu)
  # Put all the series in a list
  series_epu <- split(series_epu, series_epu$name)
  # Save EPU series
  message("EPU series saved successfully...")
  saveRDS(series_epu, path_rds_epu)
} else {
  message("Loading EPU series from RDS folder...")
  series_epu <- readRDS(path_rds_epu)
}





