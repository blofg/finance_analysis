################################################################################
# Database for Geopolitical Risk Index
################################################################################

# File path for the GPR RDS 
path_rds_gpr <- paste0(path_rds_folder, "series_store_gpr.rds")

# Check if the RDS file exists
rds_gpr_exists <- file.exists(path_rds_gpr)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_gpr_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_gpr)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for GPR inputs
input_gpr <- subset(input_database, source == "gpr")

# The GPR series are updated every Day
if (update_needed) {
  # Reformat GPR data 
  series_gpr <- reformate_data_gpr(tribble = input_gpr)
  # Put all the series in a list
  series_gpr <- split(series_gpr, series_gpr$name)
  # Save GPR series
  message("Geopolitical Risk Index series saved successfully...")
  saveRDS(series_gpr, path_rds_gpr)
} else {
  message("Loading Geopolitical Risk Index series from RDS folder...")
  series_gpr <- readRDS(path_rds_gpr)
}





