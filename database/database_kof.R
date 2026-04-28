

################################################################################
# Database for KOF series
################################################################################

# File path for the KOF RDS 
path_rds_kof  <- paste0(path_rds_folder,"series_store_kof.rds")

# Check if the RDS file exists 
rds_kof_exists <- file.exists(path_rds_kof)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_kof_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_kof)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for KOF inputs
input_kof <- subset(input_database, source %in% c("kof"))

# The kof series are updated every Day
if (update_needed) {
  # Reformat KOF data 
  series_kof <-reformate_data_kof(tribble = input_kof)
  # Put all the series in a list 
  series_kof <- split(series_kof, series_kof$name)
  # Save KOF series
  message("KOF series saved successfully...")
  saveRDS(series_kof, path_rds_kof)
} else {
  # Otherwise download the KOF series from the RDS folder 
  message("Loading kof series from RDS folder...")
  series_kof <- readRDS(path_rds_kof)
}

