suppressPackageStartupMessages(library(pbdZMQ))

### zmq interface

### In general and separate files
# server_context = zmq.ctx.new()
# server_socket = zmq.socket(server_context, .pbd_env$ZMQ.ST$REP)
# client_context = zmq.ctx.new()
# client_socket = zmq.socket(client_context, .pbd_env$ZMQ.ST$REQ)
### Server file
# zmq.setsockopt(server_socket, .pbd_env$ZMQ.SO$CONNECT_TIMEOUT, 1000L)
# zmq.setsockopt(server_socket, .pbd_env$ZMQ.SO$RCVTIMEO, 1000L)
# zmq.setsockopt(server_socket, .pbd_env$ZMQ.SO$SNDTIMEO, 1000L)
# zmq.bind(server_socket, "tcp://*:55555")
### client file
# zmq.setsockopt(client_socket, .pbd_env$ZMQ.SO$CONNECT_TIMEOUT, 1000L)
# zmq.setsockopt(client_socket, .pbd_env$ZMQ.SO$RCVTIMEO, 1000L)
# zmq.setsockopt(client_socket, .pbd_env$ZMQ.SO$SNDTIMEO, 1000L)
# zmq.connect(client_socket, "tcp://localhost:55555")

### For CRAN testing in local (the same process) only to avoid block
cran_context = zmq.ctx.new()
server_socket = zmq.socket(cran_context, .pbd_env$ZMQ.ST$REP)
client_socket = zmq.socket(cran_context, .pbd_env$ZMQ.ST$REQ)
### Server
zmq.bind(server_socket, "inproc://#1")
### client
zmq.connect(client_socket, "inproc://#1")


### Test pbdZMQ
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
