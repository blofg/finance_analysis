
################################################################################
# Database for Shiller series 
################################################################################

# File path for the Shiller RDS 
path_rds_shiller  <- paste0(path_rds_folder,"series_store_shiller.rds")

# Check if the RDS file exists 
rds_shiller_exists <- file.exists(path_rds_shiller)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_shiller_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_shiller)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for Shiller inputs 
input_shiller <- subset(input_database, source == "shiller")

# The shiller series are updated every Day
if (update_needed) {
  # Reformat Shiller data
  series_shiller <- suppressWarnings(reformate_data_shiller(tribble = input_shiller))
  # Put all the series in a list 
  series_shiller <- split(series_shiller, series_shiller$name)
  # Save Shiller series
  message("Shiller series saved successfully...")
  saveRDS(series_shiller, path_rds_shiller)
} else {
  # Otherwise download the Shiller series from the RDS folder 
  message("Loading shiller series from RDS folder...")
  series_shiller <- readRDS(path_rds_shiller)
}
