from bokeh.models import LayoutDOM, Instance, ColumnDataSource, Int, String, Any, Dict

_DEFAULT_LAYOUT_OPTIONS = {}

class CytoscapeGraph(LayoutDOM):

    __implementation__ = 'cytoscapegraph.coffee'

    __javascript__ = ["https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.2.9/cytoscape.min.js",
                      "http://marvl.infotech.monash.edu/webcola/cola.v3.min.js",
                      "https://cdn.jsdelivr.net/npm/cytoscape-cola@2.1.0/cytoscape-cola.min.js"]

    node_source = Instance(ColumnDataSource)
    edge_source = Instance(ColumnDataSource)

    plot_width = Int
    plot_height = Int

    node_index: String(default="index")
    layout_type: String(default="cola")
    layout_options: Dict(String, Any, default=_DEFAULT_LAYOUT_OPTIONS)

    style: String(default="")
