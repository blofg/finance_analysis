################################################################################
# Database for Investing.com
################################################################################

# File path for the investing RDS 
path_rds_investing <- paste0(path_rds_folder, "series_store_investing.rds")

# Check if the RDS file exists
rds_investing_exists <- file.exists(path_rds_investing)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_investing_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_investing)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for Investing inputs
input_investing <- subset(input_database, source == "investing")

# The Investing series are updated every Day
if (update_needed) {
  # Reformat investing data 
  series_investing <- reformate_data_investing(tribble = input_investing)
  # Put all the series in a list
  series_investing <- split(series_investing, series_investing$name)
  # Save Investing series
  message("Investing series saved successfully...")
  saveRDS(series_investing, path_rds_investing)
} else {
  message("Loading Investing series from RDS folder...")
  series_investing <- readRDS(path_rds_investing)
}





