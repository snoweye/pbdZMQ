### Error related.
zmq.strerror <- function(errno){
  .Call("R_zmq_strerror", as.integer(errno[1]), PACKAGE = "pbdZMQ")
} # End of zmq.strerror().

### Version.
zmq.version <- function(){
  .Call("R_zmq_version", PACKAGE = "pbdZMQ")
  invisible()
} # End of zmq.version().
