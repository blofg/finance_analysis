
################################################################################
# Data format functions
################################################################################

# Function to reformat series from different sources 
reformate_data_fred      <- function(serie_id, tribble, fred_unit) {
  #-----------------------------------------------------------------------------
  # Function : Reformat data from FRED source
  # 1. Input : serie_id   = single id or vector of ids (character)
  # 2. Input : tribble    = mapping inputs table 
  # 3. Input : fred_unit  = FRED unit/transformation (character):
  #    - "lin" (raw values), 
  #    - "chg" (change from previous period),
  #    - "ch1" (change from year ago), 
  #    - "pch" (percent change from previous period),
  #    - "pc1" (percent change from year ago), 
  #    - "pca" (compounded annual rate),
  #    - "cch" (continuously compounded change), 
  #    - "cca" (continuously compounded annual rate),
  #    - "log" (natural log)
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # FRED series
  #-----------------------------------------------------------------------------
  fu          <- fred_unit
  result      <- NULL
  attempts    <- 0
  max_attempts <- 3
  while (is.null(result) && attempts < max_attempts) {
    attempts <- attempts + 1
    result <- tryCatch({
      data <- fredr(series_id = serie_id, units = fred_unit) %>%
        rename_with(tolower) %>%
        select(date, value, series_id) %>%
        rename(id = series_id) %>%
        left_join(tribble %>% filter(id == serie_id, .data$fred_unit == fu) %>% distinct(id, .keep_all = TRUE) %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>%
        distinct(id, date, .keep_all = TRUE) %>%
        na.omit()
      message(paste0(serie_id, " fetched successfully"))
      data}, error = function(e) {
      message(paste0(serie_id, " failed (attempt ", attempts, "/", max_attempts, "): ", e$message))
      Sys.sleep(2 * attempts)  
      NULL})}
  result
}
reformate_data_yahoo     <- function(serie_id, tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Yahoo source
  # 1. Input : serie_id = single id or vector of ids (character)
  # 2. Input : tribble  = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # Yahoo series
  #-----------------------------------------------------------------------------
  df <- tryCatch({
    result <- get_prices(serie_id) %>%
      rename_with(tolower) %>%
      select(time, close, id, low, high, volume) %>%
      rename(date = time, value = close) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>% 
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
    message(paste0(serie_id, " fetched successfully"))
    result
  }, error = function(e) {message(paste0(serie_id, " failed")); NULL })
}
reformate_data_kof       <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from KOF source
  # 1. Input : source  = data source 
  # 2. Input : tribble = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # KOF Swiss Barometer
  kof_barometer_swiss <- tryCatch({
      download.file(kof_barometer_swiss_link, kof_barometer_swiss_path, method = "curl")
      result <- read_excel(kof_barometer_swiss_path) %>%
        rename(value = kofbarometer) %>%
        mutate(date = paste0(date,"-01"), date = as.Date(date)) %>%
        mutate(id = "KOFBCH", name = "kof_bar_ch") %>%
        mutate(value = as.numeric(value)) %>%
        left_join(tribble %>% select(id, label, source, unit, frequency, adjustment), by = "id")
      message("KOF Swiss Barometer fetched successfully")
      result
    }, error = function(e) {message("KOF Swiss Barometer failed"); NULL })
  # KOF Global Barometer
  kof_barometer_global <- tryCatch({
      download.file(kof_barometer_global_link, kof_barometer_global_path, method = "curl")
      result <- read_excel(kof_barometer_global_path) %>%
        select(-gdp_reference) %>%
        rename(kof_bar_gl_coinci = globalbaro_coincident, kof_bar_gl_lead = globalbaro_leading) %>%
        pivot_longer(cols = -date, names_to = "name", values_to = "value") %>%
        mutate(date = paste0(date,"-01"), date = as.Date(date)) %>%
        mutate(id = case_when(name == "kof_bar_gl_coinci" ~ "KOFBGLCO", name == "kof_bar_gl_lead" ~ "KOFBGLLE")) %>%
        mutate(value = as.numeric(value)) %>%
        left_join(tribble %>% select(id, label, source, unit, frequency, adjustment), by = "id")
      message("KOF Global Barometer fetched successfully")
      result
    }, error = function(e) { message("KOF Global Barometer failed"); NULL })
  # KOF Business Sentiment Indicator 
  kof_indicator_sbusiness <- tryCatch({
      download.file(kof_indicator_sbusiness_link, kof_indicator_sbusiness_path, method = "curl")
      result <- read_excel(kof_indicator_sbusiness_path) %>%
        select(date, ch.kof.bts_total.ng08.fx.q_ql_ass_bs.balance.d11) %>%
        rename(value = ch.kof.bts_total.ng08.fx.q_ql_ass_bs.balance.d11) %>%
        mutate(date = paste0(date,"-01"), date = as.Date(date)) %>%
        mutate(id = "KOFBSI", name = "kof_ind_busen") %>%
        mutate(value = as.numeric(value)) %>%
        left_join(tribble %>% select(id, label, source, unit, frequency, adjustment), by = "id")
      message("KOF Business Sentiment Indicator fetched successfully")
      result
    }, error = function(e) {message("KOF Business Sentiment Indicator failed"); NULL })
  # KOF Economic Sentiment Indicator 
  kof_indicator_seconomic <- tryCatch({
      download.file(kof_indicator_seconomic_link, kof_indicator_seconomic_path, method = "curl")
      result <- read_excel(kof_indicator_seconomic_path) %>%
        rename(kof_ind_ch_es = ch.kof.esi.index, kof_ind_eu_es = eu.ec.esi.eu.esi) %>%
        pivot_longer(cols = -date, names_to = "name", values_to = "value") %>%
        mutate(date = paste0(date,"-01"), date = as.Date(date)) %>%
        mutate(id = case_when(name == "kof_ind_ch_es" ~ "KOFESCH", name == "kof_ind_eu_es" ~ "KOFESEU")) %>%
        mutate(value = as.numeric(value)) %>%
        left_join(tribble %>% select(id, label, source, unit, frequency, adjustment), by = "id")
      message("KOF Economic Sentiment Indicator fetched successfully")
      result
    }, error = function(e) {message("KOF Economic Sentiment Indicator failed"); NULL })
  df <- rbind(kof_barometer_swiss, kof_barometer_global, kof_indicator_seconomic,  kof_indicator_sbusiness) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_kofnc     <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from KOF Nowcasting source
  # 1. Input : source  = data source 
  # 2. Input : tribble = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # KOF nowcasting lab
  kof_nowcasting <- tryCatch({
    download.file(kof_nowcasting_link, kof_nowcasting_path, method = "curl")
    result <- read.csv(kof_nowcasting_path, stringsAsFactors = FALSE) %>%
      rename(publication_date = kofcast_datestamp, variable = target_variable, date = target_period) %>%
      mutate(target_period = date) %>%
      mutate(name = paste0(country,"_", variable,"nc"), id = toupper(paste0(country,variable,"nc"))) %>%
      mutate(date = as.Date(as.yearqtr(date, format = "Q%q %Y")), publication_date = as.Date(publication_date, format = "%d.%m.%Y")) %>%
      select(-country, -variable) %>%
      mutate(value = as.numeric(value))
      message("KOF Nowcasting Lab fetched successfully")
    result
  }, error = function(e) {message("KOF Nowcasting Lab failed"); NULL })
 
}
reformate_data_shiller   <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Shiller source
  # 1. Input : tribble = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # Shiller Series
  #-----------------------------------------------------------------------------
  shiller <- tryCatch({
    # Scrape the link 
    page <- read_html(capeshiller_url)
    # Construct the URL 
    capeshiller_url <- page %>%
      html_elements("a[href*='ie_data']") %>%
      html_attr("href") %>%
      first()
    # Add https
    capeshiller_url <- paste0("https:", capeshiller_url)
    # Download 
    download.file(capeshiller_url, destfile = capeshiller_path, mode = "wb")
    result <- read_excel(capeshiller_path, sheet = "Data", skip = 7) %>%
      select(Date, CAPE) %>%
      rename(date = Date, value = CAPE) %>%
      mutate(date = sprintf("%.2f", as.numeric(date)), year = as.integer(substr(date, 1, 4)), month = as.integer(substr(date, 6, 7)), date = as.Date(sprintf("%d-%02d-01", year, month)), id = "CSHR") %>%
      mutate(value = as.numeric(value)) %>%
      select(date, value, id) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>% 
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
    message(paste0("Shiller fetched successfully"))
    result
  }, error = function(e) {message(paste0("Shiller failed")); NULL })
}
reformate_data_stoxx     <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from SOXX source
  # 1. Input : tribble = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # SOXX Series
  #-----------------------------------------------------------------------------
  # VSTOXX 50
  vstoxx50 <- tryCatch({
    result <- read_delim(vstoxx_url, delim = ";", col_types = cols(Date = col_character(), Symbol = col_character(), Indexvalue = col_double()), locale = locale(decimal_mark = ".")) %>%
      mutate(Date = as.Date(Date, format = "%d.%m.%Y")) %>%
      rename(date = Date, value = Indexvalue, id = Symbol) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>% 
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
    message(paste0("VSTOXX 50 fetched successfully"))
    result
  }, error = function(e) {
    message(paste0("VSTOXX 50 failed")); NULL })
}
reformate_data_oecd      <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from OECD source
  # 1. Input : tribble = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # OECD Series
  #-----------------------------------------------------------------------------
  # Contributions to national year-on-year inflation by COICOP 1999 divisions from OECD database
  oecd_inflation <- tryCatch({
    result <- read.csv(oecd_api_key) %>%
      mutate(id = paste0(REF_AREA,"CPIOECD")) %>%
      rename(frequency = FREQ, value = OBS_VALUE, date = TIME_PERIOD) %>%
      filter(Transformation == "Growth rate, over 1 year") %>%
      select(id, value, frequency, date) %>%
      mutate(value = as.numeric(value), date = as.Date(paste0(date,"-01"))) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>%
      filter(!is.na(label)) %>% 
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
    message(paste0("Inflation (COICOP 1999) from OECD fetched successfully"))
    result
  }, error = function(e) { message(paste0("Inflation (COICOP 1999) from OECD failed")); NULL })
}
reformate_data_buffet    <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Buffet source
  # 1. Input : tribble  = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # Buffet Series
  #-----------------------------------------------------------------------------
  # GDP
  gdp <- tryCatch({
    fredr(series_id = "GDP") %>% select(date, gdp = value)
  }, error = function(e) { message("GDP failed"); NULL })
  # Wilshire 5000
  wilshire <- tryCatch({
    result <- get_prices("^FTW5000") %>%
      select(date = time, wil_5000 = Close) %>%
      mutate(gdp = gdp$gdp[findInterval(date, gdp$date)], value = wil_5000 / gdp) %>%
      select(date, value) %>%
      mutate(id = "BUFFWILR") %>%
      select(id, date, value) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("BUFFWILR fetched successfully"))
    result
  }, error = function(e) { message("BUFFWILR failed"); NULL })
  # SP500
  sp500 <- tryCatch({
    result <- get_prices("^GSPC") %>%
      select(date = time, sp500 = Close) %>%
      mutate(gdp = gdp$gdp[findInterval(date, gdp$date)], value = sp500 / gdp) %>%
      select(date, value) %>%
      mutate(id = "BUFFSP500R") %>%
      select(id, date, value) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("BUFFSP500R fetched successfully"))
    result
  }, error = function(e) { message("BUFFSP500R failed"); NULL })
  # Dow Jones
  dow <- tryCatch({
    result <- get_prices("^DJI") %>%
      select(date = time, dow = Close) %>%
      mutate(gdp = gdp$gdp[findInterval(date, gdp$date)], value = dow / gdp) %>%
      select(date, value) %>%
      mutate(id = "BUFFDJR") %>%
      select(id, date, value) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("BUFFDJR fetched successfully"))
    result
  }, error = function(e) { message("BUFFDJR failed"); NULL })
  # Corporate Equities / GDP
  corp_eq <- tryCatch({
    result <- fredr(series_id = "BOGZ1LM893064105Q") %>%
      select(date, corp_equi = value) %>%
      left_join(gdp, by = "date") %>%
      mutate(gdp = gdp * 1000) %>% 
      mutate(value = corp_equi / gdp) %>%
      select(date, value) %>%
      mutate(id = "BUFFCORER") %>%
      select(id, date, value) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("BUFFCORER fetched successfully"))
    result
  }, error = function(e) { message("BUFFCORER failed"); NULL })
  # Rbind all the buffet database
  df <- rbind(wilshire, sp500, dow, corp_eq) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_eurostat  <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from eurostat source
  # 1. Input : tribble    = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # eurostat Series
  #-----------------------------------------------------------------------------
  # Inflation: HICP all items, Percent change from Year Ago
  eurostat_inflation <- tryCatch({
    result <- get_eurostat_series("prc_hicp_manr") %>%
      filter(geo %in% eurostat_geo_area, coicop == "CP00") %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD) %>%
      mutate(adjustment = "NSA") %>%
      mutate(id = paste0(coicop, geo)) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("prc_hicp_manr fetched successfully"))
    result
  }, error = function(e) { message("prc_hicp_manr failed"); NULL })
  # Employment rate (20–64) : Percent of active population
  eurostat_employment_rate <- tryCatch({
    result <- get_eurostat_series("lfsi_emp_q") %>%
      filter(geo %in% eurostat_geo_area, age == "Y20-64", sex == "T", unit == "PC_POP", s_adj == "NSA") %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      mutate(id = paste0("EMPRATE", geo)) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("lfsi_emp_q fetched successfully"))
    result
  }, error = function(e) { message("lfsi_emp_q failed"); NULL })
  # Unemployment rate : Percent of active population
  eurostat_unemployment_rate <- tryCatch({
    result <- get_eurostat_series("une_rt_m") %>%
      filter(geo %in% eurostat_geo_area, age == "TOTAL", sex == "T", unit == "PC_ACT", s_adj == "NSA") %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      mutate(id = paste0("UNRATE", geo)) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("une_rt_m fetched successfully"))
    result
  }, error = function(e) { message("une_rt_m failed"); NULL })
  # House prices Total: Percent change from Year Ago
  eurostat_house_price <- tryCatch({
    result <- get_eurostat_series("prc_hpi_q") %>%
      filter(geo %in% eurostat_geo_area, unit == "RCH_A", purchase == "TOTAL") %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD) %>%
      mutate(id = paste0("HOUPR", geo), adjustment = "NSA") %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("prc_hpi_q fetched successfully"))
    result
  }, error = function(e) { message("prc_hpi_q failed"); NULL })
  #  National account : Real (2020) volume and percent change from Year Ago 
  eurostat_national_account <- tryCatch({
    result <- get_eurostat_series("namq_10_gdp") %>%
      filter(geo %in% eurostat_geo_area, unit %in% c("CLV_PCH_ANN","CLV20_MEUR"), s_adj %in% c("SCA","NSA"))
    message(paste0("namq_10_gdp fetched successfully"))
    result
  }, error = function(e) { message("namq_10_gdp failed"); NULL })
  # GDP : Real (2020) volume and percent change from Year Ago 
  eurostat_real_gdp <- tryCatch({
    result <- eurostat_national_account %>%
      filter(na_item == "B1GQ") %>%
      mutate(id = paste0("RGDP",unit,s_adj,geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("RGDP fetched successfully"))
    result
  }, error = function(e) { message("RGDP failed"); NULL })
  # Total consumption : Real (2020) volume and percent change from Year Ago 
  eurostat_real_total_consumption <- tryCatch({
    result <- eurostat_national_account %>%
      filter(na_item == "P3") %>%
      mutate(id = paste0("RTC",unit,s_adj,geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("RTC fetched successfully"))
    result
  }, error = function(e) { message("RTC failed"); NULL })
  # Household consumption : Real (2020) volume and percent change from Year Ago 
  eurostat_real_final_household_consumption <- tryCatch({
    result <- eurostat_national_account %>%
      filter(na_item == "P31_S14") %>%
      mutate(id = paste0("RFHC",unit,s_adj,geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("RFHC fetched successfully"))
    result
  }, error = function(e) { message("RFHC failed"); NULL })
  # Capital investment GDP : Real (2020) volume and percent change from Year Ago 
  eurostat_real_investment <- tryCatch({
    result <- eurostat_national_account %>%
      filter(na_item == "P51G") %>%
      mutate(id = paste0("RI",unit,s_adj,geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("RI fetched successfully"))
    result
  }, error = function(e) { message("RI failed"); NULL })
  #  Sector accounts key indicators 
  nas_key <- tryCatch({
    result <- get_eurostat_series("nasq_10_ki") %>% filter(geo %in% eurostat_geo_area)
    message(paste0("nasq_10_ki fetched successfully"))
    result
  }, error = function(e) { message("nasq_10_ki failed"); NULL })
  # Household savings : Percent
  household_saving <- tryCatch({
    result <- nas_key %>%
      filter(na_item == "SRG_S14_S15") %>%
      mutate(id = paste0("HS",geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      filter(adjustment == "NSA") %>% 
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("HS fetched successfully"))
    result
  }, error = function(e) { message("HS failed"); NULL })
  # Businesses investments : Percent
  eurostat_business_investment <- tryCatch({
    result <- nas_key %>%
      filter(na_item == "IRG_S11") %>%
      mutate(id = paste0("BI",geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      filter(adjustment == "NSA") %>% 
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("BI fetched successfully"))
    result
  }, error = function(e) { message("BI failed"); NULL })
  #  Government deficit / surplus : Million Euro and Percent of GDP
  eurostat_government_deficit_surplus <- tryCatch({
    result <- get_eurostat_series("gov_10q_ggnfa") %>%
      filter(geo %in% eurostat_geo_area, na_item == "B9", sector == "S13", unit %in% c("MIO_EUR", "PC_GDP"), s_adj %in% c("SCA","NSA")) %>%
      mutate(id = paste0("GOVDFSU",unit, s_adj,geo)) %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD, adjustment = s_adj) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("gov_10q_ggnfa fetched successfully"))
    result
  }, error = function(e) { message("gov_10q_ggnfa failed"); NULL })
  #  Government debt (consolidated level GD):  Million Euro and percent of GDP 
  eurostat_government_debt <- tryCatch({
    result <- get_eurostat_series("gov_10q_ggdebt") %>%
      filter(geo %in% eurostat_geo_area, na_item == "GD", sector == "S13", unit %in% c("PC_GDP","MIO_EUR")) %>%
      mutate(id = paste0("GOVDEP",unit,geo), adjustment = "NSA") %>%
      rename(frequency = freq, value = values, date = TIME_PERIOD) %>%
      select(id, value, frequency, date) %>%
      left_join(tribble %>% select(id, name, label, source, unit, adjustment), by = "id")
    message(paste0("gov_10q_ggdebt fetched successfully"))
    result
  }, error = function(e) { message("gov_10q_ggdebt failed"); NULL })
  # Rbind all the eurostat series
  df <- rbind(eurostat_inflation, eurostat_employment_rate, eurostat_unemployment_rate, eurostat_house_price, eurostat_real_gdp, eurostat_real_total_consumption, eurostat_real_final_household_consumption, eurostat_real_investment, household_saving, eurostat_business_investment, eurostat_government_deficit_surplus, eurostat_government_debt) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_ecb       <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from ECB source
  # 1. Input : tribble    = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format
  #-----------------------------------------------------------------------------
  # AAA-rated government bonds — Spot rates (zero-coupon)
  #-----------------------------------------------------------------------------
  ecb_yc_aaa_sr_3m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_3M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_4m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_4M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_5m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_5M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_6m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_6M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_7m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_7M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_8m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_8M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_9m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_9M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_10m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_10M") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_11m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_11M") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_1y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_1Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_2y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_2Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_3y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_3Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_4y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_4Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_5y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_5Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_6y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_6Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_7y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_7Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_8y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_8Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_9y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_9Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_10y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_10Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_11y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_11Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_12y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_12Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_13y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_13Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_14y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_14Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_15y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_15Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_16y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_16Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_17y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_17Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_18y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_18Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_19y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_19Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_20y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_20Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_21y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_21Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_22y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_22Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_23y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_23Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_24y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_24Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_25y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_25Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_26y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_26Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_27y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_27Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_28y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_28Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_29y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_29Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_sr_30y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.SR_30Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  #-----------------------------------------------------------------------------
  # AAA-rated government bonds — Instantaneous forward rates
  #-----------------------------------------------------------------------------
  ecb_yc_aaa_if_3m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_3M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_4m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_4M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_5m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_5M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_6m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_6M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_7m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_7M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_8m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_8M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_9m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_9M")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_10m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_10M") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_11m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_11M") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_1y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_1Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_2y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_2Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_3y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_3Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_4y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_4Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_5y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_5Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_6y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_6Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_7y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_7Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_8y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_8Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_9y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_9Y")  %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_10y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_10Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_11y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_11Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_12y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_12Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_13y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_13Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_14y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_14Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_15y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_15Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_16y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_16Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_17y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_17Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_18y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_18Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_19y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_19Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_20y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_20Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_21y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_21Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_22y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_22Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_23y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_23Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_24y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_24Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_25y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_25Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_26y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_26Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_27y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_27Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_28y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_28Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_29y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_29Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_aaa_if_30y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_A.SV_C_YM.IF_30Y") %>% mutate(id = paste0("ECB_YC_AAA_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  #-----------------------------------------------------------------------------
  # All government bonds — Spot rates
  #-----------------------------------------------------------------------------
  ecb_yc_all_sr_3m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_3M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_4m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_4M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_5m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_5M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_6m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_6M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_7m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_7M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_8m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_8M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_9m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_9M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_10m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_10M") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_11m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_11M") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_1y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_1Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_2y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_2Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_3y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_3Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_4y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_4Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_5y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_5Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_6y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_6Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_7y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_7Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_8y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_8Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_9y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_9Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_10y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_10Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_11y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_11Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_12y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_12Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_13y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_13Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_14y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_14Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_15y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_15Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_16y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_16Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_17y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_17Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_18y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_18Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_19y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_19Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_20y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_20Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_21y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_21Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_22y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_22Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_23y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_23Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_24y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_24Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_25y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_25Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_26y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_26Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_27y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_27Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_28y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_28Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_29y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_29Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_sr_30y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.SR_30Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  #-----------------------------------------------------------------------------
  # All government bonds — Instantaneous forward rates
  #-----------------------------------------------------------------------------
  ecb_yc_all_if_3m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_3M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_4m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_4M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_5m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_5M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_6m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_6M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_7m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_7M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_8m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_8M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_9m  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_9M")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_10m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_10M") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_11m <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_11M") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_1y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_1Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_2y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_2Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_3y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_3Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_4y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_4Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_5y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_5Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_6y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_6Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_7y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_7Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_8y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_8Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_9y  <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_9Y")  %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_10y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_10Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_11y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_11Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_12y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_12Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_13y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_13Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_14y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_14Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_15y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_15Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_16y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_16Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_17y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_17Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_18y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_18Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_19y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_19Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_20y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_20Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_21y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_21Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_22y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_22Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_23y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_23Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_24y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_24Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_25y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_25Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_26y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_26Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_27y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_27Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_28y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_28Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_29y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_29Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  ecb_yc_all_if_30y <- tryCatch(get_ecb_yield(id = "YC.B.U2.EUR.4F.G_N_C.SV_C_YM.IF_30Y") %>% mutate(id = paste0("ECB_YC_ALL_",id)) %>% left_join(tribble %>% select(id, name, label, source, unit, adjustment, frequency), by = "id"), error = function(e) NULL)
  #-----------------------------------------------------------------------------
  # Bind all
  #-----------------------------------------------------------------------------
  df <- bind_rows(
    ecb_yc_aaa_sr_3m,  ecb_yc_aaa_sr_4m,  ecb_yc_aaa_sr_5m,  ecb_yc_aaa_sr_6m,
    ecb_yc_aaa_sr_7m,  ecb_yc_aaa_sr_8m,  ecb_yc_aaa_sr_9m,  ecb_yc_aaa_sr_10m,
    ecb_yc_aaa_sr_11m, ecb_yc_aaa_sr_1y,  ecb_yc_aaa_sr_2y,
    ecb_yc_aaa_sr_3y,  ecb_yc_aaa_sr_4y,  ecb_yc_aaa_sr_5y,  ecb_yc_aaa_sr_6y,
    ecb_yc_aaa_sr_7y,  ecb_yc_aaa_sr_8y,  ecb_yc_aaa_sr_9y,  ecb_yc_aaa_sr_10y,
    ecb_yc_aaa_sr_11y, ecb_yc_aaa_sr_12y, ecb_yc_aaa_sr_13y, ecb_yc_aaa_sr_14y,
    ecb_yc_aaa_sr_15y, ecb_yc_aaa_sr_16y, ecb_yc_aaa_sr_17y, ecb_yc_aaa_sr_18y,
    ecb_yc_aaa_sr_19y, ecb_yc_aaa_sr_20y, ecb_yc_aaa_sr_21y, ecb_yc_aaa_sr_22y,
    ecb_yc_aaa_sr_23y, ecb_yc_aaa_sr_24y, ecb_yc_aaa_sr_25y, ecb_yc_aaa_sr_26y,
    ecb_yc_aaa_sr_27y, ecb_yc_aaa_sr_28y, ecb_yc_aaa_sr_29y, ecb_yc_aaa_sr_30y,
    ecb_yc_aaa_if_3m,  ecb_yc_aaa_if_4m,  ecb_yc_aaa_if_5m,  ecb_yc_aaa_if_6m,
    ecb_yc_aaa_if_7m,  ecb_yc_aaa_if_8m,  ecb_yc_aaa_if_9m,  ecb_yc_aaa_if_10m,
    ecb_yc_aaa_if_11m, ecb_yc_aaa_if_1y,  ecb_yc_aaa_if_2y,
    ecb_yc_aaa_if_3y,  ecb_yc_aaa_if_4y,  ecb_yc_aaa_if_5y,  ecb_yc_aaa_if_6y,
    ecb_yc_aaa_if_7y,  ecb_yc_aaa_if_8y,  ecb_yc_aaa_if_9y,  ecb_yc_aaa_if_10y,
    ecb_yc_aaa_if_11y, ecb_yc_aaa_if_12y, ecb_yc_aaa_if_13y, ecb_yc_aaa_if_14y,
    ecb_yc_aaa_if_15y, ecb_yc_aaa_if_16y, ecb_yc_aaa_if_17y, ecb_yc_aaa_if_18y,
    ecb_yc_aaa_if_19y, ecb_yc_aaa_if_20y, ecb_yc_aaa_if_21y, ecb_yc_aaa_if_22y,
    ecb_yc_aaa_if_23y, ecb_yc_aaa_if_24y, ecb_yc_aaa_if_25y, ecb_yc_aaa_if_26y,
    ecb_yc_aaa_if_27y, ecb_yc_aaa_if_28y, ecb_yc_aaa_if_29y, ecb_yc_aaa_if_30y,
    ecb_yc_all_sr_3m,  ecb_yc_all_sr_4m,  ecb_yc_all_sr_5m,  ecb_yc_all_sr_6m,
    ecb_yc_all_sr_7m,  ecb_yc_all_sr_8m,  ecb_yc_all_sr_9m,  ecb_yc_all_sr_10m,
    ecb_yc_all_sr_11m, ecb_yc_all_sr_1y,  ecb_yc_all_sr_2y,
    ecb_yc_all_sr_3y,  ecb_yc_all_sr_4y,  ecb_yc_all_sr_5y,  ecb_yc_all_sr_6y,
    ecb_yc_all_sr_7y,  ecb_yc_all_sr_8y,  ecb_yc_all_sr_9y,  ecb_yc_all_sr_10y,
    ecb_yc_all_sr_11y, ecb_yc_all_sr_12y, ecb_yc_all_sr_13y, ecb_yc_all_sr_14y,
    ecb_yc_all_sr_15y, ecb_yc_all_sr_16y, ecb_yc_all_sr_17y, ecb_yc_all_sr_18y,
    ecb_yc_all_sr_19y, ecb_yc_all_sr_20y, ecb_yc_all_sr_21y, ecb_yc_all_sr_22y,
    ecb_yc_all_sr_23y, ecb_yc_all_sr_24y, ecb_yc_all_sr_25y, ecb_yc_all_sr_26y,
    ecb_yc_all_sr_27y, ecb_yc_all_sr_28y, ecb_yc_all_sr_29y, ecb_yc_all_sr_30y,
    ecb_yc_all_if_3m,  ecb_yc_all_if_4m,  ecb_yc_all_if_5m,  ecb_yc_all_if_6m,
    ecb_yc_all_if_7m,  ecb_yc_all_if_8m,  ecb_yc_all_if_9m,  ecb_yc_all_if_10m,
    ecb_yc_all_if_11m, ecb_yc_all_if_1y,  ecb_yc_all_if_2y,
    ecb_yc_all_if_3y,  ecb_yc_all_if_4y,  ecb_yc_all_if_5y,  ecb_yc_all_if_6y,
    ecb_yc_all_if_7y,  ecb_yc_all_if_8y,  ecb_yc_all_if_9y,  ecb_yc_all_if_10y,
    ecb_yc_all_if_11y, ecb_yc_all_if_12y, ecb_yc_all_if_13y, ecb_yc_all_if_14y,
    ecb_yc_all_if_15y, ecb_yc_all_if_16y, ecb_yc_all_if_17y, ecb_yc_all_if_18y,
    ecb_yc_all_if_19y, ecb_yc_all_if_20y, ecb_yc_all_if_21y, ecb_yc_all_if_22y,
    ecb_yc_all_if_23y, ecb_yc_all_if_24y, ecb_yc_all_if_25y, ecb_yc_all_if_26y,
    ecb_yc_all_if_27y, ecb_yc_all_if_28y, ecb_yc_all_if_29y, ecb_yc_all_if_30y
  ) %>%
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_euribor   <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Euribor source
  # 1. Input : tribble    = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # Euribor 1 week
  euribor_1w <- tryCatch({
    result <- get_euribor_series(id = "EURIBOR1W", maturity_label = "1 week") %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("EURIBOR1W fetched successfully"))
    result
  }, error = function(e) { message("EURIBOR1W failed"); NULL })
  # Euribor 1 month
  euribor_1m <- tryCatch({
    result <- get_euribor_series(id = "EURIBOR1M", maturity_label = "1 month") %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("EURIBOR1M fetched successfully"))
    result
  }, error = function(e) { message("EURIBOR1M failed"); NULL })
  # Euribor 3 months
  euribor_3m <- tryCatch({
    result <- get_euribor_series(id = "EURIBOR3M", maturity_label = "3 months") %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("EURIBOR3M fetched successfully"))
    result
  }, error = function(e) { message("EURIBOR3M failed"); NULL })
  # Euribor 6 months
  euribor_6m <- tryCatch({
    result <- get_euribor_series(id = "EURIBOR6M", maturity_label = "6 months") %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("EURIBOR6M fetched successfully"))
    result
  }, error = function(e) { message("EURIBOR6M failed"); NULL })
  # Euribor 12 months
  euribor_12m <- tryCatch({
    result <- get_euribor_series(id = "EURIBOR12M", maturity_label = "12 months") %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message(paste0("EURIBOR12M fetched successfully"))
    result
  }, error = function(e) { message("EURIBOR12M failed"); NULL })
  df <- bind_rows(euribor_1w, euribor_1m, euribor_3m, euribor_6m, euribor_12m) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_cnn       <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from CNN source
  # 1. Input : tribble    = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # CNN Series
  #-----------------------------------------------------------------------------
  # Get the greed and fear pages headers 
  response <- GET(greed_and_fear_url, add_headers(
    "User-Agent"      = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
    "Referer"         = "https://money.cnn.com/data/fear-and-greed/",
    "Accept"          = "application/json, text/plain, */*",
    "Accept-Language" = "en-US,en;q=0.9"))
  # Transform headers in a list of data
  data <- fromJSON(rawToChar(response$content))
  # Great and Fear Historic 
  greatfear_index <- tryCatch({
    result <- data$fear_and_greed_historical$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFI") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("Great and Fear Historic fetched successfully"); result
  }, error = function(e) { message("Great and Fear Historic failed"); NULL })
  # Market Momentum Indicator, S&P500
  sp500_indicator <- tryCatch({
    result <- data$market_momentum_sp500$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFMMSP500") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("S&P500 fetched successfully"); result
  }, error = function(e) { message("S&P500 fetched successfully failed"); NULL })
  # Market Momentum Indicator, S&P500 125-day Moving Average
  sp500ma_indicator <- tryCatch({
    result <- data$market_momentum_sp125$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFMMSP500MA") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("S&P500 125-day Moving Average fetched successfully"); result
  }, error = function(e) { message("S&P500 125-day Moving Average failed"); NULL })
  # Stock Price Strength Indicator, Net new 52-week Highs and Lows on the NYSE
  stock_price_strength <- tryCatch({
    result <- data$stock_price_strength$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFSPS") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("Net new 52-week Highs and Lows on the NYSE fetched successfully"); result
  }, error = function(e) { message("Net new 52-week Highs and Lows on the NYSE failed"); NULL })
  # Stock Price Strength Indicator, McClellan Volume Summation Index 
  stock_price_breadth <- tryCatch({
    result <- data$stock_price_breadth$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFSPB") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("McClellan Volume Summation Index  fetched successfully"); result
  }, error = function(e) { message("McClellan Volume Summation Index failed"); NULL })
  # Put and Call Options Indicator, 5-day Average Put/Call Ratio
  put_call_options <- tryCatch({
    result <- data$put_call_options$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFPCO") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("5-day Average Put/Call Ratio fetched successfully"); result
  }, error = function(e) { message("5-day Average Put/Call Ratio failed"); NULL })
  # Market Volatility Indicator, VIX
  market_volatility_vix <- tryCatch({
    result <- data$market_volatility_vix$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFMV") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("VIX fetched successfully"); result
  }, error = function(e) { message("VIX failed"); NULL })
  # Market Volatility Indicator, VIX 50-day Moving
  market_volatility_vix_50 <- tryCatch({
    result <- data$market_volatility_vix_50$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFMVMA") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("VIX 50-day Moving fetched successfully"); result
  }, error = function(e) { message("VIX 50-day Moving failed"); NULL })
  # Safe Haven Demand Indicator, Difference in 20-day Stock and Bond Returns
  safe_haven_demand <- tryCatch({
    result <- data$safe_haven_demand$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFSHD") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("Difference in 20-day Stock and Bond Returns fetched successfully"); result
  }, error = function(e) { message("Difference in 20-day Stock and Bond Returns failed"); NULL })
  # Junk Bond Demand Indicator, Yield Spread: Junk Bonds vs. Investment grade 
  junk_bond_demand <- tryCatch({
    result <- data$junk_bond_demand$data %>%
      mutate(date = as.Date(as.POSIXct(x / 1000, origin = "1970-01-01", tz = "UTC")), id = "GFJBD") %>%
      select(-x) %>% rename(value = y) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("Yield Spread: Junk Bonds vs. Investment grade  fetched successfully"); result
  }, error = function(e) { message("Yield Spread: Junk Bonds vs. Investment grade  failed"); NULL })
  df <- rbind(greatfear_index, sp500_indicator, sp500ma_indicator, stock_price_strength, stock_price_breadth, put_call_options, market_volatility_vix, market_volatility_vix_50, safe_haven_demand, junk_bond_demand) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_investing <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Investing source
  # 1. Input : tribble    = mapping inputs table 
  # Output   : dataframe for the chosen serie(s) with standardized format 
  #-----------------------------------------------------------------------------
  # Investing Series
  #-----------------------------------------------------------------------------
  # Baltic Dry Index
  bdi <- tryCatch({
    result <- get_investing_market_series(id = 940793, date_from = "1985-01-01", date_to = Sys.Date()) %>%
      mutate(id = "BDIINV") %>%
      left_join(tribble %>% select(id, name, label, source, unit), by = "id")
    message("Baltic Dry Index fetched successfully")
    result
  }, error = function(e) { message("Baltic Dry Index failed"); NULL })
  timeout(10)
  # ISM Manufacturing Purchasing Managers Index PMI
  ism <- tryCatch({
    result <- get_investing_indicator_series(id = 173, date_from = "1970-01-01", date_to = Sys.Date()) %>%
      mutate(id = "ISMPMIINV") %>%
      left_join(tribble %>% select(id, name, label, source, unit), by = "id")
    message("ISM Manufacturing PMI fetched successfully")
    result
  }, error = function(e) { message("ISM Manufacturing PMI failed"); NULL })
  timeout(10)
  # ZEW Economic Sentiment Index 
  zew <- tryCatch({
    result <- get_investing_indicator_series(id = 310, date_from = "1970-01-01", date_to = Sys.Date()) %>%
      mutate(id = "ZEWINV") %>%
      left_join(tribble %>% select(id, name, label, source, unit), by = "id")
    message("ZEW Economic Sentiment Index fetched successfully")
    result
  }, error = function(e) { message("ZEW Economic Sentiment Index failed"); NULL })
  df <- rbind(bdi, ism, zew) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_imf       <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from IMF Source
  # 1. Input : tribble    = mapping inputs table 
  # Output   : dataframe for the chosen series with standardized format
  #-----------------------------------------------------------------------------
  # IMF Series
  #-----------------------------------------------------------------------------
  area_key <- paste(imf_geo_area, collapse = "+")
  set_config(config(ssl_verifypeer = 0L))
  # Gold Reserves at Market Value (SDR)
  gold_market_value <- tryCatch({
    result <- as.data.frame(
      readSDMX(providerId = "IMF_DATA", resource = "data", flowRef = "IMF.STA,IL", key = paste0(area_key, ".RGOLDMV_REVS."))) %>%
      rename(geo = COUNTRY, frequency = FREQUENCY, value = OBS_VALUE, date = TIME_PERIOD) %>%
      filter(frequency == "M") %>%
      mutate(id = paste0("RGOLDMV_REVS",geo), adjustment = "NA", value = as.numeric(value), date = as.Date(paste0(substr(date, 1, 4), "-", substr(date, 7, 8), "-01"))) %>%
      select(id, value, date, adjustment) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency), by = "id")
    message("Gold Reserves at Market Value fetched successfully")
    result
  }, error = function(e) { message("Gold Reserves at Market Value failed"); NULL })
  # Gold Reserves Volume (Fine Troy Ounces)
  gold_volume_reserve <- tryCatch({
    result <- as.data.frame(
      readSDMX(providerId = "IMF_DATA", resource = "data", flowRef = "IMF.STA,IL", key = paste0(area_key, ".RGV_REVS."))) %>%
      rename(geo = COUNTRY, frequency = FREQUENCY, value = OBS_VALUE, date = TIME_PERIOD) %>%
      filter(frequency == "M") %>%
      mutate(id = paste0("RGV_REVS",geo), adjustment = "NA", value = as.numeric(value), date = as.Date(paste0(substr(date, 1, 4), "-", substr(date, 7, 8), "-01"))) %>%
      select(id, value, date, adjustment) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency), by = "id")
    message("Gold Reserves Volume fetched successfully")
    result
  }, error = function(e) { message("Gold Reserves Volume failed"); NULL })
  # M2 Broad Money (Depository Corporations Survey)
  m2_broad_money <- tryCatch({
    result <- as.data.frame(
      readSDMX(providerId = "IMF_DATA", resource = "data", flowRef = "IMF.STA,MFS_DC", key = paste0(area_key,".DCORP_L_BM"))) %>%
      rename(geo = COUNTRY, frequency = FREQUENCY, value = OBS_VALUE, date = TIME_PERIOD) %>%
      filter(frequency == "M") %>%
      mutate(id = paste0("DCORP_L_BM", geo), adjustment = "NA", value = as.numeric(value), date = as.Date(paste0(substr(date, 1, 4), "-", substr(date, 7, 8), "-01"))) %>%
      select(id, value, date, adjustment) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency), by = "id")
    message("M2 Broad Money fetched successfully")
    result
  }, error = function(e) { message("M2 Broad Money failed"); NULL })
  df <- rbind(gold_market_value, gold_volume_reserve, m2_broad_money) %>% 
    distinct(id, date, .keep_all = TRUE) %>%
    na.omit()
  return(df)
}
reformate_data_epu       <- function(tribble) {
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Economic Policy Uncertainty source
  # Input    : tribble = mapping inputs table
  # Output   : dataframe for the chosen serie(s) with standardized format
  #-----------------------------------------------------------------------------
  # EPU US
  epu_us <- tryCatch({
    tmp <- tempfile(fileext = ".xlsx")
    GET(epu_us_url, write_disk(tmp, overwrite = TRUE))
    result <- read_excel(tmp) %>%
      mutate(date = as.Date(paste(Year, Month, "01", sep = "-"), format = "%Y-%m-%d")) %>%
      select(-Year, -Month) %>%
      pivot_longer(cols = -date, names_to = "id", values_to = "value") %>%
      mutate(id = "EPUUSM") %>% 
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("EPU US fetched successfully")
    result
  }, error = function(e) {
    message("EPU US failed"); NULL })
  # EPU Global
  epu_global <- tryCatch({
    tmp <- tempfile(fileext = ".xlsx")
    GET(epu_global_url, write_disk(tmp, overwrite = TRUE))
    result <- read_excel(tmp) %>%
      mutate(date = as.Date(paste(Year, Month, "01", sep = "-"), format = "%Y-%m-%d")) %>%
      select(-Year, -Month) %>%
      pivot_longer(cols = -date, names_to = "id", values_to = "value") %>%
      mutate(id = toupper(paste0(id,"M"))) %>% 
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("EPU Global fetched successfully")
    result
  }, error = function(e) {
    message("EPU Global failed"); NULL })
  # EPU Canada
  epu_canada <- tryCatch({
    tmp <- tempfile(fileext = ".xlsx")
    GET(epu_canada_url, write_disk(tmp, overwrite = TRUE))
    result <- read_excel(tmp) %>%
      mutate(date = as.Date(paste(Year, Month, "01", sep = "-"), format = "%Y-%m-%d")) %>%
      select(-Year, -Month) %>%
      pivot_longer(cols = -date, names_to = "id", values_to = "value") %>%
      mutate(id = "EPUCANM") %>% 
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("EPU Canada fetched successfully")
    result
  }, error = function(e) {
    message("EPU Canada failed"); NULL })
  # EPU UK
  epu_uk <- tryCatch({
    tmp <- tempfile(fileext = ".xlsx")
    GET(epu_uk_url, write_disk(tmp, overwrite = TRUE))
    result <- read_excel(tmp) %>%
      mutate(date = as.Date(paste(year, month, "01", sep = "-"), format = "%Y-%m-%d")) %>%
      select(-year, -month) %>%
      pivot_longer(cols = -date, names_to = "id", values_to = "value") %>%
      mutate(id = "EPUUKM") %>% 
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("EPU UK fetched successfully")
    result
  }, error = function(e) {
    message("EPU UK failed"); NULL })
  # EPU Europe (Europe, France, Germany, Italy and Spain)
  epu_europe <- tryCatch({
    tmp <- tempfile(fileext = ".xlsx")
    GET(epu_europe_url, write_disk(tmp, overwrite = TRUE))
    result <- read_excel(tmp) %>%
      mutate(date = as.Date(paste(Year, Month, "01", sep = "-"), format = "%Y-%m-%d")) %>%
      select(-Year, -Month) %>%
      pivot_longer(cols = -date, names_to = "id", values_to = "value") %>%
      filter(!str_detect(id, "UK")) %>%
      mutate(id = case_when(str_detect(id, "France")  ~ "EPUFR",str_detect(id, "Germany") ~ "EPUDE",str_detect(id, "Italy")   ~ "EPUIT",str_detect(id, "Spain")   ~ "EPUES",str_detect(id, "Europe")  ~ "EPUEU",TRUE ~ id)) %>%
      mutate(id = toupper(paste0(id,"M"))) %>% 
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id")
    message("EPU Europe fetched successfully")
    result
  }, error = function(e) {
    message("EPU Europe failed"); NULL })
    df <- bind_rows(epu_us, epu_global, epu_canada, epu_uk, epu_europe) %>% 
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
  return(df)
}
reformate_data_ccc       <- function(tribble){
  #-----------------------------------------------------------------------------
  # Function : Reformat data from CoinMarketCap source
  # 1. Input : tribble    = mapping inputs table
  # Output   : dataframe for the chosen serie(s) with standardized format
  #-----------------------------------------------------------------------------
  # CCC Series
  #-----------------------------------------------------------------------------
  # Crypto Fear & Greed Index
  ccc_fear_greed <- tryCatch({
    response <- GET(ccc_fg_url, add_headers("User-Agent" = "Mozilla/5.0"))
    data <- fromJSON(rawToChar(response$content))
    result <- data$data %>%
      mutate(date   = as.Date(as.POSIXct(as.numeric(timestamp), origin = "1970-01-01", tz = "UTC")),value  = as.numeric(value),rating = tolower(value_classification),id = "CCCFG") %>%
      select(date, value, rating, id) %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>%
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
    message("Crypto Fear & Greed fetched successfully"); result
  }, error = function(e) { message("Crypto Fear & Greed failed"); NULL })
  return(ccc_fear_greed)
}
reformate_data_gpr       <- function(tribble) {
  #-----------------------------------------------------------------------------
  # Function : Reformat data from Geopolitical Risk Index source
  # Input    : tribble = mapping inputs table
  # Output   : dataframe for the chosen serie(s) with standardized format
  #-----------------------------------------------------------------------------
  # GPR
  gpr <- tryCatch({
    tmp <- tempfile(fileext = ".xls")
    GET(gpr_url, write_disk(tmp, overwrite = TRUE))
    result <- read_excel(tmp) %>%
      select(-event,-DAY,-N10D, -var_name, -var_label) %>% 
      pivot_longer(cols      = c(GPRD, GPRD_ACT, GPRD_THREAT, GPRD_MA30, GPRD_MA7),names_to  = "id",values_to = "value") %>%
      left_join(tribble %>% select(id, name, label, source, unit, frequency, adjustment), by = "id") %>% 
      distinct(id, date, .keep_all = TRUE) %>%
      na.omit()
    message("Geopolitical Risk Index fetched successfully")
    result
  }, error = function(e) {
    message("Geopolitical Risk Index failed"); NULL
  })
}

