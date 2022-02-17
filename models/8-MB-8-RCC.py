from mergexp.unit import mbps, ms, gb
from mergexp.net import capacity, latency
from mergexp.machine import memory
import mergexp as mx

net = mx.Topology('8-MB-8-RCC')
nodes = []

# Minnowboards
for i in range(8):
    nodes.append(net.device(f'mb-{i}'))

# RCC-VE
for i in range(8):
    nodes.append(net.device(f'rcc-{i}', memory >= gb(8)))

lan = net.connect(nodes)
mx.experiment(net)
