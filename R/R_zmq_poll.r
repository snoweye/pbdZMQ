#' Poll Functions
#' 
#' Poll functions
#' 
#' \code{zmq.poll()} initials a ZMQ poll given  ZMQ \code{socket}'s
#' and ZMQ poll \code{type}'s. Both \code{socket} and \code{type} are
#' in vectors of the same length, while \code{socket} contains socket pointers
#' and \code{type} contains types of poll.
#' See \code{\link{ZMQ.PO}()} for the possible values of
#' \code{type}. ZMQ defines several poll types and utilize
#' them to poll multiple sockets.
#' 
#' 
#' @param socket 
#' a list of ZMQ socket
#' @param type 
#' a list of socket type
#' 
#' @return \code{zmq.poll()} returns,
#' see ZeroMQ manual for details.
#' 
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' 
#' @references ZeroMQ/4.1.0 API Reference:
#' \url{http://api.zeromq.org/4-1:_start}
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' 
#' @examples
#' \dontrun{
#' }
#' 
#' @keywords programming
#' @seealso \code{\link{zmq.recv}()}, \code{\link{zmq.send}()}.
#' @rdname b2_poll
#' @name Poll Functions
NULL



#' @rdname b2_poll
#' @export
zmq.poll <- function(socket, type, timeout){
  if(length(socket) != length(type)){
    stop("socket and type are of different length.")
  }

  ret <- .Call("R_zmq_poll", socket, as.integer(type), as.integer(timeout),
               PACKAGE = "pbdZMQ")
  invisible(ret)
}

