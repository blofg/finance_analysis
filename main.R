rm(list = ls())
options(scipen = 999)

################################################################################
# Environment
################################################################################

# Central folder path
path_main <- file.path("~", "Desktop", "script", "finance_analysis")
setwd(path_main)


################################################################################
# Call scripts to get functions/inputs
################################################################################

source("initialization/package.R")           # |Packages|
source("initialization/secret.R")            # |Secret|
source("function/function_information.R")    # |Function price|
source("function/function_format.R")         # |Function format|
source("function/function_visualization.R")  # |Functions visualization|
source("function/function_compute.R")        # |Functions compute|
source("function/function_ai.R")             # |Functions ai|
source("initialization/input.R")             # |Inputs|

################################################################################
# Call scripts to get data
################################################################################

# Compute entire running time for HTML creation
start_time <- Sys.time()

compute_time_data("database/database_fred.R",      "Fred database loading")                         # |Fred database loading|
compute_time_data("database/database_yahoo.R",     "Yahoo database loading")                        # |Yahoo database loading|
compute_time_data("database/database_eurostat.R",  "Eurostat database loading")                     # |Eurostat database loading|
compute_time_data("database/database_ecb.R",       "ECB database loading")                          # |ECB database loading|
compute_time_data("database/database_oecd.R",      "OECD database loading")                         # |OECD database loading|
compute_time_data("database/database_investing.R", "Investing database loading")                    # |Investing database loading|
compute_time_data("database/database_kof.R",       "KOF database loading")                          # |KOF database loading|
compute_time_data("database/database_kofnc.R",     "KOF Nowcasting database loading")               # |KOF Nowcasting database loading|
compute_time_data("database/database_shiller.R",   "Shiller database loading")                      # |Shiller database loading|
compute_time_data("database/database_buffet.R",    "Buffet database loading")                       # |Buffet database loading|
compute_time_data("database/database_stoxx.R",     "Stoxx database loading")                        # |Stoxx database loading|
compute_time_data("database/database_euribor.R",   "Euribor database loading")                      # |Euribor database loading|
compute_time_data("database/database_cnn.R",       "CNN database loading")                          # |CNN database loading|
compute_time_data("database/database_ccc.R",       "CoinMarketCap database loading")                # |CoinMarketCap database loading|
compute_time_data("database/database_imf.R",       "IMF database loading")                          # |IMF database loading|
compute_time_data("database/database_epu.R",       "Economic Policy Uncertainty database loading")  # |Economic Policy Uncertainty database loading|
compute_time_data("database/database_gpr.R",       "Geopolitical Risk Index database loading")      # |Geopolitical Risk Index database loading|
compute_time_data("database/database_eia.R",       "EIA database loading")                          # |EIA database loading|
compute_time_data("database/database_gie.R",       "GIE database loading")                          # |GIE database loading|
compute_time_data("database/database_all.R",       "All database interactive view")                 # |Data from all sources loading|

# Running time 
end_time <- Sys.time()
cat("✅ Total :", round(difftime(end_time, start_time, units = "mins"), 2), "minutes\n")

################################################################################
# Call markdown html documents
################################################################################

# Compute entire running time for HTML creation
start_time <- Sys.time()

# Geo reports
compute_time_render("html/geo_reports/markdown/us_report_html.Rmd",  "html/geo_reports/output/", "US report markdown")           # |US report markdown|
compute_time_render("html/geo_reports/markdown/eu_report_html.Rmd",  "html/geo_reports/output/", "Europe report markdown")       # |Europe report markdown|
compute_time_render("html/geo_reports/markdown/ch_report_html.Rmd",  "html/geo_reports/output/", "Switzerland report markdown")  # |Switzerland report markdown|
compute_time_render("html/geo_reports/markdown/wrl_report_html.Rmd", "html/geo_reports/output/", "World report markdown")        # |World report markdown|

# Market reports
compute_time_render("html/market_reports/markdown/equity_indices_report_html.Rmd",             "html/market_reports/output/", "Equity index markdown")               # |Equity index markdown|
compute_time_render("html/market_reports/markdown/key_indices_and_indicators_report_html.Rmd", "html/market_reports/output/", "Key index markdown")                  # |Key index markdown|
compute_time_render("html/market_reports/markdown/crypto_report_html.Rmd",                     "html/market_reports/output/", "Crypto report markdown")              # |Crypto report markdown|
compute_time_render("html/market_reports/markdown/bond_market_report_html.Rmd",                "html/market_reports/output/", "Bond market report markdown")         # |Bond market report markdown|

