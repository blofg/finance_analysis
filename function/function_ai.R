
################################################################################
# IA/LLM functions
################################################################################

# Functions to summarise key stats for Ollama llm analysis
summarize_for_ollama_chat <- function(df, last_n = 12) {
  #-----------------------------------------------------------------------------
  # Function : Summarise series statistics for Ollama chat analysis
  # 1. Input : df      = dataframe containing at least date, value, name, label
  # 2. Input : last_n  = number of last observations for rolling statistics
  # Output   : dataframe with descriptive statistics by series
  #-----------------------------------------------------------------------------
  out <- df %>%
    group_by(name, label) %>%
    summarise(
      start       = min(date, na.rm=TRUE),
      end         = max(date, na.rm=TRUE),
      last        = last(value),
      fst_prev    = nth(value, n() - 1),
      scd_prev    = nth(value, n() - 2),
      thr_prev    = nth(value, n() - 3),
      diff1       = last - fst_prev,
      diff2       = last - scd_prev,
      diff3       = last - thr_prev,
      max         = max(value, na.rm=TRUE),
      min         = min(value, na.rm=TRUE),
      max_last_n  = max(tail(value, min(last_n, n())), na.rm = TRUE),
      mean_last_n = min(tail(value, min(last_n, n())), na.rm = TRUE),
      mean        = mean(value,  na.rm = TRUE),
      sd          = sd(value,  na.rm = TRUE),
      mean_last_n = mean(tail(value, min(last_n, n())), na.rm=TRUE),
      sd_last_n   = sd(tail(value, min(last_n, n())), na.rm=TRUE),
      .groups = "drop") %>%
    ungroup() %>% 
    mutate(label = label)
  out
}