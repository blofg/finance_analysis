# finance_analysis

A comprehensive R-based financial analysis framework that automatically collects data from multiple sources, computes indicators, and renders a suite of HTML reports Covering macro indicators, equity valuations, monetary policy, stress & volatility indices, bond markets & yield curves, freight, geopolitical risk, currency dynamics, and crypto across major economies, as well as by share analysis, technical indicators, and financial statements.

## Project Structure

```
finance_analysis/
│
├── main.R                          # Master script — runs the full pipeline
│
├── initialization/
│   ├── package.R                   # Package installation & loading
│   ├── input.R                     # Global inputs (dates, paths, API keys, tickers)
│   └── secret.R                    # API credentials (not tracked in version control)
│
├── function/
│   ├── function_information.R      # Price fetching (Yahoo Finance via quantmod)
│   ├── function_format.R           # Data formatting & reshaping utilities
│   ├── function_visualization.R    # Chart & table rendering functions
│   ├── function_compute.R          # Technical indicators & statistical computations
│   └── function_ai.R               # LLM/Ollama integration for AI commentary
│
├── database/
│   ├── database_fred.R             # FRED — US & global macro series
│   ├── database_yahoo.R            # Yahoo Finance — equities, ETFs, FX, commodities
│   ├── database_eurostat.R         # Eurostat — EU/EA macro aggregates
│   ├── database_ecb.R              # ECB — yield curves (AAA & all-issuers, 3M–30Y)
│   ├── database_oecd.R             # OECD — CPI harmonised series
│   ├── database_investing.R        # Investing.com — Baltic Dry, PMI, ZEW
│   ├── database_kof.R              # KOF Swiss Economic Institute — barometers & sentiment
│   ├── database_kofnc.R            # KOF Nowcasting Lab — GDP nowcast vintages
│   ├── database_shiller.R          # Shiller data — CAPE / P/E10 ratio
│   ├── database_buffet.R           # Buffet Indicator — market-cap-to-GDP ratios
│   ├── database_stoxx.R            # STOXX — VSTOXX volatility index
│   ├── database_euribor.R          # Euribor — interbank rates (1W to 12M)
│   ├── database_cnn.R              # CNN Fear & Greed Index & sub-indicators
│   ├── database_ccc.R              # CoinMarketCap — Crypto Fear & Greed Index
│   ├── database_imf.R              # IMF — gold reserves (value & volume) + M2 broad money
│   ├── database_epu.R              # Economic Policy Uncertainty Index (US, EU & major countries)
│   ├── database_gpr.R              # Geopolitical Risk Index (daily, acts, threats, MA7/MA30)
│   └── database_all.R              # Combined interactive metadata view
│   └── rds/
│       ├── series_store_fred.rds
│       ├── series_store_yahoo.rds
│       ├── series_store_eurostat.rds
│       ├── series_store_ecb.rds
│       ├── series_store_oecd.rds
│       ├── series_store_investing.rds
│       ├── series_store_kof.rds
│       ├── series_store_kofnc.rds
│       ├── series_store_shiller.rds
│       ├── series_store_buffet.rds
│       ├── series_store_stoxx.rds
│       ├── series_store_euribor.rds
│       ├── series_store_cnn.rds
│       ├── series_store_ccc.rds
│       ├── series_store_imf.rds
│       ├── series_store_epu.rds
│       ├── series_store_gpr.rds
│       └── series_store_all.rds
│
├── html/
│   ├── geo_reports/
│   │   ├── markdown/
│   │   │   ├── us_report_html.Rmd      # United States macroeconomic report
│   │   │   ├── eu_report_html.Rmd      # Europe macroeconomic report
│   │   │   ├── ch_report_html.Rmd      # Switzerland macroeconomic report
│   │   │   └── wrl_report_html.Rmd     # World macroeconomic report
│   │   └── output/
│   │
│   ├── market_reports/
│   │   ├── markdown/
│   │   │   ├── equity_index_report_html.Rmd              # Global equity indices
│   │   │   ├── key_indices_and_indicators_report_html.Rmd # VIX, Fear & Greed, spreads, etc.
│   │   │   ├── gold_fundamentals_report_html.Rmd         # Gold & precious metals
│   │   │   ├── crypto_report_html.Rmd                    # Crypto markets
│   │   │   └── bond_market_report_html.Rmd               # Bond markets & yield curves
│   │   └── output/
│   │
│   ├── share_reports/
│   │   └── mag7/
│   │       ├── markdown/
│   │       │   ├── magnificent_aapl_report_html.Rmd      # Apple
│   │       │   ├── magnificent_msft_report_html.Rmd      # Microsoft
│   │       │   ├── magnificent_googl_report_html.Rmd     # Alphabet (Google)
│   │       │   ├── magnificent_nvda_report_html.Rmd      # Nvidia
│   │       │   ├── magnificent_amzn_report_html.Rmd      # Amazon
│   │       │   ├── magnificent_meta_report_html.Rmd      # Meta Platforms
│   │       │   └── magnificent_tsla_report_html.Rmd      # Tesla
│   │       └── output/
│   │
│   └── style/                          # Shared CSS / assets for HTML reports
│
├── data/
│   ├── rdata/                          # Cached R data objects
│   └── excel/                          # Source Excel/CSV downloads (Shiller, KOF, EPU, GPR…)
│
├── publish.R                           # Pushes rendered reports to GitHub Pages
├── stock_analysis.R                    # Standalone individual stock analysis
└── metadata_display.R                  # Interactive metadata viewer (DT table with view button)
```

