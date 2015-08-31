### Message related.
zmq.msg.init <- function(){
  .Call("R_zmq_msg_init", PACKAGE = "pbdZMQ")
} # End of zmq.msg.init().

zmq.msg.close <- function(msg.t){
  .Call("R_zmq_msg_close", msg.t, PACKAGE = "pbdZMQ")
} # End of zmq.msg.close().

zmq.msg.send <- function(rmsg, socket, flags = .pbdZMQEnv$ZMQ.SR$BLOCK, serialize = TRUE){
  if(serialize){
    rmsg <- serialize(rmsg, NULL)
  }
  ret <- .Call("R_zmq_msg_send", rmsg, socket, as.integer(flags),
               PACKAGE = "pbdZMQ")
  invisible(ret)
} # End of zmq.msg.send().

zmq.msg.recv <- function(socket, flags = .pbdZMQEnv$ZMQ.SR$BLOCK, unserialize = TRUE){
  rmsg <- .Call("R_zmq_msg_recv", socket, as.integer(flags),
                PACKAGE = "pbdZMQ")
  if(unserialize && is.raw(rmsg)){
    rmsg <- unserialize(rmsg)
  }
  rmsg
} # End of zmq.msg.recv().

