import * as p from "core/properties"
import {LayoutDOM, LayoutDOMView} from "models/layouts/layout_dom"
import {div} from "core/dom";

export class CytoscapeGraphView extends LayoutDOMView

  get_width: () ->
    return @model.plot_width

  get_height: () ->
    return @model.plot_height

  initialize: (options) ->
    super(options)

    @_css = document.createElement("style");
    @_css.type = "text/css";

    width = @get_width()
    height = @get_height()

    @_css.innerHTML = "#" + @el.id + " { width: #{width} px; height: #{height} px;}";

    @_cy = null;

    document.body.appendChild(@_css);

    @nodes_updated = false;
    @edges_updated = false;

    @connect(@model.node_source.change, () =>
      @try_update_data('nodes');
    )
    @connect(@model.edge_source.change, () =>
      @try_update_data('edges');
    )

    @layout_options = @model.layout_options

    if @model.ideal_edge_length_function
      func = new Function("e", @model.ideal_edge_length_function);
      @layout_options['edgeLength'] = func;

  render: () ->
    super()

    @_cy = new cytoscape(
      container: @el,
      autounselectify: true,
      boxSelectionEnabled: false,
      style: @model.style,
    );

    @update_data();


  try_update_data: (updated_source) ->

    # Do not re-render unless both nodes and edges updated
    if updated_source == 'nodes'
      @nodes_updated = true

    if updated_source == 'edges'
      @edges_updated = true

    if @nodes_updated && @edges_updated
      @update_data()


  update_data: () ->
    node_source = @model.node_source

    @_cy.elements().remove();

    ids = node_source.get_column(@model.node_index)
    for i in [0...node_source.get_length()]
      entry = {
        id: ids[i],
      }

      for col, vals of node_source.data
        if col == @model.node_index
          continue

        entry[col] = vals[i];


      @_cy.add({data: entry});

    edge_source = @model.edge_source

    froms = edge_source.get_column('from')
    tos = edge_source.get_column('to')

    for i in [0...edge_source.get_length()]
      d = {
        source: froms[i],
        target: tos[i]
      }

      for col, vals of edge_source.data
        if (col == 'from') || (col == "to")
          continue

        d[col] = vals[i];

      @_cy.add({data: d});

    # Re-run layout
    @_cy.layout({
      name: @model.layout_type,
      options: @layout_options
    }).run();

    @nodes_updated = false;
    @edges_updated = false;


# We must also create a corresponding JavaScript Backbone model sublcass to
# correspond to the python Bokeh model subclass. In this case, since we want
# an element that can position itself in the DOM according to a Bokeh layout,
# we subclass from ``LayoutDOM.model``
export class CytoscapeGraph extends LayoutDOM

  # This is usually boilerplate. In some cases there may not be a view.
  default_view: CytoscapeGraphView

  type: "CytoscapeGraph"

  @define {
    node_source: [p.Instance]
    edge_source: [p.Instance]
    plot_width: [p.Int]
    plot_height: [p.Int]

    node_index: [p.String, "index"]

    layout_type: [p.String, "cola"]
    layout_options: [p.Any, {}]

    style: [p.String, ""]

    ideal_edge_length_function: [p.String, ""]
  }