# Commodity reports
compute_time_render("html/commodities_reports/markdown/gold_fundamentals_report_html.Rmd",       "html/commodities_reports/output/", "Gold fundamentals index markdown")           # |Gold fundamentals index markdown|
compute_time_render("html/commodities_reports/markdown/soft_commodities_report_html.Rmd",        "html/commodities_reports/output/", "Soft commodities market report markdown")    # |Soft Commodities market report markdown|
compute_time_render("html/commodities_reports/markdown/hard_commodities_report_html.Rmd",        "html/commodities_reports/output/", "Hard commodities market report markdown")    # |Hard Commodities market report markdown|
compute_time_render("html/commodities_reports/markdown/energy_commodities_report_html.Rmd",      "html/commodities_reports/output/", "Energy Commodities market report markdown")  # |Energy Commodities market report markdown|

# Share reports
compute_time_render("html/share_reports/mag7/markdown/magnificent_aapl_report_html.Rmd",  "html/share_reports/mag7/output/", "Magnificent Apple report markdown")     # |Magnificent Apple report markdown|
compute_time_render("html/share_reports/mag7/markdown/magnificent_msft_report_html.Rmd",  "html/share_reports/mag7/output/", "Magnificent Microsoft report markdown") # |Magnificent Microsoft report markdown|
compute_time_render("html/share_reports/mag7/markdown/magnificent_googl_report_html.Rmd", "html/share_reports/mag7/output/", "Magnificent Google markdown")           # |Magnificent Google markdown|
compute_time_render("html/share_reports/mag7/markdown/magnificent_nvda_report_html.Rmd",  "html/share_reports/mag7/output/", "Magnificent Nvidia markdown")           # |Magnificent Nvidia markdown|
compute_time_render("html/share_reports/mag7/markdown/magnificent_amzn_report_html.Rmd",  "html/share_reports/mag7/output/", "Magnificent Amazon markdown")           # |Magnificent Amazon markdown|
compute_time_render("html/share_reports/mag7/markdown/magnificent_meta_report_html.Rmd",  "html/share_reports/mag7/output/", "Magnificent Meta report markdown")      # |Magnificent Meta report markdown|
compute_time_render("html/share_reports/mag7/markdown/magnificent_tsla_report_html.Rmd",  "html/share_reports/mag7/output/", "Magnificent Tesla report markdown")     # |Magnificent Tesla report markdown|

# Running time 
end_time <- Sys.time()
cat("✅ Total :", round(difftime(end_time, start_time, units = "mins"), 2), "minutes\n")

################################################################################
# Publish reports to GitHub financial report page
################################################################################

source("publish.R")            # |Publish on Git|

################################################################################
# Clean Data interface and compute the time 
################################################################################

rm(list = Filter(function(x) (is.data.frame(get(x)) || is.list(get(x)) || is.matrix(get(x)) || is.array(get(x))) && !grepl("series|input", x), ls()))

################################################################################
# Display Metadata 
################################################################################

source("database/metadata_display.R")     # |Metadata display with view button|









################################################################################
# ToDo
################################################################################

source("stock_analysis.R")     # |stock analysis|


# Probability risque neutral approach 2 de first finance 
# Spread de crédit pour mesurer le risque relatif d'une obligation
# performance relative pour mesurer le risque relatif d'un actif en comparaison avec un indice de marché
# Théorie de portefeuille de markowitz avec frontière efficiente et capm
# how the variance of one asset affect your portfolio (variance)
# Clean financial statements and compute ratio and indicators 

# Mouvement brownien 
# Monte Carlo
# GARCH(1,1), tomorrow's variance (volatility squared), floor + shock + variance of yesterday weighted by Beta, forecasting risk not return
# Hedged portfolio, look a th video saved 
# Trading model with time series momentum, rolling trend 12 months return, signal over the 25 year, positive or negative signals 
# Credit Risk scoring model
# Auto-update financial statements, generate monthly report and create a summary insights 

# Report de recession pour US et Europe, taux de croissance du PIB, taux naturel , écart de production, outputgap, conference board , indice composite de l'OCDE, écart de la courbe des taux
# 20 facteurs fondamentaux barometer geopolitical (regarder capture d'écran Top Gane)
# Indidcateurs pour déterminer le taux de change, différence d'inflation entre les pays.  Les écarts de taux d'intérêts et surtout les écarts de leurs balance de paiements
# cross rates table (currency first finance 67)
# indice msci propose le msci world, s&p propose le spx, goldman sachs propose GS commodity index












