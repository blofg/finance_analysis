

################################################################################
# Database for Buffet Ratio
################################################################################


# File path for the buffet RDS 
path_rds_buffet <- paste0(path_rds_folder,"series_store_buffet.rds")

# Check if the RDS file exists 
rds_buffet_exists <- file.exists(path_rds_buffet)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_buffet_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_buffet)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for Yahoo inputs 
input_buffet <- subset(input_database, source == "buffet")

# The Buffet series are updated every Day
if (update_needed) {
  # Reformat buffet data 
  series_buffet <- reformate_data_buffet(tribble = input_buffet) 
  # Put all the series in a list 
  series_buffet <- split(series_buffet, series_buffet$name)
  # Save buffet series
  message("Buffet series saved successfully...")
  saveRDS(series_buffet, path_rds_buffet)
} else {
  # Otherwise download the buffet series from the RDS folder 
  message("Loading Buffet series from RDS folder...")
  series_buffet <- readRDS(path_rds_buffet)
}



