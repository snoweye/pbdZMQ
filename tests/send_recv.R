suppressPackageStartupMessages(library(pbdZMQ))

### zmq interface

# Server
server_context = zmq.ctx.new()
server_socket = zmq.socket(server_context, .pbd_env$ZMQ.ST$REP)
zmq.bind(server_socket, "tcp://*:55555")

# Client
client_context = zmq.ctx.new()
client_socket = zmq.socket(client_context, .pbd_env$ZMQ.ST$REQ)
zmq.connect(client_socket, "tcp://localhost:55555")

tester = function(indata)
{
  zmq.msg.send(indata, client_socket)
  c2s <- zmq.msg.recv(server_socket)
  stopifnot(all.equal(c2s, indata))

  zmq.send(server_socket, "ok")
  s2c <- zmq.recv(client_socket)
  stopifnot(all.equal(s2c$buf, "ok"))
}

tester("test")
tester(1:5)

zmq.close(server_socket)
zmq.close(client_socket)



### rzmq interface

# Server
server_context = init.context()
server_socket = init.socket(server_context, "ZMQ_REP")
bind.socket(server_socket, "tcp://*:55555")

# Client
client_context = init.context()
client_socket = init.socket(client_context, "ZMQ_REQ")
connect.socket(client_socket, "tcp://localhost:55555")

tester_rzmq = function(indata)
{
  send.socket(client_socket, indata)
  c2s <- receive.socket(server_socket)
  stopifnot(all.equal(c2s, indata))

  send.socket(server_socket, "ok")
  s2c <- receive.socket(client_socket)
  stopifnot(all.equal(s2c, "ok"))
}

tester_rzmq("test")
tester_rzmq(1:5)
