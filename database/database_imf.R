
################################################################################
# Database for IMF series 
################################################################################

# File path for the IMF RDS 
path_rds_imf  <- paste0(path_rds_folder,"series_store_imf.rds")

# Check if the RDS file exists 
rds_imf_exists <- file.exists(path_rds_imf)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_imf_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_imf)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for IMF inputs 
input_imf <- subset(input_database, source == "imf")

# The IMF series are updated every Day
if (update_needed) {
  # Reformat IMF data 
  series_imf <-reformate_data_imf(tribble = input_imf)
  # Put all the series in a list 
  series_imf <- split(series_imf, series_imf$name)
  # Save IMF series
  message("IMF series saved successfully...")
  saveRDS(series_imf, path_rds_imf)
} else {
  # Otherwise download the IMF series from the RDS folder 
  message("Loading IMF series from RDS folder...")
  series_imf <- readRDS(path_rds_imf)
}
