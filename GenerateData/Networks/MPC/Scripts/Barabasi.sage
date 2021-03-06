#!/usr/lib/sagemath/sage -python


import networkx as nx
import numpy as np
from scipy.sparse import csc_matrix       # To make a matrix sparse
from scipy.io import savemat              # To save matrices to Matlab
from sage.all import *

# ==================================================================
# Parameters

TYPE = 'Barabasi'

m = 2                # Barabasi parameter

num_nodes = 6 #100 #2000     # Number of nodes

# Name of the file to save the data
FILENAME_OUTPUT = 'tmp.txt'

# Will be used as seed for everything random
random_seed = 1234 

# Plot Active/Inactive
_PLOT = False
# ==================================================================

# ==================================================================
# Read the network into graph_sage
graph_nx = nx.generators.barabasi_albert_graph(num_nodes, m, seed=random_seed)

graph_sage = Graph(graph_nx)               # convert to Sage graph
# ==================================================================


# ==================================================================
# Get network information

num_nodes_raw = graph_sage.num_verts()
num_edges_raw = graph_sage.num_edges()

Edges = graph_sage.edges()

Diameter = graph_sage.diameter()

colors = graph_sage.coloring(algorithm='MILP',verbose=1)  # Use MILP, 
                                                          # otherwise it is slow                                                          
numColors = len(colors)

is_connected = graph_sage.is_connected()
# ==================================================================

#print 'Saving data to file ' + str(FILENAME_OUTPUT) + '\n'

FILE = open(FILENAME_OUTPUT, "w")
FILE.write('conn = '      + str(int(is_connected)) + '\n')
FILE.write('num_nodes = ' + str(num_nodes_raw) + '\n')
FILE.write('num_edges = ' + str(num_edges_raw) + '\n')
FILE.write('diameter = '  + str(Diameter) + '\n')
FILE.write('numColors = ' + str(numColors) + '\n')

FILE.write('nodesPerColor = \n')
for color in range(numColors):
    FILE.write(str(len(colors[color])) + '\n')

FILE.write('colors = \n')

for color in range(numColors):
    for node in range(len(colors[color])):
        FILE.write(str(colors[color][node]) + ' ')
    FILE.write('\n')

FILE.write('Edges =\n')

for edge in range(num_edges_raw):
    FILE.write(str(Edges[edge][0]) + ' ' + str(Edges[edge][1]) + '\n')  

FILE.close()

#print 'Done \n\n'


# ==================================================================
# Print Network statistics

Degrees   = [graph_sage.degree(i) for i in range(num_nodes_raw)]

Max_Degree  = max(Degrees)
Min_Degree  = min(Degrees)
Mean_Degree = float(mean(Degrees))

print '--------------------------------------------------'
print 'Network Statistics:\n'
print '\n'
print 'Type:             ' + TYPE
print 'Parameter:        ' + str(m)
print 'Random seed:      ' + str(random_seed)
print 'Number of nodes:  ' + str(num_nodes_raw)
print 'Number of edges:  ' + str(num_edges_raw)
print 'Diameter:         ' + str(Diameter)
print 'Number of colors: ' + str(numColors)
print 'Maximum degree:   ' + str(Max_Degree)
print 'Minimum degree:   ' + str(Min_Degree)
print 'Average degree:   ' + str(Mean_Degree)
print '--------------------------------------------------'
# ==================================================================

