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

    @connect(@model.node_source.change, () =>
      @update_data();
    )
    @connect(@model.edge_source.change, () =>
      @update_data();
    )

  render: () ->
    super()

    @_cy = new cytoscape(
      container: @el,
      autounselectify: true,
      boxSelectionEnabled: false,
      style: @model.style,
    );

    @update_data();

  update_data: () ->
    node_source = @model.node_source

    @_cy.elements().remove();

    ids = node_source.get_column(@model.node_index)

    for i in [0...node_source.get_length()]
      entry = {
        id: ids[i],
      }
      @_cy.add({data: entry});


    edge_source = @model.edge_source

    froms = edge_source.get_column('from')
    tos = edge_source.get_column('to')


    for i in [0...edge_source.get_length()]
      d = {
        source: froms[i],
        target: tos[i]
      }

      @_cy.add({data: d});

    # Re-run layout
    @_cy.layout({
      name: @model.layout_type,
      options: @model.layout_options
    }).run();


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
  }