## Data Sources

- **FRED**
- **Yahoo Finance**
- **Eurostat**
- **ECB**
- **OECD**
- **Investing.com**
- **KOF** & **KOF Nowcasting Lab**
- **Shiller**
- **Buffet Indicator**
- **STOXX**
- **Euribor**
- **CNN**
- **CoinMarketCap**
- **IMF**
- **EPU**
- **GPR**

## Reports Generated

### Geographic Reports (`html/geo_reports/`)
Macroeconomic and financial reports across major economies:

- **United States** (`us_report_html.Rmd`)
- **Europe** (`eu_report_html.Rmd`)
- **Switzerland** (`ch_report_html.Rmd`)
- **World** (`wrl_report_html.Rmd`)

### Market Reports (`html/market_reports/`)
Financial and marekt reports:

- **Global Equity Indices** (`equity_index_report_html.Rmd`)
- **Key Indices & Indicators** (`key_indices_and_indicators_report_html.Rmd`)
- **Gold Fundamentals** (`gold_fundamentals_report_html.Rmd`)
- **Crypto Markets** (`crypto_report_html.Rmd`)
- **Bond Markets** (`bond_market_report_html.Rmd`)

### Share Reports — Magnificent 7 (`html/share_reports/mag7/`)
Individual equity reports with price history, technical indicators. 

- **Reports for the magnficient 7 (Apple, Nvidia, Google, Microsoft, Amazon, Meta, Tesla)**

## Key Functions


### `function_information.R` — Data fetching

| Function | Purpose |
|---|---|
| `get_prices()` | Fetches OHLCV price data from Yahoo Finance |
| `get_financial()` | Retrieves financial statements (income, balance sheet, cash flow) |
| `get_eurostat_series()` | Pulls a time series from the Eurostat API |
| `get_ecb_yield()` | Fetches ECB yield curve data (spot & forward rates) |
| `get_investing_market_series()` | Scrapes market series from Investing.com |
| `get_investing_indicator_series()` | Scrapes indicator series from Investing.com |
| `get_euribor_series()` | Fetches Euribor rates for a given maturity |
| `get_series()` | Generic loader — retrieves a cached series by name from the RDS store |

### `function_compute.R` — Computation & analytics

