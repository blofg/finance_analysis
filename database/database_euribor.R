
################################################################################
# Database for Euribor series
################################################################################

# File path for the euribor RDS 
path_rds_euribor  <- paste0(path_rds_folder,"series_store_euribor.rds")

# Check if the RDS file exists 
rds_euribor_exists  <- file.exists(path_rds_euribor)

# Update the series only one time on Friday
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_euribor_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_euribor)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for FRED inputs 
input_euribor <- subset(input_database, source == "euribor")

# The Euribor series are updated every Day
if (update_needed) {
  # Reformat euribor data 
  series_euribor <- suppressWarnings(reformate_data_euribor(tribble = input_euribor))
  # Put all the series in a list 
  series_euribor <- split(series_euribor, series_euribor$name)
  # Save euribor series
  message("Euribor series saved successfully...")
  saveRDS(series_euribor, path_rds_euribor)
} else {
  # Otherwise download the euribor series from the RDS folder 
  message("Loading euribor series from RDS folder...")
  series_euribor <- readRDS(path_rds_euribor)
}


