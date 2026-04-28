
################################################################################
# Visualization functions
################################################################################



#-------------------------------------------------------------------------------
# Functions with get_prices() function
#-------------------------------------------------------------------------------

# Function to produce interactive candlestick plot with technical indicators
produce_technical_indicators_plot <- function(id, interval, title, technical_indicator = NULL, cut = FALSE) {
  #-----------------------------------------------------------------------------
  # Function : Plot candlestick chart with selected technical indicators (highcharter)
  # 1. Input : id                   = stock symbol (character)
  # 2. Input : interval             = time window for indicators / charts ("1m","3m","6m","1Y","5Y","YTD","all")
  # 3. Input : title                = title of the plot
  # 4. Input : technical_indicator  = optional character vector of indicators to display
  #                                   Allowed values: "sma","vol","obv","ad","adx","aroon","macd","rsi","sto"
  #                                   If NULL or empty, all indicators are displayed
  #                                   "obv" and "ad" are only available when cut = TRUE
  # Input 5  : cut                  = logical, if TRUE use interval-filtered data, if FALSE use full dataset
  # Output   : highcharter chart with technical indicators
  #-----------------------------------------------------------------------------
  # Compute technical indicators
  ti <- compute_technical_indicators(id, interval)
  df <- if (cut) ti$cut else ti$all
  # Available technical indicators ("obv" and "ad" only when cut = TRUE)
  all_ind <- c("sma", "vol",if (cut) "obv",if (cut) "ad","adx", "aroon", "macd", "rsi", "sto")
  all_ind <- unlist(all_ind)
  # Clean and select indicators (according to the argument technical_indicator)
  if (is.null(technical_indicator) || length(technical_indicator) == 0) {
    ind <- all_ind
  } else {
    ind <- tolower(technical_indicator)
    ind <- gsub("[^a-z]", "", ind)
    ind <- ind[ind %in% all_ind]}
  # Transform to xts for chartSeries
  df1 <- xts(as.matrix(df[, c("Open","High","Low","Close")]), order.by = df$time)
  cols_to_exclude <- c("time", "id")
  df2 <- xts(as.data.frame(lapply(df[setdiff(names(df), cols_to_exclude)], as.numeric)), order.by = df$time)
  # Panel map (yAxis): 0 = price, others depend on selected indicators
  # "obv" and "ad" panels only created when cut = TRUE
  ordered_panels <- unlist(c("vol", if (cut) "obv", if (cut) "ad", "adx", "aroon", "macd", "rsi", "sto"))
  selected_panels <- ordered_panels[ordered_panels %in% ind]
  panel <- list(price = 0)
  # Loop to know how many panels we have to add under the main interactive plot
  if (length(selected_panels) > 0) {for (k in seq_along(selected_panels)) panel[[selected_panels[k]]] <- k}
  # Axis heights : price panel larger, volume slightly larger, rest equal
  n_yaxis <- 1 + length(selected_panels)
  heights <- c(4, 1.5, rep(1, n_yaxis - 2))
  if (length(heights) > n_yaxis) heights <- heights[seq_len(n_yaxis)]
  # Panel labels for each yAxis
  panel_labels <- c(
    price = "Price",
    vol   = "Volume",
    obv   = "OBV",
    ad    = "A/D Line",
    adx   = "ADX / DI",
    aroon = "Aroon",
    macd  = "MACD",
    rsi   = "RSI (14)",
    sto   = "Stochastic")
  panel_order <- c("price", selected_panels)
  # Build yAxes via create_axis() and inject panel titles + label colors (dark theme)
  # Note: label colors injected here directly to avoid conflict with hc_yAxis() + hc_yAxis_multiples()
  axes <- create_axis(n_yaxis, height = heights, turnopposite = TRUE)
  for (i in seq_along(panel_order)) {
    nm <- panel_order[i]
    axes[[i]]$title  <- list(text  = panel_labels[[nm]],
                             style = list(fontSize = "11px", color = "#aaaaaa", fontWeight = "600"))
    axes[[i]]$labels <- list(style = list(color = "#ffffff"))}
  # Create the main plot
  hc <- hchart(df1, type = "line") %>%
    hc_yAxis_multiples(axes) %>%
    hc_rangeSelector(enabled = TRUE,selected = 5) %>%
    hc_navigator(enabled = TRUE,series = list(color = "transparent", lineWidth = 0)) %>%
    hc_scrollbar(enabled = FALSE) %>% 
    hc_title(text = toupper(title), style = list(color = "#ffffff")) %>%
    hc_chart(backgroundColor = "#161b22") %>%
    hc_xAxis(labels = list(style = list(color = "#ffffff"))) %>%
    hc_legend(itemStyle = list(color = "#ffffff")) %>%
    hc_exporting(enabled = TRUE, buttons = list(contextButton = list(
      menuItems = c("downloadCSV", "downloadXLS", "separator", "downloadPNG", "downloadPDF"))))
  # SMA overlays on price panel
  if ("sma" %in% ind) {
    if ("SMA20"  %in% names(df2)) hc <- hc %>% hc_add_series(df2$SMA20,  type = "line", name = "SMA20",  color = "green",    yAxis = panel$price)
    if ("SMA50"  %in% names(df2)) hc <- hc %>% hc_add_series(df2$SMA50,  type = "line", name = "SMA50",  color = "red",      yAxis = panel$price)
    if ("SMA200" %in% names(df2)) hc <- hc %>% hc_add_series(df2$SMA200, type = "line", name = "SMA200", color = "darkblue", yAxis = panel$price)}
  # Volume
  if ("vol" %in% ind && "Volume" %in% names(df2)) {
    hc <- hc %>% hc_add_series(df2$Volume, type = "column", name = "Volume", color = "steelblue", yAxis = panel$vol)}
  # OBV (cut = TRUE only)
  if ("obv" %in% ind && "OBV" %in% names(df2) && cut) {
    hc <- hc %>% hc_add_series(df2$OBV, type = "line", name = "OBV", color = "orange", yAxis = panel$obv)}
  # A/D line (cut = TRUE only)
  if ("ad" %in% ind && "AD" %in% names(df2) && cut) {
    hc <- hc %>% hc_add_series(df2$AD, type = "line", name = "AD", color = "orange", yAxis = panel$ad)}
  # ADX / DI+ / DI-
  if ("adx" %in% ind) {
    if ("ADX" %in% names(df2)) hc <- hc %>% hc_add_series(df2$ADX, type = "line", name = "ADX", color = "pink",  yAxis = panel$adx)
    if ("DIn" %in% names(df2)) hc <- hc %>% hc_add_series(df2$DIn, type = "line", name = "DI-", color = "red",   yAxis = panel$adx)
    if ("DIp" %in% names(df2)) hc <- hc %>% hc_add_series(df2$DIp, type = "line", name = "DI+", color = "green", yAxis = panel$adx)}
  # Aroon (Up / Down)
  if ("aroon" %in% ind) {
    if ("AroonUp" %in% names(df2)) hc <- hc %>% hc_add_series(df2$AroonUp, type = "line", name = "AroonUp", color = "blue", yAxis = panel$aroon)
    if ("AroonDn" %in% names(df2)) hc <- hc %>% hc_add_series(df2$AroonDn, type = "line", name = "AroonDn", color = "red",  yAxis = panel$aroon)}
  # MACD (line, signal, histogram)
  if ("macd" %in% ind) {
    if ("MACD"        %in% names(df2)) hc <- hc %>% hc_add_series(df2$MACD,        type = "line",   name = "MACD",   color = "blue",   yAxis = panel$macd)
    if ("MACD_signal" %in% names(df2)) hc <- hc %>% hc_add_series(df2$MACD_signal, type = "line",   name = "Signal", color = "orange", yAxis = panel$macd)
    if ("MACD_hist"   %in% names(df2)) hc <- hc %>% hc_add_series(df2$MACD_hist,   type = "column", name = "Hist",   color = "green",  yAxis = panel$macd)}
  # RSI
  if ("rsi" %in% ind && "RSI" %in% names(df2)) {
    hc <- hc %>% hc_add_series(df2$RSI, type = "line", name = "RSI", color = "green", yAxis = panel$rsi)
    hc <- hc %>% hc_add_series(xts(rep(30, NROW(df2)), order.by = index(df2)), type = "line", dashStyle = "Dash", name = "30", yAxis = panel$rsi)
    hc <- hc %>% hc_add_series(xts(rep(70, NROW(df2)), order.by = index(df2)), type = "line", dashStyle = "Dash", name = "70", yAxis = panel$rsi)}
  # Stochastic oscillator
  if ("sto" %in% ind) {
    if ("StochK" %in% names(df2)) hc <- hc %>% hc_add_series(df2$StochK, type = "line", name = "StochK", color = "green",  yAxis = panel$sto)
    if ("StochD" %in% names(df2)) hc <- hc %>% hc_add_series(df2$StochD, type = "line", name = "StochD", color = "orange", yAxis = panel$sto)}
  return(hc)
}

