

################################################################################
# Database for FRED series
################################################################################


# File path for the FRED RDS 
path_rds_fred <- paste0(path_rds_folder,"series_store_fred.rds")

# Check if the RDS file exists 
rds_fred_exists <- file.exists(path_rds_fred)

# Update the series only one time on Friday
update_needed <- FALSE

# Condition to know if the series need to be updated 
if (!rds_fred_exists) {update_needed <- TRUE} else {
  # Get last modification date
  last_modified <- as.Date(file.info(path_rds_fred)$mtime)
  # Update only if file was not updated today
  if (last_modified != date_today) {update_needed <- TRUE}
}

# Subset the database inputs only for FRED inputs 
input_fred <- subset(input_database, source == "fred")

# The Investing series are updated every Day
if (update_needed) {
  # Reformat FRED data
  series_fred <- setNames(lapply(seq_len(nrow(input_fred)), function(i) { 
   id   <- input_fred$id[i]
   unit <- input_fred$fred_unit[i]
   fred_unit_arg <- if (is.na(unit) || identical(unit, "")) NULL else unit
   reformate_data_fred(serie_id = id, tribble = input_fred, fred_unit = fred_unit_arg)}),
   input_fred$name)
  # Save FRED series
  message("FRED series saved successfully...")
  saveRDS(series_fred, path_rds_fred)
} else {
  # Otherwise download the FRED series from the RDS folder 
  message("Loading FRED series from RDS folder...")
  series_fred <- readRDS(path_rds_fred)
}

