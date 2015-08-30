### Socket related.
zmq.socket <- function(ctx, type = .pbdZMQEnv$ZMQ.ST$REP){
  ret <- .Call("R_zmq_socket", ctx, type, PACKAGE = "pbdZMQ")
  ### Users are responsible to take care free and gc.
  # reg.finalizer(ret, zmq.close, TRUE)
  ret
} # End of zmq.socket().

zmq.close <- function(socket){
  ret <- .Call("R_zmq_close", socket, PACKAGE = "pbdZMQ")
  invisible(ret)
} # End of zmq.close().

zmq.bind <- function(socket, endpoint, MC = .pbdZMQEnv$ZMQ.MC){
  ret <- .Call("R_zmq_bind", socket, endpoint, PACKAGE = "pbdZMQ")

  if(ret != 0){
    if(MC$stop.at.error){
      stop(paste("zmq.bind fails, ", endpoint, sep = ""))
    }
    if(MC$warning.at.error){
      warning(paste("zmq.bind fails, ", endpoint, sep = ""))
    }
  }
  invisible(ret)
} # End of zmq.bind().

zmq.connect <- function(socket, endpoint, MC = .pbdZMQEnv$ZMQ.MC){
  ret <- .Call("R_zmq_connect", socket, endpoint, PACKAGE = "pbdZMQ")

  if(ret != 0){
    if(MC$stop.at.error){
      stop(paste("zmq.connect fails, ", endpoint, sep = ""))
    }
    if(MC$warning.at.error){
      warning(paste("zmq.connect fails, ", endpoint, sep = ""))
    }
  }
  invisible(ret)
} # End of zmq.connect().

zmq.setsockopt <- function(socket, option.name, option.value, MC = .pbdZMQEnv$ZMQ.MC){
  if(is.character(option.value)){
    option.type <- 0L
  } else if(is.integer(option.value)){
    option.type <- 1L
  } else{
    stop("Type of option.value is not implemented")
  }

  ret <- .Call("R_zmq_setsockopt", socket, option.name, option.value,
               option.type, PACKAGE = "pbdZMQ")

  if(ret != 0){
    if(MC$stop.at.error){
      stop(paste("zmq.setsockopt fails, ", option.value, sep = ""))
    }
    if(MC$warning.at.error){
      warning(paste("zmq.setsockopt fails, ", option.value, sep = ""))
    }
  }
  invisible(ret)
} # End of zmq.setsockopt().