# Function to produce table for series performance 
produce_performance_table <- function(series, labels = NULL){
  #-----------------------------------------------------------------------------
  # Function : Create table of series performance 
  # 1. Input : series = vector of ids (from Yahoo)
  # 2. Input : labels = optional named vector for renaming series
  # Output   : table showing performance (%) over multiple horizons with color coding
  #            - Green if positive
  #            - Red if negative
  #            - White if exactly zero
  #            - Values displayed as percentage with % sign
  #-----------------------------------------------------------------------------
  # Define horizons in trading days
  horizons <- list("1D" = 1,"5D" = 5, "1M" = 21, "3M" = 63,"6M" = 126,"1Y"= 252,"2Y" = 504,"5Y"  = 1260, "10Y" = 2520)
  # Compute performances for all series
  table <- map_dfr(series, function(series_name){
    # Get the data and clean NA and distinct values (date and value columns)
    df <- get_prices(id = series_name)
    prices <- df$Close                          
    last <- tail(prices, 1)                      
    perf <- map_dbl(horizons, function(h){
      if(length(prices) > h) {past <- tail(prices, h + 1)[1]       
      (last / past - 1) * 100              
      } else {NA}})
    # Return tibble for this index
    tibble(Series = series_name,!!!perf)})
  # Replace ticker names with readable labels if provided
  if(!is.null(labels)){table <- table %>% mutate(Series = recode(Series, !!!labels))}
  # Create table with color formatting and bold headers, display values as %
  gt_table <- table %>%
    gt() %>%
    tab_header(title = toupper("Performance Overview"), subtitle = "Returns over multiple horizons (in %)") %>%
    fmt_number(columns = -Series,decimals = 2, pattern = "{x} %") %>%
    data_color(columns = -Series, fn = function(x){ifelse(is.na(x), "#161b22", ifelse(x > 0, "#1a9850", ifelse(x < 0, "#d73027", "#ffffff")))}) %>%    tab_style(style = cell_text(color = "#e6edf3"),locations = cells_body()) %>% 
    tab_style(style = cell_text(weight = "bold"),locations = cells_column_labels(columns = everything())) %>% 
    tab_style(style = cell_text(weight = "bold", transform = "uppercase"),locations = cells_body(columns = Series)) %>% 
    tab_options(table.font.size = px(13), table.border.top.style = "hidden",table.border.bottom.style = "hidden",heading.border.bottom.style = "hidden",column_labels.border.top.style = "hidden") %>% 
    tab_options(table.background.color = "#161b22",column_labels.background.color = "#161b22",heading.background.color = "#161b22",row.striping.include_table_body = TRUE, row.striping.background_color = "#161b22")
  return(gt_table)
}

