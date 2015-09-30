#' All Wrapper Functions for rzmq
#' 
#' All wrapper functions for rzmq
#' 
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' @references ZeroMQ/4.1.0 API Reference:
#' \url{http://api.zeromq.org/4-1:_start}
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' @keywords internal
#' @rdname xx_rzmq_wrapper
#' @name Wrapper Functions for rzmq
NULL



#' @rdname xx_rzmq_wrapper
#' @export
send.socket <- function(socket, data, send.more = FALSE, serialize = TRUE){
  if(send.more){
    flags <- .pbdZMQEnv$ZMQ.SR$SNDMORE
  } else{
    flags <- .pbdZMQEnv$ZMQ.SR$BLOCK
  }
  zmq.msg.send(data, socket, flags = flags, serialize = serialize)
}



#' @rdname xx_rzmq_wrapper
#' @export
receive.socket <- function(socket, unserialize = TRUE, dont.wait = FALSE){
  if(dont.wait){
    flags <- .pbdZMQEnv$ZMQ.SR$DONTWAIT
  } else{
    flags <- .pbdZMQEnv$ZMQ.SR$BLOCK
  }
  zmq.msg.recv(socket, flags = flags, unserialize = unserialize)
}



#' @rdname xx_rzmq_wrapper
#' @export
init.context <- function(){
  try.zmq.ctx.destroy <- function(ctx){
    try(zmq.ctx.destroy(ctx), silent = TRUE)
  }

  ctx <- zmq.ctx.new()  
  reg.finalizer(ctx, try.zmq.ctx.destroy, onexit = TRUE)
  ctx
}



#' @rdname xx_rzmq_wrapper
#' @export
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
}



#' @rdname xx_rzmq_wrapper
#' @export
bind.socket <- function(socket, address){
  zmq.bind(socket, address)
}



#' @rdname xx_rzmq_wrapper
#' @export
connect.socket <- function(socket, address){
  zmq.connect(socket, address)
}

