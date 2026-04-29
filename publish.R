################################################################################
# Publish Reports to GitHub Pages
################################################################################

# Geo reports 
geo_reports <- list(
  "us_report_html.html"  = file.path(path_main, "html/geo_reports/output"),
  "eu_report_html.html"  = file.path(path_main, "html/geo_reports/output"),
  "ch_report_html.html"  = file.path(path_main, "html/geo_reports/output"),
  "wrl_report_html.html" = file.path(path_main, "html/geo_reports/output"))

# Market reports
market_reports <- list(
  "equity_index_report_html.html"                = file.path(path_main, "html/market_reports/output"),
  "key_indices_and_indicators_report_html.html"  = file.path(path_main, "html/market_reports/output"),
  "gold_fundamentals_report_html.html"           = file.path(path_main, "html/market_reports/output"),
  "crypto_report_html.html"                      = file.path(path_main, "html/market_reports/output"),
  "bond_market_report_html.html"                = file.path(path_main, "html/market_reports/output")
)

# Share reports: Magnificent 7 
mag7_reports <- list(
  "magnificent_aapl_report_html.html"  = file.path(path_main, "html/share_reports/mag7/output"),
  "magnificent_msft_report_html.html"  = file.path(path_main, "html/share_reports/mag7/output"),
  "magnificent_googl_report_html.html" = file.path(path_main, "html/share_reports/mag7/output"),
  "magnificent_nvda_report_html.html"  = file.path(path_main, "html/share_reports/mag7/output"),
  "magnificent_amzn_report_html.html"  = file.path(path_main, "html/share_reports/mag7/output"),
  "magnificent_meta_report_html.html"  = file.path(path_main, "html/share_reports/mag7/output"),
  "magnificent_tsla_report_html.html"  = file.path(path_main, "html/share_reports/mag7/output"))

# Output folder structure in the GitHub repo
out_root    <- path_finance_reports_output_folder    
out_geo     <- file.path(out_root)                  
out_market  <- file.path(out_root)                  
out_mag7    <- file.path(out_root, "share", "mag7")  

# Create sub-directories if they don't exist yet
dir.create(out_mag7, recursive = TRUE, showWarnings = FALSE)

# Copy helper
copy_reports <- function(report_map, dest_folder) {
  for (report_name in names(report_map)) {
    src  <- file.path(report_map[[report_name]], report_name)
    dest <- file.path(dest_folder, report_name)
    if (file.exists(src)) {
      file.copy(src, dest, overwrite = TRUE)
      message("✓ Copied:  ", report_name, "  →  ", dest_folder)
    } else {
      message("– Skipped: ", report_name, "  (file not found at ", src, ")")}}}

# Copy all reports
copy_reports(geo_reports,    out_geo)
copy_reports(market_reports, out_market)
copy_reports(mag7_reports,   out_mag7)

# Stage, commit and push
timestamp  <- format(Sys.time(), "%Y-%m-%d %H:%M")
commit_msg <- paste0("update reports — ", timestamp)
system(paste0('cd "', path.expand(path_finance_reports_folder), '" && ','git add reports/ index.html && ','git commit -m "', commit_msg, '" && ','git push'))
message("Done — reports published to https://blofg.github.io/finance_reports")
