

################################################################################
# Database for KOF Nowcasting series
################################################################################

# File path for the KOF Nowcasting RDS 
path_rds_kofnc  <- paste0(path_rds_folder,"series_store_kofnc.rds")

# Check if the RDS file exists 
rds_kofnc_exists <- file.exists(path_rds_kofnc)

# Update the series one time every day
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_kofnc_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_kofnc)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for KOF Nowcasting inputs
input_kofnc <- subset(input_database, source %in% c("kofnc"))

# The KOF Nowcasting series are updated every Day
if (update_needed) {
  # Reformat KOF Nowcasting data 
  series_kofnc <-reformate_data_kofnc(tribble = input_kofnc)
  series_kofnc <- list(kof_nowcastinglab = series_kofnc)
  # Save KOF Nowcasting series
  message("KOF Nowcastingseries saved successfully...")
  saveRDS(series_kofnc, path_rds_kofnc)
} else {
  # Otherwise download the KOF Nowcasting series from the RDS folder 
  message("Loading KOF Nowcasting series from RDS folder...")
  series_kofnc <- readRDS(path_rds_kofnc)
}

