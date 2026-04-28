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

source("initialization/package.R")           # |Package|
source("function/function_information.R")    # |Function price|
source("function/function_format.R")         # |Function format|
source("function/function_visualization.R")  # |Functions visualization|
source("function/function_compute.R")        # |Functions compute|
source("function/function_ai.R")             # |Functions ai|
source("initialization/input.R")             # |Input|

################################################################################
# Call scripts to get data
################################################################################

source("database/database_fred.R")         # |Fred database loading|
source("database/database_yahoo.R")        # |Yahoo database loading|
source("database/database_eurostat.R")     # |Eurostat database loading|
source("database/database_ecb.R")          # |ECB database loading|
source("database/database_oecd.R")         # |OECD database loading|
source("database/database_investing.R")    # |Investing database loading|
source("database/database_kof.R")          # |KOF database loading|
source("database/database_kofnc.R")        # |KOF Nowcasting database loading|
source("database/database_shiller.R")      # |Shiller database loading|
source("database/database_buffet.R")       # |Buffet database loading|
source("database/database_stoxx.R")        # |Investing database loading|
source("database/database_euribor.R")      # |Euribor database loading|
source("database/database_cnn.R")          # |CNN database loading|
source("database/database_ccc.R")          # |CoinMarketCap database loading|
source("database/database_imf.R")          # |IMF database loading|
source("database/database_epu.R")          # |Economic Policy Uncertainty database loading|
source("database/database_gpr.R")          # |Geopolitical Risk Index database loading|
source("database/database_all.R")          # |All database interactive view|

################################################################################
# Call markdown html documents
################################################################################

# Geo reports
render("html/geo_reports/markdown/us_report_html.Rmd",  output_dir = "html/geo_reports/output/", params = list(llm_analysis = FALSE))      # |US report markdown|
render("html/geo_reports/markdown/eu_report_html.Rmd",  output_dir = "html/geo_reports/output/", params = list(llm_analysis = FALSE))      # |Europe report markdown|
render("html/geo_reports/markdown/ch_report_html.Rmd",  output_dir = "html/geo_reports/output/", params = list(llm_analysis = FALSE))      # |Switzerland report markdown|
render("html/geo_reports/markdown/wrl_report_html.Rmd", output_dir = "html/geo_reports/output/", params = list(llm_analysis = FALSE))      # |World report markdown|

# Market reports
render("html/market_reports/markdown/equity_index_report_html.Rmd",             output_dir = "html/market_reports/output/", params = list(llm_analysis = FALSE))      # |Equity index markdown|
render("html/market_reports/markdown/key_index_and_indicator_report_html.Rmd",  output_dir = "html/market_reports/output/", params = list(llm_analysis = FALSE))      # |Key index markdown|
render("html/market_reports/markdown/gold_fundamentals_report_html.Rmd",        output_dir = "html/market_reports/output/", params = list(llm_analysis = FALSE))      # |Gold fundamentals index markdown|
render("html/market_reports/markdown/crypto_report_html.Rmd",                   output_dir = "html/market_reports/output/", params = list(llm_analysis = FALSE))      # |Crypto report markdown|render("html/market_reports/markdown/bond_marketr_report_html.Rmd",             output_dir = "html/market_reports/output/", params = list(llm_analysis = FALSE))      # |Bond market report markdown|

# Share reports
render("html/share_reports/mag7/markdown/magnificent_aapl_report_html.Rmd",      output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Apple report markdown|
render("html/share_reports/mag7/markdown/magnificent_msft_report_html.Rmd",      output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Microsoft report markdown|
render("html/share_reports/mag7/markdown/magnificent_googl_report_html.Rmd",     output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Google markdown|
render("html/share_reports/mag7/markdown/magnificent_nvda_report_html.Rmd",      output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Nvidia markdown|
render("html/share_reports/mag7/markdown/magnificent_amzn_report_html.Rmd",      output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Amazon markdown|
render("html/share_reports/mag7/markdown/magnificent_meta_report_html.Rmd",      output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Meta report markdown|
render("html/share_reports/mag7/markdown/magnificent_tsla_report_html.Rmd",      output_dir = "html/share_reports/mag7/output/", params = list(llm_analysis = FALSE))      # |Magnificent Tesla report markdown|



################################################################################
# Publish reports to GitHub financial report page
################################################################################

source("publish.R")            # |Publish on Git|





source("stock_analysis.R")     # |stock analysis|










################################################################################
# ToDo
################################################################################




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
# report commodities
# 20 facteurs fondamentaux barometer geopolitical (regarder capture d'écran Top Gane)
# Indidcateurs pour déterminer le taux de change, différence d'inflation entre les pays.  Les écarts de taux d'intérêts et surtout les écarts de leurs balance de paiements
# cross rates table (currency first finance 67)
# indice msci propose le msci world, s&p propose le spx, goldman sachs propose GS commodity index








################################################################################
# LLM
################################################################################

library(devtools)
library(tidyverse)
library(tidychatmodels)
library(dotenv)
load_dot_env("/Users/benjaminlachavanne/Desktop/script/finance_analysis/.env")
chat_openai <- create_chat('openai', Sys.getenv('OAI_DEV_KEY'))
chat_openai %>% 
  add_model("gpt-5.2")

chat_openai <- create_chat("openai", Sys.getenv("OAI_DEV_KEY")) %>%
  add_model("gpt-4o-mini") %>%                 # plus léger
  add_params(temperature = 0.2, max_tokens = 50) %>%
  add_message("Say hi in one word.") %>%
  perform_chat()

chat_openai %>% extract_chat()


install.packages("rollama")
library(rollama)

prompt <- "Complete: 2 + 2 is 4, minus 1 that's 3, "
cmd <- sprintf('ollama run mistral "%s"', prompt)
cat(system(cmd, intern = TRUE), sep = "\n")


library(devtools)
library(tidyverse)
library(tidychatmodels)
library(dotenv)


ollama_chat <- create_chat("ollama") |>
  add_model("mistral:latest") |>
  add_message("What is love? IN 10 WORDS.") |>
  perform_chat()

ollama_chat |> extract_chat()


ollama_chat <- create_chat("ollama") |>
  add_model("phi3") |>
  add_message("What is love? IN 10 WORDS.") |>
  perform_chat()

ollama_chat |> extract_chat()




################################################################################
# Comments
################################################################################

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                           VARIABLE SET METHODOLOGY                         ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# ║ All macro-finance variables are structured with exactly 4 columns:         ║
# ║                                                                            ║
# ║ 1. date  : Dates in 'YYYY-MM-DD' format                                    ║
# ║ 2. value : Numeric values representing the variable                        ║
# ║ 3. name  : Name of the variable in the environment                         ║
# ║ 4. id    : An alternative identifier or label for the variable             ║
# ╚════════════════════════════════════════════════════════════════════════════╝







url <- "https://api.alternative.me/fng/?limit=0"
response <- GET(url)
raw <- fromJSON(rawToChar(response$content))
df <- raw$data

# 2. Nettoyer
df$value     <- as.numeric(df$value)
df$date      <- as.Date(as.POSIXct(as.numeric(df$timestamp), origin = "1970-01-01"))






