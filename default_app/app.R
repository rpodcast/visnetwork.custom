library(shiny)
library(visNetwork)

ui <- fluidPage(
  fluidRow(
    column(
      width = 12,
      h3("Network Display"),
      visNetworkOutput("network_manip", height = "600px")
    )
  ),
  fluidRow(
    column(
      width = 4,
      h4("graphChange output"),
      verbatimTextOutput("view_manip")
    ),
    column(
      width = 4,
      h4("click event"),
      verbatimTextOutput("view_click")
    ),
    column(
      width = 4,
      h4("drag end"),
      verbatimTextOutput("view_dragEnd")
    )
  )
)

server <- function(input, output, session) {
  output$network_manip <- renderVisNetwork({
    nodes <- data.frame(
      id = "node1",
      label = "Node 1"
    )
    
    visNetwork(nodes, edges = NULL) |>
      visPhysics(enabled = FALSE) |>
      visInteraction(
        multiselect = TRUE,
        selectConnectedEdges = TRUE
      ) |>
      visEvents(
        click = "function(params) {
          Shiny.onInputChange('click_object', params);
        }",
        dragEnd = "function(params) {
          Shiny.onInputChange('drag_object', params);
        }"
      ) |>
      visOptions(manipulation = TRUE)
  })
  
  output$view_manip <- renderPrint({
    input$network_manip_graphChange
  })
  
  output$view_click <- renderPrint({
    input$click_object
  })
  
  output$view_dragEnd <- renderPrint({
    input$drag_object
  })
}

shinyApp(ui, server)