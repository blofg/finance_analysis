
################################################################################
# Metadata Display
################################################################################

# Add a View button column to the database display
input_database_display <- input_database
input_database_display$view_series <- paste0(
  '<button onclick="Shiny.setInputValue(\'btn\', \'',
  input_database$name,
  '\', {priority: \'event\'})" style="font-size:11px;padding:2px 6px;">View</button>')

# Build the Shiny app
app <- shinyApp(
  ui = fluidPage(DTOutput("table")),
  server = function(input, output, session) {
    output$table <- renderDT(datatable(
      input_database_display, escape = FALSE,
      options = list(scrollY = "calc(100vh - 120px)", scrollCollapse = TRUE)), server = TRUE)
    observeEvent(input$btn, {
      df <- series_database[[input$btn]]
      if (!is.null(df)) View(df, title = input$btn) }) })

# Launch in RStudio Viewer pane
runGadget(app, viewer = paneViewer())