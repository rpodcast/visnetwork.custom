library(shiny)
library(visNetwork)
library(shinyWidgets)

ui <- fluidPage(
  html_dependency_viscustom(),
  fluidRow(
    column(
      width = 3,
      actionButton(
        "delete_node",
        "Delete Node"
      )
    ),
    column(
      width = 3,
      actionButton(
        "add_node_mode",
        "Enter Add Node"
        #onclick = "addNode();"
      )
    ),
    column(
      width = 3,
      actionButton(
        "add_edge_mode",
        "Enter Add Edge"
      )
    )
  ),
  fluidRow(
    column(
      width = 12,
      h3("Network Display"),
      visNetworkOutput("network_all", height = "600px")
    )
  ),
  fluidRow(
    column(
      width = 3,
      h4("graphChange output"),
      verbatimTextOutput("view_manip")
    ),
    column(
      width = 3,
      h4("click event"),
      verbatimTextOutput("view_click")
    ),
    column(
      width = 3,
      h4("nodes proxy"),
      verbatimTextOutput("view_nodesproxy"),
      verbatimTextOutput("view_edgesproxy")
    ),
    column(
      width = 3,
      h4("edit_mode"),
      verbatimTextOutput("view_edit")
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
      visOptions(manipulation = list(
        enabled = FALSE,
        addNode = htmlwidgets::JS("onAddNode"),
        addEdge = htmlwidgets::JS("onAddEdge"),
        deleteNode = htmlwidgets::JS("deleteNodeFunction")
      ))
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
  
  output$view_edgesproxy <- renderPrint({
    input$network_all_get_edges
  })
  
  output$view_edit <- renderPrint({
    input$edit_mode
  })
  
  observeEvent(input$hide, {
    toggleDisplay(id = "test", display = FALSE)
  })
  
  observeEvent(input$add_node_mode, {
    visNetworkProxy("network_all") |>
      visAddNodeMode()
      #visGrabNetwork()
  })
  
  observeEvent(input$add_edge_mode, {
    visNetworkProxy("network_all") |>
      visAddEdgeMode()
  })
}

shinyApp(ui, server)