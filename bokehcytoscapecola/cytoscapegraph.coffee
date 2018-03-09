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


  render: () ->
    super()
    console.log(@el.clientWidth);

    @_cy = new cytoscape(
      container: @el,
      layout: {
        name: "cola"
      },
      autounselectify: true,
      boxSelectionEnabled: false,
      style: [
        {
          selector: 'node',
          css: {
            'background-color': '#f92411'
          }
        },
        {
          selector: 'edge',
          css: {
            'line-color': '#f92411'
          }
        }
      ],
      elements: [
        {data: {id: 'a'}},
        {data: {id: 'b'}},
        {
          data: {
            id: 'ab',
            source: 'a',
            target: 'b'
          }
        }]
    );

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
  }
