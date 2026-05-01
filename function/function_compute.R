
################################################################################
# Indicators functions
################################################################################

#-------------------------------------------------------------------------------
# Functions with get_prices() function 
#-------------------------------------------------------------------------------

# Function to compute technical indicators for one id 
compute_technical_indicators <- function(id, interval) {
  #-----------------------------------------------------------------------------
  # Function : Compute technical indicators for one id from get_prices()
  # 1. Input : id       = stock symbol (character)
  # 2. Input : interval = time window for indicators / charts  (character: "1m","3m","6m","1Y","5Y","YTD","all")
  # Output   : list containing full and interval-filtered dataframe with technical indicators
  #-----------------------------------------------------------------------------
  #  Additional inputs (not arguments of the function) 
  #-----------------------------------------------------------------------------
  # Get the data 
  df <- get_prices(id)
  # Only Close, High and Low prices
  hlc <- HLC(df)  
  # Only High and Low prices
  hl <- hlc[, c("High", "Low")]
  # Interval cutting for the graph with technical indicators
  cut_date <- switch(interval,"1m"  = Sys.Date() - months(1),
                     "3m"  = Sys.Date() - months(3),
                     "6m"  = Sys.Date() - months(6),
                     "1Y"  = Sys.Date() - years(1),
                     "5Y"  = Sys.Date() - years(5),
                     "YTD" = floor_date(Sys.Date(), "year"),
                     "all" = min(df$date))
  #-----------------------------------------------------------------------------
  # Technical indicators independent of the selected time interval
  # (always computed using rolling windows on the full data set with the 20 last
  # closing prices. 
  #-----------------------------------------------------------------------------
  # SMA (Simple Moving Averages) (20 last closing prices)
  df$SMA20  <- SMA(df$Close, n = 20)
  df$SMA50  <- SMA(df$Close, n = 50)
  df$SMA200 <- SMA(df$Close, n = 200)
  # ADX / DI+ / DI-
  adx_obj <- ADX(hlc, n = 14)                                                   # n = look back period for trend strength calculation (standard = 14)
  adx_obj <- as.data.frame(adx_obj)
  df$DIp <- adx_obj$DIp                                                         # Positive directional movement
  df$DIn <- adx_obj$DIn                                                         # Negative directional movement
  df$ADX <- adx_obj$ADX                                                         # Trend strength (independent of direction)
  # Aroon (Up / Down)
  aroon_obj <- aroon(hl, n = 25)                                                # n = number of periods used to detect recent highs/lows (standard = 25)
  aroon_obj <- as.data.frame(aroon_obj)
  df$AroonUp <- aroon_obj$aroonUp                                               # Measures strength of upward trend
  df$AroonDn <- aroon_obj$aroonDn                                               # Measures strength of downward trend
  # MACD 
  macd_obj <- MACD(df$Close, nFast = 12, nSlow = 26, nSig = 9, maType = "EMA")  # nFast = fast EMA period (12), nSlow = slow EMA period (26), nSig  = signal line EMA period (9), maType = moving average type (EMA by default)
  macd_obj <- as.data.frame(macd_obj)
  df$MACD <- macd_obj$macd                                                      # MACD line
  df$MACD_signal <- macd_obj$signal                                             # Signal line
  df$MACD_hist <- df$MACD - df$MACD_signal                                      # Histogram (MACD - Signal)
  # RSI 
  df$RSI <- RSI(df$Close, n = 14)                                               # n = lookback window for momentum calculation (standard = 14)
  # Stochastic Oscillator (%K, %D)
  stoch_obj <- stoch(hlc, nFastK = 14, nFastD = 3, nSlowD = 3)                  # nFastK = lookback period for %K (14), nFastD = smoothing period for %D (3), nSlowD = additional smoothing for slow %D (3)
  stoch_obj <- as.data.frame(stoch_obj)
  df$StochK <- stoch_obj$fastK                                                  # Fast %K line
  df$StochD <- stoch_obj$fastD                                                  # Fast %D signal line
  #-----------------------------------------------------------------------------
  # Technical indicators dependent on the selected time interval
  # (AD and OBV are more meaningful on recent data, less steady)
  #-----------------------------------------------------------------------------
  # Cut the dataframe with respect to the interval (in argument)
  df1<- df %>%
    filter(time >= cut_date)
  # AD (Accumulation/Distribution - Chaikin AD line)
  df1$AD <- chaikinAD(HLC(df1), df1$Volume)
  # OBV (On-Balance Volume)
  df1$OBV <- OBV(df1$Close, df1$Volume)
  #-----------------------------------------------------------------------------
  # Output
  #-----------------------------------------------------------------------------
  return(list(all = df,cut = df1))
}

