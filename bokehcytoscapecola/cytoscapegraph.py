from bokeh.models import LayoutDOM, ColumnDataSource, Bool
from bokeh.core.properties import Instance, Int, String, Any, Dict

_DEFAULT_LAYOUT_OPTIONS = {}


class CytoscapeGraph(LayoutDOM):

    __implementation__ = 'cytoscapegraph.coffee'

    __javascript__ = ["https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.2.9/cytoscape.min.js",
                      "http://marvl.infotech.monash.edu/webcola/cola.v3.min.js",
                      "https://cdn.jsdelivr.net/npm/cytoscape-cola@2.1.0/cytoscape-cola.min.js",
                      'https://cdn.jsdelivr.net/npm/cytoscape-cose-bilkent@4.0.0/cytoscape-cose-bilkent.min.js']

    node_source = Instance(ColumnDataSource)
    edge_source = Instance(ColumnDataSource)

    plot_width = Int
    plot_height = Int

    node_index = String(default="index")
    layout_type = String(default="cola")
    layout_options = Dict(String, Any, default=_DEFAULT_LAYOUT_OPTIONS)

    style = String(default="")

    # Allows encoding of edge length option in layout as a function
    # The value gets inserted into the following code block
    # func = new Function(e, [[value]]);
    # The function should take e (the edge) as parameter and return the desired length.
    ideal_edge_length_function = String(default="")
