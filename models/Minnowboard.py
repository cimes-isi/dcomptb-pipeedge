import mergexp as mx

net = mx.Topology('Minnowboard')
net.device('mb-0')
mx.experiment(net)
