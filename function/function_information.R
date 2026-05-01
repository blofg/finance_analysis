
################################################################################
# Price functions
################################################################################

# Function to get prices from Yahoo 
get_prices <- function(id) {
  #-----------------------------------------------------------------------------
  # Function :  Get price from Yahoo
  # 1. Input :  id = vector of tickers from Yahoo (character)
  # Outputs  :  list with id price from Yahoo
  #-----------------------------------------------------------------------------
  res <- purrr::map(id, ~ try(
    getSymbols(.x, src = "yahoo", auto.assign = FALSE, warnings = FALSE, from = "1950-01-01"),
    silent = TRUE))
  names(res) <- id
  fails <- names(purrr::keep(res, ~ inherits(.x, "try-error")))
  if (length(fails) > 0) {
    message("⛔ Impossible to fetch : ", paste(fails, collapse = ", "))}
  purrr::imap_dfr(
    purrr::keep(res, ~ !inherits(.x, "try-error")),   
    ~ fortify.zoo(.x) %>%
      dplyr::rename(time = Index) %>%
      dplyr::mutate(id = .y, .before = 1) %>%
      dplyr::rename_with(~ paste0(sub(".*\\.", "", .x)), -c(id, time))) %>% 
    distinct(id, time, .keep_all = TRUE) %>%
    na.omit()
}

# Functions to get financial information 
get_financial <- function(id, aq, fs) {
  #-----------------------------------------------------------------------------
  # Function : Download and format Finviz financial statements
  # 1. Input : id      = ticker id (character)
  # 2. Input : aq      = reporting frequency (character: "A", "Q")
  # 3. Input : fs      = statement type (character : "I" income, "B" balance sheet, "C" cash flow)
  # Output   : dataframe with financial statements. 
  #-----------------------------------------------------------------------------
  Sys.sleep(4)
  # Build URL
  URL <- paste0("https://finviz.com/api/statement.ashx?t=",id,"&s=F&s=",fs,aq)
  # Headers (browser-like)
  headers <- c(
    "Host" = "finviz.com",
    "User-Agent" = "Mozilla/5.0",
    "Accept" = "*/*",
    "Accept-Language" = "en-US,en;q=0.5",
    "Accept-Encoding" = "gzip, deflate, br, zstd",
    "Referer" = paste0("https://finviz.com/quote.ashx?t=", id),
    "Connection" = "keep-alive",
    "Sec-Fetch-Dest" = "empty",
    "Sec-Fetch-Mode" = "cors",
    "Sec-Fetch-Site" = "same-origin",
    "Priority" = "u=4")
  # Number of column 9 if annual, 12 if quarter 
  number_col <- if (aq == "A") 9 else 12
  # GET request
  pg <- GET(url = URL, add_headers(.headers = headers))
  # Extract content
  res <- content(pg)
  # If the financial statement does not exist it end the process
  if (is.null(res$data) || length(res$data) == 0) {
    message(paste0("Financial statement not available for ", id))
    return(NULL)}
  # Create the df with financial statements
  tbl <- unlist(res$data)
  rName <- gsub("1", "", unique(names(tbl)[seq(1, length(tbl), number_col)]))
  df <- matrix(tbl, ncol = number_col, byrow = TRUE)
  df <- data.frame(df, row.names = rName)
  colnames(df) <- df[1, ]
  df <- df[-1, ]
  dfn <- data.frame(apply(df, 2, function(x) as.numeric(gsub(",", "", x))), row.names = rownames(df))
  dfn <- dfn[rowSums(is.na(dfn)) != ncol(dfn), ]
  # Clean "X" prefix added by make.names() on numeric column names (e.g. "X2024" -> "2024")
  colnames(dfn) <- gsub("^X", "", colnames(dfn))
  # Move row names to first "Item" column
  dfn <- cbind(Item = rownames(dfn), dfn, stringsAsFactors = FALSE)
  rownames(dfn) <- NULL
  return(dfn)
}

# Functions to get series from Eurostat
get_eurostat_series <- function(id) {
  #-----------------------------------------------------------------------------
  # Function : Safely download a Eurostat dataset
  # 1. Input : id = Eurostat dataset ID (character)
  # Output   : dataframe returned or Null if failed
  #-----------------------------------------------------------------------------
  tryCatch(
    get_eurostat(id, time_format = "date"), error = function(e) {
      message(sprintf("Eurostat download failed for '%s': %s", id, e$message))
      NULL})
}

