

################################################################################
# Database for EIA (International crude oil production) series
################################################################################

# File path for the EIA RDS 
path_rds_eia  <- paste0(path_rds_folder,"series_store_eia.rds")

# Check if the RDS file exists 
rds_eia_exists <- file.exists(path_rds_eia)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_eia_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_eia)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for EIA inputs
input_eia <- subset(input_database, source %in% c("eia"))

# The EIA series are updated every Day
if (update_needed) {
  # Reformat EIA data 
  series_eia <-reformate_data_eia(tribble = input_eia)
  # Put all the series in a list 
  series_eia <- split(series_eia, series_eia$name)
  # Save eia series
  message("eia series saved successfully...")
  saveRDS(series_eia, path_rds_eia)
} else {
  # Otherwise download the EIA series from the RDS folder 
  message("Loading eia series from RDS folder...")
  series_eia <- readRDS(path_rds_eia)
}

