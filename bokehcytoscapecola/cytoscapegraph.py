from bokeh.models import LayoutDOM, Instance, ColumnDataSource, Int, String


class CytoscapeGraph(LayoutDOM):

    __implementation__ = 'cytoscapegraph.coffee'

    __javascript__ = ["https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.2.9/cytoscape.js",
                      #"https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.2.9/cytoscape.min.js",
                      "http://marvl.infotech.monash.edu/webcola/cola.v3.min.js",
                      "https://cdn.jsdelivr.net/npm/cytoscape-cola@2.1.0/cytoscape-cola.min.js"]

    node_source = Instance(ColumnDataSource)
    edge_source = Instance(ColumnDataSource)

    plot_width = Int
    plot_height = Int

    node_index: String(default="index")
    node_label: String(default="index")

