from bokeh.layouts import column
from bokeh.models import Div

from bokehcytoscapecola.cytoscapegraph import CytoscapeGraph
from bokeh.io import curdoc
from bokeh.models import ColumnDataSource

# This example uses networkx to generate example graph, but it is not needed for cytoscape
import networkx as nx

G = nx.random_geometric_graph(200, 0.125)
node_indices = list(G.nodes.keys())
edges_from = [e[0] for e in G.edges]
edges_to = [e[1] for e in G.edges]

nodes = ColumnDataSource()

nodes.data = dict(index=node_indices)

edges = ColumnDataSource()
edges.data = {'from': edges_from,
              'to': edges_to}

graph = CytoscapeGraph(
    node_source=nodes,
    edge_source=edges,
    plot_width=500,
    plot_height=500,
    style="""node { background-color: green; }"""
)

div = Div(text="Example of Cytoscapegraph")

curdoc().add_root(column(div,
                         graph))