| Function | Purpose |
|---|---|
| `compute_technical_indicators()` | Computes RSI, MACD, Bollinger Bands, ATR, Ichimoku and more |
| `compute_risk_return()` | Calculates returns, volatility, and Sharpe ratio over multiple horizons |
| `compute_correlation()` | Computes pairwise correlation matrix (Pearson or log returns) |
| `compute_capm()` | Estimates alpha, beta, and R² via CAPM regression |
| `compute_rolling_correlation()` | Computes rolling correlation between two series over a sliding window |
| `compute_rebase()` | Rebases a series to 100 at a given base date |
| `compute_moving_average()` | Adds simple moving averages to a dataframe |
| `build_sml()` | Builds the Security Market Line with optional Markowitz efficient frontier |

### `function_format.R` — Formatting

All reformate_data_*() functions follow the same pattern: they fetch or receive raw data from their respective source, then normalize it into a single standardized long-format dataframe with consistent columns (id, date, value, name, label, source, unit, frequency, adjustment) — ready to be cached as .rds and consumed by the reporting layer.

### `function_visualization.R` — Charts & tables

| Function | Purpose |
|---|---|
| `produce_technical_indicators_plot()` | Renders a full technical analysis chart for a given asset and time interval |
| `produce_performance_table()` | Generates a formatted performance summary table |
| `produce_correlation_table()` | Renders a styled pairwise correlation matrix |
| `produce_interactive_plot()` | Produces an interactive `dygraphs` time series chart with optional SMA |
| `produce_histogram_plot()` | Plots a histogram of a time series column |
| `produce_distribution_plot()` | Renders a distribution (density) plot for a given value series |
| `produce_financial_statements_table()` | Displays formatted financial statement data as a `gt` table |

### `function_ai.R` — AI / LLM integration

| Function | Purpose |
|---|---|
| `summarize_for_ollama_chat()` | Computes descriptive statistics (last values, diffs, rolling mean/SD) to feed as context to an Ollama LLM for narrative generation |
---

## Setup

### 1. Prerequisites

- R ≥ 4.2
- The following API keys must be set as environment variables (e.g. in `.Renviron`):

```r
FRED_API_KEY        = "your_fred_key"
MARKETSTACK_API_KEY = "your_marketstack_key"
```

Place any additional credentials in `initialization/secret.R` (not tracked in version control).

### 2. Set the working directory

In `main.R`, update the path to match your local setup:

```r
path_main <- file.path("~", "Desktop", "script", "finance_analysis")
```

### 3. Run the pipeline

Source `main.R` to execute the full pipeline:

```r
source("main.R")
```

This will, in order:
1. Load all packages (`initialization/package.R`)
2. Load credentials and inputs (`initialization/secret.R`, `initialization/input.R`)
3. Pull and cache all data (`database/*.R` → `database/rds/`)
4. Render all HTML reports (`html/**/*.Rmd` → `html/**/output/`)
5. Publish reports to GitHub Pages (`publish.R`)
6. Display metadata (`metadata_display.R`)


## Main R Packages

| Package | Role |
|---|---|
| `fredr` | FRED API |
| `quantmod`, `yfR`, `yahoofinancer` | Yahoo Finance data |
| `eurostat` | Eurostat API |
| `ecb` | ECB data |
| `rsdmx` | OECD SDMX API |
| `rvest`, `httr`, `jsonlite` | Web scraping & REST APIs |
| `dplyr`, `tidyr`, `tibble`, `tidyverse` | Data manipulation |
| `ggplot2`, `highcharter`, `dygraphs` | Visualisation |
| `TTR`, `ichimoku` | Technical indicators |
| `rmarkdown`, `knitr` | Report rendering |
| `gt`, `DT` | Formatted tables |
| `rollama`, `tidychatmodels` | LLM / AI integration |
| `shiny` | Interactive components |

## Cached Data

Each `database_*.R` script saves its output as an `.rds` file in `database/rds/` (e.g. `series_store_fred.rds`). On subsequent runs, cached data can be loaded directly to avoid unnecessary API calls.

## Publishing

`publish.R` pushes all rendered HTML outputs to a separate `finance_reports` repository, making them available via GitHub Pages.
