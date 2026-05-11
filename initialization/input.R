
################################################################################
# Inputs
################################################################################

################################################################################
# Date Inputs 
################################################################################

date_today           <- Sys.Date()                                                   

################################################################################
# Path Inputs
################################################################################

path_rdta_folder                    <- paste0(path_main,"/finance_analysis/data/rdata/")
path_excel_folder                   <- paste0(path_main,"/data/excel/")
path_rds_folder                     <- paste0(path_main,"/database/rds/")
path_finance_reports_folder         <- paste0("~/Desktop/script/finance_reports")
path_finance_reports_output_folder  <- paste0(path_finance_reports_folder,"/reports")

################################################################################
# Tickers/API/Source Inputs 
################################################################################

# Marketsatck inputs
marketstack_api_key <- Sys.getenv("MARKETSTACK_API_KEY")
marketstack_url     <- "http://api.marketstack.com/v1/tickers"

# Fred inputs 
fred_api_key    <- Sys.getenv("FRED_API_KEY")
fredr_set_key(fred_api_key)
fred_url       <- "https://fredaccount.stlouisfed.org/apikey"

# Shiller inputs
capeshiller_url  <- "https://shillerdata.com/"
capeshiller_path <- file.path(path_excel_folder, "capeshiller_data.xls")

# KOF inputs
kof_nowcasting_link           <- "https://nowcastinglab.org/api/output/download?indicator=en_excl_covid&model=all"
kof_nowcasting_path           <- file.path(path_excel_folder, "kof_nowcasting_lab.csv")
kof_barometer_swiss_link      <- "https://datenservice.kof.ethz.ch/api/v1/public/ts?keys=kofbarometer&mime=xlsx"
kof_barometer_swiss_path      <-file.path(path_excel_folder, "kof_barometer_swiss.xlsx")
kof_barometer_global_link     <- "https://datenservice.kof.ethz.ch/api/v1/public/ts?keys=ch.kof.globalbaro.coincident,ch.kof.globalbaro.leading,ch.kof.globalbaro.gdp_reference&mime=xlsx&name=date,globalbaro_coincident,globalbaro_leading,gdp_reference"
kof_barometer_global_path     <-file.path(path_excel_folder, "kof_barometer_global.xlsx")
kof_indicator_sbusiness_link  <- "https://datenservice.kof.ethz.ch/api/v1/public/sets/bs_indicator?mime=xlsx"
kof_indicator_sbusiness_path  <-file.path(path_excel_folder, "kof_indicator_business_situation.xlsx")
kof_indicator_seconomic_link  <- "https://datenservice.kof.ethz.ch/api/v1/public/ts?keys=ch.kof.esi.index,eu.ec.esi.eu.esi&mime=xlsx"
kof_indicator_seconomic_path  <-file.path(path_excel_folder, "kof_indicator_economic_sentiment.xlsx")

# Eurostat inputs
eurostat_geo_area <- c("EA21","EA20", "EU27_2020", "FR", "DE", "IT", "CH", "ES", "PT", "AT", "NL", "DK", "NO", "SE", "PL")

# OECD inputs
oecd_api_key <- paste0("https://sdmx.oecd.org/public/rest/data/","OECD.SDD.TPS,DSD_PRICES@DF_PRICES_ALL,1.0/",".M.N.CPI.._T.N.GY+_Z","?startPeriod=1999-01","&dimensionAtObservation=AllDimensions","&format=csvfilewithlabels")

# STOXX inputs 
vstoxx_url <- "https://www.stoxx.com/documents/stoxxnet/Documents/Indices/Current/HistoricalData/h_v2tx.txt"

# Euribor inputs 
euribor_url <- "https://www.euribor-rates.eu/en/euribor-rates-by-year/"

# CNN inputs
greed_and_fear_url <- "https://production.dataviz.cnn.io/index/fearandgreed/graphdata/"

# CoinMarketCap inputs
ccc_fg_url <- "https://api.alternative.me/fng/?limit=0&format=json"

# IMF inputs
imf_geo_area  <- c("USA","DEU","ITA","FRA","RUS","CHN","CHE","JPN","IND","NLD","TUR","POL","GBR","ESP","AUT","BEL","SAU","KAZ","THA","SGP","AUS","SWE","MEX","BRA","PHL","EGY","QAT","IRQ","HUN","ARE")

# Economic Policy Uncertainty inputs 
epu_us_url      <- "https://www.policyuncertainty.com/media/US_Policy_Uncertainty_Data.xlsx"
epu_global_url  <- "https://www.policyuncertainty.com/media/Global_Policy_Uncertainty_Data.xlsx"
epu_canada_url  <- "https://www.policyuncertainty.com/media/Canada_Policy_Uncertainty_Data.xlsx"
epu_uk_url      <- "https://www.policyuncertainty.com/media/UK_Policy_Uncertainty_Data.xlsx"
epu_europe_url  <- "https://www.policyuncertainty.com/media/Europe_Policy_Uncertainty_Data.xlsx"

# Geopoplitical Risk Index inputs 
gpr_url <- "https://www.matteoiacoviello.com/gpr_files/data_gpr_daily_recent.xls"

################################################################################
# Database Inputs  
################################################################################

