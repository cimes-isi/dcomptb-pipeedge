from mergexp.unit import gb
from mergexp.machine import memory
import mergexp as mx

net = mx.Topology('1-MB-1-RCC')
nodes = []

# Minnowboard
nodes.append(net.device(f'mb-0'))
# RCC-VE
nodes.append(net.device(f'rcc-0', memory >= gb(8)))

net.connect(nodes)
mx.experiment(net)
