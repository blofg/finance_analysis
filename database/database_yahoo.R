

################################################################################
# Database for Yahoo series
################################################################################

# File path for the Yahoo RDS 
path_rds_yahoo <- paste0(path_rds_folder,"series_store_yahoo.rds")

# Check if the RDS file exists 
rds_yahoo_exists <- file.exists(path_rds_yahoo)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_yahoo_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_yahoo)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for Yahoo inputs 
input_yahoo <- subset(input_database, source == "yahoo")

# The Yahoo series are updated every Day
if (update_needed) {
  # Reformat Yahoo data
  series_yahoo <- setNames(lapply(seq_len(nrow(input_yahoo)), function(i) {
    id   <- input_yahoo$id[i]
    suppressWarnings(reformate_data_yahoo(serie_id = id, tribble = input_yahoo))}), 
    input_yahoo$name)
  # Save Yahoo series
  message("Yahoo series saved successfully...")
  saveRDS(series_yahoo, path_rds_yahoo)
} else {
  # Otherwise download the Yahoo series from the RDS folder 
  message("Loading Yahoo series from RDS folder...")
  series_yahoo <- readRDS(path_rds_yahoo)
}