input_database <- tribble(
  ~id,                      ~name,              ~label,                                                                                                                          ~source, ~frequency, ~fred_unit, ~unit, ~adjustment,
  
  # =============================== MACRO ======================================
  
  # World 
  "NYGDPMKTPCDWLD",          "wrl_gdp_fd",          "Gross Domestic Product for World, Current US Dollars, Seasonally Adjusted",                                                       "fred", "A",      "lin",      "usd",  "SA",
  "NYGDPMKTPCDWLD",          "wrl_gdp_pc1_fd",      "Gross Domestic Product for World, Percent Change from Year Ago, Seasonally Adjusted, ",                                           "fred", "A",      "pc1",      "prc",  "SA",
  
  # Euro Union 
  "CPMNACSCAB1GQEU272020",      "eu27_gdp_fd",            "Gross Domestic Product for European Union (27 Countries), Millions of Euros, Seasonally Adjusted",                                    "fred", "Q",      "lin",      "eur",  "SA",
  "CPMNACSCAB1GQEU272020",      "eu27_gdp_fd",            "Gross Domestic Product for European Union (27 Countries), Percent Change from Year Ago, Seasonally Adjusted",                         "fred", "Q",      "pc1",      "prc",  "SA",
  "CLVMNACSCAB1GQEU272020",     "eu27_rgdp_fd",           "Real Gross Domestic Product for European Union (27 Countries), Millions of Chained 2010 Euros, Seasonally Adjusted",                  "fred", "Q",      "lin",      "eur",  "SA",
  "CLVMNACSCAB1GQEU272020",     "eu27_rgdp_pc1_fd",       "Real Gross Domestic Product for European Union (27 Countries), Percent Change from Year Ago, Seasonally Adjusted",                    "fred", "Q",      "pc1",      "prc",  "SA",
  "CP00EU27_2020",              "eu27_hicp_pc1_es",       "HICP, All Items for European Union (27 Countries), Percent Change from Year Ago, Not Adjusted",                                   "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEEU27_2020",           "eu27_emp_es",            "Employment Rate for European Union (27 Countries), Percent of Active Population, Not Adjusted",                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEEU27_2020",            "eu27_unemp_es",          "Unemployment Rate for European Union (27 Countries), Percent of Active Population, Not Adjusted",                                 "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPREU27_2020",             "eu27_hp_pc1_es",         "Housing Prices Index for European Union (27 Countries), Percent Change from Year Ago, Not Adjusted",                              "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAEU27_2020","eu27_rgdp_pc1_es",       "Real Gross Domestic Product for European Union (27 Countries), Percent Change from Year Ago, Seasonally and Calendar Adjusted",   "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAEU27_2020", "eu27_rgdp_sca_es",       "Real Gross Domestic Product for European Union (27 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted", "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAEU27_2020", "eu27_rgdp_nsa_es",       "Real Gross Domestic Product for European Union (27 Countries), Millions of Chained 2020 Euros, Not Adjusted",                     "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAEU27_2020", "eu27_rtc_pc1_sca_es",    "Real Total Consumption for European Union (27 Countries), Percent Change from Year Ago, Seasonally and Calendar Adjusted",        "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV_PCH_ANNNSAEU27_2020", "eu27_rtc_pc1_nsa_es",    "Real Total Consumption for European Union (27 Countries), Percent Change from Year Ago, Not Adjusted",                            "eurostat", "Q",         NA,      "prc",  "NA",
  "RTCCLV20_MEURSCAEU27_2020",  "eu27_rtc_sca_es",        "Real Total Consumption for European Union (27 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",      "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAEU27_2020",  "eu27_trc_nsa_es",        "Real Total Consumption for European Union (27 Countries), Millions of Chained 2020 Euros, Not Adjusted",                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAEU27_2020", "eu27_rfhc_sca_es",       "Real Household Consumption for European Union (27 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",  "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAEU27_2020", "eu27_rfhc_nsa_es",       "Real Household Consumption for European Union (27 Countries), Millions of Chained 2020 Euros, Not Adjusted",                      "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURNSAEU27_2020",   "eu27_ri_nsa_es",         "Real Investment for European Union (27 Countries), Millions of Chained 2020 Euros, Not Adjusted",                                 "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAEU27_2020",   "eu27_ri_sca_es",         "Real Investment for European Union (27 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",             "eurostat", "Q",         NA,      "eur", "SCA",
  "HSEU27_2020",                "eu27_hs_nsa_es",         "Household Savings for European Union (27 Countries), Percent, Not Adjusted",                                                      "eurostat", "Q",         NA,      "prc",  "NA",
  "BIEU27_2020",                "eu27_bi_nsa_es",         "Business Investment for European Union (27 Countries), Percent, Not Adjusted",                                                    "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAEU27_2020", "eu27_govdfsu_nsa_es",    "Governement Surplus/Deficit for European Union (27 Countries), Millions Euros, Not Adjusted",                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAEU27_2020", "eu27_govdfsu_sca_es",    "Governement Surplus/Deficit for European Union (27 Countries), Millions Euros, Seasonally and Calendar Adjusted",                 "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAEU27_2020",  "eu27_govdfsu_nsa_pg_es", "Governement Surplus/Deficit for European Union (27 Countries), Percentage of GDP, Not Adjusted",                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAEU27_2020",  "eu27_govdfsu_sca_pg_es", "Governement Surplus/Deficit for European Union (27 Countries), Percentage of GDP, Seasonally and Calendar Adjusted",              "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EUREU27_2020",     "eu27_govde_nsa_es",      "Governement Debt for European Union (27 Countries), Millions Euros, Not Adjusted",                                                "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPEU27_2020",      "eu27_govde_nsa_pg_es",   "Governement Debt for European Union (27 Countries), Percentage of GDP, Not Adjusted",                                             "eurostat", "Q",         NA,      "prc",  "NA",
  "EU27_2020CPIOECD",           "eu27_cpi_oecd",          "Consumer Price Index (CPIs, HICPs), Total for European Union (27 Countries), Percent Change from Year Ago, Not Adjusted",             "oecd", "M",         NA,      "prc",  "NA",
  
  # Euro Area 
  "CLV10MNACB1GQSCAEA20Q",   "ea20_rgdp_fd",           "Real Gross Domestic Product (Euro/ECU Series) for Euro Area (20 Countries), Millions of Chained 2010 Euros, Seasonally Adjusted",  "fred", "Q",      "lin",      "eur",  "SA",
  "CLV10MNACB1GQSCAEA20Q",   "ea20_rgdp_pc1_fd",       "Real Gross Domestic Product (Euro/ECU Series) for Euro Area (20 Countries), Percent Change from Year Ago, Seasonally Adjusted",    "fred", "Q",      "pc1",      "prc",  "SA",  
  "CPMNACB1GQSCAEA20Q",      "ea20_gdp_fd",            "Gross Domestic Product for Euro Area (20 Countries), Millions of Euros, Seasonally Adjusted",                                      "fred", "Q",      "lin",      "eur",  "SA",
  "CPMNACB1GQSCAEA20Q",      "ea20_gdp_pc1_fd",        "Gross Domestic Product for Euro Area (20 Countries), Percent Change from Year Ago, Seasonally Adjusted",                           "fred", "Q",      "pc1",      "prc",  "SA",
  "CP00MI15EA20M086NEST",    "ea20_hicp_fd",           "HICP, All Items for Euro Area (20 Countries), Index 2015 = 100, Not Adjusted",                                                     "fred", "M",      "lin",      "idx",  "NA",
  "CP00MI15EA20M086NEST",    "ea20_fd_hicp_pc1_fd",    "HICP, All Items for Euro Area (20 Countries), Percent Change from Year Ago, Not Adjusted",                                         "fred", "M",      "pc1",      "prc",  "NA",
  "CP00EA20",                "ea20_hicp_pc1_es",       "HICP, All Items for Euro Area (20 Countries) Percent Change from Year Ago, Not Adjusted",                                      "eurostat", "M",         NA,      "prc",  "NA",
  "TOTNRGFOODEA20MI15XM",    "ea20_chicp_es",          "HICP, Index Excluding Energy, Food, Alcohol, and Tobacco for Euro Area (20 Countries), Index 2015 = 100, Not Adjusted",           "fred", "M",      "lin",      "idx",  "NA",
  "TOTNRGFOODEA20MI15XM",    "ea20_chicp_pc1_fd",      "HICP, Index Excluding Energy, Food, Alcohol, and Tobacco for Euro Area (20 Countries),Percent Change from Year Ago, Not Adjusted,","fred", "M",      "pc1",      "prc",  "NA",
  "ECBMRRFR",                "ea20_mrr_fd",            "Main Refinancing Operations Rate of ECB, Percent",                                                                                 "fred", "D",      "lin",      "prc",  "NA",
  "ECBDFR",                  "ea20_depfr_fd",          "Deposit Facility Rate of ECB, Percent",                                                                                            "fred", "D",      "lin",      "prc",  "NA",
  "ECBMLFR",                 "ea20_mlr_fd",            "Marginal Lending Facility Rate of ECB, Percent",                                                                                   "fred", "D",      "lin",      "prc",  "NA",
  "ECBASSETSW",              "ea20_ecb_total_asset_fd","Total Assets of ECB, Millions of Euros, Not Adjusted       ",                                                                      "fred", "W",      "lin",      "eur",  "NA",
  "EMPRATEEA21",             "ea21_emp_es",            "Employment Rate for Euro Area (21 Countries), Percent of Active Population, Not Adjusted",                                     "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEEA21",              "ea21_unemp_es",          "Unemployment Rate for Euro Area (21 Countries), Percent of Active Population, Not Adjusted",                                   "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPREA21",               "ea21_hp_pc1_es",         "Housing Prices Index for Euro Area (21 Countries), Percent Change from Year Ago, Not Adjusted",                                "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAEA21",  "ea21_rgdp_pc1_es",       "Real Gross Domestic Product for Euro Area (21 Countries), Percent Change from Year Ago, Seasonally and Calendar Adjusted",     "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAEA21",   "ea21_rgdp_sca_es",       "Real Gross Domestic Product for Euro Area (21 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",   "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAEA21",   "ea21_rgdp_nsa_es",       "Real Gross Domestic Product for Euro Area (21 Countries), Millions of Chained 2020 Euros, Not Adjusted",                       "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAEA21",   "ea21_rtc_pc1_es",        "Real Total Consumption for Euro Area (21 Countries), Percent Change from Year Ago, Seasonally and Calendar Adjusted",          "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAEA21",    "ea21_rtc_sca_es",        "Real Total Consumption for Euro Area (21 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",        "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAEA21",    "ea21_trc_nsa_es",        "Real Total Consumption for Euro Area (21 Countries), Millions of Chained 2020 Euros, Not Adjusted",                            "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAEA21",   "ea21_rfhc_sca_es",       "Real Household Consumption for Euro Area (21 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",    "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAEA21",   "ea21_rfhc_nsa_es",       "Real Household Consumption for Euro Area (21 Countries), Millions of Chained 2020 Euros, Not Adjusted",                        "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAEA21",     "ea21_ri_sca_es",         "Real Investment for Euro Area (21 Countries), Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",               "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAEA21",     "ea21_ri_nsa_es",         "Real Investment for Euro Area (21 Countries), Millions of Chained 2020 Euros, Not Adjusted",                                   "eurostat", "Q",         NA,      "eur",  "NA",
  "HSEA20",                  "ea20_hs_nsa_es",         "Household Savings for Euro Area (20 Countries), Percent, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "BIEA20",                  "ea20_bi_nsa_es",         "Business Investment for Euro Area (20 Countries), Percent, Not Adjusted",                                                      "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAEA21",   "ea21_govdfsu_nsa_es",    "Governement Surplus/Deficit for Euro Area (21 Countries), Millions Euros, Not Adjusted",                                       "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAEA21",   "ea21_govdfsu_sca_es",    "Governement Surplus/Deficit for Euro Area (21 Countries), Millions Euros, Seasonally and Calendar Adjusted",                   "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAEA21",    "ea21_govdfsu_nsa_pg_es", "Governement Surplus/Deficit for Euro Area (21 Countries), Percentage of GDP, Not Adjusted",                                    "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAEA21",    "ea21_govdfsu_sca_pg_es", "Governement Surplus/Deficit for Euro Area (21 Countries), Percentage of GDP, Seasonally and Calendar Adjusted",                "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EUREA21",       "ea21_govde_nsa_es",      "Governement Debt for Euro Area (21 Countries), Millions Euros, Not Adjusted",                                                  "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPEA21",        "ea21_govde_nsa_pg_es",   "Governement Debt for Euro Area (21 Countries), Percentage of GDP, Not Adjusted",                                               "eurostat", "Q",         NA,      "prc",  "NA",
  "EA20CPIOECD",             "ea20_cpi_oecd",          "Consumer Price Index (CPIs, HICPs), Total for Euro Area (20 Countries), Percent Change from Year Ago, Not Adjusted",               "oecd", "M",         NA,      "prc",  "NA",
  "EURIBOR1W",               "ea21_euribor1w",         "Euribor 1 Week for Euro Area (21 Countries)",                                                                                   "euribor", "M",         NA,      "prc",  "NA",
  "EURIBOR1M",               "ea21_euribor1m",         "Euribor 1 Month for Euro Area (21 Countries)",                                                                                  "euribor", "M",         NA,      "prc",  "NA",
  "EURIBOR3M",               "ea21_euribor3m",         "Euribor 3 Months for Euro Area (21 Countries)",                                                                                 "euribor", "M",         NA,      "prc",  "NA",
  "EURIBOR6M",               "ea21_euribor6m",         "Euribor 6 Months for Euro Area (21 Countries)",                                                                                 "euribor", "M",         NA,      "prc",  "NA",
  "EURIBOR12M",              "ea21_euribor12m",        "Euribor 12 Months for Euro Area (21 Countries)",                                                                                "euribor", "M",         NA,      "prc",  "NA",
  
  
  # France
  "CLVMNACSCAB1GQFR",        "fr_rgdp_fd",          "Real Gross Domestic Product for France, Millions of Chained 2010 Euros, Seasonally Adjusted",                                      "fred", "Q",      "lin",      "eur",  "SA",
  "CLVMNACSCAB1GQFR",        "fr_rgdp_pc1_fd",      "Real Gross Domestic Product for France, Percent Change from Year Ago, Seasonally Adjusted",                                        "fred", "Q",      "pc1",      "prc",  "SA",
  "CPMNACSCAB1GQFR",         "fr_gdp_fd",           "Gross Domestic Product for France, Millions of Euros, Seasonally Adjusted",                                                        "fred", "Q",      "lin",      "eur",  "SA",
  "CPMNACSCAB1GQFR",         "fr_gdp_pc1_fd",       "Gross Domestic Product for France, Percent Change from Year Ago, Seasonally Adjusted",                                             "fred", "Q",      "pc1",      "prc",  "SA",
  "FPCPITOTLZGFRA",          "fr_inf_fd",           "Inflation, consumer prices for France, Percent",                                                                                   "fred", "A",      "lin",      "idx",  "NA",
  "CPALTT01FRM657N",         "fr_cpi_fd",           "Consumer Price Index, All Items, Total for France, Growth rate previous period, Not Adjusted",                                     "fred", "M",      "lin",      "idx",  "NA",
  "CP00FR",                  "fr_hicp_pc1_es",      "HICP, All Items for France, Percent Change from Year Ago, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "EMPRATEFR",               "fr_emp_es",           "Employment Rate for France, Percent of Active Population, Not Adjusted",                                                       "eurostat", "M",         NA,      "prc",  "NA",
  "UNRATEFR",                "fr_unemp_es",         "Unemployment Rate for France, Percent of Active Population, Not Adjusted",                                                     "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRFR",                 "fr_hp_pc1_es",        "Housing Prices Index for France, Percent Change from Year Ago, Not Adjusted",                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAFR",    "fr_rgdp_pc1_es",      "Real Gross Domestic Product for France, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAFR",     "fr_rgdp_sca_es",      "Real Gross Domestic Product for France, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                     "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAFR",     "fr_rgdp_nsa_es",      "Real Gross Domestic Product for France, Millions of Chained 2020 Euros, Not Adjusted",                                         "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAFR",     "fr_rtc_pc1_es",       "Real Total Consumption for France, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                            "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAFR",      "fr_rtc_sca_es",       "Real Total Consumption for France, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                          "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAFR",      "fr_trc_nsa_es",       "Real Total Consumption for France, Millions of Chained 2020 Euros, Not Adjusted",                                              "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAFR",     "fr_rfhc_sca_es",      "Real Household Consumption for France, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAFR",     "fr_rfhc_nsa_es",      "Real Household Consumption for France, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAFR",       "fr_ri_sca_es",        "Real Investment for France, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                 "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAFR",       "fr_ri_nsa_es",        "Real Investment for France, Millions of Chained 2020 Euros, Not Adjusted",                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "HSFR",                    "fr_hs_nsa_es",        "Household Savings for France, Percent, Not Adjusted",                                                                          "eurostat", "Q",         NA,      "prc",  "NA",
  "BIFR",                    "fr_bi_nsa_es",        "Business Investment for France, Percent, Not Adjusted",                                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAFR",     "fr_govdfsu_nsa_es",   "Governement Surplus/Deficit for France, Millions Euros, Not Adjusted",                                                         "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAFR",     "fr_govdfsu_sca_es",   "Governement Surplus/Deficit for France, Millions Euros, Seasonally and Calendar Adjusted",                                     "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAFR",      "fr_govdfsu_nsa_pg_es","Governement Surplus/Deficit for France, Percentage of GDP, Not Adjusted",                                                      "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAFR",      "fr_govdfsu_sca_pg_es","Governement Surplus/Deficit for France, Percentage of GDP, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURFR",         "fr_govde_nsa_es",     "Governement Debt for France, Millions Euros, Not Adjusted",                                                                    "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPFR",          "fr_govde_nsa_pg_es",  "Governement Debt for France, Percentage of GDP, Not Adjusted",                                                                 "eurostat", "Q",         NA,      "prc",  "NA",
  "FRACPIOECD",              "fr_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for France, Percent Change from Year Ago, Not Adjusted",                                 "oecd", "M",         NA,      "prc",  "NA",
  
  # Germany 
  "CLVMNACSCAB1GQDE",        "de_rgdp_fd",          "Real Gross Domestic Product for Germany, Millions of Chained 2010 Euros, Seasonally Adjusted",                                     "fred", "Q",      "lin",      "eur",  "SA",
  "CLVMNACSCAB1GQDE",        "de_rgdp_pc1_fd",      "Real Gross Domestic Product for Germany, Percent Change from Year Ago, Seasonally Adjusted",                                       "fred", "Q",      "pc1",      "prc",  "SA",
  "CPMNACSCAB1GQDE",         "de_gdp_fd",           "Gross Domestic Product for Germany, Millions of Euros, Seasonally Adjusted",                                                       "fred", "Q",      "lin",      "eur",  "SA",
  "CPMNACSCAB1GQDE",         "de_gdp_pc1_fd",       "Gross Domestic Product for Germany, Percent Change from Year Ago, Seasonally Adjusted",                                            "fred", "Q",      "pc1",      "prc",  "SA",
  "FPCPITOTLZGDEU",          "de_inf_fd",           "Inflation, consumer prices for Germany, Not Adjusted, Percent",                                                                    "fred", "A",      "lin",      "prc",  "NA",
  "CPALTT01DEM659N",         "de_cpi_fd",           "Consumer Price Indices (CPIs, HICPs), Total for Germany, Not Adjusted, Percent Change from Year Ago",                              "fred", "M",      "lin",      "prc",  "NA",
  "CP00DE",                  "de_hicp_pc1_es",      "HICP, All Items for Germany, Percent Change from Year Ago, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEDE",               "de_emp_es",           "Employment Rate for Germany, Percent of Active Population, Not Adjusted",                                                      "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEDE",                "de_unemp_es",         "Unemployment Rate for Germany, Percent of Active Population, Not Adjusted",                                                    "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRDE",                 "de_hp_pc1_es",        "Housing Prices Index for Germany, Percent Change from Year Ago, Not Adjusted",                                                 "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCADE",    "de_rgdp_pc1_es",      "Real Gross Domestic Product for Germany, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCADE",     "de_rgdp_sca_es",      "Real Gross Domestic Product for Germany, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                    "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSADE",     "de_rgdp_nsa_es",      "Real Gross Domestic Product for Germany, Millions of Chained 2020 Euros, Not Adjusted",                                        "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCADE",     "de_rtc_pc1_es",       "Real Total Consumption for Germany, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCADE",      "de_rtc_sca_es",       "Real Total Consumption for Germany, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                         "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSADE",      "de_trc_nsa_es",       "Real Total Consumption for Germany, Millions of Chained 2020 Euros, Not Adjusted",                                             "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCADE",     "de_rfhc_sca_es",      "Real Household Consumption for Germany, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                     "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSADE",     "de_rfhc_nsa_es",      "Real Household Consumption for Germany, Millions of Chained 2020 Euros, Not Adjusted",                                         "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCADE",       "de_ri_sca_es",        "Real Investment for Germany, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSADE",       "de_ri_nsa_es",        "Real Investment for Germany, Millions of Chained 2020 Euros, Not Adjusted",                                                    "eurostat", "Q",         NA,      "eur",  "NA",
  "HSDE",                    "de_hs_nsa_es",        "Household Savings for Germany, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "BIDE",                    "de_bi_nsa_es",        "Business Investment for Germany, Percent, Not Adjusted",                                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSADE",     "de_govdfsu_nsa_es",   "Governement Surplus/Deficit for Germany, Millions Euros, Not Adjusted",                                                        "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCADE",     "de_govdfsu_sca_es",   "Governement Surplus/Deficit for Germany, Millions Euros, Seasonally and Calendar Adjusted",                                    "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSADE",      "de_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Germany, Percentage of GDP, Not Adjusted",                                                     "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCADE",      "de_govdfsu_sca_pg_es","Governement Surplus/Deficit for Germany, Percentage of GDP, Seasonally and Calendar Adjusted",                                 "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURDE",         "de_govde_nsa_es",     "Governement Debt for Germany, Millions Euros, Not Adjusted",                                                                   "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPDE",          "de_govde_nsa_pg_es",  "Governement Debt for Germany, Percentage of GDP, Not Adjusted",                                                                "eurostat", "Q",         NA,      "prc",  "NA",
  "DEUCPIOECD",              "de_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Germany, Percent Change from Year Ago, Not Adjusted",                                "oecd", "M",         NA,      "prc",  "NA",
  
  # Italy 
  "CP00IT",                  "it_hicp_pc1_es",      "HICP, All Items for Italy, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEIT",               "it_emp_es",           "Employment Rate for Italy, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEIT",                "it_unemp_es",         "Unemployment Rate for Italy, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRIT",                 "it_hp_pc1_es",        "Housing Prices Index for Italy, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAIT",    "it_rgdp_pc1_es",      "Real Gross Domestic Product for Italy, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAIT",     "it_rgdp_sca_es",      "Real Gross Domestic Product for Italy, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAIT",     "it_rgdp_nsa_es",      "Real Gross Domestic Product for Italy, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAIT",     "it_rtc_pc1_es",       "Real Total Consumption for Italy, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAIT",      "it_rtc_sca_es",       "Real Total Consumption for Italy, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAIT",      "it_trc_nsa_es",       "Real Total Consumption for Italy, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAIT",     "it_rfhc_sca_es",      "Real Household Consumption for Italy, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAIT",     "it_rfhc_nsa_es",      "Real Household Consumption for Italy, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAIT",       "it_ri_sca_es",        "Real Investment for Italy, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAIT",       "it_ri_nsa_es",        "Real Investment for Italy, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSIT",                    "it_hs_nsa_es",        "Household Savings for Italy, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BIIT",                    "it_bi_nsa_es",        "Business Investment for Italy, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAIT",     "it_govdfsu_nsa_es",   "Governement Surplus/Deficit for Italy, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUPC_GDPNSAIT",      "it_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Italy, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDEPMIO_EURIT",         "it_govde_nsa_es",     "Governement Debt for Italy, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPIT",          "it_govde_nsa_pg_es",  "Governement Debt for Italy, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "ITACPIOECD",              "it_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Italy, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Spain
  "CP00ES",                  "es_hicp_pc1_es",      "HICP, All Items for Spain, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEES",               "es_emp_es",           "Employment Rate for Spain, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEES",                "es_unemp_es",         "Unemployment Rate for Spain, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRES",                 "es_hp_pc1_es",        "Housing Prices Index for Spain, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAES",    "es_rgdp_pc1_es",      "Real Gross Domestic Product for Spain, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAES",     "es_rgdp_sca_es",      "Real Gross Domestic Product for Spain, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAES",     "es_rgdp_nsa_es",      "Real Gross Domestic Product for Spain, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAES",     "es_rtc_pc1_es",       "Real Total Consumption for Spain, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAES",      "es_rtc_sca_es",       "Real Total Consumption for Spain, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAES",      "es_trc_nsa_es",       "Real Total Consumption for Spain, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAES",     "es_rfhc_sca_es",      "Real Household Consumption for Spain, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAES",     "es_rfhc_nsa_es",      "Real Household Consumption for Spain, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAES",       "es_ri_sca_es",        "Real Investment for Spain, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAES",       "es_ri_nsa_es",        "Real Investment for Spain, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSES",                    "es_hs_nsa_es",        "Household Savings for Spain, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BIES",                    "es_bi_nsa_es",        "Business Investment for Spain, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAES",     "es_govdfsu_nsa_es",   "Governement Surplus/Deficit for Spain, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAES",     "es_govdfsu_sca_es",   "Governement Surplus/Deficit for Spain, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAES",      "es_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Spain, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAES",      "es_govdfsu_sca_pg_es","Governement Surplus/Deficit for Spain, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURES",         "es_govde_nsa_es",     "Governement Debt for Spain, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPES",          "es_govde_nsa_pg_es",  "Governement Debt for Spain, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "ESPCPIOECD",              "es_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Spain, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Portugal
  "CP00PT",                  "pt_hicp_pc1_es",      "HICP, All Items for Portugal, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEPT",               "pt_emp_es",           "Employment Rate for Portugal, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEPT",                "pt_unemp_es",         "Unemployment Rate for Portugal, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRPT",                 "pt_hp_pc1_es",        "Housing Prices Index for Portugal, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAPT",    "pt_rgdp_pc1_es",      "Real Gross Domestic Product for Portugal, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAPT",     "pt_rgdp_sca_es",      "Real Gross Domestic Product for Portugal, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAPT",     "pt_rgdp_nsa_es",      "Real Gross Domestic Product for Portugal, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAPT",     "pt_rtc_pc1_es",       "Real Total Consumption for Portugal, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAPT",      "pt_rtc_sca_es",       "Real Total Consumption for Portugal, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAPT",      "pt_trc_nsa_es",       "Real Total Consumption for Portugal, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAPT",     "pt_rfhc_sca_es",      "Real Household Consumption for Portugal, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAPT",     "pt_rfhc_nsa_es",      "Real Household Consumption for Portugal, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAPT",       "pt_ri_sca_es",        "Real Investment for Portugal, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAPT",       "pt_ri_nsa_es",        "Real Investment for Portugal, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSPT",                    "pt_hs_nsa_es",        "Household Savings for Portugal, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BIPT",                    "pt_bi_nsa_es",        "Business Investment for Portugal, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAPT",     "pt_govdfsu_nsa_es",   "Governement Surplus/Deficit for Portugal, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAPT",     "pt_govdfsu_sca_es",   "Governement Surplus/Deficit for Portugal, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAPT",      "pt_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Portugal, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAPT",      "pt_govdfsu_sca_pg_es","Governement Surplus/Deficit for Portugal, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURPT",         "pt_govde_nsa_es",     "Governement Debt for Portugal, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPPT",          "pt_govde_nsa_pg_es",  "Governement Debt for Portugal, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "PRTCPIOECD",              "pt_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Portugal, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Austria 
  "CP00AT",                  "at_hicp_pc1_es",      "HICP, All Items for Austria, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEAT",               "at_emp_es",           "Employment Rate for Austria, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEAT",                "at_unemp_es",         "Unemployment Rate for Austria, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRAT",                 "at_hp_pc1_es",        "Housing Prices Index for Austria, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAAT",    "at_rgdp_pc1_es",      "Real Gross Domestic Product for Austria, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAAT",     "at_rgdp_sca_es",      "Real Gross Domestic Product for Austria, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAAT",     "at_rgdp_nsa_es",      "Real Gross Domestic Product for Austria, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAAT",     "at_rtc_pc1_es",       "Real Total Consumption for Austria, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAAT",      "at_rtc_sca_es",       "Real Total Consumption for Austria, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAAT",      "at_trc_nsa_es",       "Real Total Consumption for Austria, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAAT",     "at_rfhc_sca_es",      "Real Household Consumption for Austria, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAAT",     "at_rfhc_nsa_es",      "Real Household Consumption for Austria, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAAT",       "at_ri_sca_es",        "Real Investment for Austria, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAAT",       "at_ri_nsa_es",        "Real Investment for Austria, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSAT",                    "at_hs_nsa_es",        "Household Savings for Austria, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BIAT",                    "at_bi_nsa_es",        "Business Investment for Austria, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAAT",     "at_govdfsu_nsa_es",   "Governement Surplus/Deficit for Austria, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAAT",     "at_govdfsu_sca_es",   "Governement Surplus/Deficit for Austria, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAAT",      "at_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Austria, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAAT",      "at_govdfsu_sca_pg_es","Governement Surplus/Deficit for Austria, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURAT",         "at_govde_nsa_es",     "Governement Debt for Austria, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPAT",          "at_govde_nsa_pg_es",  "Governement Debt for Austria, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "AUTCPIOECD",              "at_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Austria, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Netherlands 
  "CP00NL",                  "nl_hicp_pc1_es",      "HICP, All Items for Netherlands, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATENL",               "nl_emp_es",           "Employment Rate for Netherlands, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATENL",                "nl_unemp_es",         "Unemployment Rate for Netherlands, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRNL",                 "nl_hp_pc1_es",        "Housing Prices Index for Netherlands, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCANL",    "nl_rgdp_pc1_es",      "Real Gross Domestic Product for Netherlands, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCANL",     "nl_rgdp_sca_es",      "Real Gross Domestic Product for Netherlands, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSANL",     "nl_rgdp_nsa_es",      "Real Gross Domestic Product for Netherlands, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCANL",     "nl_rtc_pc1_es",       "Real Total Consumption for Netherlands, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCANL",      "nl_rtc_sca_es",       "Real Total Consumption for Netherlands, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSANL",      "nl_trc_nsa_es",       "Real Total Consumption for Netherlands, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCANL",     "nl_rfhc_sca_es",      "Real Household Consumption for Netherlands, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSANL",     "nl_rfhc_nsa_es",      "Real Household Consumption for Netherlands, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCANL",       "nl_ri_sca_es",        "Real Investment for Netherlands, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSANL",       "nl_ri_nsa_es",        "Real Investment for Netherlands, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSNL",                    "nl_hs_nsa_es",        "Household Savings for Netherlands, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BINL",                    "nl_bi_nsa_es",        "Business Investment for Netherlands, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSANL",     "nl_govdfsu_nsa_es",   "Governement Surplus/Deficit for Netherlands, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCANL",     "nl_govdfsu_sca_es",   "Governement Surplus/Deficit for Netherlands, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSANL",      "nl_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Netherlands, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCANL",      "nl_govdfsu_sca_pg_es","Governement Surplus/Deficit for Netherlands, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURNL",         "nl_govde_nsa_es",     "Governement Debt for Netherlands, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPNL",          "nl_govde_nsa_pg_es",  "Governement Debt for Netherlands, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "NLDCPIOECD",              "nl_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Netherlands, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Denmark 
  "CP00DK",                  "dk_hicp_pc1_es",      "HICP, All Items for Denmark, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEDK",               "dk_emp_es",           "Employment Rate for Denmark, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEDK",                "dk_unemp_es",         "Unemployment Rate for Denmark, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRDK",                 "dk_hp_pc1_es",        "Housing Prices Index for Denmark, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCADK",    "dk_rgdp_pc1_es",      "Real Gross Domestic Product for Denmark, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCADK",     "dk_rgdp_sca_es",      "Real Gross Domestic Product for Denmark, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSADK",     "dk_rgdp_nsa_es",      "Real Gross Domestic Product for Denmark, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCADK",     "dk_rtc_pc1_es",       "Real Total Consumption for Denmark, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCADK",      "dk_rtc_sca_es",       "Real Total Consumption for Denmark, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSADK",      "dk_trc_nsa_es",       "Real Total Consumption for Denmark, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCADK",     "dk_rfhc_sca_es",      "Real Household Consumption for Denmark, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSADK",     "dk_rfhc_nsa_es",      "Real Household Consumption for Denmark, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCADK",       "dk_ri_sca_es",        "Real Investment for Denmark, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSADK",       "dk_ri_nsa_es",        "Real Investment for Denmark, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSDK",                    "dk_hs_nsa_es",        "Household Savings for Denmark, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BIDK",                    "dk_bi_nsa_es",        "Business Investment for Denmark, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSADK",     "dk_govdfsu_nsa_es",   "Governement Surplus/Deficit for Denmark, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCADK",     "dk_govdfsu_sca_es",   "Governement Surplus/Deficit for Denmark, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSADK",      "dk_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Denmark, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCADK",      "dk_govdfsu_sca_pg_es","Governement Surplus/Deficit for Denmark, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURDK",         "dk_govde_nsa_es",     "Governement Debt for Denmark, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPDK",          "dk_govde_nsa_pg_es",  "Governement Debt for Denmark, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",

  # Norway 
  "CP00NO",                  "no_hicp_pc1_es",      "HICP, All Items for Norway, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATENO",               "no_emp_es",           "Employment Rate for Norway, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATENO",                "no_unemp_es",         "Unemployment Rate for Norway, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRNO",                 "no_hp_pc1_es",        "Housing Prices Index for Norway, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCANO",    "no_rgdp_pc1_es",      "Real Gross Domestic Product for Norway, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCANO",     "no_rgdp_sca_es",      "Real Gross Domestic Product for Norway, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSANO",     "no_rgdp_nsa_es",      "Real Gross Domestic Product for Norway, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCANO",     "no_rtc_pc1_es",       "Real Total Consumption for Norway, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCANO",      "no_rtc_sca_es",       "Real Total Consumption for Norway, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSANO",      "no_trc_nsa_es",       "Real Total Consumption for Norway, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCANO",     "no_rfhc_sca_es",      "Real Household Consumption for Norway, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSANO",     "no_rfhc_nsa_es",      "Real Household Consumption for Norway, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCANO",       "no_ri_sca_es",        "Real Investment for Norway, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSANO",       "no_ri_nsa_es",        "Real Investment for Norway, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSNO",                    "no_hs_nsa_es",        "Household Savings for Norway, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BINO",                    "no_bi_nsa_es",        "Business Investment for Norway, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSANO",     "no_govdfsu_nsa_es",   "Governement Surplus/Deficit for Norway, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUPC_GDPNSANO",      "no_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Norway, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDEPMIO_EURNO",         "no_govde_nsa_es",     "Governement Debt for Norway, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPNO",          "no_govde_nsa_pg_es",  "Governement Debt for Norway, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "NORCPIOECD",              "no_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Norway, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Sweden 
  "CP00SE",                  "se_hicp_pc1_es",      "HICP, All Items for Sweden, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATESE",               "se_emp_es",           "Employment Rate for Sweden, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATESE",                "se_unemp_es",         "Unemployment Rate for Sweden, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRSE",                 "se_hp_pc1_es",        "Housing Prices Index for Sweden, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCASE",    "se_rgdp_pc1_es",      "Real Gross Domestic Product for Sweden, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCASE",     "se_rgdp_sca_es",      "Real Gross Domestic Product for Sweden, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSASE",     "se_rgdp_nsa_es",      "Real Gross Domestic Product for Sweden, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCASE",     "se_rtc_pc1_es",       "Real Total Consumption for Sweden, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCASE",      "se_rtc_sca_es",       "Real Total Consumption for Sweden, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSASE",      "se_trc_nsa_es",       "Real Total Consumption for Sweden, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCASE",     "se_rfhc_sca_es",      "Real Household Consumption for Sweden, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSASE",     "se_rfhc_nsa_es",      "Real Household Consumption for Sweden, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCASE",       "se_ri_sca_es",        "Real Investment for Sweden, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSASE",       "se_ri_nsa_es",        "Real Investment for Sweden, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSSE",                    "se_hs_nsa_es",        "Household Savings for Sweden, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BISE",                    "se_bi_nsa_es",        "Business Investment for Sweden, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSASE",     "se_govdfsu_nsa_es",   "Governement Surplus/Deficit for Sweden, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCASE",     "se_govdfsu_sca_es",   "Governement Surplus/Deficit for Sweden, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSASE",      "se_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Sweden, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCASE",      "se_govdfsu_sca_pg_es","Governement Surplus/Deficit for Sweden, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURSE",         "se_govde_nsa_es",     "Governement Debt for Sweden, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPSE",          "se_govde_nsa_pg_es",  "Governement Debt for Sweden, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "SWECPIOECD",              "se_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Sweden, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # Poland
  "CP00PL",                  "pl_hicp_pc1_es",      "HICP, All Items for Poland, Percent Change from Year Ago, Not Adjusted",                                                        "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATEPL",               "pl_emp_es",           "Employment Rate for Poland, Percent of Active Population, Not Adjusted",                                                        "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATEPL",                "pl_unemp_es",         "Unemployment Rate for Poland, Percent of Active Population, Not Adjusted",                                                      "eurostat", "M",         NA,      "prc",  "NA",
  "HOUPRPL",                 "pl_hp_pc1_es",        "Housing Prices Index for Poland, Percent Change from Year Ago, Not Adjusted",                                                   "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCAPL",    "pl_rgdp_pc1_es",      "Real Gross Domestic Product for Poland, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                        "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCAPL",     "pl_rgdp_sca_es",      "Real Gross Domestic Product for Poland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                      "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSAPL",     "pl_rgdp_nsa_es",      "Real Gross Domestic Product for Poland, Millions of Chained 2020 Euros, Not Adjusted",                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCAPL",     "pl_rtc_pc1_es",       "Real Total Consumption for Poland, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                             "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCAPL",      "pl_rtc_sca_es",       "Real Total Consumption for Poland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                           "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSAPL",      "pl_trc_nsa_es",       "Real Total Consumption for Poland, Millions of Chained 2020 Euros, Not Adjusted",                                               "eurostat", "Q",         NA,      "eur",  "NA",
  "RFHCCLV20_MEURSCAPL",     "pl_rfhc_sca_es",      "Real Household Consumption for Poland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "eur", "SCA",
  "RFHCCLV20_MEURNSAPL",     "pl_rfhc_nsa_es",      "Real Household Consumption for Poland, Millions of Chained 2020 Euros, Not Adjusted",                                           "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCAPL",       "pl_ri_sca_es",        "Real Investment for Poland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                                  "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSAPL",       "pl_ri_nsa_es",        "Real Investment for Poland, Millions of Chained 2020 Euros, Not Adjusted",                                                      "eurostat", "Q",         NA,      "eur",  "NA",
  "HSPL",                    "pl_hs_nsa_es",        "Household Savings for Poland, Percent, Not Adjusted",                                                                           "eurostat", "Q",         NA,      "prc",  "NA",
  "BIPL",                    "pl_bi_nsa_es",        "Business Investment for Poland, Percent, Not Adjusted",                                                                         "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUMIO_EURNSAPL",     "pl_govdfsu_nsa_es",   "Governement Surplus/Deficit for Poland, Millions Euros, Not Adjusted",                                                          "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURSCAPL",     "pl_govdfsu_sca_es",   "Governement Surplus/Deficit for Poland, Millions Euros, Seasonally and Calendar Adjusted",                                      "eurostat", "Q",         NA,      "eur", "SCA",
  "GOVDFSUPC_GDPNSAPL",      "pl_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Poland, Percentage of GDP, Not Adjusted",                                                       "eurostat", "Q",         NA,      "prc",  "NA",
  "GOVDFSUPC_GDPSCAPL",      "pl_govdfsu_sca_pg_es","Governement Surplus/Deficit for Poland, Percentage of GDP, Seasonally and Calendar Adjusted",                                   "eurostat", "Q",         NA,      "prc", "SCA",
  "GOVDEPMIO_EURPL",         "pl_govde_nsa_es",     "Governement Debt for Poland, Millions Euros, Not Adjusted",                                                                     "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDEPPC_GDPPL",          "pl_govde_nsa_pg_es",  "Governement Debt for Poland, Percentage of GDP, Not Adjusted",                                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "POLCPIOECD",              "pl_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Poland, Percent Change from Year Ago, Not Adjusted",                                  "oecd", "M",         NA,      "prc",  "NA",
  
  # United Kingdom
  "CLVMNACSCAB1GQUK",        "uk_rgdp_fd",          "Real Gross Domestic Product for United Kingdom (DISCONTINUED), Millions of Chained 2010 British Pounds, Seasonally Adjusted",      "fred", "Q",      "lin",      "gbp",  "SA",
  "CLVMNACSCAB1GQUK",        "uk_rgdp_pc1_fd",      "Real Gross Domestic Product for United Kingdom (DISCONTINUED), Percent Change from Year Ago, Seasonally Adjusted",                 "fred", "Q",      "pc1",      "prc",  "SA",
  "UKNGDP",                  "uk_gdp_fd",           "Gross Domestic Product for United Kingdom, Millions of British Pounds, Seasonally Adjusted",                                       "fred", "Q",      "lin",      "gbp",  "SA",
  "UKNGDP",                  "uk_gdp_pc1_fd",       "Gross Domestic Product for United Kingdom, Percent Change from Year Ago, Seasonally Adjusted",                                     "fred", "Q",      "pc1",      "prc",  "SA",
  "FPCPITOTLZGGBR",          "uk_inf_fd",           "Inflation, consumer prices for the United Kingdom, Percent, Not Adjusted",                                                         "fred", "A",      "lin",      "prc",  "NA",
  "GBRCPIOECD",              "uk_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for United Kingdom Percent Change from Year Ago, Not Adjusted,",                         "oecd", "M",         NA,      "prc",  "NA",
  "CPALTT01GBM657N",         "uk_cpi2_fd",          "Consumer Price Index, All Items, Total for United Kingdom, Growth rate previous period, Not Adjusted",                             "fred", "M",      "lin",      "prc",  "NA",
  
  # Switzerland 
  "CPMNACSAB1GQCH",          "ch_gdp_fd",           "Gross Domestic Product for Switzerland, Millions of Euros, Seasonally Adjusted",                                                   "fred", "Q",      "lin",      "eur",  "SA",
  "CPMNACSAB1GQCH",          "ch_gdp_pc1_fd",       "Gross Domestic Product for Switzerland, Percent Change from Year Ago, Seasonally Adjusted",                                        "fred", "Q",      "pc1",      "prc",  "SA",
  "CLVMNACSAB1GQCH",         "ch_rgdp_fd",          "Real Gross Domestic Product for Switzerland, Millions of Chained 2010 Euros, Seasonally Adjusted",                                 "fred", "Q",      "lin",      "eur",  "SA",
  "CLVMNACSAB1GQCH",         "ch_rgdp_pc1_fd",      "Real Gross Domestic Product for Switzerland, Percent Change from Year Ago, Seasonally Adjusted",                                   "fred", "Q",      "pc1",      "prc",  "SA",
  "CLVMNACSCAB1GQCH",        "ch_rgdp2_fd",         "Real Gross Domestic Product for Switzerland, Millions of Chained 2010 Euros, Seasonally Adjusted",                                 "fred", "Q",      "lin",      "eur",  "SA",
  "CLVMNACSCAB1GQCH",        "ch_rgdp2_pc1_fd",     "Real Gross Domestic Product for Switzerland, Percent Change from Year Ago, Seasonally Adjusted",                                   "fred", "Q",      "pc1",      "prc",  "NA",
  "FPCPITOTLZGCHE",          "ch_inf_fd",           "Inflation, consumer prices for Switzerland, Percent, Not Adjusted",                                                                "fred", "A",      "lin",      "prc",  "NA",
  "CP00CH",                  "ch_hicp_pc1_es",      "HICP, All Items for Switzerland, Percent Change from Year Ago, Not Adjusted",                                                  "eurostat", "M",         NA,      "prc",  "NA",
  "EMPRATECH",               "ch_emp_es",           "Employment Rate for Switzerland, Percent of Active Population, Not Adjusted",                                                  "eurostat", "Q",         NA,      "prc",  "NA",
  "UNRATECH",                "ch_unemp_es",         "Unemployment Rate for Switzerland, Percent of Active Population, Not Adjusted",                                                "eurostat", "Q",         NA,      "prc",  "NA",
  "HOUPRCH",                 "ch_hp_pc1_es",        "Housing Prices Index for Switzerland, Percent Change from Year Ago, Not Adjusted",                                             "eurostat", "Q",         NA,      "prc",  "NA",
  "RGDPCLV_PCH_ANNSCACH",    "ch_rgdp_pc1_es",      "Real Gross Domestic Product for Switzerland, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                  "eurostat", "Q",         NA,      "prc", "SCA",
  "RGDPCLV20_MEURSCACH",     "ch_rgdp_sca_es",      "Real Gross Domestic Product for Switzerland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                "eurostat", "Q",         NA,      "eur", "SCA",
  "RGDPCLV20_MEURNSACH",     "ch_rgdp_nsa_es",      "Real Gross Domestic Product for Switzerland, Millions of Chained 2020 Euros, Not Adjusted",                                    "eurostat", "Q",         NA,      "eur",  "NA",
  "RTCCLV_PCH_ANNSCACH",     "ch_rtc_pc1_es",       "Real Total Consumption for Switzerland, Percent Change from Year Ago, Seasonally and Calendar Adjusted",                       "eurostat", "Q",         NA,      "prc", "SCA",
  "RTCCLV20_MEURSCACH",      "ch_rtc_sca_es",       "Real Total Consumption for Switzerland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                     "eurostat", "Q",         NA,      "eur", "SCA",
  "RTCCLV20_MEURNSACH",      "ch_trc_nsa_es",       "Real Total Consumption for Switzerland, Millions of Chained 2020 Euros, Not Adjusted",                                         "eurostat", "Q",         NA,      "eur",  "NA",
  "RICLV20_MEURSCACH",       "ch_ri_sca_es",        "Real Investment for Switzerland, Millions of Chained 2020 Euros, Seasonally and Calendar Adjusted",                            "eurostat", "Q",         NA,      "eur", "SCA",
  "RICLV20_MEURNSACH",       "ch_ri_nsa_es",        "Real Investment for Switzerland, Millions of Chained 2020 Euros, Not Adjusted",                                                "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUMIO_EURNSACH",     "ch_govdfsu_nsa_es",   "Governement Surplus/Deficit for Switzerland, Millions Euros, Not Adjusted",                                                    "eurostat", "Q",         NA,      "eur",  "NA",
  "GOVDFSUPC_GDPNSACH",      "ch_govdfsu_nsa_pg_es","Governement Surplus/Deficit for Switzerland, Percentage of GDP, Not Adjusted",                                                 "eurostat", "Q",         NA,      "prc",  "NA",
  "CHECPIOECD",              "ch_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Switzerland, Percent Change from Year Ago, Not Adjusted",                            "oecd", "M",         NA,      "prc",  "NA",
  
  # United States 
  "GDP",                     "us_gdp_fd",             "Gross Domestic Product for US, Billions of Dollars, Annual Rate, Seasonally Adjusted",                                                        "fred", "Q",      "lin",      "usd",  "SA",
  "GDP",                     "us_gdp_pc1_fd",         "Gross Domestic Product for US, Seasonally Adjusted Annual Rate, Change from Year Ago",                                                        "fred", "Q",      "pc1",      "prc",  "SA",
  "GDPC1",                   "us_rgdp_fd",            "Real Gross Domestic Product for US, Billions of Chained 2017 Dollars, Annual Rate, Seasonally Adjusted",                                      "fred", "Q",      "lin",      "usd",  "SA",
  "GDPC1",                   "us_rgdp_pc1_fd",        "Real Gross Domestic Product for US, Seasonally Adjusted Annual Rate, Percent Change from Year Ago",                                           "fred", "Q",      "pc1",      "prc",  "SA",
  "CPIAUCSL",                "us_cpi_fd",             "Consumer Price Index for Urban Consumers, All Items for US, Index 1982-1984=100, Seasonally Adjusted",                                        "fred", "M",      "lin",      "idx",  "SA",
  "CPIAUCSL",                "us_cpi_pc1_fd",         "Consumer Price Index for Urban Consumers, All Items for US, Percent Change from Year Ago, Seasonally Adjusted",                               "fred", "M",      "pc1",      "prc",  "SA",
  "CPILFESL",                "us_ccpi_fd",            "Consumer Price Index for Urban Consumers (Core), All Items Less Food and Energy for US, Index 1982-1984=100, Seasonally Adjusted",            "fred", "M",      "lin",      "idx",  "SA",
  "CPILFESL",                "us_ccpi_pc1_fd",        "Consumer Price Index for Urban Consumers (Core), All Items Less Food and Energy for US, Percent Change from Year Ago, Seasonally Adjusted",   "fred", "M",      "pc1",      "prc",  "SA",
  "UNRATE",                  "us_unrate_fd",          "Unemployment Rate for US, Percent of Active Population, Seasonally Adjusted",                                                                 "fred", "M",      "lin",      "prc",  "SA",
  "DFF",                     "us_ffr_fd",             "Effective Federal Funds Rate, Percent, Not Adjusted",                                                                                         "fred", "D",      "lin",      "prc",  "NA",
  "EFFR",                    "us_ffrvw_fd",           "Effective Federal Funds Rate, Percent, Not Adjusted",                                                                                         "fred", "D",      "lin",      "prc",  "NA",
  "WALCL",                   "us_fed_total_asset_fd", "Total Assets of the Federal Reserve, Millions of Dollars",                                                                                    "fred", "W",      "lin",      "usd",  "NA",
  "USACPIOECD",              "us_cpi_oecd",           "Consumer Price Index (CPIs, HICPs), Total for US, Percent Change from Year Ago, Not Adjusted",                                                "oecd", "M",         NA,      "prc",  "NA",
  "PCEPI",                   "us_pce_pc1_fd",         "Personal Consumption Expenditures (PCE), Chain-type Price Index for US, Percent Change from Year Ago, Seasonally Adjusted",                   "fred", "M",      "pc1",      "prc",  "SA",
  "PAYEMS",                  "us_nfp_fd",             "Total Nonfarm for US, Thousands of Persons, Seasonally Adjusted",                                                                             "fred", "M",      "lin",      "plp",  "SA",
  "ADPWNUSNERSA",            "us_adpnfp_pc1_fd",      "Total Nonfarm Private Payroll Employment (ADP) for US, Percent Change from Year Ago, Seasonally Adjusted",                                    "fred", "W",      "pc1",      "prc",  "SA",
  "ADPWNUSNERSA",            "us_adpnfp_fd",          "Total Nonfarm Private Payroll Employment (ADP) for US, Persons, Seasonally Adjusted",                                                         "fred", "W",      "lin",      "plp",  "SA",
  "PAYEMS",                  "us_nfp_pc1_fd",         "Total Nonfarm for US, Percent Change from Year Ago, Seasonally Adjusted",                                                                     "fred", "M",      "pc1",      "prc",  "SA",
  "JTSJOL",                  "us_jtsjo_fd",           "Job Openings for US, Total Nonfarm, Level in Thousands, Seasonally Adjusted",                                                                  "fred", "M",      "lin",      "nbr",  "SA",
  "CCSA",                    "us_unemplcla_fd",       "Continued Claims (Insured Unemployment) for US, Number of Persons, Seasonally Adjusted",                                                                 "fred", "W",      "lin",      "nbr",  "SA",
  "USPCE",                   "us_pcetot_pc1_fd",      "Personal Consumption Expenditures for US, Percent Change from Year Ago, Not Adjusted",                                                        "fred", "A",      "lin",      "prc",   "NA",
  "USPCE",                   "us_pcetot_fd",          "Personal Consumption Expenditures for US, Millions of Dollars, Not Adjusted",                                                                 "fred", "A",      "lin",      "usd",   "NA",
  "GPDIC1",                  "us_rgdi_fd",            "Real Gross Private Domestic Investment for US, Billions of Chained 2017 Dollars, Seasonally Adjusted",                                        "fred", "Q",      "lin",      "usd",   "SA",
  "GPDIC1",                  "us_rgdi_pc1_fd",        "Real Gross Private Domestic Investment for US, Percent Change from Year Ago, Seasonally Adjusted",                                            "fred", "Q",      "pc1",      "prc",   "SA",
  "PNFIC1",                  "us_rpnfi_fd",           "Real Private Nonresidential Fixed Investment for US, Billions of Chained 2017 Dollars, Seasonally Adjusted",                                  "fred", "Q",      "lin",      "usd",   "SA",
  "PNFIC1",                  "us_rpnfi_pc1_fd",       "Real Private Nonresidential Fixed Investment for US, Percent Change from Year Ago, Seasonally Adjusted",                                      "fred", "Q",      "pc1",      "prc",   "SA",
  "PRFIC1",                  "us_rpfi_fd",            "Real Private Residential Fixed Investment for US, Billions of Chained 2017 Dollars, Seasonally Adjusted",                                     "fred", "Q",      "lin",      "usd",   "SA",
  "PRFIC1",                  "us_rpfi_pc1_fd",        "Real Private Residential Fixed Investment for US, Percent Change from Year Ago, Seasonally Adjusted",                                         "fred", "Q",      "pc1",      "prc",   "SA",
  "GCEC1",                   "us_rgcegi_fd",          "Real Government Consumption Expenditures and Gross Investment for US, Billions of Chained 2017 Dollars, Seasonally Adjusted",                 "fred", "Q",      "lin",      "usd",   "SA",
  "GCEC1",                   "us_rgcegi_pc1_fd",      "Real Government Consumption Expenditures and Gross Investment for US, Percent Change from Year Ago, Seasonally Adjusted",                     "fred", "Q",      "pc1",      "prc",   "SA",
  "PSAVERT",                 "us_hs_sa_fd",           "Household Savings for US, Percent of Disposable Personal Income, Seasonally Adjusted",                                                        "fred", "M",      "lin",      "prc",   "SA",
  "MTSDS133FMS",             "us_govdfsu_nsa_fd",     "Governement Surplus/Deficit for US, Billions of Dollars, Not Adjusted",                                                                       "fred", "M",      "lin",      "usd",   "NA",
  "MTSDS133FMS",             "us_govdfsu_pc1_nsa_fd", "Governement Surplus/Deficit for US, Percent Change from Year Ago, Not Adjusted",                                                              "fred", "M",      "pc1",      "prc",   "NA",
  "GFDEBTN",                 "us_govde_nsa_fd",       "Governement Debt for US, Millions of Dollars, Not Adjusted",                                                                                  "fred", "Q",      "lin",      "usd",   "NA",
  "GFDEBTN",                 "us_govde_pc1_nsa_fd",   "Governement Debt for US, Percent Change from Year Ago, Not Adjusted",                                                                         "fred", "Q",      "pc1",      "prc",   "NA",
  "USSTHPI",                 "us_hp_fd",              "Housing prices Index for US, Index 1980:Q1 = 100, Not Adjusted",                                                                              "fred", "Q",      "lin",      "usd",   "NA",
  "USSTHPI",                 "us_hp_pc1_fd",          "Housing prices Index for US, Percent Change from Year Ago, Not Adjusted",                                                                     "fred", "Q",      "pc1",      "prc",   "NA",
  "SOFR",                    "us_sofr_fd",            "Secured Overnight Financing Rate, Percent, Not Adjusted",                                                                                     "fred", "D",      "lin",      "prc",   "NA",
  "SOFR30DAYAVG",            "us_sofr30_fd",          "30-Day Average Secured Overnight Financing Rate, Percent, Not Adjusted",                                                                      "fred", "D",      "lin",      "prc",   "NA",
  "SOFR90DAYAVG",            "us_sofr90_fd",          "90-Day Average Secured Overnight Financing Rate, Percent, Not Adjusted",                                                                      "fred", "D",      "lin",      "prc",   "NA",
  "T10YIE",                  "us_10ybrk_inf_fd",      "10-Year Breakeven Inflation Rate for US, Percent, Not Adjusted",                                                                              "fred", "D",      "lin",      "prc",   "NA",
  "T5YIE",                   "us_5ybrk_inf_fd",       "5-Year Breakeven Inflation Rate for US, Percent, Not Adjusted",                                                                               "fred", "D",      "lin",      "prc",   "NA",
  "M2SL",                    "us_m2_m_fd",            "M2 for US, Billions of Dollars, Seasonally Adjusted",                                                                                         "fred", "M",      "lin",      "usd",   "SA",
  "WM2NS",                   "us_m2_w_fd",            "M2 for US, Billions of Dollars, Seasonally Adjusted",                                                                                         "fred", "W",      "lin",      "usd",   "NA",
  "DGS1",                    "us_dgs1_fd",            "Market Yield on US Treasury Securities at 1-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS2",                    "us_dgs2_fd",            "Market Yield on US Treasury Securities at 2-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS3",                    "us_dgs3_fd",            "Market Yield on US Treasury Securities at 3-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS5",                    "us_dgs5_fd",            "Market Yield on US Treasury Securities at 5-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS7",                    "us_dgs7_fd",            "Market Yield on US Treasury Securities at 7-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS10",                   "us_dgs10_fd",           "Market Yield on US Treasury Securities at 10-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS20",                   "us_dgs20_fd",           "Market Yield on US Treasury Securities at 20-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DGS30",                   "us_dgs30_fd",           "Market Yield on US Treasury Securities at 30-Year Constant Maturity, Quoted on an Investment Basis, Percent, Not Adjusted",                   "fred", "D",      "lin",      "prc",   "NA",
  "DFII30",                  "us_dfii30_fd",          "Market Yield on US Treasury Securities at 30-Year Constant Maturity, Quoted on an Investment Basis, Inflation-Indexed Percent, Not Adjusted", "fred", "D",      "lin",      "prc",   "NA",
  "DFII10",                  "us_dfii10_fd",          "Market Yield on US Treasury Securities at 10-Year Constant Maturity, Quoted on an Investment Basis, Inflation-Indexed Percent, Not Adjusted", "fred", "D",      "lin",      "prc",   "NA",
  "DFII5",                   "us_dfii5_fd",           "Market Yield on US Treasury Securities at 5-Year Constant Maturity, Quoted on an Investment Basis, Inflation-Indexed Percent, Not Adjusted",  "fred", "D",      "lin",      "prc",   "NA",
  
  # Japan 
  "JPNNGDP",                 "jp_gdp_fd",           "Gross Domestic Product for Japan, Billions of Yen, Not Adjusted",                                                                 "fred", "Q",      "lin",       "jpy",  "NA",
  "JPNNGDP",                 "jp_gdp_pc1_fd",       "Gross Domestic Product for Japan, Percent Change from Year Ago, Not Adjusted",                                                    "fred", "Q",      "pc1",       "prc",  "NA",
  "JPNRGDPEXP",              "jp_rgdp_fd",          "Real Gross Domestic Product for Japan, Billions of Chained 2015 Yen, Seasonally Adjusted",                                        "fred", "Q",      "lin",       "jpy",  "SA",
  "JPNRGDPEXP",              "jp_rgdp_pc1_fd",      "Real Gross Domestic Product for Japan, Percent Change from Year Ago, Seasonally Adjusted",                                        "fred", "Q",      "pc1",       "prc",  "SA",
  "JPNCPIOECD",              "jp_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Japan, Percent Change from Year Ago, Not Adjusted",                                 "oecd", "M",         NA,       "prc",  "NA",
  
  # China 
  "MKTGDPCNA646NWDB",        "cn_gdp_fd",           "Gross Domestic Product for China, Current United States Dollars, Not Adjusted",                                                   "fred", "A",     "lin",       "usd",  "NA",
  "MKTGDPCNA646NWDB",        "cn_gdp_pc1_fd",       "Gross Domestic Product for China, Percent Change from Year Ago, Not Adjusted",                                                    "fred", "A",     "pc1",       "prc",  "NA",
  "NGDPRXDCCNA",             "cn_rgdp_fd",          "Real Gross Domestic Product for China, Millions of Domestic Currency, Seasonally Adjusted",                                       "fred", "Q",     "lin",       "cny",  "SA",
  "NGDPRXDCCNA",             "cn_rgdp_pc1_fd",      "Real Gross Domestic Product for China, Percent Change from Year Ago, Seasonally Adjusted",                                        "fred", "Q",     "pc1",       "prc",  "SA",
  "CHNCPIOECD",              "cn_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for China, Percent Change from Year Ago, Not Adjusted,",                                "oecd", "M",        NA,       "prc",  "NA",
  
  # India
  "MKTGDPINA646NWDB",        "in_gdp_fd",           "Gross Domestic Product for India, Current US Dollars, Not Adjusted",                                                              "fred", "A",     "lin",       "usd",  "NA",
  "MKTGDPINA646NWDB",        "in_gdp_pc1_fd",       "Gross Domestic Product for India, Percent Change from Year Ago, Not Adjusted",                                                    "fred", "A",     "pc1",       "prc",  "NA",
  "NGDPRNSAXDCINQ",          "in_rgdp_fd",          "Real Gross Domestic Product for India, Millions of Domestic Currency, Seasonally Adjusted",                                       "fred", "Q",     "lin",       "inr",  "SA",
  "NGDPRNSAXDCINQ",          "in_rgdp_pc1_fd",      "Real Gross Domestic Product for India, Millions of Domestic Currency, Percent Change from Year Ago, Seasonally Adjusted",         "fred", "Q",     "pc1",       "prc",  "SA",
  "INDCPIOECD",              "in_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for India, Percent Change from Year Ago, Not Adjusted,",                                "oecd", "M",        NA,       "prc",  "NA",
  
  # Brazil
  "NGDPRSAXDCBRQ",           "br_rgdp_fd",          "Real Gross Domestic Product for Brazil, Millions of Domestic Currency, Seasonally Adjusted",                                     "fred", "Q",     "lin",        "brl",  "SA",
  "NGDPRSAXDCBRQ",           "br_rgdp_pc1_fd",      "Real Gross Domestic Product for Brazil, Percent Change from Year Ago, Seasonally Adjusted",                                      "fred", "Q",     "pc1",        "prc",  "SA",
  "NGDPSAXDCBRQ",            "br_gdp_fd",           "Gross Domestic Product for Brazil, Millions of Domestic Currency, Seasonally Adjusted",                                          "fred", "Q",     "lin",        "brl",  "SA",
  "NGDPSAXDCBRQ",            "br_gdp_pc1_fd",       "Gross Domestic Product for Brazil,Percent Change from Year Ago, Seasonally Adjusted",                                            "fred", "Q",     "pc1",        "prc",  "SA",
  "BRACPIOECD",              "br_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Brazil, Percent Change from Year Ago, Not Adjusted,",                              "oecd", "M",        NA,        "prc",  "NA",
  
  # Canada
  "NGDPRSAXDCCAQ",           "ca_rgdp_fd",          "Real Gross Domestic Product for Canada, Millions of Domestic Currency, Seasonally Adjusted",                                     "fred", "Q",     "lin",        "cad",  "SA",
  "NGDPRSAXDCCAQ",           "ca_rgdp_pc1_fd",      "Real Gross Domestic Product for Canada, Percent Change from Year Ago, Seasonally Adjusted",                                      "fred", "Q",     "pc1",        "prc",  "SA",
  "MKTGDPCNA646NWDB",        "ca_gdp_fd",           "Gross Domestic Product for Canada, Current US Dollars, Not Adjusted",                                                            "fred", "A",     "lin",        "usd",  "NA",
  "MKTGDPCNA646NWDB",        "ca_gdp_pc1_fd",       "Gross Domestic Product for Canada, Percent Change from Year Ago, Not Adjusted",                                                  "fred", "A",     "pc1",        "prc",  "NA",
  "CANCPIOECD",              "ca_cpi_oecd",         "Consumer Price Index (CPIs, HICPs), Total for Canada, Percent Change from Year Ago, Not Adjusted,",                              "oecd", "M",        NA,        "prc",  "NA",
  
  # ============================== GEOPOLTICS  =================================
  
  # Policy Uncertainty Index
  "EPUUSM",                 "us_epu",               "Economic Policy Uncertainty for US",                                         "epu",    "M",         NA,          "idx",   "NA",
  "GEPU_PPPM",              "global_epu_ppp",       "Economic Policy Uncertainty for Global, PPP-Weighted",                       "epu",    "M",         NA,          "idx",   "NA",
  "GEPU_CURRENTM",          "global_epu",           "Economic Policy Uncertainty for Global, Current GDP-Weighted",               "epu",    "M",         NA,          "idx",   "NA",
  "EPUCANM",                "ca_epu",               "Economic Policy Uncertainty for Canada",                                     "epu",    "M",         NA,          "idx",   "NA",
  "EPUUKM",                 "uk_epu",               "Economic Policy Uncertainty for United Kingdom",                             "epu",    "M",         NA,          "idx",   "NA",
  "EPUDEM",                 "de_epu",               "Economic Policy Uncertainty for Germany",                                    "epu",    "M",         NA,          "idx",   "NA",
  "EPUFRM",                 "fr_epu",               "Economic Policy Uncertainty for France",                                     "epu",    "M",         NA,          "idx",   "NA",
  "EPUEUM",                 "eu_epu",               "Economic Policy Uncertainty for Europe",                                     "epu",    "M",         NA,          "idx",   "NA",
  "EPUESM",                 "es_epu",               "Economic Policy Uncertainty for Spain",                                      "epu",    "M",         NA,          "idx",   "NA",
  "EPUITM",                 "it_epu",               "Economic Policy Uncertainty for Italy",                                      "epu",    "M",         NA,          "idx",   "NA",

  # Geopolitical Risk Index
  "GPRD",                   "gpr",                 "Geopolitical Risk Index, Daily",                                              "gpr",     "D",        NA,          "idx",   "NA",
  "GPRD_ACT",               "gpr_act",             "Geopolitical Risk Index Acts, Daily",                                         "gpr",     "D",        NA,          "idx",   "NA",
  "GPRD_THREAT",            "gpr_threat",          "Geopolitical Risk Index Threats, Daily",                                      "gpr",     "D",        NA,          "idx",   "NA",
  "GPRD_MA30",              "gpr_ma30",            "Geopolitical Risk Index, 30 day moving average, Daily",                       "gpr",     "D",        NA,          "idx",   "NA",
  "GPRD_MA7",               "gpr_ma7",             "Geopolitical Risk Index, 7 day moving average, Daily",                        "gpr",     "D",        NA,          "idx",   "NA",  
  
  # ================================ ECB =======================================
  
  # AAA-rated government bonds — Spot rates (zero-coupon) = yield of a hypothetical zero-coupon AAA sovereign bond for the given residual maturity
  "ECB_YC_AAA_SR_3M",   "ea_yc_aaa_sr_3m",   "Euro Area AAA Yield Curve, Spot Rate 3-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_4M",   "ea_yc_aaa_sr_4m",   "Euro Area AAA Yield Curve, Spot Rate 4-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_5M",   "ea_yc_aaa_sr_5m",   "Euro Area AAA Yield Curve, Spot Rate 5-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_6M",   "ea_yc_aaa_sr_6m",   "Euro Area AAA Yield Curve, Spot Rate 6-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_7M",   "ea_yc_aaa_sr_7m",   "Euro Area AAA Yield Curve, Spot Rate 7-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_8M",   "ea_yc_aaa_sr_8m",   "Euro Area AAA Yield Curve, Spot Rate 8-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_9M",   "ea_yc_aaa_sr_9m",   "Euro Area AAA Yield Curve, Spot Rate 9-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_10M",  "ea_yc_aaa_sr_10m",  "Euro Area AAA Yield Curve, Spot Rate 10-Month, Percent, Not Adjusted",   "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_11M",  "ea_yc_aaa_sr_11m",  "Euro Area AAA Yield Curve, Spot Rate 11-Month, Percent, Not Adjusted",   "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_1Y",   "ea_yc_aaa_sr_1y",   "Euro Area AAA Yield Curve, Spot Rate 1-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_2Y",   "ea_yc_aaa_sr_2y",   "Euro Area AAA Yield Curve, Spot Rate 2-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_3Y",   "ea_yc_aaa_sr_3y",   "Euro Area AAA Yield Curve, Spot Rate 3-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_4Y",   "ea_yc_aaa_sr_4y",   "Euro Area AAA Yield Curve, Spot Rate 4-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_5Y",   "ea_yc_aaa_sr_5y",   "Euro Area AAA Yield Curve, Spot Rate 5-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_6Y",   "ea_yc_aaa_sr_6y",   "Euro Area AAA Yield Curve, Spot Rate 6-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_7Y",   "ea_yc_aaa_sr_7y",   "Euro Area AAA Yield Curve, Spot Rate 7-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_8Y",   "ea_yc_aaa_sr_8y",   "Euro Area AAA Yield Curve, Spot Rate 8-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_9Y",   "ea_yc_aaa_sr_9y",   "Euro Area AAA Yield Curve, Spot Rate 9-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_10Y",  "ea_yc_aaa_sr_10y",  "Euro Area AAA Yield Curve, Spot Rate 10-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_11Y",  "ea_yc_aaa_sr_11y",  "Euro Area AAA Yield Curve, Spot Rate 11-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_12Y",  "ea_yc_aaa_sr_12y",  "Euro Area AAA Yield Curve, Spot Rate 12-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_13Y",  "ea_yc_aaa_sr_13y",  "Euro Area AAA Yield Curve, Spot Rate 13-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_14Y",  "ea_yc_aaa_sr_14y",  "Euro Area AAA Yield Curve, Spot Rate 14-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_15Y",  "ea_yc_aaa_sr_15y",  "Euro Area AAA Yield Curve, Spot Rate 15-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_16Y",  "ea_yc_aaa_sr_16y",  "Euro Area AAA Yield Curve, Spot Rate 16-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_17Y",  "ea_yc_aaa_sr_17y",  "Euro Area AAA Yield Curve, Spot Rate 17-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_18Y",  "ea_yc_aaa_sr_18y",  "Euro Area AAA Yield Curve, Spot Rate 18-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_19Y",  "ea_yc_aaa_sr_19y",  "Euro Area AAA Yield Curve, Spot Rate 19-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_20Y",  "ea_yc_aaa_sr_20y",  "Euro Area AAA Yield Curve, Spot Rate 20-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_21Y",  "ea_yc_aaa_sr_21y",  "Euro Area AAA Yield Curve, Spot Rate 21-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_22Y",  "ea_yc_aaa_sr_22y",  "Euro Area AAA Yield Curve, Spot Rate 22-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_23Y",  "ea_yc_aaa_sr_23y",  "Euro Area AAA Yield Curve, Spot Rate 23-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_24Y",  "ea_yc_aaa_sr_24y",  "Euro Area AAA Yield Curve, Spot Rate 24-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_25Y",  "ea_yc_aaa_sr_25y",  "Euro Area AAA Yield Curve, Spot Rate 25-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_26Y",  "ea_yc_aaa_sr_26y",  "Euro Area AAA Yield Curve, Spot Rate 26-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_27Y",  "ea_yc_aaa_sr_27y",  "Euro Area AAA Yield Curve, Spot Rate 27-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_28Y",  "ea_yc_aaa_sr_28y",  "Euro Area AAA Yield Curve, Spot Rate 28-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_29Y",  "ea_yc_aaa_sr_29y",  "Euro Area AAA Yield Curve, Spot Rate 29-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_SR_30Y",  "ea_yc_aaa_sr_30y",  "Euro Area AAA Yield Curve, Spot Rate 30-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  
  # AAA-rated government bonds — Instantaneous forward rates = short-term rate implied by the spot curve for a future date
  "ECB_YC_AAA_IF_3M",   "ea_yc_aaa_if_3m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 3-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_4M",   "ea_yc_aaa_if_4m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 4-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_5M",   "ea_yc_aaa_if_5m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 5-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_6M",   "ea_yc_aaa_if_6m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 6-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_7M",   "ea_yc_aaa_if_7m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 7-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_8M",   "ea_yc_aaa_if_8m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 8-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_9M",   "ea_yc_aaa_if_9m",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 9-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_10M",  "ea_yc_aaa_if_10m",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 10-Month, Percent, Not Adjusted",   "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_11M",  "ea_yc_aaa_if_11m",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 11-Month, Percent, Not Adjusted",   "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_1Y",   "ea_yc_aaa_if_1y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 1-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_2Y",   "ea_yc_aaa_if_2y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 2-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_3Y",   "ea_yc_aaa_if_3y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 3-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_4Y",   "ea_yc_aaa_if_4y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 4-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_5Y",   "ea_yc_aaa_if_5y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 5-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_6Y",   "ea_yc_aaa_if_6y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 6-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_7Y",   "ea_yc_aaa_if_7y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 7-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_8Y",   "ea_yc_aaa_if_8y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 8-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_9Y",   "ea_yc_aaa_if_9y",   "Euro Area AAA Yield Curve, Instantaneous Forward Rate 9-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_10Y",  "ea_yc_aaa_if_10y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 10-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_11Y",  "ea_yc_aaa_if_11y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 11-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_12Y",  "ea_yc_aaa_if_12y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 12-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_13Y",  "ea_yc_aaa_if_13y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 13-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_14Y",  "ea_yc_aaa_if_14y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 14-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_15Y",  "ea_yc_aaa_if_15y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 15-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_16Y",  "ea_yc_aaa_if_16y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 16-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_17Y",  "ea_yc_aaa_if_17y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 17-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_18Y",  "ea_yc_aaa_if_18y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 18-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_19Y",  "ea_yc_aaa_if_19y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 19-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_20Y",  "ea_yc_aaa_if_20y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 20-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_21Y",  "ea_yc_aaa_if_21y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 21-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_22Y",  "ea_yc_aaa_if_22y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 22-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_23Y",  "ea_yc_aaa_if_23y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 23-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_24Y",  "ea_yc_aaa_if_24y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 24-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_25Y",  "ea_yc_aaa_if_25y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 25-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_26Y",  "ea_yc_aaa_if_26y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 26-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_27Y",  "ea_yc_aaa_if_27y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 27-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_28Y",  "ea_yc_aaa_if_28y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 28-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_29Y",  "ea_yc_aaa_if_29y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 29-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_AAA_IF_30Y",  "ea_yc_aaa_if_30y",  "Euro Area AAA Yield Curve, Instantaneous Forward Rate 30-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  
  # All euro area government bonds — Spot rates
  "ECB_YC_ALL_SR_3M",   "ea_yc_all_sr_3m",   "Euro Area All-Issuers Yield Curve, Spot Rate 3-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_4M",   "ea_yc_all_sr_4m",   "Euro Area All-Issuers Yield Curve, Spot Rate 4-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_5M",   "ea_yc_all_sr_5m",   "Euro Area All-Issuers Yield Curve, Spot Rate 5-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_6M",   "ea_yc_all_sr_6m",   "Euro Area All-Issuers Yield Curve, Spot Rate 6-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_7M",   "ea_yc_all_sr_7m",   "Euro Area All-Issuers Yield Curve, Spot Rate 7-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_8M",   "ea_yc_all_sr_8m",   "Euro Area All-Issuers Yield Curve, Spot Rate 8-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_9M",   "ea_yc_all_sr_9m",   "Euro Area All-Issuers Yield Curve, Spot Rate 9-Month, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_10M",  "ea_yc_all_sr_10m",  "Euro Area All-Issuers Yield Curve, Spot Rate 10-Month, Percent, Not Adjusted",            "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_11M",  "ea_yc_all_sr_11m",  "Euro Area All-Issuers Yield Curve, Spot Rate 11-Month, Percent, Not Adjusted",            "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_1Y",   "ea_yc_all_sr_1y",   "Euro Area All-Issuers Yield Curve, Spot Rate 1-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_2Y",   "ea_yc_all_sr_2y",   "Euro Area All-Issuers Yield Curve, Spot Rate 2-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_3Y",   "ea_yc_all_sr_3y",   "Euro Area All-Issuers Yield Curve, Spot Rate 3-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_4Y",   "ea_yc_all_sr_4y",   "Euro Area All-Issuers Yield Curve, Spot Rate 4-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_5Y",   "ea_yc_all_sr_5y",   "Euro Area All-Issuers Yield Curve, Spot Rate 5-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_6Y",   "ea_yc_all_sr_6y",   "Euro Area All-Issuers Yield Curve, Spot Rate 6-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_7Y",   "ea_yc_all_sr_7y",   "Euro Area All-Issuers Yield Curve, Spot Rate 7-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_8Y",   "ea_yc_all_sr_8y",   "Euro Area All-Issuers Yield Curve, Spot Rate 8-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_9Y",   "ea_yc_all_sr_9y",   "Euro Area All-Issuers Yield Curve, Spot Rate 9-Year, Percent, Not Adjusted",              "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_10Y",  "ea_yc_all_sr_10y",  "Euro Area All-Issuers Yield Curve, Spot Rate 10-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_11Y",  "ea_yc_all_sr_11y",  "Euro Area All-Issuers Yield Curve, Spot Rate 11-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_12Y",  "ea_yc_all_sr_12y",  "Euro Area All-Issuers Yield Curve, Spot Rate 12-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_13Y",  "ea_yc_all_sr_13y",  "Euro Area All-Issuers Yield Curve, Spot Rate 13-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_14Y",  "ea_yc_all_sr_14y",  "Euro Area All-Issuers Yield Curve, Spot Rate 14-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_15Y",  "ea_yc_all_sr_15y",  "Euro Area All-Issuers Yield Curve, Spot Rate 15-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_16Y",  "ea_yc_all_sr_16y",  "Euro Area All-Issuers Yield Curve, Spot Rate 16-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_17Y",  "ea_yc_all_sr_17y",  "Euro Area All-Issuers Yield Curve, Spot Rate 17-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_18Y",  "ea_yc_all_sr_18y",  "Euro Area All-Issuers Yield Curve, Spot Rate 18-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_19Y",  "ea_yc_all_sr_19y",  "Euro Area All-Issuers Yield Curve, Spot Rate 19-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_20Y",  "ea_yc_all_sr_20y",  "Euro Area All-Issuers Yield Curve, Spot Rate 20-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_21Y",  "ea_yc_all_sr_21y",  "Euro Area All-Issuers Yield Curve, Spot Rate 21-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_22Y",  "ea_yc_all_sr_22y",  "Euro Area All-Issuers Yield Curve, Spot Rate 22-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_23Y",  "ea_yc_all_sr_23y",  "Euro Area All-Issuers Yield Curve, Spot Rate 23-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_24Y",  "ea_yc_all_sr_24y",  "Euro Area All-Issuers Yield Curve, Spot Rate 24-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_25Y",  "ea_yc_all_sr_25y",  "Euro Area All-Issuers Yield Curve, Spot Rate 25-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_26Y",  "ea_yc_all_sr_26y",  "Euro Area All-Issuers Yield Curve, Spot Rate 26-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_27Y",  "ea_yc_all_sr_27y",  "Euro Area All-Issuers Yield Curve, Spot Rate 27-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_28Y",  "ea_yc_all_sr_28y",  "Euro Area All-Issuers Yield Curve, Spot Rate 28-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_29Y",  "ea_yc_all_sr_29y",  "Euro Area All-Issuers Yield Curve, Spot Rate 29-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_SR_30Y",  "ea_yc_all_sr_30y",  "Euro Area All-Issuers Yield Curve, Spot Rate 30-Year, Percent, Not Adjusted",             "ecb",  "D",  NA,  "prc",  "NA",
  
  # All euro area government bonds — Instantaneous forward rates = short-term rate implied by the spot curve for a future date
  "ECB_YC_ALL_IF_3M",   "ea_yc_all_if_3m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 3-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_4M",   "ea_yc_all_if_4m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 4-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_5M",   "ea_yc_all_if_5m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 5-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_6M",   "ea_yc_all_if_6m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 6-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_7M",   "ea_yc_all_if_7m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 7-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_8M",   "ea_yc_all_if_8m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 8-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_9M",   "ea_yc_all_if_9m",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 9-Month, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_10M",  "ea_yc_all_if_10m",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 10-Month, Percent, Not Adjusted",   "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_11M",  "ea_yc_all_if_11m",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 11-Month, Percent, Not Adjusted",   "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_1Y",   "ea_yc_all_if_1y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 1-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_2Y",   "ea_yc_all_if_2y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 2-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_3Y",   "ea_yc_all_if_3y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 3-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_4Y",   "ea_yc_all_if_4y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 4-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_5Y",   "ea_yc_all_if_5y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 5-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_6Y",   "ea_yc_all_if_6y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 6-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_7Y",   "ea_yc_all_if_7y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 7-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_8Y",   "ea_yc_all_if_8y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 8-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_9Y",   "ea_yc_all_if_9y",   "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 9-Year, Percent, Not Adjusted",     "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_10Y",  "ea_yc_all_if_10y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 10-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_11Y",  "ea_yc_all_if_11y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 11-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_12Y",  "ea_yc_all_if_12y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 12-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_13Y",  "ea_yc_all_if_13y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 13-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_14Y",  "ea_yc_all_if_14y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 14-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_15Y",  "ea_yc_all_if_15y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 15-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_16Y",  "ea_yc_all_if_16y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 16-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_17Y",  "ea_yc_all_if_17y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 17-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_18Y",  "ea_yc_all_if_18y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 18-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_19Y",  "ea_yc_all_if_19y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 19-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_20Y",  "ea_yc_all_if_20y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 20-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_21Y",  "ea_yc_all_if_21y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 21-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_22Y",  "ea_yc_all_if_22y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 22-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_23Y",  "ea_yc_all_if_23y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 23-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_24Y",  "ea_yc_all_if_24y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 24-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_25Y",  "ea_yc_all_if_25y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 25-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_26Y",  "ea_yc_all_if_26y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 26-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_27Y",  "ea_yc_all_if_27y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 27-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_28Y",  "ea_yc_all_if_28y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 28-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_29Y",  "ea_yc_all_if_29y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 29-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  "ECB_YC_ALL_IF_30Y",  "ea_yc_all_if_30y",  "Euro Area All-Issuers Yield Curve, Instantaneous Forward Rate 30-Year, Percent, Not Adjusted",    "ecb",  "D",  NA,  "prc",  "NA",
  
  # ================================ IMF =======================================
  
  # Gold Reserves at Market Value 
  "RGOLDMV_REVSUSA",  "us_gold_mv_res_imf",   "Gold Reserves at Market Value for US, SDR (International Unit of Account)",              "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSDEU",  "de_gold_mv_res_imf",   "Gold Reserves at Market Value for Germany, SDR (International Unit of Account)",         "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSITA",  "it_gold_mv_res_imf",   "Gold Reserves at Market Value for Italy, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSFRA",  "fr_gold_mv_res_imf",   "Gold Reserves at Market Value for France, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSRUS",  "ru_gold_mv_res_imf",   "Gold Reserves at Market Value for Russia, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSCHN",  "cn_gold_mv_res_imf",   "Gold Reserves at Market Value for China, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSCHE",  "ch_gold_mv_res_imf",   "Gold Reserves at Market Value for Switzerland, SDR (International Unit of Account)",     "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSJPN",  "jp_gold_mv_res_imf",   "Gold Reserves at Market Value for Japan, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSIND",  "in_gold_mv_res_imf",   "Gold Reserves at Market Value for India, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSNLD",  "nl_gold_mv_res_imf",   "Gold Reserves at Market Value for Netherlands, SDR (International Unit of Account)",     "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSTUR",  "tr_gold_mv_res_imf",   "Gold Reserves at Market Value for Turkey, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSPOL",  "pl_gold_mv_res_imf",   "Gold Reserves at Market Value for Poland, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSGBR",  "gb_gold_mv_res_imf",   "Gold Reserves at Market Value for United Kingdom, SDR (International Unit of Account)",  "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSESP",  "es_gold_mv_res_imf",   "Gold Reserves at Market Value for Spain, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSAUT",  "at_gold_mv_res_imf",   "Gold Reserves at Market Value for Austria, SDR (International Unit of Account)",         "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSBEL",  "be_gold_mv_res_imf",   "Gold Reserves at Market Value for Belgium, SDR (International Unit of Account)",         "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSSAU",  "sa_gold_mv_res_imf",   "Gold Reserves at Market Value for Saudi Arabia, SDR (International Unit of Account)",    "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSKAZ",  "kz_gold_mv_res_imf",   "Gold Reserves at Market Value for Kazakhstan, SDR (International Unit of Account)",      "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSTHA",  "th_gold_mv_res_imf",   "Gold Reserves at Market Value for Thailand, SDR (International Unit of Account)",        "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSSGP",  "sg_gold_mv_res_imf",   "Gold Reserves at Market Value for Singapore, SDR (International Unit of Account)",       "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSAUS",  "au_gold_mv_res_imf",   "Gold Reserves at Market Value for Australia, SDR (International Unit of Account)",       "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSSWE",  "se_gold_mv_res_imf",   "Gold Reserves at Market Value for Sweden, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSMEX",  "mx_gold_mv_res_imf",   "Gold Reserves at Market Value for Mexico, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSBRA",  "br_gold_mv_res_imf",   "Gold Reserves at Market Value for Brazil, SDR (International Unit of Account)",          "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSPHL",  "ph_gold_mv_res_imf",   "Gold Reserves at Market Value for Philippines, SDR (International Unit of Account)",     "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSEGY",  "eg_gold_mv_res_imf",   "Gold Reserves at Market Value for Egypt, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSQAT",  "qa_gold_mv_res_imf",   "Gold Reserves at Market Value for Qatar, SDR (International Unit of Account)",           "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSIRQ",  "iq_gold_mv_res_imf",   "Gold Reserves at Market Value for Iraq, SDR (International Unit of Account)",            "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSHUN",  "hu_gold_mv_res_imf",   "Gold Reserves at Market Value for Hungary, SDR (International Unit of Account)",         "imf",   "M",        NA,         "sdr",  "NA",
  "RGOLDMV_REVSARE",  "ae_gold_mv_res_imf",   "Gold Reserves at Market Value for UAE, SDR (International Unit of Account)",             "imf",   "M",        NA,         "sdr",  "NA",
    
  # Gold Reserves Volume
  "RGV_REVSUSA",      "us_gold_vol_res_imf",  "Gold Reserves Volume for US, Fine Troy Ounces",                                          "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSDEU",      "de_gold_vol_res_imf",  "Gold Reserves Volume for Germany, Fine Troy Ounces",                                     "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSITA",      "it_gold_vol_res_imf",  "Gold Reserves Volume for Italy, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSFRA",      "fr_gold_vol_res_imf",  "Gold Reserves Volume for France, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSRUS",      "ru_gold_vol_res_imf",  "Gold Reserves Volume for Russia, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSCHN",      "cn_gold_vol_res_imf",  "Gold Reserves Volume for China, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSCHE",      "ch_gold_vol_res_imf",  "Gold Reserves Volume for Switzerland, Fine Troy Ounces",                                 "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSJPN",      "jp_gold_vol_res_imf",  "Gold Reserves Volume for Japan, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSIND",      "in_gold_vol_res_imf",  "Gold Reserves Volume for India, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSNLD",      "nl_gold_vol_res_imf",  "Gold Reserves Volume for Netherlands, Fine Troy Ounces",                                 "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSTUR",      "tr_gold_vol_res_imf",  "Gold Reserves Volume for Turkey, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSPOL",      "pl_gold_vol_res_imf",  "Gold Reserves Volume for Poland, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSGBR",      "gb_gold_vol_res_imf",  "Gold Reserves Volume for United Kingdom, Fine Troy Ounces",                              "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSESP",      "es_gold_vol_res_imf",  "Gold Reserves Volume for Spain, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSAUT",      "at_gold_vol_res_imf",  "Gold Reserves Volume for Austria, Fine Troy Ounces",                                     "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSBEL",      "be_gold_vol_res_imf",  "Gold Reserves Volume for Belgium, Fine Troy Ounces",                                     "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSSAU",      "sa_gold_vol_res_imf",  "Gold Reserves Volume for Saudi Arabia, Fine Troy Ounces",                                "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSKAZ",      "kz_gold_vol_res_imf",  "Gold Reserves Volume for Kazakhstan, Fine Troy Ounces",                                  "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSTHA",      "th_gold_vol_res_imf",  "Gold Reserves Volume for Thailand, Fine Troy Ounces",                                    "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSSGP",      "sg_gold_vol_res_imf",  "Gold Reserves Volume for Singapore, Fine Troy Ounces",                                   "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSAUS",      "au_gold_vol_res_imf",  "Gold Reserves Volume for Australia, Fine Troy Ounces",                                   "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSSWE",      "se_gold_vol_res_imf",  "Gold Reserves Volume for Sweden, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSMEX",      "mx_gold_vol_res_imf",  "Gold Reserves Volume for Mexico, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSBRA",      "br_gold_vol_res_imf",  "Gold Reserves Volume for Brazil, Fine Troy Ounces",                                      "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSPHL",      "ph_gold_vol_res_imf",  "Gold Reserves Volume for Philippines, Fine Troy Ounces",                                 "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSEGY",      "eg_gold_vol_res_imf",  "Gold Reserves Volume for Egypt, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSQAT",      "qa_gold_vol_res_imf",  "Gold Reserves Volume for Qatar, Fine Troy Ounces",                                       "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSIRQ",      "iq_gold_vol_res_imf",  "Gold Reserves Volume for Iraq, Fine Troy Ounces",                                        "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSHUN",      "hu_gold_vol_res_imf",  "Gold Reserves Volume for Hungary, Fine Troy Ounces",                                     "imf",   "M",        NA,         "toz",  "NA",
  "RGV_REVSARE",      "ae_gold_vol_res_imf",  "Gold Reserves Volume for UAE, Fine Troy Ounces",                                         "imf",   "M",        NA,         "toz",  "NA",
  
  # Broad Money - M2
  "DCORP_L_BMUSA",  "us_m2_imf",  "M2 Broad Money for US, National Currency",            "imf",  "M",  NA,  "usd",  "NA",
  "DCORP_L_BMRUS",  "ru_m2_imf",  "M2 Broad Money for Russia, National Currency",        "imf",  "M",  NA,  "rub",  "NA",
  "DCORP_L_BMJPN",  "jp_m2_imf",  "M2 Broad Money for Japan, National Currency",         "imf",  "M",  NA,  "jpy",  "NA",
  "DCORP_L_BMIND",  "in_m2_imf",  "M2 Broad Money for India, National Currency",         "imf",  "M",  NA,  "inr",  "NA",
  "DCORP_L_BMTUR",  "tr_m2_imf",  "M2 Broad Money for Turkey, National Currency",        "imf",  "M",  NA,  "try",  "NA",
  "DCORP_L_BMPOL",  "pl_m2_imf",  "M2 Broad Money for Poland, National Currency",        "imf",  "M",  NA,  "pln",  "NA",
  "DCORP_L_BMKAZ",  "kz_m2_imf",  "M2 Broad Money for Kazakhstan, National Currency",    "imf",  "M",  NA,  "kzt",  "NA",
  "DCORP_L_BMTHA",  "th_m2_imf",  "M2 Broad Money for Thailand, National Currency",      "imf",  "M",  NA,  "thb",  "NA",
  "DCORP_L_BMAUS",  "au_m2_imf",  "M2 Broad Money for Australia, National Currency",     "imf",  "M",  NA,  "aud",  "NA",
  "DCORP_L_BMSWE",  "se_m2_imf",  "M2 Broad Money for Sweden, National Currency",        "imf",  "M",  NA,  "sek",  "NA",
  "DCORP_L_BMMEX",  "mx_m2_imf",  "M2 Broad Money for Mexico, National Currency",        "imf",  "M",  NA,  "mxn",  "NA",
  "DCORP_L_BMBRA",  "br_m2_imf",  "M2 Broad Money for Brazil, National Currency",        "imf",  "M",  NA,  "brl",  "NA",
  "DCORP_L_BMPHL",  "ph_m2_imf",  "M2 Broad Money for Philippines, National Currency",   "imf",  "M",  NA,  "php",  "NA",
  "DCORP_L_BMEGY",  "eg_m2_imf",  "M2 Broad Money for Egypt, National Currency",         "imf",  "M",  NA,  "egp",  "NA",
  "DCORP_L_BMQAT",  "qa_m2_imf",  "M2 Broad Money for Qatar, National Currency",         "imf",  "M",  NA,  "qar",  "NA",
  "DCORP_L_BMIRQ",  "iq_m2_imf",  "M2 Broad Money for Iraq, National Currency",          "imf",  "M",  NA,  "iqd",  "NA",
  "DCORP_L_BMHUN",  "hu_m2_imf",  "M2 Broad Money for Hungary, National Currency",       "imf",  "M",  NA,  "huf",  "NA",
  "DCORP_L_BMARE",  "ae_m2_imf",  "M2 Broad Money for UAE, National Currency",           "imf",  "M",  NA,  "aed",  "NA",
  
  # ============================== KOF =========================================
  
  # Nowcast
  "KOFNC",                   "kof_nowcastinglab",   "KOF Nowcasting Lab (forecast vintages by country/variable)",                                                            "kofnc",     "Q",            NA,      "fct",   "SA",
  
  # Indicator 
  "KOFBCH",                  "kof_bar_ch",          "KOF Barometer for Switzerland",                                                                                           "kof",     "M",            NA,      "bar",   "SA",
  "KOFBGLCO",                "kof_bar_gl_coinci",   "KOF Barometer Global, Coincidence",                                                                                       "kof",     "M",            NA,      "bar",   "SA",
  "KOFBGLLE",                "kof_bar_gl_lead",     "KOF Barometer Global, Leading",                                                                                           "kof",     "M",            NA,      "bar",   "SA",
  "KOFBSI",                  "kof_ind_busen",       "KOF Business Sentiment Indicator for Switzerland",                                                                                        "kof",     "M",            NA,      "ind",   "SA",
  "KOFESCH",                 "kof_ind_ch_es",       "KOF Economic Sentiment Indicator for Switzerland",                                                                        "kof",     "M",            NA,      "ind",   "SA",
  "KOFESEU",                 "kof_ind_eu_es",       "KOF Economic Sentiment Indicator for  Europe",                                                                            "kof",     "M",            NA,      "ind",   "SA",
  
  # =============================== CREDIT SPREAD ==============================
  
  # ICE BofA US Corporate IG — By Rating
  "BAMLC0A0CM",              "ice_bofa_allig_us",          "ICE BofA US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                                  "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC0A1CAAA",            "ice_bofa_aaa_us",            "ICE BofA AAA US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                              "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC0A2CAA",             "ice_bofa_aa_us",             "ICE BofA AA US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                               "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC0A3CA",              "ice_bofa_a_us",              "ICE BofA Single-A US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                         "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC0A4CBBB",            "ice_bofa_bbb_us",            "ICE BofA BBB US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                              "fred",    "D",         "lin",       "prc",  "NA",
  
  # ICE BofA US Corporate IG — By Maturity
  "BAMLC1A0C13Y",            "ice_bofa_1_3y_us",           "ICE BofA 1-3 Year US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                        "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC2A0C35Y",            "ice_bofa_3_5y_us",           "ICE BofA 3-5 Year US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                        "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC3A0C57Y",            "ice_bofa_5_7y_us",           "ICE BofA 5-7 Year US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                        "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC4A0C710Y",           "ice_bofa_7_10y_us",          "ICE BofA 7-10 Year US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                       "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC7A0C1015Y",          "ice_bofa_10_15y_us",         "ICE BofA 10-15 Year US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                      "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLC8A0C15PY",           "ice_bofa_15py_us",           "ICE BofA 15+ Year US Corporate Index Option-Adjusted Spread, Percent, Not Adjusted",                        "fred",    "D",         "lin",       "prc",  "NA",
  
  # ICE BofA US High Yield — By Rating
  "BAMLH0A0HYM2",            "ice_bofa_allhy_us",          "ICE BofA US High Yield Index Option-Adjusted Spread, Percent, Not Adjusted",                                "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLH0A1HYBB",            "ice_bofa_bb_us",             "ICE BofA BB US High Yield Index Option-Adjusted Spread, Percent, Not Adjusted",                             "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLH0A2HYB",             "ice_bofa_b_us",              "ICE BofA Single-B US High Yield Index Option-Adjusted Spread, Percent, Not Adjusted",                       "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLH0A3HYC",             "ice_bofa_ccc_us",            "ICE BofA CCC & Lower US High Yield Index Option-Adjusted Spread, Percent, Not Adjusted",                    "fred",    "D",         "lin",       "prc",  "NA",
  
  # ICE BofA Europe
  "BAMLHE00EHYIOAS",         "ice_bofa_allhy_eu",          "ICE BofA Euro High Yield Index Option-Adjusted Spread, Percent, Not Adjusted",                              "fred",    "D",         "lin",       "prc",  "NA",
  
  # ICE BofA Emerging Markets
  "BAMLEMCBPIOAS",           "ice_bofa_em_corp",           "ICE BofA Emerging Markets Corporate Plus Index Option-Adjusted Spread, Percent, Not Adjusted",              "fred",    "D",         "lin",       "prc",  "NA",
  "BAMLEMHBHYCRPIOAS",       "ice_bofa_em_hy_corp",        "ICE BofA High Yield Emerging Markets Corporate Plus Index Option-Adjusted Spread, Percent, Not Adjusted",   "fred",    "D",         "lin",       "prc",  "NA",
  
  
  # ================================ SHARE =====================================
  
  # US Share
  "PYPL",                    "paypal",              "Paypal, Share",                                                                                                      "yahoo",     "D",            NA,      "usd",   "NA",
  "UPS",                     "ups",                 "UPS, Share",                                                                                                         "yahoo",     "D",            NA,      "usd",   "NA",
  "WMT",                     "walmart",             "Walmart, Share",                                                                                                     "yahoo",     "D",            NA,      "usd",   "NA",
  "AAPL",                    "apple",               "Apple, Share",                                                                                                       "yahoo",     "D",            NA,      "usd",   "NA",
  "MSFT",                    "microsoft",           "Microsoft, Share",                                                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  "GOOGL",                   "alphabet",            "Alphabet, Share",                                                                                                    "yahoo",     "D",            NA,      "usd",   "NA",
  "AMZN",                    "amazon",              "Amazon, Share",                                                                                                      "yahoo",     "D",            NA,      "usd",   "NA",
  "META",                    "meta",                "Meta Platforms, Share",                                                                                              "yahoo",     "D",            NA,      "usd",   "NA",
  "TSLA",                    "tesla",               "Tesla, Share",                                                                                                       "yahoo",     "D",            NA,      "usd",   "NA",
  "KO",                      "coca_cola",           "Coca-Cola, Share",                                                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  "NVDA",                    "nvidia",              "Nvidia, Share",                                                                                                      "yahoo",     "D",            NA,      "usd",   "NA",
  "MCO",                     "moodys",              "Moody's, Share",                                                                                                     "yahoo",     "D",            NA,      "usd",   "NA",
  "ORCL",                    "oracle",              "Oracle, Share",                                                                                                      "yahoo",     "D",            NA,      "usd",   "NA",
  "NVO",                     "novo_nordisk",        "Novo Nordisk, Share",                                                                                                "yahoo",     "D",            NA,      "usd",   "NA",
  "NIO",                     "nio",                 "NIO, Share",                                                                                                         "yahoo",     "D",            NA,      "usd",   "NA",
  "CPNG",                    "coupang",             "Coupang, Share",                                                                                                     "yahoo",     "D",            NA,      "usd",   "NA",
  "LLY",                     "eli_lilly",           "Eli Lilly, Share",                                                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  "BHP",                     "bhp_group",           "BHP Group, Share",                                                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  "RIO",                     "rio_tinto",           "Rio Tinto, Share",                                                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  
  # Swiss Share 
  "SQN.SW",                  "swissquote",          "Swissquote, Share",                                                                                                  "yahoo",     "D",            NA,      "chf",   "NA",
  "SREN.SW",                 "swiss_re",            "Swiss Re, Share",                                                                                                    "yahoo",     "D",            NA,      "chf",   "NA",
  "UBSG.SW",                 "ubs_group",           "UBS Group, Share",                                                                                                   "yahoo",     "D",            NA,      "chf",   "NA",
  
  # EU Share
  "SIE.DE",                  "siemens",             "Siemens, Share",                                                                                                     "yahoo",     "D",            NA,      "eur",   "NA",
  "EOAN.DE",                 "eon",                 "E.ON, Share",                                                                                                        "yahoo",     "D",            NA,      "eur",   "NA",
  "TEZNY",                   "terna_rete_elettrica","Terna Rete Elettrica, Share",                                                                                        "yahoo",     "D",            NA,      "eur",   "NA",
  
  # ================================= ETF  =====================================
  
  "VUAA.L",                  "vanguard_sp500",                    "Vanguard S&P 500, ETF",                                                                                "yahoo",     "D",            NA,      "usd",   "NA",
  "CSNDX.SW",                "ishares_nasdaq_100",                "iShares Nasdaq 100, ETF",                                                                              "yahoo",     "D",            NA,      "usd",   "NA",
  "LYY7.DE",                 "amundi_dax_ii",                     "Amundi DAX II, ETF",                                                                                   "yahoo",     "D",            NA,      "eur",   "NA",
  "LYP6.DE",                 "amundi_stoxx_europe_600",           "Amundi STOXX Europe 600, ETF",                                                                         "yahoo",     "D",            NA,      "eur",   "NA",
  "CHSPI.SW",                "ishares_spi_etf",                   "iShares SPI, ETF",                                                                                     "yahoo",     "D",            NA,      "chf",   "NA",
  "EDMUZ.XC",                "ishares_msci_usa_esg",              "iShares MSCI USA ESG, ETF",                                                                            "yahoo",     "D",            NA,      "usd",   "NA",
  "SEMI.AS",                 "ishares_global_semiconductors",     "iShares Global Semiconductors, ETF",                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  "LOCK.L",                  "ishares_digital_security",          "iShares Digital Security, ETF",                                                                        "yahoo",     "D",            NA,      "usd",   "NA",
  "INRG.SW",                 "ishares_clean_energy",              "iShares Clean Energy, ETF",                                                                            "yahoo",     "D",            NA,      "usd",   "NA",
  "WBLK.L",                  "wisdomtree_blockchain",             "WisdomTree Blockchain, ETF",                                                                           "yahoo",     "D",            NA,      "usd",   "NA",
  "REMX",                    "vaneck_rare_earth",                 "VanEck Rare Earth, ETF",                                                                               "yahoo",     "D",            NA,      "usd",   "NA",
  "URNU.L",                  "global_x_uranium",                  "Global X Uranium, ETF",                                                                                "yahoo",     "D",            NA,      "usd",   "NA",
  "NUKL.DE",                 "vaneck_uranium_nuclear_tech",       "VanEck Uranium & Nuclear Tech, ETF",                                                                   "yahoo",     "D",            NA,      "usd",   "NA",
  "GLD",                     "gold_spdr_etf",                     "SPDR Gold Shares, ETF",                                                                                "yahoo",     "D",            NA,      "usd",   "NA",
  "IAU",                     "gold_ishare_etf",                   "iShares Gold Trust, ETF",                                                                              "yahoo",     "D",            NA,      "usd",   "NA",
  "CMOD.L",                  "invesco_bloomberg_commodity",       "Invesco Bloomberg Commodity, ETF",                                                                     "yahoo",     "D",            NA,      "usd",   "NA",
  "EGLN.L",                  "ishares_physical_gold",             "iShares Physical Gold, ETF",                                                                           "yahoo",     "D",            NA,      "usd",   "NA",
  "ZGLD.SW",                 "zuercher_gold_etf",                 "Zürcher Gold, ETF",                                                                                    "yahoo",     "D",            NA,      "chf",   "NA",
  "IDTL.L",                  "ishares_us_treasury_20y",           "iShares US Treasury 20Y, ETF",                                                                         "yahoo",     "D",            NA,      "usd",   "NA",
  "LQDE.L",                  "ishares_usd_corp_bond",             "iShares USD Corp Bond, ETF",                                                                           "yahoo",     "D",            NA,      "usd",   "NA",
 
  # =============================== CRYPTO  ====================================
  
  "BTC-USD",                 "bitcoin",                           "Bitcoin, Crypto",                                                                                       "yahoo",     "D",            NA,      "usd",   "NA",
  "ETH-USD",                 "ethereum",                          "Ethereum, Crypto",                                                                                      "yahoo",     "D",            NA,      "usd",   "NA",
  "SOL-USD",                 "solana",                            "Solana, Crypto",                                                                                        "yahoo",     "D",            NA,      "usd",   "NA",

  # ============================= COMMODITIES ==================================
  
  # Energy 
  "BZ=F",                    "fut_brent_crude",       "Brent crude oil futures (front contract)",                           "yahoo",       "D",   NA,   "usd",   "NA",
  "CL=F",                    "fut_wti_crude",         "WTI crude oil futures (front contract)",                             "yahoo",       "D",   NA,   "usd",   "NA",
  "NG=F",                    "fut_natural_gas",       "Natural gas futures (front contract)",                               "yahoo",       "D",   NA,   "usd",   "NA",
  "HO=F",                    "fut_heating_oil",       "Heating oil futures",                                                "yahoo",       "D",   NA,   "usd",   "NA",
  "RB=F",                    "fut_rbob_gasoline",     "RBOB gasoline futures (gasoline benchmark)",                         "yahoo",       "D",   NA,   "usd",   "NA",
  
  # Metals
  "GC=F",                    "fut_gold",              "Gold futures (COMEX front contract)",                                "yahoo",       "D",   NA,   "usd",   "NA",
  "SI=F",                    "fut_silver",            "Silver futures (COMEX front contract)",                              "yahoo",       "D",   NA,   "usd",   "NA",
  "HG=F",                    "fut_copper",            "Copper futures (COMEX front contract)",                              "yahoo",       "D",   NA,   "usd",   "NA",
  "PL=F",                    "fut_platinum",          "Platinum futures",                                                   "yahoo",       "D",   NA,   "usd",   "NA",
  "PA=F",                    "fut_palladium",         "Palladium futures",                                                  "yahoo",       "D",   NA,   "usd",   "NA",
  "ALI=F",                   "fut_aluminium",         "Aluminium futures (COMEX front contract)",                           "yahoo",       "D",   NA,   "usd",   "NA",
  
  # Agriculture
  "ZC=F",                    "fut_corn",              "Corn futures (CBOT front contract)",                                 "yahoo",       "D",   NA,   "usd",   "NA",
  "ZW=F",                    "fut_wheat",             "Wheat futures (CBOT front contract)",                                "yahoo",       "D",   NA,   "usd",   "NA",
  "ZS=F",                    "fut_soybeans",          "Soybean futures (CBOT front contract)",                              "yahoo",       "D",   NA,   "usd",   "NA",
  "KC=F",                    "fut_coffee",            "Coffee (Arabica) futures",                                           "yahoo",       "D",   NA,   "usd",   "NA",
  "CC=F",                    "fut_cocoa",             "Cocoa futures",                                                      "yahoo",       "D",   NA,   "usd",   "NA",
  "CT=F",                    "fut_cotton",            "Cotton futures",                                                     "yahoo",       "D",   NA,   "usd",   "NA",
  "SB=F",                    "fut_sugar",             "Sugar futures",                                                      "yahoo",       "D",   NA,   "usd",   "NA",
  "LE=F",                    "fut_live_cattle",       "Live cattle futures (CME front contract)",                           "yahoo",       "D",   NA,   "usd",   "NA",
  "HE=F",                    "fut_lean_hogs",         "Lean hogs futures (CME front contract)",                             "yahoo",       "D",   NA,   "usd",   "NA",
  "OJ=F",                    "fut_orange_juice",      "Orange juice futures (ICE front contract)",                          "yahoo",       "D",   NA,   "usd",   "NA",
  "LBS=F",                   "fut_lumber",            "Lumber futures (CME front contract)",                                "yahoo",       "D",   NA,   "usd",   "NA",
  
  # Commodity Indices
  "^SPGSCI",                 "idx_spgsci",            "S&P GSCI broad commodity index",                                     "yahoo",       "D",   NA,   "usd",   "NA",
  "BCOM",                    "idx_bcom",              "Bloomberg Commodity Index (BCOM)",                                   "investing",   "D",   NA,   "usd",   "NA",
  
  # Stock
  "WTTSTUS1",                "us_crude_inv",          "US Crude Oil Inventories, Weekly, Thousands of Barrels, Not Adjusted", "investing", "W",   NA,   "bbl",   "NA",
  
  # Production 
  "COPR_OPEC",  "opec_crude_prod",  "Crude Oil Production including Lease Condensate for OPEC, Thousand Barrels per Day, Not Adjusted",                   "eia", "M", NA, "bbl", "NA",
  "COPR_USA",   "us_crude_prod",    "Crude Oil Production including Lease Condensate for United States, Thousand Barrels per Day, Not Adjusted",          "eia", "M", NA, "bbl", "NA",
  "COPR_RUS",   "ru_crude_prod",    "Crude Oil Production including Lease Condensate for Russia, Thousand Barrels per Day, Not Adjusted",                 "eia", "M", NA, "bbl", "NA",
  "COPR_CHN",   "cn_crude_prod",    "Crude Oil Production including Lease Condensate for China, Thousand Barrels per Day, Not Adjusted",                  "eia", "M", NA, "bbl", "NA",
  "COPR_SAU",   "sau_crude_prod",   "Crude Oil Production including Lease Condensate for Saudi Arabia, Thousand Barrels per Day, Not Adjusted",           "eia", "M", NA, "bbl", "NA",
  "COPR_IRQ",   "irq_crude_prod",   "Crude Oil Production including Lease Condensate for Iraq, Thousand Barrels per Day, Not Adjusted",                   "eia", "M", NA, "bbl", "NA",
  "COPR_IRN",   "irn_crude_prod",   "Crude Oil Production including Lease Condensate for Iran, Thousand Barrels per Day, Not Adjusted",                   "eia", "M", NA, "bbl", "NA",
  "COPR_ARE",   "are_crude_prod",   "Crude Oil Production including Lease Condensate for United Arab Emirates, Thousand Barrels per Day, Not Adjusted",   "eia", "M", NA, "bbl", "NA",
  "COPR_KWT",   "kwt_crude_prod",   "Crude Oil Production including Lease Condensate for Kuwait, Thousand Barrels per Day, Not Adjusted",                 "eia", "M", NA, "bbl", "NA",
  "COPR_VEN",   "ven_crude_prod",   "Crude Oil Production including Lease Condensate for Venezuela, Thousand Barrels per Day, Not Adjusted",              "eia", "M", NA, "bbl", "NA",
  "COPR_NGA",   "nga_crude_prod",   "Crude Oil Production including Lease Condensate for Nigeria, Thousand Barrels per Day, Not Adjusted",                "eia", "M", NA, "bbl", "NA",
  "COPR_LBY",   "lby_crude_prod",   "Crude Oil Production including Lease Condensate for Libya, Thousand Barrels per Day, Not Adjusted",                  "eia", "M", NA, "bbl", "NA",
  "COPR_DZA",   "dza_crude_prod",   "Crude Oil Production including Lease Condensate for Algeria, Thousand Barrels per Day, Not Adjusted",                "eia", "M", NA, "bbl", "NA",
  "COPR_NOR",   "nor_crude_prod",   "Crude Oil Production including Lease Condensate for Norway, Thousand Barrels per Day, Not Adjusted",                 "eia", "M", NA, "bbl", "NA",
  "COPR_CAN",   "can_crude_prod",   "Crude Oil Production including Lease Condensate for Canada, Thousand Barrels per Day, Not Adjusted",                 "eia", "M", NA, "bbl", "NA",
  "COPR_MEX",   "mex_crude_prod",   "Crude Oil Production including Lease Condensate for Mexico, Thousand Barrels per Day, Not Adjusted",                 "eia", "M", NA, "bbl", "NA",
  "COPR_BRA",   "bra_crude_prod",   "Crude Oil Production including Lease Condensate for Brazil, Thousand Barrels per Day, Not Adjusted",                 "eia", "M", NA, "bbl", "NA",
  "COPR_KAZ",   "kaz_crude_prod",   "Crude Oil Production including Lease Condensate for Kazakhstan, Thousand Barrels per Day, Not Adjusted",             "eia", "M", NA, "bbl", "NA",
  
  # Supply
  "RICBH",       "us_rig_count",   "Baker Hughes US Rig Count, Total Oil & Gas Rigs, Not Adjusted",                                                    "investing", "W", NA, "nbr", "NA",
  
  # ================================= INDEX ====================================
  
  # Index 
  "VXVCLS",                  "cboevix_3m_fd",         "CBOE S&P 500 3-Month Volatility Index (VIX)",                                                                          "fred",     "D",         "lin",      "idx",   "NA",
  "^VIX",                    "cboevix_1m",            "CBOE S&P 500 1-Month Volatility Index (VIX)",                                                                         "yahoo",     "D",            NA,      "idx",   "NA",
  "FRGSHPUSM649NCIS",        "cassfrei_ship_idx_fd",  "Cass Freight Shipments Index, Index 1990:01 = 1",                                                                      "fred",     "M",         "lin",      "idx",   "NA",
  "FRGEXPUSM649NCIS",        "cassfrei_exp_idx_fd",   "Cass Freight Expenditures Index, Index 1990:01 = 1",                                                                   "fred",     "M",         "lin",      "idx",   "NA",
  "DTWEXBGS",                "trade_dol_idx_fd",      "Nominal Broad US Dollar Index, Index 2006:01 = 100",                                                                   "fred",     "D",         "lin",      "idx",   "NA",
  "STLFSI4",                 "fina_stress_idx_fd",    "St. Louis Fed Financial Stress Index",                                                                                 "fred",     "W",         "lin",      "idx",   "NA",
  "BDIINV",                  "baltic_dry_idx_inv",    "Baltic Dry Index",                                                                                                "investing",     "D",            NA,      "idx",   "NA",
  "ISMPMIINV",               "ism_pmi_idx_inv",       "US ISM Manufacturing Purchasing Managers Index (PMI)",                                                            "investing",     "M",            NA,      "idx",   "NA",
  "ZEWINV",                  "zwe_idx_inv",           "ZEW Economic Sentiment Index for Euro Area (20 Countries)",                                                       "investing",     "M",            NA,      "idx",   "NA",
  "^SOX",                    "sox_idx",               "Semiconductor Index (SOX)",                                                                                           "yahoo",     "D",            NA,      "idx",   "NA",
  "V2TX",                    "vstoxx_idx",            "EURO STOXX 50 Volatility Index (VSTOXX)",                                                                             "stoxx",     "D",            NA,      "idx",   "NA",
  "DX-Y.NYB",                "dol_idx",               "US Dollar Index",                                                                                                     "yahoo",     "D",            NA,      "idx",   "NA",
  "^MOVE",                   "move_idx",              "ICE BofAML MOVE Index",                                                                                               "yahoo",     "D",            NA,      "idx",   "NA",
  "CCCFG",                   "ccc_fg",                "Crypto Fear & Greed Index, Score 0-100",                                                                               "ccc",      "D",            NA,      "idx",   "NA",
  
  
  # Equity Index 
  "^GSPC",                   "sp500",              "S&P 500 (United States), Equity Index",                                                                             "yahoo",    "D",            NA,      "bsp",   "NA",
  "^DJI",                    "dowjones",           "Dow Jones (United States), Equity Index",                                                                           "yahoo",    "D",            NA,      "bsp",   "NA",
  "^NDX",                    "nasdaq100",          "Nasdaq 100 (United States), Equity Index",                                                                          "yahoo",    "D",            NA,      "bsp",   "NA",
  "^IXIC",                   "nasdaqcomposite",    "Nasdaq Composite (United States), Equity Index",                                                                    "yahoo",    "D",            NA,      "bsp",   "NA",
  "^RUT",                    "russell2000",        "Russell 2000 (United States), Equity Index",                                                                        "yahoo",    "D",            NA,      "bsp",   "NA",
  "^GSPTSE",                 "tsx",                "TSX (Canada), Equity Index",                                                                                        "yahoo",    "D",            NA,      "bsp",   "NA",
  "^FTSE",                   "ftse100",            "FTSE 100 (United Kingdom), Equity Index",                                                                           "yahoo",    "D",            NA,      "bsp",   "NA",
  "^GDAXI",                  "dax",                "DAX (Germany), Equity Index",                                                                                       "yahoo",    "D",            NA,      "bsp",   "NA",
  "^FCHI",                   "cac40",              "CAC 40 (France), Equity Index",                                                                                     "yahoo",    "D",            NA,      "bsp",   "NA",
  "^SSMI",                   "smi",                "SMI (Switzerland), Equity Index",                                                                                   "yahoo",    "D",            NA,      "bsp",   "NA",
  "^OMX",                    "omx30",              "OMX 30 (Sweden), Equity Index",                                                                                     "yahoo",    "D",            NA,      "bsp",   "NA",
  "^AEX",                    "aex",                "AEX (Netherlands), Equity Index",                                                                                   "yahoo",    "D",            NA,      "bsp",   "NA",
  "^IBEX",                   "ibex35",             "IBEX 35 (Spain), Equity Index",                                                                                     "yahoo",    "D",            NA,      "bsp",   "NA",
  "FTSEMIB.MI",              "ftsemib",            "FTSE MIB (Italy), Equity Index",                                                                                    "yahoo",    "D",            NA,      "bsp",   "NA",
  "^N225",                   "nikkei225",          "Nikkei 225 (Japan), Equity Index",                                                                                  "yahoo",    "D",            NA,      "bsp",   "NA",
  "^HSI",                    "hangseng",           "Hang Seng (Hong Kong), Equity Index",                                                                               "yahoo",    "D",            NA,      "bsp",   "NA",
  "000001.SS",               "shanghai",           "Shanghai Composite (China), Equity Index",                                                                          "yahoo",    "D",            NA,      "bsp",   "NA",
  "^KS11",                   "kospi",              "KOSPI (South Korea), Equity Index",                                                                                 "yahoo",    "D",            NA,      "bsp",   "NA",
  "^AXJO",                   "asx200",             "ASX 200 (Australia), Equity Index",                                                                                 "yahoo",    "D",            NA,      "bsp",   "NA",
  "^BSESN",                  "sensex",             "Sensex (India), Equity Index",                                                                                      "yahoo",    "D",            NA,      "bsp",   "NA",
  "^MXX",                    "ipcmexico",          "IPC Mexico (Mexico), Equity Index",                                                                                 "yahoo",    "D",            NA,      "bsp",   "NA",
  "^BVSP",                   "bovespa",            "Bovespa (Brazil), Equity Index",                                                                                    "yahoo",    "D",            NA,      "bsp",   "NA",
  "^STOXX50E",               "eurostoxx",          "STOXX 50 (Europe), Equity Index",                                                                                   "yahoo",    "D",            NA,      "bsp",   "NA",
  "^STOXX",                  "stoxxeur600",        "STXE 600 (Europe), Equity Index",                                                                                   "yahoo",    "D",            NA,      "bsp",   "NA",
  "^TASI.SR",                "tadawul",            "Tadawul All Shares Index (Saudi Arabia), Equity Index",                                                             "yahoo",    "D",            NA,      "bsp",   "NA",
  "^990100-USD-STRD",        "msci_world",         "MSCI World Index (Standard, USD), Equity Index",                                                                    "yahoo",    "D",            NA,      "bsp",   "NA",
  "SLI.SW",                  "sli",                "Swiss Leader Index Price Index, Equity Index",                                                                      "yahoo",    "D",            NA,      "bsp",   "NA",
  "^SSHI",                   "spi",                "Swiss Performance Index, Equity Index",                                                                             "yahoo",    "D",            NA,      "bsp",   "NA",
  

  # ================================= RATIO ====================================
  
  # Buffet
  "CSHR",                    "shiller_ratio",         "Cyclically Adjusted Price Earnings Ratio P/E10 or CAPE",                                                         "shiller",     "M",            NA,      "rto",  "CYA",
  "BUFFWILR",                "buff_wilshire_ratio",   "Wilshire 5000 to GDP Ratio",                                                                                      "buffet",     "D",            NA,      "rto",   "NA",
  "BUFFSP500R",              "buff_sp500_ratio",      "S&P 500 to GDP Ratio",                                                                                            "buffet",     "D",            NA,      "rto",   "NA",
  "BUFFDJR",                 "buff_dj_ratio",         "Dow Jones to GDP Ratio",                                                                                          "buffet",     "D",            NA,      "rto",   "NA",
  "BUFFCORER",               "buff_corpequity_ratio", "Value of Public and Private Equities to GDP Ratio",                                                               "buffet",     "D",            NA,      "rto",   "NA",
  
  # =============================== INDICATOR ==================================
  
  # Greed and Fear Indicator
  "GFI",                     "gf_hist_cnn",                "Fear & Greed Index, One Year Historic",                                                                                        "cnn",     "D",            NA,      "idx",   "NA",
  "GFMMSP500",               "gf_mkt_mom_sp500_cnn",       "Market Momentum Indicator, S&P500, One Year Historic",                                                                         "cnn",     "D",            NA,      "ind",   "NA",
  "GFMMSP500MA",             "gf_mkt_mom_sp500_125ma_cnn", "Market Momentum Indicator, S&P500 125-day Moving Average, One Year Historic",                                                  "cnn",     "D",            NA,      "ind",   "NA",
  "GFSPS",                   "gf_sto_strength_cnn",        "Stock Price Strength Indicator, Net new 52-week Highs and Lows on the NYSE, One Year Historic",                                "cnn",     "D",            NA,      "ind",   "NA",
  "GFSPB",                   "gf_sto_breadth_cnn",         "Stock Price Breadth Indicator, McClellan Volume Summation Index, One Year Historic",                                           "cnn",     "D",            NA,      "ind",   "NA",
  "GFPCO",                   "gf_put_call_cnn",            "Put and Call Options Indicator, 5-day Average Put/Call Ratio, One Year Historic",                                              "cnn",     "D",            NA,      "ind",   "NA",
  "GFMV",                    "gf_mkt_vol_cnn",             "Market Volatility Indicator, VIX, One Year Historic",                                                                          "cnn",     "D",            NA,      "ind",   "NA",
  "GFMVMA",                  "gf_mkt_vol_50ma_cnn",        "Market Volatility Indicator, VIX 50-day Moving Average, One Year Historic",                                                    "cnn",     "D",            NA,      "ind",   "NA",
  "GFSHD",                   "gf_safe_haven_dmd_cnn",      "Safe Haven Demand Indicator, Difference in 20-day Stock and Bond Returns, One Year Historic",                                  "cnn",     "D",            NA,      "ind",   "NA",
  "GFJBD",                   "gf_junk_bond_dmd_cnn",       "Junk Bond Demand Indicator, Yield Spread: Junk Bonds vs. Investment grade, One Year Historic",                                 "cnn",     "D",            NA,      "ind",   "NA",
  
  # ================================= CURRENCY =================================
  
  # CHF Base 
  "CHF%3DX",                 "usd_chf",             "USD/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "usd",   "NA",
  "EURCHF%3DX",              "eur_chf",             "EUR/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "eur",   "NA",
  "CHFJPY=X",                "jpy_chf",             "JPY/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "jpy",   "NA",
  "CADCHF=X",                "cad_chf",             "CAD/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "cad",   "NA",
  "GBPCHF=X",                "gbp_chf",             "GBP/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "gbp",   "NA",
  "SEKCHF=X",                "sek_chf",             "SEK/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "sek",   "NA",
  "HKDCHF=X",                "hkd_chf",             "HKD/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "hkd",   "NA",
  "CNYCHF=X",                "cny_chf",             "CNY/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "cny",   "NA",
  "KRWCHF=X",                "krw_chf",             "KRW/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "krw",   "NA",
  "AUDCHF=X",                "aud_chf",             "AUD/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "aud",   "NA",
  "INRCHF=X",                "inr_chf",             "INR/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "inr",   "NA",
  "MXNCHF=X",                "mxn_chf",             "MXN/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "mxn",   "NA",
  "BRLCHF=X",                "brl_chf",             "BRL/CHF Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "brl",   "NA",
  
  # USD Base
  "EURUSD=X",                "eur_usd",             "EUR/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "eur",   "NA",
  "CADUSD=X",                "cad_usd",             "CAD/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "cad",   "NA",
  "GBPUSD=X",                "gbp_usd",             "GBP/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "gbp",   "NA",
  "SEKUSD=X",                "sek_usd",             "SEK/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "sek",   "NA",
  "CHFUSD=X",                "chf_usd",             "CHF/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "chf",   "NA",
  "HKDUSD=X",                "hkd_usd",             "HKD/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "hkd",   "NA",
  "JPYUSD=X",                "jpy_usd",             "JPY/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "jpy",   "NA",
  "CNYUSD=X",                "cny_usd",             "CNY/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "cny",   "NA",
  "KRWUSD=X",                "krw_usd",             "KRW/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "krw",   "NA",
  "AUDUSD=X",                "aud_usd",             "AUD/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "aud",   "NA",
  "INRUSD=X",                "inr_usd",             "INR/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "inr",   "NA",
  "MXNUSD=X",                "mxn_usd",             "MXN/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "mxn",   "NA",
  "BRLUSD=X",                "brl_usd",             "BRL/USD Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "brl",   "NA",
  
  # EUR Base 
  "USDEUR=X",                "usd_eur",             "USD/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "usd",   "NA",
  "CADEUR=X",                "cad_eur",             "CAD/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "cad",   "NA",
  "GBPEUR=X",                "gbp_eur",             "GBP/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "gbp",   "NA",
  "SEKEUR=X",                "sek_eur",             "SEK/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "sek",   "NA",
  "CHFEUR=X",                "chf_eur",             "CHF/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "chf",   "NA",
  "HKDEUR=X",                "hkd_eur",             "HKD/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "hkd",   "NA",
  "JPYEUR=X",                "jpy_eur",             "JPY/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "jpy",   "NA",
  "CNYEUR=X",                "cny_eur",             "CNY/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "cny",   "NA",
  "KRWEUR=X",                "krw_eur",             "KRW/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "krw",   "NA",
  "AUDEUR=X",                "aud_eur",             "AUD/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "aud",   "NA",
  "INREUR=X",                "inr_eur",             "INR/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "inr",   "NA",
  "MXNEUR=X",                "mxn_eur",             "MXN/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "mxn",   "NA",
  "BRLEUR=X",                "brl_eur",             "BRL/EUR Exchange Rate",                                                                                                "yahoo",    "D",            NA,      "brl",   "NA"
)