# Function to produce table for series correlation 
produce_correlation_table <- function(ids, method = "pearson", use_log_returns = TRUE, period = NULL) {
  #-----------------------------------------------------------------------------
  # Function : Display a correlation matrix as a styled gt table
  # 1. Input : ids             = character vector of Yahoo tickers
  # 2. Input : method          = "pearson" (default) or "spearman"
  # 3. Input : use_log_returns = if TRUE (default), use log returns
  # 4. Input : period          = optional integer, number of last trading days, if NULL (default), use all available history
  # Output   : styled gt table with correlation matrix
  #            - Blue       : correlation = 1 (diagonal)
  #            - Green      : positive correlation (darker = stronger)
  #            - Red        : negative correlation (darker = stronger)
  #            - White      : correlation = 0
  #-----------------------------------------------------------------------------
  # Compute correlation matrix
  cor_result <- compute_correlation(ids = ids, method = method, use_log_returns = use_log_returns, period = period)
  cor_mat    <- cor_result$cor_matrix
  # Convert to dataframe with Series column
  table <- as.data.frame(cor_mat) %>%
    mutate(Series = rownames(cor_mat), .before = 1)
  # Color function with gradient depending on correlation value
  color_fn <- function(x) {
    sapply(x, function(v) {
      if (is.na(v))   return("#161b22")
      if (abs(v - 1) < 1e-10) return("#484f58")
      if (v > 0)      return(colorRampPalette(c("#ffffff", "#1a9850"))(100)[round(v * 99) + 1]) 
      if (v < 0)      return(colorRampPalette(c("#ffffff", "#d73027"))(100)[round(abs(v) * 99) + 1]) 
      return("#ffffff")})}
  # Styled gt table
  gt_table <- table %>%
    gt() %>%
    tab_header(title = toupper("Correlation Matrix"), subtitle = paste0(method, " | ", cor_result$n_obs, " overlapping observations")) %>%
    fmt_number(columns = -Series, decimals = 2) %>%
    data_color(columns = -Series, fn = color_fn) %>%
    tab_style(style = cell_text(color = "#e06c00"), locations = cells_body(columns = -Series)) %>%
    tab_style(style = cell_text(color = "#e6edf3"), locations = cells_body(columns = Series)) %>%
    tab_style(style = cell_text(weight = "bold"), locations = cells_column_labels(columns = everything())) %>%
    tab_style(style = cell_text(weight = "bold", transform = "uppercase"), locations = cells_body(columns = Series)) %>%
    tab_options(table.font.size = px(13), table.border.top.style = "hidden", table.border.bottom.style = "hidden", heading.border.bottom.style = "hidden", column_labels.border.top.style = "hidden") %>%
    tab_options(table.background.color = "#161b22", column_labels.background.color = "#161b22", heading.background.color = "#161b22", row.striping.include_table_body = TRUE, row.striping.background_color = "#161b22")
  return(gt_table)
}

