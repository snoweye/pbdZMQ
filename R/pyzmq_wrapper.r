#' R6 ZMQ Interface
#' 
#' @references
#' Modeled after the PyZMQ interface \url{https://zeromq.github.io/pyzmq/api/zmq.html}
#' 
#' @format
#' An \code{\link{R6Class}} generator object
#' 
#' @author Drew Schmidt
#' 
#' @examples
#' \dontrun{
#' context = zmq$Context()
#' socket = context$socket("ZMQ_REQ")
#' socket$connect("tcp://localhost:5555")
#' ### etc...
#' }
#' 
#' @aliases pyzmq
#' 
#' @docType class
#' @importFrom R6 R6Class
#' @keywords data
#' @rdname pyzmq
#' @name PyZMQ-like Interface
NULL



#' @rdname pyzmq
#' @export
Socket <- R6Class("Socket",
  public = list(
    bind = function(address)
    {
      zmq.bind(self$get(), address)
      private$bound.address <- address
      
      invisible(self)
    },
    close = function()
    {
      zmq.close(self$get())
    },
    connect = function(address)
    {
      zmq.connect(self$get(), address)
      private$connected.address <- address
      
      invisible(self)
    },
    get = function()
    {
      private$value
    },
    print = function(...)
    {
      cat("A ZeroMQ <Socket> R6 class\n")
      if (!is.null(private$socket.type))
        cat(paste("Type:", private$socket.type, "\n"))
      if (!is.null(private$bound.address))
        cat(paste("Bound Address:", private$bound.address, "\n"))
      if (!is.null(private$connected.address))
        cat(paste("Connected Address:", private$connected.address, "\n"))
      
      invisible(self)
    },
    receive = function(unserialize=TRUE, dont.wait=FALSE)
    {
      receive.socket(socket=self$get(), unserialize, dont.wait)
    },
    send = function(data, send.more=FALSE, serialize=TRUE)
    {
      send.socket(socket=self$get(), data, send.more, serialize)
    },
    set = function(ctxt, socket.type)
    {
      private$value <- init.socket(ctxt, socket.type)
      private$socket.type <- socket.type
      
      invisible(self)
    }
  ),
  private = list(
    value = NULL,
    socket.type = NULL,
    bound.address = NULL,
    connected.address = NULL
  )
)



#' @rdname pyzmq
#' @export
Context <- R6Class("Context",
  public = list(
    get = function()
    {
      private$value
    },
    Context = function()
    {
      private$value <- pbdZMQ::init.context()
    },
    print = function(...)
    {
      cat("A ZeroMQ <Context> R6 class\n")
      invisible(self)
    },
    socket = function(socket.type)
    {
      socket <- Socket$new()
      socket$set(self$get(), socket.type)
      socket
    }
  ),
  private = list(
    value = NULL
  )
)



zmq_ <- R6Class("zmq",
  public = list(
    Context = function()
    {
      ctx <- Context$new()
      ctx$Context()
      return(ctx)
    },
    print = function(...)
    {
      cat("A ZeroMQ <zmq> R6 class\n")
      invisible(self)
    },
    version = function()
    {
      zmq.version()
    }
  )
)

#' @rdname pyzmq
#' @export
zmq <- zmq_$new()