# Function to compute risk return metrics for one id
compute_risk_return <- function(id, days = c(1, 5, 10), window = 252, rf = 0.04) {
  #-----------------------------------------------------------------------------
  # Function : Compute log returns, rolling volatility, Sharpe, drawdown, skewness, kurtosis and VaR for one or multiple return horizons
  # 1. Input : id     = Yahoo ticker (character), e.g. "AAPL"
  # 2. Input : days   = integer vector of return horizons in trading days, default: c(1, 5, 10) = daily, weekly, bi-weekly
  # 3. Input : window = rolling window used for Sharpe ratio (default: 252 = 1Y)
  # 4. Input : rf     = annualized risk-free rate (default: 4%)
  # Output   : named list with two elements a dataframe with all computed columns and summary tibble with last available values per horizon, (last log return, annualized vol 1Y, Sharpe 1Y, skewness 1Y, kurtosis 1Y, VaR 1%, max drawdown)
  #-----------------------------------------------------------------------------
  # Annualization factor (trading days per year)
  ann_factor <- 252
  # Standard rolling windows: 1M, 3M, 6M, 1Y, 2Y
  windows <- c(20, 60, 120, 252, 504)
  # Daily risk-free rate from annualized rf
  rf_daily <- rf / ann_factor
  # Fetch and prepare price data
  df <- get_prices(id) %>%
    arrange(time)
  # Compute metrics for each return horizon
  for (day in days) {
    # Column name helper
    col_log <- paste0("logret_", day, "d")
    # Log return: log(P(t)/P(t-day))  (preferred for statistical properties)
    df[[col_log]] <- log(df$Close / lag(df$Close, n = day))
    # Rolling metrics across standard windows
    for (w in windows) {
      pfx_mu  <- paste0("mean_logret_",    day, "d_", w, "d_rolling")
      pfx_sd  <- paste0("sd_logret_",      day, "d_", w, "d_rolling")
      pfx_vol <- paste0("ann_vol_logret_", day, "d_", w, "d_rolling")
      pfx_skw <- paste0("skew_logret_",    day, "d_", w, "d_rolling")
      pfx_krt <- paste0("kurt_logret_",    day, "d_", w, "d_rolling")
      pfx_var <- paste0("var1pct_logret_", day, "d_", w, "d_rolling")
      # Rolling mean and sd over window w
      df[[pfx_mu]]  <- rollmean(df[[col_log]], k = w, fill = NA, align = "right")
      df[[pfx_sd]]  <- rollapply(df[[col_log]], width = w, FUN = sd, fill = NA, align = "right")
      # Annualized vol: always sqrt(252/day), NOT sqrt(w) — window size does not affect scaling
      df[[pfx_vol]] <- df[[pfx_sd]] * sqrt(ann_factor / day)
      # Skewness: asymmetry of return distribution — negative = fat left tail (crash risk)
      df[[pfx_skw]] <- rollapply(df[[col_log]], width = w,FUN = function(x) { n <- length(x); m <- mean(x); s <- sqrt(sum((x-m)^2)/n); sum((x-m)^3) / n / s^3 },fill = NA, align = "right")
      # Excess kurtosis: tail thickness vs normal distribution (ref = 0) — positive = fat tails
      df[[pfx_krt]] <- rollapply(df[[col_log]], width = w,FUN = function(x) { n <- length(x); m <- mean(x); s <- sqrt(sum((x-m)^2)/n); sum((x-m)^4) / n / s^4 - 3 },fill = NA, align = "right")
      # Historical VaR 1%: worst return in the bottom 1% of the empirical distribution
      df[[pfx_var]] <- rollapply(df[[col_log]], width = w,FUN = function(x) quantile(x, probs = 0.01, na.rm = TRUE), fill = NA, align = "right")}
    # Use rf to compute excess-return Sharpe with risk-free rate deduction
    mu_col  <- paste0("mean_logret_",     day, "d_", window, "d_rolling")
    vol_col <- paste0("ann_vol_logret_",  day, "d_", window, "d_rolling")
    ann_mu  <- paste0("ann_mean_logret_", day, "d_", window, "d_rolling")
    # Annualized mean log return: mu * (252/day)
    df[[ann_mu]] <- df[[mu_col]] * (ann_factor / day)
    # Sharpe = (annualized mean - rf) / annualized vol
    df[[paste0("sharpe_", day, "d_", window, "d_rolling")]] <- (df[[ann_mu]] - rf) / df[[vol_col]]
    # Maximum drawdown: worst peak-to-trough loss over the rolling window
    df[[paste0("max_drawdown_", day, "d_", window, "d_rolling")]] <-rollapply(df[[col_log]], width = window,FUN = function(x) { cum_ret <- exp(cumsum(x)); min(cum_ret / cummax(cum_ret)) - 1 },fill = NA, align = "right")}
  return(df)
}

