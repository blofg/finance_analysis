
################################################################################
# Database for Stoxx series 
################################################################################

# File path for the Stoxx RDS 
path_rds_stoxx  <- paste0(path_rds_folder,"series_store_stoxx.rds")

# Check if the RDS file exists 
rds_stoxx_exists <- file.exists(path_rds_stoxx)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_stoxx_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_stoxx)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for stoxx inputs 
input_stoxx <- subset(input_database, source == "stoxx")

# The Stoxx series are updated every Day
if (update_needed) {
  # Reformat Stoxx data 
  series_stoxx <- reformate_data_stoxx(tribble = input_stoxx)
  # Put all the series in a list 
  series_stoxx <- split(series_stoxx, series_stoxx$name)
  # Save Stoxx series
  message("Stoxx series saved successfully...")
  saveRDS(series_stoxx, path_rds_stoxx)
} else {
  # Otherwise download the stoxx series from the RDS folder 
  message("Loading Stoxx series from RDS folder...")
  series_stoxx <- readRDS(path_rds_stoxx)
}
