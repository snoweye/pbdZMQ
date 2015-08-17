### Context related.
zmq.ctx.new <- function(){
  ret <- .Call("R_zmq_ctx_new", PACKAGE = "pbdZMQ")
  ### Users are responsible to take care free and gc.
  # reg.finalizer(ret, zmq.ctx.destroy, TRUE)
  ret
} # End of zmq.ctx.new().

zmq.ctx.destroy <- function(ctx){
  .Call("R_zmq_ctx_destroy", ctx, PACKAGE = "pbdZMQ")
  invisible()
} # End of zmq.ctx.destroy().
