suppressPackageStartupMessages(library(pbdZMQ))

### Server
server_context = init.context()
server_socket = init.socket(server_context, "ZMQ_REP")
bind.socket(server_socket, "tcp://*:55555")

### Client
client_context = init.context()
client_socket = init.socket(client_context, "ZMQ_REQ")
connect.socket(client_socket, "tcp://localhost:55555")


send.socket(client_socket, "test")
c2s <- receive.socket(server_socket)

stopifnot(all.equal(c2s, "test"))


send.socket(server_socket, "ok")
s2c <- receive.socket(client_socket)

stopifnot(all.equal(s2c, "ok"))