# Function to compute correlation between several ids 
compute_correlation <- function(ids, method = "pearson", use_log_returns = TRUE, period = NULL) {
  #-----------------------------------------------------------------------------
  # Function : Compute pairwise correlation matrix across a vector of asset IDs
  # 1. Input : ids             = character vector of Yahoo tickers
  # 2. Input : method          = "pearson" (default) or "spearman"
  # 3. Input : use_log_returns = if TRUE (default), use log returns before correlating
  # 4. Input : period          = optional integer, number of last trading days to use, if NULL (default), use all available history
  # Output   : list with cor_matrix, n_obs, method, period
  #-----------------------------------------------------------------------------
  # Fetch returns for each ticker
  df <- lapply(ids, function(id) {
    df <- get_prices(id) %>% arrange(time)
    if (!is.null(period)) df <- tail(df, period + 1)
    ret <- if (use_log_returns) log(df$Close / lag(df$Close)) else df$Close / lag(df$Close) - 1
    tibble(time = df$time, !!id := ret)})
  # Align by date (inner join on time)
  df <- Reduce(function(a, b) inner_join(a, b, by = "time"), df) %>% 
    na.omit()
  n_obs   <- nrow(df)
  # Compute correlation matrix
  ret_mat <- as.matrix(df[, -1])
  cor_mat <- cor(ret_mat, method = method, use = "pairwise.complete.obs")
  # Return results
  return(list(cor_matrix = cor_mat, n_obs = n_obs, method = method, period = range(df$time), ids = ids))
}

