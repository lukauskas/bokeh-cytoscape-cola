from bokeh.layouts import row
from bokeh.models import Div, Select, WidgetBox

from bokehcytoscapecola.cytoscapegraph import CytoscapeGraph
from bokeh.io import curdoc
from bokeh.models import ColumnDataSource

nodes = ColumnDataSource()
nodes.data = dict(index=['a', 'b', 'c'],
                  labels=['Node a', 'Node b', 'Node c'])


edges = ColumnDataSource()
edges.data = {'from': ["a", "a"],
              'to': ["b", "c"]}

graph = CytoscapeGraph(
    node_source=nodes,
    edge_source=edges,
    plot_width=500,
    plot_height=500
)

div = Div(text="Test")

curdoc().add_root(row(div,
                      graph))
