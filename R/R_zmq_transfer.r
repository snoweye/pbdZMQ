#' File Transfer Functions
#' 
#' File transfer functions
#' 
#' \code{zmq.sendfile()} is a high level R function calling ZMQ C API
#' \code{zmq_send()} sending the data stored at \code{filename} out in chunks.
#' 
#' \code{zmq.recvfile()} is a high level R function calling ZMQ C API
#' \code{zmq_recv()} receiving data from \code{zmq.sendfile()} and
#' storing it in \code{filename}.
#' 
#' \code{buf.type} currently supports \code{char} and \code{raw} which are both
#' in R object format.
#' 
#' @param socket 
#' a ZMQ socket
#' @param filename
#' the name of the file to send or the location to receive (recv) it into
#' @param verbose
#' logical; determines if 
#' @param flags
#' a flag for the method used by \code{zmq_sendfile} and
#' \code{zmq_recvfile}
#' 
#' 
#' @return \code{zmq.sendfile()} and \code{zmq.recvfile()} return
#' number of bytes (invisible) in the sent message if successful,
#' otherwise returns -1 (invisible) and sets \code{errno} to the error
#' value, see ZeroMQ manual for details.
#' 
#' @author Christian Heckendorf and Drew Schmidt.
#' 
#' @references ZeroMQ/4.1.0 API Reference:
#' \url{http://api.zeromq.org/4-1:_start}
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' 
#' @examples
#' \dontrun{
#' ### Using request-reply pattern.
#' 
#' ### Server --- run in the background/in another R session
#' # setup
#' library(pbdZMQ, quietly = TRUE)
#' context <- zmq.ctx.new()
#' socket <- zmq.socket(context, .pbdZMQEnv$ZMQ.ST$REP)
#' zmq.bind(socket, "tcp://*:55555")
#' 
#' # Receive file from client, store locally as "/tmp/data.csv"
#' zmq.recvfile(socket, "/tmp/data.csv")
#' 
#' # cleanup
#' zmq.close(socket)
#' zmq.ctx.destroy(context)
#' 
#' 
#' 
#' ### Client --- run in the foreground.
#' # setup
#' library(pbdZMQ, quietly = TRUE)
#' context <- zmq.ctx.new()
#' socket <- zmq.socket(context, .pbdZMQEnv$ZMQ.ST$REQ)
#' zmq.connect(socket, "tcp://localhost:55555")
#' 
#' # Send file "data.csv" to server
#' zmq.sendfile(socket,"data.csv")
#' 
#' # cleanup
#' zmq.close(socket)
#' zmq.ctx.destroy(context)
#' }
#' 
#' @keywords programming
#' @seealso \code{\link{zmq.msg.send}()}, \code{\link{zmq.msg.recv}()}.
#' @rdname b1_sendrecvfile
#' @name File Transfer Functions
NULL



#' @rdname b1_sendrecvfile
#' @export
zmq.sendfile <- function(socket, filename, verbose=FALSE, flags = .pbdZMQEnv$ZMQ.SR$BLOCK)
{
  filesize <- as.double(file.info(filename)$size)
  # zmq.msg.send(socket, filesize)
  
  ret <- .Call("R_zmq_send_file", socket, filename, as.integer(verbose), filesize, as.integer(flags),
               PACKAGE = "pbdZMQ")
  invisible(ret)
}



#' @rdname b1_sendrecvfile
#' @export
zmq.recvfile <- function(socket, filename, verbose=FALSE, flags = .pbdZMQEnv$ZMQ.SR$BLOCK)
{
  # filesize <- zmq.msg.recv(socket)
  
  ret <- .Call("R_zmq_recv_file", socket, filename, as.integer(verbose), as.integer(flags),
               PACKAGE = "pbdZMQ")
  invisible(ret)
}
