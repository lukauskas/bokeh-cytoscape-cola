import random

from bokeh.layouts import column, row, widgetbox
from bokeh.models import Div, Button

from bokehcytoscapecola.cytoscapegraph import CytoscapeGraph
from bokeh.io import curdoc
from bokeh.models import ColumnDataSource

# This example uses networkx to generate example graph, but it is not needed for cytoscape
import networkx as nx
import numpy as np

nodes = ColumnDataSource(dict(index=[],
                              type=[]))
edges = ColumnDataSource(dict({'from': [],
                               'to': [],
                               'weight': []}))


def generate_random_graph():

    n = random.randint(50, 200)

    random_graph = nx.random_geometric_graph(n, 0.125)

    node_indices = list(random_graph.nodes.keys())
    edges_from = [e[0] for e in random_graph.edges]
    edges_to = [e[1] for e in random_graph.edges]
    weights = np.random.rand(len(random_graph.edges))

    nodes.data = dict(index=node_indices,
                      type=np.random.choice(['a', 'b'], n))

    edges.data = {'from': edges_from,
                  'to': edges_to,
                  'weight': weights}


button = Button(label="Randomise!")
button.on_click(generate_random_graph)

generate_random_graph()

graph = CytoscapeGraph(
    node_source=nodes,
    edge_source=edges,
    width=500,
    height=500,
    style="""
    node[type = "a"] { 
        background-color: #1b9e77; 
    }
    node[type = "b"] { 
        background-color: #d95f02; 
    }
    """,
   layout_type="cose-bilkent",
   layout_options=dict(animate='end'),
   sizing_mode='scale_both',
)

div = Div(text="Example of Cytoscapegraph")

curdoc().add_root(row(widgetbox(button), column(div, graph)))
