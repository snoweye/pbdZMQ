#' File Transfer Functions
#' 
#' High level functions calling \code{zmq_send()} and \code{zmq_recv()}
#' to transfer a file in 200 KiB chunks.
#' 
#' @details
#' If no socket is passed, then by default \code{zmq.sendfile()} binds a
#' \code{ZMQ_PUSH} socket, and \code{zmq.recvfile()} connects to this with a
#' \code{ZMQ_PULL} socket. On the other hand, a PUSH/PULL or REQ/REP socket
#' combination may be passed. In that case, the socket should already be
#' connected to the desired endpoint.
#' 
#' @param port 
#' A valid tcp port.
#' @param endpoint
#' A ZMQ socket endpoint.
#' @param filename
#' The name (as a string) of the in/out files. The in and out file names
#' can be different.
#' @param verbose
#' Logical; determines if a progress bar should be shown.
#' @param flags
#' A flag for the method used by \code{zmq_sendfile} and
#' \code{zmq_recvfile}
#' @param forcebin
#' Force to read/send/recv/write in binary form. Typically for a Windows
#' system, text (ASCII) and binary files are processed differently.
#' If \code{TRUE}, "r+b" and "w+b" will be enforced in the C code.
#' This option is mainly for Windows.
#' @param ctx
#' A ZMQ ctx. If \code{NULL} (default), the function will initial one at
#' the beginning and destroy it after finishing file transfer.
#' @param socket
#' A ZMQ socket based on \code{ctx}.
#' If \code{NULL} (default), the function will create one at the beginning
#' and close it after finishing file transfer.
#' 
#' 
#' @return \code{zmq.sendfile()} and \code{zmq.recvfile()} return
#' number of bytes (invisible) in the sent message if successful,
#' otherwise returns -1 (invisible) and sets \code{errno} to the error
#' value, see ZeroMQ manual for details.
#' 
#' @author Drew Schmidt and Christian Heckendorf
#' 
#' @references ZeroMQ/4.1.0 API Reference:
#' \url{http://api.zeromq.org/4-1:_start}
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' 
#' @examples
#' \dontrun{
#' ### Run the sender and receiver code in separate R sessions.
#' 
#' # Receiver
#' library(pbdZMQ, quietly = TRUE)
#' zmq.recvfile(55555, "localhost", "/tmp/outfile", verbose=TRUE)
#' 
#' # Sender
#' library(pbdZMQ, quietly = TRUE)
#' zmq.sendfile(55555, "/tmp/infile", verbose=TRUE)
#' }
#' 
#' @keywords programming
#' @seealso \code{\link{zmq.msg.send}()}, \code{\link{zmq.msg.recv}()}.
#' @rdname b1_sendrecvfile
#' @name File Transfer Functions
NULL



# -----------------------------------------------------------------------------
# Send
# -----------------------------------------------------------------------------

#' @rdname b1_sendrecvfile
#' @export
zmq.sendfile <- function(port, filename, verbose=FALSE,
  flags = .pbd_env$ZMQ.SR$BLOCK, forcebin = FALSE, ctx = NULL, socket = NULL)
{
  if (is.null(socket))
  {
    if (is.null(ctx))
    {
      ctx <- zmq.ctx.new()
      ctx.destroy <- TRUE
    }
    else
      ctx.destroy <- FALSE
    
    socket <- zmq.socket(ctx, .pbd_env$ZMQ.ST$PUSH)
    socket.close <- TRUE
    
    endpoint <- address("*", port)
    zmq.bind(socket, endpoint)
  }
  else
  {
    ctx.destroy <- FALSE
    socket.close <- FALSE
  }
  
  type = attr(socket, "type")
  if (is.null(type))
    stop("unable to determine socket type")
  else if (type != .pbd_env$ZMQ.ST$PUSH && type != .pbd_env$ZMQ.ST$REQ)
    stop("socket type must be one of PUSH or REQ (matching PULL and REP respectively in zmq.recvfile())")
  
  fi <- file.info(filename)
  if (!is.na(fi$isdir) && !fi$isdir)
  {
    filesize <- as.double(fi$size)
    send.socket(socket, filesize)
    
    if (type == .pbd_env$ZMQ.ST$REQ)
      receive.socket(socket)
    
    ret <- .Call("R_zmq_send_file", socket, filename, as.integer(verbose),
      filesize, as.integer(flags), as.integer(forcebin), type, PACKAGE="pbdZMQ")
  }
  else
    stop(paste("File does not exist:", filename)) 
  
  if (socket.close || ctx.destroy)
    zmq.close(socket)
  if (ctx.destroy)
    zmq.ctx.destroy(ctx)
  
  invisible(ret)
}



# -----------------------------------------------------------------------------
# Receive
# -----------------------------------------------------------------------------

#' @rdname b1_sendrecvfile
#' @export
zmq.recvfile <- function(port, endpoint, filename, verbose=FALSE,
  flags = .pbd_env$ZMQ.SR$BLOCK, forcebin = FALSE, ctx = NULL, socket = NULL)
{
  if (is.null(socket))
  {
    if (is.null(ctx))
    {
      ctx <- zmq.ctx.new()
      ctx.destroy <- TRUE
    }
    else
      ctx.destroy <- FALSE
    
    socket <- zmq.socket(ctx, .pbd_env$ZMQ.ST$PULL)
    socket.close <- TRUE
    
    endpoint <- address(endpoint, port)
    zmq.connect(socket, endpoint)
  }
  else
  {
    ctx.destroy <- FALSE
    socket.close <- FALSE
  }
  
  type = attr(socket, "type")
  if (is.null(type))
    stop("unable to determine socket type")
  else if (type != .pbd_env$ZMQ.ST$PULL && type != .pbd_env$ZMQ.ST$REP)
    stop("socket type must be one of PULL or REP (matching PUSH and REQ respectively in zmq.sendfile())")
  
  filesize <- receive.socket(socket)
  if (type == .pbd_env$ZMQ.ST$REP)
    send.socket(socket, NULL)
  
  ret <- .Call("R_zmq_recv_file", socket, filename, as.integer(verbose),
    filesize, as.integer(flags), as.integer(forcebin), type, PACKAGE="pbdZMQ")

  if (socket.close || ctx.destroy)
    zmq.close(socket)
  if (ctx.destroy)
    zmq.ctx.destroy(ctx)
  
  invisible(ret)
}
