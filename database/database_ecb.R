
################################################################################
# Database for ECB series
################################################################################

# File path for the ECB RDS 
path_rds_ecb  <- paste0(path_rds_folder,"series_store_ecb.rds")

# Check if the RDS file exists 
rds_ecb_exists  <- file.exists(path_rds_ecb)

# Update the series only one time on Friday
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_ecb_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_ecb)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for ECB inputs 
input_ecb <- subset(input_database, source == "ecb")

# The ECB series are updated every Day
if (update_needed) {
  # Reformat ECB data 
  series_ecb <- reformate_data_ecb(tribble = input_ecb)
  # Put all the series in a list 
  series_ecb <- split(series_ecb, series_ecb$name)
  # Save ECB series
  message("ECB series saved successfully...")
  saveRDS(series_ecb, path_rds_ecb)
} else {
  # Otherwise download the ECB series from the RDS folder 
  message("Loading ECB series from RDS folder...")
  series_ecb <- readRDS(path_rds_ecb)
}
