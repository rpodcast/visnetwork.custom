library(shiny)
library(visNetwork)

ui <- fluidPage(
  fluidRow(
    column(
      width = 12,
      h3("Network Display"),
      visNetworkOutput("network_all", height = "600px")
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
      h4("nodes proxy"),
      verbatimTextOutput("view_nodesproxy")
    )
  )
)

server <- function(input, output, session) {
  output$network_all <- renderVisNetwork({
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
  
  # run every 1 second to obtain correct X and Y node positions
  observe({
    invalidateLater(1000)
    visNetworkProxy("network_all") |>
      visGetNodes(input = "network_all_get_nodes", addCoordinates = TRUE) |>
      visGetEdges(input = "network_all_get_edges") |>
      visGetSelectedNodes(input = "network_all_get_selectedNodes") |>
      visGetSelectedEdges(input = "network_all_get_selectedEdges") |>
      visGetSelection(input = "network_all_get_selection")
  })
  
  output$view_manip <- renderPrint({
    input$network_all_graphChange
  })
  
  output$view_click <- renderPrint({
    input$click_object
  })
  
  output$view_nodesproxy <- renderPrint({
    input$network_all_get_nodes
  })
}

shinyApp(ui, server)