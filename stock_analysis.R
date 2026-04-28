
################################################################################
# Stock analysis
################################################################################





 
################################################################################
# My stocks analysis
################################################################################

 

# Technical indicators - Interactive
technical_indicator_list <- compute_technical_indicators(id = "AAPL", interval = "1Y")
produce_interactive_technical_indicators_plot(id = "AAPL", interval = "1Y", title = toupper("Apple"), technical_indicator = NULL, cut = FALSE) 
produce_interactive_technical_indicators_plot(id = "AAPL", interval = "1Y", title = toupper("Apple"), technical_indicator = NULL, cut = TRUE) 
produce_interactive_technical_indicators_plot(id = "AAPL", interval = "1Y", title = toupper("Apple"), technical_indicator = c("sma","adx","macd","rsi"), cut = TRUE) 
produce_interactive_technical_indicators_plot(id = "AAPL", interval = "1Y", title = toupper("Apple"), technical_indicator = c("sma","adx","macd","rsi"), cut = FALSE) 

# Financial statements 
cash_flow_a <- get_financial(id = "AAPL", aq = "A", fs = "C")
cash_flow_q <- get_financial(id = "AAPL", aq = "Q", fs = "C")
income_statment_a <- get_financial(id = "AAPL", aq = "A", fs = "I")
income_statment_q <- get_financial(id = "AAPL", aq = "Q", fs = "I")
balance_sheet_a <- get_financial(id = "AAPL", aq = "A", fs = "B")
balance_sheet_q <- get_financial(id = "AAPL", aq = "Q", fs = "B")

# Yield and volatility 
yield_vol_df <- compute_yield_volatility(id = "AAPL", days = c(1, 5, 10), window = 252)

# Correlation
corr_df <- compute_correlation(ids = c("AAPL", "MSFT", "NVDA", "GOOGL", "AMZN", "META", "TSLA"), method = "pearson", use_log_returns = TRUE, period = NULL)
produce_correlation_table(ids = c("AAPL", "MSFT", "NVDA", "GOOGL", "AMZN", "META", "TSLA"), method = "pearson", use_log_returns = TRUE, period = NULL)

# CAPM 
capm <- compute_capm(id = "AAPL", benchmark_id = "^GSPC", risk_free_rate = 0)

