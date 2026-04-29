
################################################################################
# Database for all series
################################################################################

# Interactive view of the complete database (with all series)
print(datatable(input_database))               

# Create a list with all series from each database
series_database <- setNames(do.call(c, mget(ls(pattern = "^series_"))), gsub("^[^.]+\\.", "", names(do.call(c, mget(ls(pattern = "^series_"))))))

# Message to know which series is NULL (not fecthed correctly)
null_series <- names(series_database)[sapply(series_database, is.null)]
if (length(null_series) > 0) { message("NULL series from Yahoo and FRED : ", paste(null_series, collapse = ", ")) } else { message("No NULL series from Yahoo and FRED") }
if (length(setdiff(input_database$name, names(series_database))) > 0) { message("NULL series from the rest: ", paste(setdiff(input_database$name, names(series_database)), collapse = " / ")) } else { message("No NULL series from the rest") }

# File path for the RDS 
path_rds_all <- paste0(path_rds_folder,"series_store_all.rds")

# Save the data base with all series in a RDS file 
saveRDS(series_database, path_rds_all)


