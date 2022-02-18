from mergexp.unit import gb
from mergexp.machine import memory
import mergexp as mx

net = mx.Topology('RCC-VE')
net.device('rcc-0', memory >= gb(8))
mx.experiment(net)
