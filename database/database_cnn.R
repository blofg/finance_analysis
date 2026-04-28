
################################################################################
# Database for cnn series 
################################################################################

# File path for the cnn RDS 
path_rds_cnn  <- paste0(path_rds_folder,"series_store_cnn.rds")

# Check if the RDS file exists 
rds_cnn_exists <- file.exists(path_rds_cnn)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_cnn_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_cnn)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for CNN inputs 
input_cnn <- subset(input_database, source == "cnn")

# The CNN series are updated every Day
if (update_needed) {
  # Reformat cnn data
  series_cnn <-reformate_data_cnn(tribble = input_cnn)
  # Put all the series in a list 
  series_cnn <- split(series_cnn, series_cnn$name)
  # Save CNN series
  message("CNN series saved successfully...")
  saveRDS(series_cnn, path_rds_cnn)
} else {
  # Otherwise download the CNN series from the RDS folder 
  message("Loading CNN series from RDS folder...")
  series_cnn <- readRDS(path_rds_cnn)
}