# Function to get series yield from ECB 
get_ecb_yield <- function(id) {
  #-----------------------------------------------------------------------------
  # Function : Download and format yield data from ECB API
  # 1. Input : series_key = ECB series identifier (character, e.g. "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_10Y")
  # 2. Input : id_value   = identifier value used for joining metadata (character)
  # Output   : dataframe with columns : id, value, date, name, label, source, unit, adjustment, frequency
  #-----------------------------------------------------------------------------
  tryCatch({
    result <- get_data(id) %>%
      rename(date = obstime, value = obsvalue) %>%
      mutate(id = data_type_fm, date = as.Date(date), value = as.numeric(value)) %>%
      select(id, value, date)
    message(paste0(id, " fetched successfully"))
    result}, error = function(e) { message(paste0(id, " failed")); NULL })
}

# Functions to get series from Investing.com (market series)
get_investing_market_series <- function(id, date_from = "1985-01-01", date_to = Sys.Date()) {
  #-----------------------------------------------------------------------------
  # Function : Download historical daily price data from Investing.com API
  # 1. Input : id         = instrument identifier on Investing.com (integer)
  # 2. Input : date_from  = start date of the series (character or Date, default: "1985-01-01")
  # 3. Input : date_to    = end date of the series (character or Date, default: today)
  # Output   : dataframe with two columns : date (Date) and value (numeric close price) 
  #-----------------------------------------------------------------------------
  # API hash required by Investing.com TVC endpoint (static token)
  HASH  <- "9368e857cc51ddcae69108bd8a3b6d49"
  # Maximum number of days per API request (API limit)
  CHUNK <- 5000L
  # Split the full date range into chunks of CHUNK days
  starts <- seq(as.Date(date_from), as.Date(date_to), by = CHUNK)
  ends   <- pmin(starts + CHUNK - 1L, as.Date(date_to))
  # Iterate over each chunk with lapply and fetch data
  chunks <- lapply(seq_along(starts), function(i) {
    message(sprintf("  Fetching chunk %d/%d : %s → %s", i, length(starts), format(starts[i], "%d/%m/%Y"), format(ends[i], "%d/%m/%Y")))
    # Convert dates to UNIX timestamps (UTC) as required by the API
    ts_from <- as.integer(as.POSIXct(paste(starts[i], "00:00:00"), tz = "UTC"))
    ts_to   <- as.integer(as.POSIXct(paste(ends[i],   "23:59:59"), tz = "UTC"))
    # Retry loop : up to 3 attempts, waiting 2 minutes between failures
    attempt <- 1L
    repeat {
      # Current timestamp, embedded in the URL path (refreshed at each attempt)
      ts_now <- as.integer(Sys.time())
      # Build the TVC API URL with symbol, resolution (D = daily) and date range
      url <- sprintf("https://tvc6.investing.com/%s/%d/56/56/23/history?symbol=%d&resolution=D&from=%d&to=%d", HASH, ts_now, id, ts_from, ts_to)
      # GET request with browser-like headers to avoid bot detection (timeout 30s), return NULL on network error instead of crashing
      resp <- tryCatch(GET(url, add_headers(`User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.102 Safari/537.36", `Accept` = "*/*", `Accept-Language` = "en-US,en;q=0.9", `content-type` = "text/plain", `Origin` = "https://tvc-invdn-com.investing.com", `Referer` = "https://tvc-invdn-com.investing.com/", `sec-fetch-dest` = "empty", `sec-fetch-mode` = "cors", `sec-fetch-site` = "same-site"), timeout(30)), error = function(e) NULL)
      # Process response only if the request succeeded (HTTP 200)
      if (!is.null(resp) && status_code(resp) == 200) {
        # Parse JSON body, return NULL on malformed JSON
        json <- tryCatch(fromJSON(content(resp, "text", encoding = "UTF-8")), error = function(e) NULL)
        # Validate API response : status must be "ok" and timestamps non-empty
        if (!is.null(json) && !is.null(json$s) && json$s == "ok" && length(json$t) > 0) {
          # Convert UNIX timestamps to Date, extract closing prices, remove rows with missing close price
          chunk <- tibble(date = as.Date(as.POSIXct(as.numeric(json$t), tz = "UTC")), value = as.numeric(json$c)) %>% filter(!is.na(value))
          message(sprintf("    ✓ %d rows | last = %.2f", nrow(chunk), tail(chunk$value, 1)))
          # Polite delay between requests to avoid rate-limiting (except after last chunk)
          if (i < length(starts)) Sys.sleep(0.8)
          return(chunk)}}
      # Skip chunk after 3 failed attempts
      if (attempt >= 3L) {
        message(sprintf("    ✗ Chunk %d/%d failed after 3 attempts — skipping.", i, length(starts)))
        return(NULL)}
      # Wait 2 minutes before retrying
      message(sprintf("    ✗ Attempt %d failed. Waiting 2 minutes before retry...", attempt))
      Sys.sleep(120)
      attempt <- attempt + 1L}})
  # Combine all chunks, remove duplicate dates, sort chronologically
  bind_rows(chunks) %>% distinct(date, .keep_all = TRUE) %>% arrange(date)
}

# Functions to get indicator series from Investing.com (indicator series)
get_investing_indicator_series <- function(id, date_from = "1950-01-01", date_to = Sys.Date()) {
  #-----------------------------------------------------------------------------
  # Function : Download historical data for an economic indicator from Investing.com
  # 1. Input : id        =  id on Investing.com economic calendar (integer) visible in the page URL, e.g. .../ism-manufacturing-pmi-173 → 173
  # 2. Input : date_from = start date of the series (character or Date, default: "1985-01-01")
  # 3. Input : date_to   = end date of the series (character or Date, default: today)
  # Output   : dataframe with two columns : date (Date) and value (numeric actual release) 
  #-----------------------------------------------------------------------------
  # Build the sbcharts endpoint URL — full history returned in a single request
  url <- sprintf("https://sbcharts.investing.com/events_charts/us/%d.json", id)
  message(sprintf("  Fetching indicator %d ...", id))
  # GET request with browser-like headers to avoid bot detection (timeout 30s), return NULL on network error instead of crashing
  resp <- tryCatch( GET(url,add_headers( `User-Agent` = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.102 Safari/537.36",`Referer`    = "https://www.investing.com/",`Origin`     = "https://www.investing.com"),timeout(30)),error = function(e) NULL)
  # Abort and return empty tibble on network error or non-200 status
  if (is.null(resp) || status_code(resp) != 200) {
    warning(sprintf("HTTP %d — could not fetch indicator %d",
                    if (is.null(resp)) 0L else status_code(resp), id))
    return(tibble(date = as.Date(character()), value = numeric()))}
  # Parse JSON body with simplify Vector = FALSE to preserve list structure, return NULL on malformed JSON
  json <- tryCatch(fromJSON(content(resp, "text", encoding = "UTF-8"), simplifyVector = FALSE), error = function(e) NULL)
  # Validate response : field "data" must be present and non-empty
  # Each element is a 3-item array : [timestamp_ms, actual_value, revision_flag]
  if (is.null(json) || is.null(json$data) || length(json$data) == 0) {
    warning(sprintf("Empty or unexpected response format for indicator %d", id))
    return(tibble(date = as.Date(character()), value = numeric()))
  }
  # Extract timestamp (ms) and actual value from each element, skip rows with missing values
  raw <- lapply(json$data, function(x) {
    vals   <- unlist(x)
    ts_ms  <- as.numeric(vals[1])
    actual <- suppressWarnings(as.numeric(vals[2])) 
    if (is.na(ts_ms) || is.na(actual)) return(NULL)
    # Convert millisecond UNIX timestamp to Date (UTC)
    tibble(date = as.Date(as.POSIXct(ts_ms / 1000, tz = "UTC")), value = actual)}) %>% 
    bind_rows()
  # Filter to requested date range, remove duplicate dates, sort chronologically
  result <- raw %>%
    filter(date >= as.Date(date_from), date <= as.Date(date_to)) %>%
    distinct(date, .keep_all = TRUE) %>%
    arrange(date)
  message(sprintf("    ✓ %d observations | last = %.2f (%s)", nrow(result),tail(result$value, 1), format(tail(result$date, 1), "%d/%m/%Y")))
  return(result)
}

# Functions to get series from Euribor
get_euribor_series <- function(id, maturity_label) {
  #-----------------------------------------------------------------------------
  # Function : Download historical daily Euribor rates by scraping euribor-rates.eu
  # 1. Input : maturity_label = column name pattern to match the desired maturity (e.g. "1 month", "3 months", "6 months", "1 year")
  # 2. Input : maturity_id    = identifier label to tag the series in the output dataframe
  # Output   : dataframe with three columns : date (Date), rate (numeric rate), id (character), covering all available years from 1999 to current year
  #-----------------------------------------------------------------------------
  # Iterate over each year from 1999 to the current year and scrape the HTML table
  years <- 1999:as.integer(format(Sys.Date(), "%Y"))
  map_dfr(years, function(yr) {
    # Build the URL for the given year
    url <- paste0(euribor_url, yr, "/")
    tryCatch({
      # Fetch and parse the HTML page for the given year, extract the first table
      page <- read_html(url)
      df   <- page %>% html_table(fill = TRUE) %>% .[[1]]
      # Locate the column index matching the requested maturity label (case-insensitive)
      col_idx <- grep(maturity_label, colnames(df), ignore.case = TRUE)
      # Skip this year if no matching maturity column is found
      if (length(col_idx) == 0) return(NULL)
      # Select date and rate columns, parse types, tag with id, drop incomplete rows
      df %>%
        select(date = 1, value = all_of(col_idx)) %>%
        mutate(date = as.Date(date, format = "%m/%d/%Y"), value = as.numeric(gsub("[^0-9.-]", "", value)),id = id) %>%
        filter(!is.na(date), !is.na(value))
      # Return NULL silently on any scraping or parsing error (e.g. year not yet available)
    }, error = function(e) NULL)})
}

# Function to get KOF now cast 
get_kof_nowcast  <- function(id, last_quarter) {
  #-----------------------------------------------------------------------------
  # Function : pick_forecast
  # 1. Input : series_id    = id of the forecast (country is inside)
  # 2. Input : last_quarter = 1 equals one last, 2 equals two lasts, 3 equals three lasts, etc
  # Output   : filtered dataframe based on pub_date and name
  #-----------------------------------------------------------------------------
  # Change the name of the input id 
  series_id <- id
  # Get the last 1, 2 or 3 quarter forecasts 
  quarter_forecast <- series_database$kof_nowcastinglab %>%
    arrange(date) %>%
    distinct(date) %>%
    tail(last_quarter) %>%
    pull(date)
  # Get the forecast according to the two inputs 
  df <- series_database$kof_nowcastinglab %>% 
    filter(id %in% series_id, date %in% quarter_forecast)
  return(df)
}

# Functions to get series from the database
get_series <- function(name) {
  #-----------------------------------------------------------------------------
  # Function : Retrieve one or multiple series by name (single name or vector)
  # 1. Input : name = series name(s) as defined in series_database (character)
  # Output   : dataframe for the chosen series (single), or cbound dataframe (vector)
  #-----------------------------------------------------------------------------
  # Check for missing series in series_database
  missing_series <- name[!name %in% names(series_database)]
  if (length(missing_series) > 0) {
    warning(paste0("get_series(): The following series are not available in series_database: ",paste(missing_series, collapse = ", ")), call. = FALSE)}
  # Keep only available series
  name <- name[name %in% names(series_database)]
  if (length(name) == 0) {
    message("get_series(): No valid series found in series_database.")
    return(invisible(NULL))}
  # Single name -> return directly
  if (length(name) == 1) {return(series_database[[name]])}
  # Vector of names -> retrieve and try to cbind
  series_list <- lapply(name, function(nm) series_database[[nm]])
  # Try to cbind; if it fails, warn and combine the columns in common(no hard stop)
  df <- tryCatch({
    # Find columns common to all series
    common_cols <- Reduce(intersect, lapply(series_list, names))
    # Keep only common columns and rbind
    do.call(rbind, lapply(series_list, `[`, common_cols))},
    error = function(e) { warning(paste0(
      "get_series(): Could not rbind all series. Returning rbind of common columns. ",
      "Reason: ", conditionMessage(e)), call. = FALSE)
      # Still bind common columns
      common_cols <- Reduce(intersect, lapply(series_list, names))
      do.call(rbind, lapply(series_list, `[`, common_cols))})
  return(df)
}


