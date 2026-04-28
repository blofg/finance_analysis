
################################################################################
# Database for CoinMarketCap series
################################################################################

# File path for the CCC RDS
path_rds_ccc <- paste0(path_rds_folder,"series_store_ccc.rds")

# Check if the RDS file exists
rds_ccc_exists <- file.exists(path_rds_ccc)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated
if (!rds_ccc_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_ccc)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for CCC inputs
input_ccc <- subset(input_database, source == "ccc")

# The CCC series are updated every Day
if (update_needed) {
  # Reformat CCC data
  series_ccc <- reformate_data_ccc(tribble = input_ccc)
  # Put all the series in a list
  series_ccc <- split(series_ccc, series_ccc$name)
  # Save CCC series
  message("CCC series saved successfully...")
  saveRDS(series_ccc, path_rds_ccc)
} else {
  # Otherwise download the CCC series from the RDS folder
  message("Loading CCC series from RDS folder...")
  series_ccc <- readRDS(path_rds_ccc)
}
