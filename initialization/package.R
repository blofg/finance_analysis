
################################################################################
# Packages
################################################################################

# ╔════════════════════════════════════════════════════════════════════════════╗
# ║                                 Comments                                  ║
# ╚════════════════════════════════════════════════════════════════════════════╝
# readxl         : Read Excel files
# dplyr          : Data manipulation (filtering, grouping, summarizing)
# tidyr          : Data reshaping and tidying
# tibble         : Modern data frames
# ggplot2        : Grammar of graphics for elegant plots
# tsbox          : Time series conversion utilities
# stringr        : Consistent string manipulation
# quantmod       : Financial data extraction and visualization
# tidyquant      : Tidyverse-friendly financial analysis
# BatchGetSymbols: Batch download market data (Yahoo Finance)
# rvest          : Web scraping (HTML parsing)
# yfR            : Efficient Yahoo Finance data retrieval
# purrr          : Functional programming tools
# httr           : HTTP requests for APIs
# jsonlite       : Read/write JSON data
# XML            : Parse XML / HTML documents
# RSelenium      : Browser automation for dynamic scraping
# quantr         : Access Quandl financial data
# TTR            : Technical trading indicators
# ichimoku       : Ichimoku Kinko Hyo indicator
# fredr          : Access FRED economic time series
# cli            : User-friendly command line interfaces
# dygraphs       : Interactive time series charts
# magrittr       : Pipe operators (%>%)
# highcharter    : Interactive charts with Highcharts

################################################################################
# Packages used in this script
################################################################################

packages <- c(
  "readxl", "dplyr", "tidyr", "tibble", "ggplot2", "tsbox", "stringr",
  "quantmod", "tidyquant", "BatchGetSymbols", "rvest", "yfR", "purrr",
  "httr", "jsonlite", "XML", "RSelenium", "quantr", "TTR", "ichimoku",
  "fredr", "cli", "dygraphs", "magrittr", "highcharter", "lubridate",
  "DT", "rollama", "tidychatmodels", "rmarkdown","htmltools", "eurostat",
  "tidyverse", "gt", "scales", "rsdmx", "knitr", "sandwich", "lmtest", "ecb",
  "yahoofinancer", "shiny")


################################################################################
# Install missing packages 
################################################################################

invisible(lapply(packages, function(pkg) {if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)}))

################################################################################
# Load packages
################################################################################

invisible(lapply(packages, function(pkg) {if (!require(pkg, character.only = TRUE)) {message(paste("Package", pkg, "could not be loaded"))}}))
