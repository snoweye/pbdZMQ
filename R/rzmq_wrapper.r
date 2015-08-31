send.socket <- function(socket, data, send.more = FALSE, serialize = TRUE){
  if(send.more){
    flags <- .pbdZMQEnv$ZMQ.SR$SNDMORE
  } else{
    flags <- .pbdZMQEnv$ZMQ.SR$BLOCK
  }
  zmq.msg.send(data, socket, flags = flags, serialize = serialize)
} # End of send.socket().

receive.socket <- function(socket, unserialize = TRUE, dont.wait = FALSE){
  if(dont.wait){
    flags <- .pbdZMQEnv$ZMQ.SR$DONTWAIT
  } else{
    flags <- .pbdZMQEnv$ZMQ.SR$BLOCK
  }
  zmq.msg.recv(socket, flags = flags, unserialize = unserialize)
} # End of receive.socket().

init.context <- function(){
  try.zmq.ctx.destroy <- function(ctx){
    try(zmq.ctx.destroy(ctx), silent = TRUE)
  }

  ctx <- zmq.ctx.new()  
  reg.finalizer(ctx, try.zmq.ctx.destroy, onexit = TRUE)
  ctx
} # End of init.context()

init.socket <- function(context, socket.type){
  try.zmqt.close <- function(socket){
    try(zmq.close(socket), silent = TRUE)
  }

  socket.type <- sub(".*_", "", socket.type)
  id <- which(names(.pbdZMQEnv$ZMQ.ST) == socket.type)
  if(length(id) != 1){
    stop("socket.type is not found.")
  } else{
    socket.type <- .pbdZMQEnv$ZMQ.ST[[id]]
  }

  socket <- zmq.socket(context, type = socket.type)
  reg.finalizer(socket, try.zmqt.close, onexit = TRUE)
  socket
} # End of init.socket()

bind.socket <- function(socket, address){
  zmq.bind(socket, address)
} # End of bind.socket()

connect.socket <- function(socket, address){
  zmq.connect(socket, address)
} # End of connect.socket()
