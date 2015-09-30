library(pbdZMQ)
ctxt <- init.context()
socket <- init.socket(ctxt, "ZMQ_REP")
bind.socket(socket, "tcp://*:5555")


while(TRUE)
{
  cat("Client command:  ")
  msg <- receive.socket(socket)
  cat(msg, "\n")

  if (msg == "EXIT")
    break
  
  result <- eval(parse(text=msg))

  send.socket(socket, result)
}

send.socket(socket, "shutting down!")