# Function to estimate CAPM for a stock with market 
compute_capm <- function(id, benchmark_id, risk_free_rate = 0) {
  #-----------------------------------------------------------------------------
  # Function : Estimate CAPM alpha and beta via OLS r_i - rf = alpha + beta * (r_m - rf) + epsilon
  # Input 1  : id             = asset ticker (character)
  # Input 2  : benchmark_id   = market/benchmark ticker (character)
  # Input 3  : risk_free_rate = annualized risk-free rate (default 0)
  # Output   : list with alpha, beta, r_squared, p_values, conf_int, model, data
  #-----------------------------------------------------------------------------
  # Compute the risk free rate daily
  rf_daily <- risk_free_rate / 252
  # Fetch and return daily log returns as a tibble
  df <- function(ticker) {
    df <- get_prices(ticker) %>% arrange(time)
    tibble(time = df$time, logret = log(df$Close / lag(df$Close))) %>% na.omit()}
  # Rename the 
  asset_ret <- df(id) %>% 
    rename(r_asset = logret)
  bench_ret <- df(benchmark_id) %>%
    rename(r_bench = logret)
  # Bind by dates 
  df_reg <- inner_join(asset_ret, bench_ret, by = "time") %>%
    mutate(excess_asset = r_asset - rf_daily,
           excess_bench = r_bench - rf_daily)
  # Stop if there are less than 30 observations, because unrealiale estimate
  if (nrow(df_reg) < 30)
    stop("compute_capm(): fewer than 30 overlapping observations — CAPM estimate unreliable.")
  # Run the regression
  fit   <- lm(excess_asset ~ excess_bench, data = df_reg)
  alpha <- coef(fit)[["(Intercept)"]]
  beta  <- coef(fit)[["excess_bench"]]
  r2    <- summary(fit)$r.squared
  # Inference (use HC3, Heteroskedasticity-Consistent)
  ct       <- coeftest(fit, vcov = vcovHC(fit, type = "HC3"))
  se_alpha <- ct[1, "Std. Error"];  se_beta <- ct[2, "Std. Error"]
  p_alpha  <- ct[1, "Pr(>|t|)"];   p_beta  <- ct[2, "Pr(>|t|)"]
  ci_alpha <- alpha + c(-1, 1) * qnorm(0.975) * se_alpha
  ci_beta  <- beta  + c(-1, 1) * qnorm(0.975) * se_beta
  se_type  <- "HC3 (robust)"
  # Result
  result <- list(id = id,benchmark_id = benchmark_id, alpha = alpha,beta = beta, r_squared = r2, n_obs = nrow(df_reg),period = range(df_reg$time), se_type = se_type, p_values = c(alpha = p_alpha, beta = p_beta), conf_int = list(alpha = setNames(ci_alpha, c("lower_95", "upper_95")), beta  = setNames(ci_beta,  c("lower_95", "upper_95"))),model = fit,data = df_reg)
  # Scatter plot 
  x_seq <- seq(min(df_reg$excess_bench), max(df_reg$excess_bench), length.out = 300)
  pred  <- data.frame(x = x_seq, y = alpha + beta * x_seq)
  p <- ggplot(df_reg, aes(x = excess_bench, y = excess_asset)) +
    geom_point(alpha = 0.2, size = 0.9, color = "#2166AC") +
    geom_line(data = pred, aes(x = x, y = y), color = "#D6604D", linewidth = 1) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey60") +
    geom_vline(xintercept = 0, linetype = "dashed", color = "grey60") +
    theme_minimal(base_size = 11) +
    theme(plot.background  = element_rect(fill = "#161b22", color = NA),panel.background = element_rect(fill = "#161b22", color = NA), panel.grid.major = element_line(color = "#30363d"), panel.grid.minor = element_line(color = "#30363d"), text = element_text(color = "white"), axis.text = element_text(color = "white"), plot.title = element_text(color = "white"), plot.subtitle = element_text(color = "white"), axis.title = element_text(color = "white"))+
    labs(title = sprintf("CAPM: %s vs %s", id, benchmark_id),subtitle = sprintf("alpha = %.5f (p=%.3f)  |  beta = %.3f (p=%.3f)  |  R² = %.3f ",alpha, p_alpha, beta, p_beta, r2), x = paste0("Excess return — ", benchmark_id), y = paste0("Excess return — ", id))
  print(p)
  result$scatter_plot <- p
  return(result)
}

#-------------------------------------------------------------------------------
# Functions with get_series() function 
#-------------------------------------------------------------------------------

