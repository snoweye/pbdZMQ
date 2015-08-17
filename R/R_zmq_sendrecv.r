### Send related.
zmq.send <- function(socket, buf, flags = .ZMQ.SR$BLOCK){
  if(is.character(buf)){
    ret <- zmq.send.char(socket, buf[1], nchar(buf[1]), flags = flags)
  } else if(is.raw(buf)){
    ret <- zmq.send.raw(socket, buf[1], length(buf[1]), flags = flags)
  } else{
    stop("buf type should be char or raw.")
  }
  invisible(ret)
} # End of zmq.send().

zmq.send.char <- function(socket, buf, len, flags = .ZMQ.SR$BLOCK){
  ret <- .Call("R_zmq_send_char", socket, buf, as.integer(len),
               as.integer(flags), PACKAGE = "pbdZMQ")
  invisible(ret)
} # End of zmq.send.char().

zmq.send.raw <- function(socket, buf, len, flags = .ZMQ.SR$BLOCK){
  ret <- .Call("R_zmq_send_raw", socket, buf, as.integer(len),
               as.integer(flags), PACKAGE = "pbdZMQ")
  invisible(ret)
} # End of zmq.send.raw().


### Recv related.
zmq.recv <- function(socket, len = 1024, flags = .ZMQ.SR$BLOCK,
    buf.type = c("char", "raw")){
  if(buf.type[1] == "char"){
    ret <- zmq.recv.char(socket, len, flags = flags)
  } else if(buf.type[1] == "raw"){
    ret <- zmq.recv.raw(socket, len, flags = flags)
  } else{
    stop("buf type should be char or raw.")
  }
  invisible(ret)
} # End of zmq.recv().

zmq.recv.char <- function(socket, len, flags = .ZMQ.SR$BLOCK){
  ret <- .Call("R_zmq_recv_char", socket, as.integer(len), as.integer(flags),
               PACKAGE = "pbdZMQ")
  invisible(ret)
} # End of zmq.recv.char().

zmq.recv.raw <- function(socket, len, flags = .ZMQ.SR$BLOCK){
  ret <- .Call("R_zmq_recv_raw", socket, as.integer(len), as.integer(flags),
               PACKAGE = "pbdZMQ")
  invisible(ret)
} # End of zmq.recv.raw().