#-------------------------------------------------------------------------------
# Function with get_series() function 
#-------------------------------------------------------------------------------

# Function to produce interactive plot (with SMA if needed)
produce_interactive_plot <- function(df, sma = TRUE, title = NULL, is_quarterly = FALSE) {
  #-----------------------------------------------------------------------------
  # Function : Plot series interactive line chart 
  # 1. Input : df     = dataframe with columns date, value, id, label
  # 2. Input : sma    = add SMA if present (FALSE or TRUE)
  # 3. Input : title  = character, custom title (if NULL use default from label)
  # Output  : highcharter chart
  #-----------------------------------------------------------------------------
  # Title logic
  if (is.null(title)) {
    name <- toupper(gsub("_", " ", df$label[1]))
  } else {name <- toupper(title)}
  # Formatter JS : Q1/Q2/Q3/Q4 YYYY instead of Jan/Apr/Jul/Oct 
  if (is_quarterly) {
    x_formatter <- JS("function() {
      var d = new Date(this.value);
      var month = d.getUTCMonth(); // 0-indexed
      var year  = d.getUTCFullYear();
      var q;
      if      (month <= 2)  { q = 'Q1'; }
      else if (month <= 5)  { q = 'Q2'; }
      else if (month <= 8)  { q = 'Q3'; }
      else                  { q = 'Q4'; }
      return q + ' ' + year;}")
    tooltip_formatter <- JS("function() {
      var d = new Date(this.x);
      var month = d.getUTCMonth();
      var year  = d.getUTCFullYear();
      var q;
      if      (month <= 2)  { q = 'Q1'; }
      else if (month <= 5)  { q = 'Q2'; }
      else if (month <= 8)  { q = 'Q3'; }
      else                  { q = 'Q4'; }
      var label = q + ' ' + year;
      var rows = this.points.map(function(p) {
        return '<span style=\"color:' + p.color + '\">\u25CF</span> ' +
               p.series.name + ': <b>' + p.y + '</b>';
      });
      return '<b>' + label + '</b><br/>' + rows.join('<br/>');}")}
  # Create the main plot
  hc <- highchart(type = "stock") %>%
    hc_title(text = name) %>%
    hc_rangeSelector(enabled = TRUE, selected = 5) %>%
    hc_navigator(enabled = TRUE, series = list(color = "transparent", lineWidth = 0)) %>%
    hc_scrollbar(enabled = FALSE) %>%
    hc_colors(c("#2196F3","#E91E63","#FF9800","#4CAF50","#9C27B0","#00BCD4","#FF5722","#8BC34A","#F44336","#3F51B5","#FFEB3B","#009688","#FF4081","#00E5FF","#76FF03","#FF6D00","#D500F9","#00E676","#FFEA00","#40C4FF","#F06292","#AED581","#4DD0E1","#FFD54F","#BA68C8","#81C784","#4FC3F7","#FFB74D","#E57373","#90A4AE")) %>%
    hc_chart(backgroundColor = "#161b22") %>%
    hc_title(style = list(color = "#ffffff")) %>%
    hc_xAxis(labels = list(style = list(color = "#ffffff"))) %>%
    hc_yAxis(labels = list(style = list(color = "#ffffff"))) %>%
    hc_legend(enabled = TRUE, itemStyle = list(color = "#ffffff")) %>%
    hc_exporting(enabled = TRUE, buttons = list(contextButton = list(menuItems = c("downloadCSV", "downloadXLS", "separator", "downloadPNG", "downloadPDF"))))
  # Apply quarterly formatters if needed, otherwise apply shared tooltip for all series
  if (is_quarterly) {
    hc <- hc %>%
      hc_xAxis(labels = list(formatter = x_formatter)) %>%
      hc_tooltip(shared = TRUE, formatter = tooltip_formatter)
  } else {
    hc <- hc %>%
      hc_tooltip(shared = TRUE, useHTML = TRUE, formatter = JS("function() {
        var rows = this.points.map(function(p) {
          return '<span style=\"color:' + p.color + '\">\u25CF</span> ' +
                 p.series.name + ': <b>' + Highcharts.numberFormat(p.y, 1) + '</b>';
        });
        return '<b>' + Highcharts.dateFormat('%e %b %Y', this.x) + '</b><br/>' + rows.join('<br/>');}"))}
  # Detect unique series
  series_ids <- unique(df$id)
  # Loop over each serie(s)
  for (sid in series_ids) {
    df_sub <- df %>% filter(id == sid)
    xts_value <- xts(as.numeric(df_sub$value), order.by = as.Date(df_sub$date))
    # Add value serie(s) (xts with value)
    hc <- hc %>%
      hc_add_series(data = xts_value, name = unique(df_sub$name), type = "line")
    # Add SMA (xts with SMA)
    if (sma && all(c("SMA20","SMA50","SMA200") %in% colnames(df_sub))) {
      hc <- hc %>%
        hc_add_series(xts(df_sub$SMA20, order.by = as.Date(df_sub$date)), name = paste(unique(df_sub$name), "SMA20"), type = "line", dashStyle = "ShortDash") %>%
        hc_add_series(xts(df_sub$SMA50, order.by = as.Date(df_sub$date)), name = paste(unique(df_sub$name), "SMA50"), type = "line", dashStyle = "ShortDot") %>%
        hc_add_series(xts(df_sub$SMA200, order.by = as.Date(df_sub$date)), name = paste(unique(df_sub$name), "SMA200"), type = "line", dashStyle = "Dot")}}
  return(hc)
}

#-------------------------------------------------------------------------------
# Others
#-------------------------------------------------------------------------------

# Function to produce histogram across time
produce_histogram_plot <- function(df, date_col, value_col, title) {
  #-----------------------------------------------------------------------------
  # Function : Produce an interactive bar chart (by date) using highcharter
  # 1. Input : df       = dataframe with time series data
  # 2. Input : date_col = column name for x-axis (e.g. "time", "date")
  # 3. Input : value_col= column name for y-axis (e.g. "yield_1d")
  # 4. Input : title    = chart title 
  # 5. Input : last_n   = number of most recent observations to display (default 500)
  # Output   : highcharter interactive bar chart
  #-----------------------------------------------------------------------------
  # Add color column based on positive/negative values
  df <- df %>%
    mutate(bar_color = case_when(
      is.na(.data[[value_col]])    ~ "#95a5a6",
      .data[[value_col]] >= 0      ~ "#2ecc71",
      TRUE                         ~ "#e74c3c"))
  # Create bar chart 
  hc <- hchart(df, "column", hcaes(x = .data[[date_col]], y = .data[[value_col]], color = bar_color)) %>%
    hc_title(text = toupper(title)) %>%
    hc_rangeSelector(enabled = TRUE,selected = 5) %>%
    hc_plotOptions(column = list(borderWidth = 0, groupPadding = 0, pointPadding = 0)) %>%
    hc_navigator(enabled = TRUE,series = list(color = "transparent", lineWidth = 0)) %>%
    hc_scrollbar(enabled = FALSE) %>% 
    hc_chart(backgroundColor = "#161b22") %>%
    hc_title(style = list(color = "#ffffff")) %>%
    hc_xAxis(title = list(text = NULL), labels = list(style = list(color = "#ffffff"))) %>%
    hc_yAxis(title = list(text = NULL), labels = list(style = list(color = "#ffffff"))) %>%
    hc_legend(itemStyle = list(color = "#ffffff")) %>% 
    hc_exporting(enabled = TRUE,buttons = list(contextButton = list(menuItems = c("downloadCSV", "downloadXLS", "separator", "downloadPNG", "downloadPDF"))))
  return(hc)
}

# Function to produce distribution
produce_distribution_plot <- function(df, value_col, title, bins = 100) {
  #-----------------------------------------------------------------------------
  # Function : Produce an interactive distribution histogram using highcharter
  # 1. Input : df        = dataframe with time series data
  # 2. Input : value_col = column name for the variable to distribute
  # 3. Input : title     = chart title
  # 4. Input : bins      = number of bins (default 100)
  # Output   : highcharter interactive histogram with normal curve overlay
  #-----------------------------------------------------------------------------
  # Compute histogram breaks and counts
  vals   <- na.omit(df[[value_col]])
  h      <- hist(vals, breaks = bins, plot = FALSE)
  bar_df <- data.frame(x = h$mids, y = h$density, color = ifelse(h$mids >= 0, "#2ecc71", "#e74c3c"))
  # Compute normal curve overlay
  x_seq   <- seq(min(vals), max(vals), length.out = 300)
  norm_df <- data.frame(x = x_seq, y = dnorm(x_seq, mean = mean(vals), sd = sd(vals)))
  # Create distribution chart
  hc <- highchart() %>%
    hc_chart(backgroundColor = "#161b22") %>%
    hc_title(text = toupper(title)) %>%
    hc_add_series(
      data         = list_parse2(bar_df),
      type         = "column",
      name         = "Empirical Distribution",
      colorByPoint = TRUE,
      showInLegend = TRUE,
      tooltip      = list(pointFormat = "Density: <b>{point.y:.4f}</b>"),
      plotOptions  = list(column = list(borderWidth = 0, groupPadding = 0, pointPadding = 0))) %>%
    hc_add_series(
      data         = list_parse2(norm_df),
      type         = "spline",
      name         = "Normal Distribution",
      color        = "#ffffff",
      dashStyle    = "Dash",
      lineWidth    = 2,
      showInLegend = TRUE,
      marker       = list(enabled = FALSE)) %>%
    hc_title(style  = list(color = "#ffffff")) %>%
    hc_xAxis(title  = list(text = NULL), labels = list(style = list(color = "#ffffff"))) %>%
    hc_yAxis(title  = list(text = NULL), labels = list(style = list(color = "#ffffff"))) %>%
    hc_legend(itemStyle = list(color = "#ffffff")) %>%
    hc_exporting(enabled = TRUE, buttons = list(contextButton = list(menuItems = c("downloadCSV", "downloadXLS", "separator", "downloadPNG", "downloadPDF"))))
  return(hc)
}

# Function to produce a financial statement as a styled table
produce_financial_statements_table <- function(id, title, aq, fs) {
  #-----------------------------------------------------------------------------
  # Function : Render a financial statement (income statement, balance sheet or cash flow) as a styled HTML table
  # 1. Input : id      = ticker id (character)
  # 2. Input : aq      = reporting frequency (character: "A", "Q")
  # 3. Input : fs      = statement type (character : "I" income, "B" balance sheet, "C" cash flow)
  # 4. Input : title   = table title (character)
  # Output   : gt table with financial statement styling
  #-----------------------------------------------------------------------------
  # Get the statements
  df <- get_financial(id = id, aq = aq, fs = fs)
  # Ensure first column is named "Item" for consistency
  names(df)[1] <- "Item"
  # Period columns (all except "Item")
  period_cols <- setdiff(names(df), "Item")
  # For quarterly data, keep only the 8 most recent quarters
  if (aq == "Q" && length(period_cols) > 8) {
    period_cols <- period_cols[1:8]
    df          <- df[, c("Item", period_cols)]
  }
  #-----------------------------------------------------------------------------
  # Define items, groups and ratio items per statement type
  # Each list entry: list(group = "Group Label", items = c(...))
  # ratio_items: formatted without thousands separator
  #-----------------------------------------------------------------------------
  if (fs == "I") {
    group_map <- list(
      list(group = "Revenue & Profit (in Millions)",  items = c(
        "Total Revenue", "Gross Profit", "Research and Development",
        "Operating Income", "Net Income Before Taxes", "Net Income", "EBITDA")),
      list(group = "Per Share",         items = c(
        "EPS (Diluted)", "EPS (Recurring)", "Shares Outstanding (in Millions)")),
      list(group = "Margins (%)",       items = c(
        "Gross Margin", "Operating Margin", "Net Margin")),
      list(group = "Valuation",         items = c(
        "Price To Earnings Ratio", "Market Capitalization (in Millions)")))
    ratio_items <- c(
      "EPS (Diluted)", "EPS (Recurring)",
      "Price To Earnings Ratio", "Gross Margin", "Operating Margin", "Net Margin")
  } else if (fs == "B") {
    group_map <- list(
      list(group = "Assets (in Millions)",            items = c(
        "Cash & Short Term Investments", "Total Assets")),
      list(group = "Liabilities (in Millions)",       items = c(
        "Total Current Liabilities", "Long Term Debt", "Total Liabilities")),
      list(group = "Equity (in Millions)",            items = c(
        "Total Equity", "Book Value Per Share")),
      list(group = "Profitability (%)", items = c(
        "Return on Assets", "Return on Equity", "Return on Invested Capital")),
      list(group = "Liquidity Ratios",  items = c(
        "Quick Ratio", "Current Ratio")),
      list(group = "Valuation Ratios",  items = c(
        "Price to Book Ratio")),
      list(group = "Other",             items = c(
        "Full-Time Employees")))
    ratio_items <- c(
      "Book Value Per Share", "Price to Book Ratio",
      "Return on Assets", "Return on Equity", "Return on Invested Capital",
      "Quick Ratio", "Current Ratio",
      "Cash Ratio", "Debt-to-Equity", "Debt Ratio",
      "Net Debt / EBITDA", "EV / EBITDA")
  } else if (fs == "C") {
    group_map <- list(
      list(group = "Operating (in Millions)",         items = c(
        "Cash from Operating Activities", "Free Cash Flow")),
      list(group = "Investing (in Millions)",         items = c(
        "Capital Expenditures")),
      list(group = "Financing (in Millions)",         items = c(
        "Repurchase of Common Pref Stock", "Change in Capital Stock")),
      list(group = "Valuation Ratio",         items = c(
        "Price to Free Cash Flow")))
    ratio_items <- c("Price to Free Cash Flow")
  } else {
    group_map   <- NULL
    ratio_items <- c()}
  #-----------------------------------------------------------------------------
  # Build ordered df with a Group column for tab_row_group
  #-----------------------------------------------------------------------------
  if (!is.null(group_map)) {
    ordered_rows <- lapply(group_map, function(g) {
      rows <- df[df$Item %in% g$items, ]
      rows <- rows[match(g$items[g$items %in% rows$Item], rows$Item), ]
      if (nrow(rows) == 0) return(NULL)
      rows$Group <- g$group
      rows
    })
    df <- do.call(rbind, Filter(Negate(is.null), ordered_rows))
  } else {
    df$Group <- ""}
  #-----------------------------------------------------------------------------
  # For Balance Sheet (fs == "B"): compute and append derived ratios
  #-----------------------------------------------------------------------------
  derived_ratio_items <- c(
    "Cash Ratio", "Debt-to-Equity", "Debt Ratio", "Net Debt / EBITDA", "EV / EBITDA")
  if (fs == "B") {
    bs_full <- get_financial(id = id, aq = aq, fs = "B")
    is_full <- get_financial(id = id, aq = aq, fs = "I")
    names(bs_full)[1] <- "Item"
    names(is_full)[1] <- "Item"
    bs_period_cols <- setdiff(names(bs_full), "Item")
    is_period_cols <- setdiff(names(is_full), "Item")
    # Apply same quarterly truncation to source statements
    if (aq == "Q") {
      bs_period_cols <- bs_period_cols[seq_len(min(8, length(bs_period_cols)))]
      is_period_cols <- is_period_cols[seq_len(min(8, length(is_period_cols)))]}
    get_row <- function(source_df, item_name, cols) {
      available_cols <- intersect(cols, names(source_df))
      row <- source_df[source_df$Item == item_name, available_cols, drop = FALSE]
      if (nrow(row) == 0) return(setNames(rep(NA_real_, length(cols)), cols))
      vals <- suppressWarnings(as.numeric(unlist(row[1, ])))
      setNames(vals, available_cols)}
    cash      <- get_row(bs_full, "Cash & Short Term Investments",                   bs_period_cols)
    cur_liab  <- get_row(bs_full, "Total Current Liabilities",                       bs_period_cols)
    lt_debt   <- get_row(bs_full, "Long Term Debt",                                  bs_period_cols)
    st_debt   <- get_row(bs_full, "Short Term Debt Incl. Current Port. of LT Debt",  bs_period_cols)
    tot_asset <- get_row(bs_full, "Total Assets",                                    bs_period_cols)
    tot_eq    <- get_row(bs_full, "Total Equity",                                    bs_period_cols)
    ebitda    <- get_row(is_full, "EBITDA",               is_period_cols)
    ebit      <- get_row(is_full, "Operating Income",     is_period_cols)
    int_exp   <- get_row(is_full, "Interest Expense",     is_period_cols)
    mkt_cap   <- get_row(is_full, "Market Capitalization", is_period_cols)
    # Align IS vectors onto the common period_cols
    align_to_bs <- function(is_vec) {
      out <- setNames(rep(NA_real_, length(period_cols)), period_cols)
      common <- intersect(period_cols, names(is_vec))
      out[common] <- is_vec[common]
      out}
    # Align BS vectors similarly
    align_bs <- function(bs_vec) {
      out <- setNames(rep(NA_real_, length(period_cols)), period_cols)
      common <- intersect(period_cols, names(bs_vec))
      out[common] <- bs_vec[common]
      out}
    cash      <- align_bs(cash)
    cur_liab  <- align_bs(cur_liab)
    lt_debt   <- align_bs(lt_debt)
    st_debt   <- align_bs(st_debt)
    tot_asset <- align_bs(tot_asset)
    tot_eq    <- align_bs(tot_eq)
    ebitda    <- align_to_bs(ebitda)
    ebit      <- align_to_bs(ebit)
    int_exp   <- align_to_bs(int_exp)
    mkt_cap   <- align_to_bs(mkt_cap)
    total_debt <- lt_debt + st_debt
    net_debt   <- total_debt - cash
    ev         <- mkt_cap + net_debt
    build_ratio_row <- function(label, values, group) {
      row <- as.data.frame(t(round(values, 2)), stringsAsFactors = FALSE)
      names(row) <- period_cols
      row$Item  <- label
      row$Group <- group
      row[, c("Item", "Group", period_cols)]}
    derived <- rbind(
      build_ratio_row("Cash Ratio",        cash / cur_liab,       "Liquidity Ratios"),
      build_ratio_row("Debt-to-Equity",    total_debt / tot_eq,   "Leverage Ratios"),
      build_ratio_row("Debt Ratio",        total_debt / tot_asset, "Leverage Ratios"),
      build_ratio_row("Net Debt / EBITDA", net_debt / ebitda,     "Leverage Ratios"),
      build_ratio_row("EV / EBITDA",       ev / ebitda,           "Valuation Ratios"))
    # Remove placeholder rows for derived items already in df, then append computed ones
    df <- df[!(df$Item %in% derived_ratio_items), ]
    df <- rbind(df, derived)}
  #-----------------------------------------------------------------------------
  # Build styled gt table
  #-----------------------------------------------------------------------------
  all_groups    <- unique(df$Group)
  gt_table <- df %>%
    gt(groupname_col = "Group") %>%
    tab_header(title = title) %>%
    # Monetary values
    fmt_number(
      columns = all_of(period_cols), rows = !(Item %in% ratio_items),
      decimals = 2, drop_trailing_zeros = TRUE, sep_mark = "'") %>%
    # Ratio / per-share values
    fmt_number(
      columns = all_of(period_cols), rows = Item %in% ratio_items,
      decimals = 2, drop_trailing_zeros = TRUE, sep_mark = "") %>%
    # Column headers
    tab_style(
      style = list(cell_fill(color = "#0d1117"), cell_text(color = "#ffffff", weight = "bold")),
      locations = cells_column_labels()) %>%
    # Body default: white text, no coloring
    tab_style(
      style = list(cell_fill(color = "#161b22"), cell_text(color = "#ffffff")),
      locations = cells_body()) %>%
    # Item column bold
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_body(columns = "Item")) %>%
    # Title
    tab_style(
      style = list(cell_fill(color = "#0d1117"), cell_text(color = "#ffffff", weight = "bold")),
      locations = cells_title()) %>%
    # Row group labels styling
    tab_style(
      style = list(
        cell_fill(color = "#0d1117"),
        cell_text(color = "#8b949e", weight = "bold", size = px(10), transform = "uppercase")),
      locations = cells_row_groups()) %>%
    tab_options(
      table.background.color            = "#0d1117",
      table.width                       = pct(100),
      table.font.size                   = px(12),
      table.border.top.style            = "none",
      table.border.bottom.style         = "none",
      row.striping.include_table_body   = TRUE,
      row.striping.background_color     = "#1c2128",
      column_labels.border.bottom.width = px(2),
      column_labels.border.bottom.color = "#30363d",
      column_labels.border.top.style    = "none",
      column_labels.padding             = px(10),
      data_row.padding                  = px(10),
      data_row.padding.horizontal       = px(14),
      row_group.padding                 = px(8),
      row_group.border.top.color        = "#30363d",
      row_group.border.top.width        = px(1),
      row_group.border.bottom.color     = "#30363d",
      row_group.border.bottom.width     = px(1)) %>%
    cols_align(align = "left",  columns = "Item") %>%
    cols_align(align = "right", columns = all_of(period_cols)) %>%
    cols_width(Item ~ px(150))
  return(gt_table)
}

