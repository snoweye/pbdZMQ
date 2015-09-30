library(pbdZMQ)
ctxt <- init.context()
socket <- init.socket(ctxt, "ZMQ_REQ")
connect.socket(socket, "tcp://localhost:5555")

sendrecv <- function(socket, data)
{
  send.socket(socket, data)
  receive.socket(socket)
}
