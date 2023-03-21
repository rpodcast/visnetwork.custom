library(shiny)
library(visNetwork)
library(shinyWidgets)

ui <- fluidPage(
  html_dependency_viscustom(),
  fluidRow(
    column(
      width = 12,
      conditionalPanel(
        condition = "output.add_node_mode",
        alert(
          status = "success",
          tags$b("Edit Mode:"),
          "Click on a point in the canvas to create a new node."
        )
      ),
      conditionalPanel(
        condition = "output.add_edge_mode",
        alert(
          status = "success",
          tags$b("Edit Mode:"),
          "Add new edge"
        )
      )
    )
  ),
  fluidRow(
    column(
      width = 3,
      dropdownButton(
        tags$h4("Scheme Ops"),
        actionBttn(
          "add_node",
          label = "Add Node",
          style = "gradient",
          color = "royal",
          icon = icon("rectangle-list")
        ),
        actionBttn(
          "edit_node",
          label = "Edit Node",
          style = "gradient",
          color = "warning",
          icon = icon("pen-to-square")
        ),
        actionBttn(
          "add_edge",
          label = "Add Edge",
          style = "gradient",
          color = "success",
          icon = icon("arrow-up-from-bracket")
        ),
        actionBttn(
          "edit_edge",
          label = "Edit Edge",
          style = "gradient",
          color = "warning",
          icon = icon("code-merge")
        ),
        actionBttn(
          "delete_selected",
          label = "Delete Selected",
          style = "gradient",
          color = "danger",
          icon = icon("eraser")
        ),
        circle = TRUE,
        status = "success",
        icon = icon("gear"),
        width = "300px",
        inputId = "scheme_ops"
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
      h4("node add mode"),
      verbatimTextOutput("view_node_edit"),
      h4("edge add mode"),
      verbatimTextOutput("view_edge_edit")
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
        deleteNode = htmlwidgets::JS("deleteFunction")
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
  
  output$add_node_mode <- reactive({
    message("Hello Node")
    input$add_node_mode
  })
  
  output$add_edge_mode <- reactive({
    message("Hello Edge")
    input$add_edge_mode
  })
  
  purrr::walk(c("add_node_mode", "add_edge_mode"), ~outputOptions(output, .x, suspendWhenHidden = FALSE))
  
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
  
  output$view_node_edit <- renderPrint({
    input$add_node_mode
  })
  
  output$view_edge_edit <- renderPrint({
    input$add_edge_mode
  })
  
  observeEvent(input$hide, {
    toggleDisplay(id = "test", display = FALSE)
  })
  
  observeEvent(input$add_node, {
    toggleDropdownButton(inputId = "scheme_ops")
    visNetworkProxy("network_all") |>
      visAddNodeMode()
      #visGrabNetwork()
  })
  
  observeEvent(input$add_edge, {
    toggleDropdownButton(inputId = "scheme_ops")
    visNetworkProxy("network_all") |>
      visAddEdgeMode()
  })
  
  observeEvent(input$delete_selected, {
    toggleDropdownButton(inputId = "scheme_ops")
    visNetworkProxy("network_all") |>
      visDeleteMode()
  })
}

shinyApp(ui, server)