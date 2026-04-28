
################################################################################
# Database for Eurostat series
################################################################################

# File path for the Eurostat RDS 
path_rds_eurostat  <- paste0(path_rds_folder,"series_store_eurostat.rds")

# Check if the RDS file exists 
rds_eurostat_exists  <- file.exists(path_rds_eurostat)

# Update the series only one time on Friday
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_eurostat_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_eurostat)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for FRED inputs 
input_eurostat <- subset(input_database, source == "eurostat")

# The Eurostat series are updated every Day
if (update_needed) {
  # Reformat eurostat data 
  series_eurostat <- reformate_data_eurostat(tribble = input_eurostat)
  # Put all the series in a list 
  series_eurostat <- split(series_eurostat, series_eurostat$name)
  # Save eurostat series
  message("Eurostat series saved successfully...")
  saveRDS(series_eurostat, path_rds_eurostat)
} else {
  # Otherwise download the Eurostat series from the RDS folder 
  message("Loading Eurostat series from RDS folder...")
  series_eurostat <- readRDS(path_rds_eurostat)
}
  