# Function to compute rolling correlation between two time series 
compute_rolling_correlation <- function(name_1, name_2, window = 90) {
  #-----------------------------------------------------------------------------
  # Function : Compute rolling correlation between two series from get_series()
  # 1. Input : name_1  = series name 1
  # 2. Input : name_2  = series name 2
  # 3. Input : window  = rolling window in days (default 90)
  # Output   : dataframe with returns and rolling correlation
  #-----------------------------------------------------------------------------
  # Get the data 
  series_1 <- get_series(name_1) 
  series_2 <- get_series(name_2)
  # Extract labels from name column
  label_1 <- unique(series_1$name)
  label_2 <- unique(series_2$name)
  # Convert to xts
  xts_1 <- xts(series_1$value, order.by = as.Date(series_1$date))
  xts_2 <- xts(series_2$value, order.by = as.Date(series_2$date))
  colnames(xts_1) <- "value"
  colnames(xts_2) <- "value"
  # Daily returns
  ret_1 <- dailyReturn(xts_1)
  ret_2 <- dailyReturn(xts_2)
  # Merge
  df <- merge(ret_1, ret_2)
  colnames(df) <- c(label_1, label_2)
  df <- na.omit(df)
  # Rolling correlation
  df$rolling_corr <- rollapply(data = df, width = window, FUN = function(x) cor(x[, 1], x[, 2]), by.column = FALSE, fill = NA, align = "right")
  # Return dataframe
  result      <- as.data.frame(df)
  result$date <- index(df)
  return(result)
}

# Function to compute rebased time series 
compute_rebase <- function(df, base_date){
  #-----------------------------------------------------------------------------
  # Function : Function that rebases time series to 100 at a specified base date
  # 1. Input : df        = dataframe with id, date, value and name columns 
  # 2. Input : base_date = base date for index normalization (character "YYYY-MM-DD")
  # Output   : dataframe with indexed values (base = 100)
  #-----------------------------------------------------------------------------
  df <- df %>%
    select(id, date, value, name) %>%
    ts_index(base = base_date) %>%             
    mutate(value = value * 100)
  return(df)
}

#-------------------------------------------------------------------------------
# Others
#-------------------------------------------------------------------------------

# Function to compute Moving average (20,50,200) 
compute_moving_average <- function(df, date_col, value_col) {
  #-----------------------------------------------------------------------------
  # Function : Compute technical indicators for one id from get_prices()
  # 1. Input : df        = dataframe with date_col and value_col
  # 2. Input : date_col  = column name for x-axis (e.g. "time", "date")
  # 3. Input : value_col = column name for y-axis (e.g. "value", "Close")
  # Output   : dataframe with simple moving average computed 
  #-----------------------------------------------------------------------------
  # Check if df is NULL or empty
  if (is.null(df) || nrow(df) == 0) {
    message("compute_moving_average(): df is NULL or empty, skipping computation.")
    return(invisible(NULL))}
  # Moving average computation (20,50,200)
  df$SMA20  <- SMA(df[[value_col]], n = 20)
  df$SMA50  <- SMA(df[[value_col]], n = 50)
  df$SMA200 <- SMA(df[[value_col]], n = 200)
  return(df)
}

# Function to source and compute a time a data script takes 
compute_time_data <- function(file, label) {
  #-----------------------------------------------------------------------------
  # Function : Compute time a data script and display the time it took to run
  # 1. Input : file  = path to the R file to source (character)
  # 2. Input : label = label to display in the message (character)
  # Output   : message with the time it took to source the file
  #-----------------------------------------------------------------------------
  t <- system.time(source(file))
  message(sprintf("%s: %.2f sec", label, t["elapsed"] / 60))
}

# Function to render and compute a Rmd script takes
compute_time_render <- function(file, output_dir, label, llm_analysis = FALSE) {
  #-----------------------------------------------------------------------------
  # Function : Compute time a Rmd script and display the time it took to run
  # 1. Input : file         = path to the Rmd file to render (character)
  # 2. Input : output_dir   = path to the output directory (character)
  # 3. Input : label        = label to display in the message (character)
  # 4. Input : llm_analysis = whether to run LLM analysis (logical, default FALSE)
  # Output   : message with the time it took to render the file
  #-----------------------------------------------------------------------------
  t <- system.time(render(file, output_dir = output_dir, params = list(llm_analysis = llm_analysis)))
  message(sprintf("%s: %.2f sec", label, t["elapsed"] / 60))
}







