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
