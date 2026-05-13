
################################################################################
# Database for GIE (Gaz Infrastructure Europe ) series
################################################################################

# File path for the  RDS 
path_rds_gie <- paste0(path_rds_folder, "series_store_gie.rds")

# Subset the database inputs only for GIE inputs 
input_gie <- subset(input_database, source == "gie")

# Load RDS if it exists and determine whether new dates need to be fetched
if (file.exists(path_rds_gie)) {
  last_modified <- as.Date(file.info(path_rds_gie)$mtime)
  # RDS was already updated today : no fetch needed
  if (last_modified == Sys.Date()) {
    message("GIE series already up to date (last modified: ", last_modified, "). No fetch needed.")
    series_gie <- readRDS(path_rds_gie)
    # RDS exists but is outdated : fetch only the missing range and append
  } else {
    series_gie  <- readRDS(path_rds_gie)
    existing_df <- bind_rows(series_gie)
    last_date   <- max(existing_df$date, na.rm = TRUE)
    from_date   <- last_date + 1
    new_data    <- reformate_data_gie(from = format(from_date, "%Y-%m-%d"), to = format(Sys.Date(), "%Y-%m-%d"), tribble = input_gie)
    series_gie  <- bind_rows(existing_df, new_data) %>% distinct(id, date, .keep_all = TRUE) %>% 
      split(.$name)
    saveRDS(series_gie, path_rds_gie)
    message("GIE series updated: added dates from ", format(from_date, "%Y-%m-%d"), " to ", format(Sys.Date(), "%Y-%m-%d"), ".")
  }
  # No RDS found : fetch full history from 2011-01-01
} else {
  message("GIE: no RDS found, fetching full history from 2011-01-01...")
  series_gie <- reformate_data_gie(from = "2011-01-01", to = format(Sys.Date(), "%Y-%m-%d"), tribble = input_gie) %>% 
    split(.$name)
  saveRDS(series_gie, path_rds_gie)
  message("GIE series saved successfully (full history up to ", format(Sys.Date(), "%Y-%m-%d"), ").")
}


