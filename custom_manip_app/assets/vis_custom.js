$(function() {
  // enable/disable an input
  Shiny.addCustomMessageHandler("toggleInput", function(data) {
    $("#" + data.id).prop("disabled", !data.enable);
    if ($("#" + data.id).hasClass("selectpicker")) {
      $("#" + data.id).selectpicker("refresh");
    }
  });

  // hide or show an element
  Shiny.addCustomMessageHandler("toggleDisplay", function(data) {
    $("#" + data.id).css("display", data.display);
  });

  // Disable / enable a button
  Shiny.addCustomMessageHandler("togglewidget", function(data) {
    if (data.type == "disable") {
      $("#" + data.inputId).prop("disabled", true);
      $("#" + data.inputId).addClass("disabled");
    }
    if (data.type == "enable") {
      $("#" + data.inputId).prop("disabled", false);
      $("#" + data.inputId).removeClass("disabled");
    }
  });
  
  var inAddNodeMode = false;
  var inAddEdgeMode = false;
  
  Shiny.addCustomMessageHandler("visShinyGrabNetwork", function(data) {
    // get container id
    var el = document.getElementById("graph"+data.id);
    var network = el.chart;
    console.log(network);
  });
  
  Shiny.addCustomMessageHandler("visShinyAddNodeMode", function(data) {
    // get container id
    var el = document.getElementById("graph"+data.id);
    var network = el.chart;
    
    if (inAddNodeMode) {
      network.disableEditMode();
      inAddNodeMode = false;
      Shiny.setInputValue(data.edit_id, inAddNodeMode, {priority: 'event'});
    } else {
      network.addNodeMode();
      inAddNodeMode = true;
      Shiny.setInputValue(data.edit_id, inAddNodeMode, {priority: 'event'});
    }
  });
  
  Shiny.addCustomMessageHandler("visShinyAddEdgeMode", function(data) {
    // get container id
    var el = document.getElementById("graph"+data.id);
    var network = el.chart;
    if (inAddEdgeMode) {
      network.disableEditMode();
      inAddEdgeMode = false;
      Shiny.setInputValue(data.edit_id, inAddEdgeMode, {priority: 'event'});
    } else {
      network.addEdgeMode();
      inAddEdgeMode = true;
      Shiny.setInputValue(data.edit_id, inAddEdgeMode, {priority: 'event'});
    }
  });
  
  Shiny.addCustomMessageHandler("visShinyDeleteMode", function(data) {
    // get container id
    var el = document.getElementById("graph"+data.id);
    var network = el.chart;
    network.deleteSelected();
  });
  
  deleteSubGraph = function(data, callback) {
    var obj = {cmd: "deleteElements", nodes: data.nodes, edges: data.edges};
    //Shiny.onInputChange(el.id + '_graphChange', obj);
    callback(data);
  };
  
  deleteFunction = function(data, callback) {
    // do something here
    console.log("I entered deleteNodeFunction");
    //deleteSubGraph(data, callback);
    callback(data);
  };
  
  onAddNode = function(data, callback) {
    console.log('onAdd');
    inAddNodeMode = false;
    Shiny.setInputValue('add_node_mode', inAddNodeMode, {priority: 'event'});
    callback(data);
  };
  
  onAddEdge = function(data, callback) {
    console.log('onEdge');
    inAddEdgeMode = false;
    Shiny.setInputValue('add_edge_mode', inAddEdgeMode, {priority: 'event'});
    callback(data);
  }
});
