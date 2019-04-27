suppressPackageStartupMessages(library(pbdZMQ))

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
