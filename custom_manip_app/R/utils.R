html_dependency_viscustom <- function() {
  htmltools::htmlDependency(
    name = "vis_custom",
    version = "0.1",
    src = c(file = "assets"),
    script = c("vis_custom.js"),
    all_files = TRUE
  )
}

#' Display or hide a Shiny input
#'
#' @param id shiny input id.
#' @param display character, 'none' to hide, 'block' or 'inline-block' to show
#' @param session shiny session.
#'
#' @noRd
toggleDisplay <- function(id,
                          display = c("none", "block", "inline-block"),
                          session = shiny::getDefaultReactiveDomain()) {
  if (is.logical(display)) {
    display <- ifelse(display, "block", "none")
  }
  session$sendCustomMessage(
    type = "toggleDisplay",
    message = list(id = id, display = display)
  )
}

visGrabNetwork <- function(graph) {
  if (!any(class(graph) %in% "visNetwork_Proxy")) {
    stop("Need visNetwork Proxy object!")
  }
  data <- list(
    id = graph$id
  )
  
  graph$session$sendCustomMessage("visShinyGrabNetwork", data)
  graph
}

visAddNodeMode <- function(graph, edit_id = "add_node_mode", session = shiny::getDefaultReactiveDomain()) {
  if (!any(class(graph) %in% "visNetwork_Proxy")) {
    stop("Need visNetwork Proxy object!")
  }
  data <- list(
    id = graph$id,
    edit_id = session$ns(edit_id)
  )
  
  graph$session$sendCustomMessage("visShinyAddNodeMode", data)
  graph
}

visAddEdgeMode <- function(graph, edit_id = "add_edge_mode", session = shiny::getDefaultReactiveDomain()) {
  if (!any(class(graph) %in% "visNetwork_Proxy")) {
    stop("Need visNetwork Proxy object!")
  }
  data <- list(
    id = graph$id,
    edit_id = session$ns(edit_id)
  )
  
  graph$session$sendCustomMessage("visShinyAddEdgeMode", data)
  graph
}

visDeleteMode <- function(graph) {
  if (!any(class(graph) %in% "visNetwork_Proxy")) {
    stop("Need visNetwork Proxy object!")
  }
  data <- list(
    id = graph$id
  )
  
  graph$session$sendCustomMessage("visShinyDeleteMode", data)
  graph
}