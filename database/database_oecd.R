
################################################################################
# Database for OECD series
################################################################################

# File path for the OECD RDS 
path_rds_oecd  <- paste0(path_rds_folder,"series_store_oecd.rds")

# Check if the RDS file exists 
rds_oecd_exists  <- file.exists(path_rds_oecd)

# Update the series only one time on Friday
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_oecd_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_oecd)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for OECD inputs 
input_oecd <- subset(input_database, source == "oecd")

# The OECD series are updated every first Friday of the month
if (update_needed) {
  # Reformat oecd data 
  series_oecd <- reformate_data_oecd(tribble = input_oecd) 
  # Put all the series in a list 
  series_oecd <- split(series_oecd, series_oecd$name)
  # Save OECD series
  message("OECD series saved successfully...")
  saveRDS(series_oecd, path_rds_oecd)
} else {
  # Otherwise download the OECD series from the RDS folder 
  message("Loading OECD series from RDS folder...")
  series_oecd <- readRDS(path_rds_oecd)
}