build_sml <- function(ids, benchmark_id, risk_free_rate = 0.02, frontier = TRUE, n_portfolios = 5000, plot = TRUE) {
  #-----------------------------------------------------------------------------
  # Function : Build Security Market Line (SML) and Markowitz Efficient Frontier
  # Input 1  : ids            = character vector of asset tickers
  # Input 2  : benchmark_id   = market benchmark ticker (e.g. "^GSPC")
  # Input 3  : risk_free_rate = annualized risk-free rate (default 0.02)
  # Input 4  : frontier       = if TRUE, compute and plot the efficient frontier
  # Input 5  : n_portfolios   = random portfolios for frontier simulation (default 5000)
  # Input 6  : plot           = if TRUE, print combined ggplot
  # Output   : list(sml_data, sml_line, frontier_data, combined_plot)
  #
  #-----------------------------------------------------------------------------
  ann_factor <- 252
  rf_daily   <- risk_free_rate / 252

  # --- Fetch and align returns for all tickers ---
  all_ids  <- unique(c(ids, benchmark_id))
  ret_list <- lapply(all_ids, function(id) {
    df <- tryCatch(get_prices(id) %>% arrange(time), error = function(e) NULL)
    if (is.null(df) || nrow(df) == 0) {
      message(sprintf("build_sml(): could not fetch '%s', skipping.", id))
      return(NULL)}
    tibble(time = df$time, !!id := log(df$Close / lag(df$Close))) %>% na.omit()})
  names(ret_list) <- all_ids
  ret_list <- Filter(Negate(is.null), ret_list)

  aligned <- Reduce(function(a, b) inner_join(a, b, by = "time"), ret_list) %>% na.omit()
  n_obs   <- nrow(aligned)

  # Assets available in aligned data (some may have failed)
  avail_assets <- ids[ids %in% names(aligned)]

  # --- CAPM stats per asset ---
  sml_data <- lapply(avail_assets, function(id) {
    r <- aligned[[id]]           - rf_daily
    m <- aligned[[benchmark_id]] - rf_daily
    fit      <- lm(r ~ m)
    beta_val <- coef(fit)[["m"]]
    # Annualized geometric return and vol
    ann_ret  <- exp(mean(aligned[[id]], na.rm = TRUE) * ann_factor) - 1
    ann_vol  <- sd(aligned[[id]], na.rm = TRUE) * sqrt(ann_factor)
    sharpe   <- (ann_ret - risk_free_rate) / ann_vol
    tibble(id = id, beta = beta_val, ann_return = ann_ret,
           ann_vol = ann_vol, sharpe = sharpe)}) %>%
    bind_rows()

  bench_ann_ret <- exp(mean(aligned[[benchmark_id]], na.rm = TRUE) * ann_factor) - 1

  # SML theoretical line: E(r) = rf + beta * (E(rm) - rf)
  beta_range <- seq(min(c(sml_data$beta, 0)) - 0.3,
                    max(c(sml_data$beta, 1)) + 0.3,
                    length.out = 300)
  sml_line <- tibble(
    beta       = beta_range,
    sml_return = risk_free_rate + beta_range * (bench_ann_ret - risk_free_rate))

  result <- list(
    sml_data             = sml_data,
    sml_line             = sml_line,
    benchmark_ann_return = bench_ann_ret,
    risk_free_rate       = risk_free_rate,
    n_obs                = n_obs,
    period               = range(aligned$time))

  # --- Efficient Frontier (Monte Carlo) ---
  do_frontier <- frontier && length(avail_assets) >= 2
  if (do_frontier) {
    ret_mat  <- as.matrix(aligned[, avail_assets])
    mu_daily <- colMeans(ret_mat, na.rm = TRUE)          # arithmetic daily mean
    cov_mat  <- cov(ret_mat, use = "pairwise.complete.obs")

    set.seed(42)
    w <- matrix(runif(n_portfolios * length(avail_assets)), ncol = length(avail_assets))
    w <- w / rowSums(w)  # long-only, sum-to-one

    port_ret <- as.numeric(w %*% (mu_daily * ann_factor))
    port_vol <- sqrt(rowSums((w %*% (cov_mat * ann_factor)) * w))

    frontier_data <- tibble(
      ann_vol    = port_vol,
      ann_return = port_ret,
      sharpe     = (port_ret - risk_free_rate) / port_vol)

    result$frontier_data <- frontier_data
  }

  # --- Visualization ---
  if (plot) {
    if (!requireNamespace("ggplot2", quietly = TRUE)) {
      warning("build_sml(): ggplot2 not available — plot skipped.")
      return(invisible(result))}

    fmt_pct <- function(x) paste0(round(x * 100, 1), "%")

    # Panel A: Security Market Line
    p_sml <- ggplot2::ggplot() +
      ggplot2::geom_line(
        data = sml_line,
        ggplot2::aes(x = beta, y = sml_return),
        color = "#D6604D", linewidth = 1) +
      ggplot2::geom_point(
        data = sml_data,
        ggplot2::aes(x = beta, y = ann_return, color = sharpe),
        size = 3.5) +
      ggplot2::geom_text(
        data = sml_data,
        ggplot2::aes(x = beta, y = ann_return, label = id),
        vjust = -0.9, size = 3) +
      ggplot2::geom_point(
        data = data.frame(beta = 1, ret = bench_ann_ret),
        ggplot2::aes(x = beta, y = ret),
        shape = 18, size = 5, color = "black") +
      ggplot2::geom_text(
        data = data.frame(beta = 1, ret = bench_ann_ret, lbl = benchmark_id),
        ggplot2::aes(x = beta, y = ret, label = lbl),
        vjust = -0.9, size = 3, fontface = "bold") +
      ggplot2::scale_color_gradient2(
        low = "#2166AC", mid = "grey80", high = "#D6604D",
        midpoint = median(sml_data$sharpe, na.rm = TRUE), name = "Sharpe") +
      ggplot2::scale_y_continuous(labels = fmt_pct) +
      ggplot2::theme_minimal(base_size = 11) +
      ggplot2::labs(
        title    = "Security Market Line (CAPM)",
        subtitle = sprintf("rf = %s  |  E(rm) = %s  |  %d obs  |  %s to %s",
                           fmt_pct(risk_free_rate), fmt_pct(bench_ann_ret), n_obs,
                           format(result$period[1], "%Y-%m-%d"),
                           format(result$period[2], "%Y-%m-%d")),
        x = "Beta (systematic risk)",
        y = "Annualized return")

    if (do_frontier) {
      # Panel B: Efficient Frontier
      p_frontier <- ggplot2::ggplot() +
        ggplot2::geom_point(
          data = frontier_data,
          ggplot2::aes(x = ann_vol, y = ann_return, color = sharpe),
          alpha = 0.25, size = 0.7) +
        ggplot2::geom_point(
          data = sml_data,
          ggplot2::aes(x = ann_vol, y = ann_return),
          color = "black", size = 3.5) +
        ggplot2::geom_text(
          data = sml_data,
          ggplot2::aes(x = ann_vol, y = ann_return, label = id),
          vjust = -0.9, size = 3) +
        ggplot2::scale_color_gradient(
          low = "#2166AC", high = "#D6604D", name = "Sharpe") +
        ggplot2::scale_x_continuous(labels = fmt_pct) +
        ggplot2::scale_y_continuous(labels = fmt_pct) +
        ggplot2::theme_minimal(base_size = 11) +
        ggplot2::labs(
          title    = "Markowitz Efficient Frontier",
          subtitle = sprintf("%d assets  |  %d random portfolios (long-only, Monte Carlo)",
                             length(avail_assets), n_portfolios),
          x = "Annualized volatility (risk)",
          y = "Annualized return")

      # Combine panels — use patchwork if available, else print separately
      if (requireNamespace("patchwork", quietly = TRUE)) {
        combined <- patchwork::wrap_plots(p_sml, p_frontier, ncol = 2)
        print(combined)
        result$combined_plot  <- combined
      } else {
        print(p_sml)
        print(p_frontier)
        result$sml_plot      <- p_sml
        result$frontier_plot <- p_frontier}
    } else {
      print(p_sml)
      result$sml_plot <- p_sml}}

  return(invisible(result))
}








