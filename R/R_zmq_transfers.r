#' Transfer Functions for Files or Directories
#' 
#' High level functions calling \code{zmq.sendfile()} and \code{zmq.recvfile()}
#' to zip, transfer, and unzip small files or directories contains small files.
#' 
#' @details
#' \code{zmq.senddir()} calls \code{zmq.senddir()}, and
#' \code{zmq.recvdir()} calls \code{zmq.recvdir()}.
#' 
#' @param port 
#' A valid tcp port to be passed to \code{zmq.sendfile()} and
#' \code{zmq.recvfile()}.
#' @param endpoint
#' A ZMQ socket endpoint to be passed to \code{zmq.sendfile()} and
#' \code{zmq.recvfile()}.
#' @param infiles
#' The name (as a string) vector of the in files to be zipped and to be
#' sent away.
#' @param outfile
#' The name (as a string) of the out file to be saved on the disk.
#' If \code{outfile = NULL} and \code{exdir = NULL}, a tempfile will be
#' used and the tempfile nanme will be returned.
#' @param exdir
#' The name (as a string) of the out directory to save the unzip files
#' unzipped from the received \code{outfile}.
#' @param verbose
#' Logical; determines if a progress bar should be shown.
#' @param flags
#' A flag for the method used by \code{zmq_sendfile} and
#' \code{zmq_recvfile}
#' @param ctx
#' A ZMQ ctx. If \code{NULL} (default), the function will initial one at
#' the beginning and destroy it after finishing file transfer.
#' @param socket
#' A ZMQ socket based on \code{ctx}.
#' If \code{NULL} (default), the function will create one at the beginning
#' and close it after finishing file transfer.
#' 
#' 
#' @return \code{zmq.senddir()} and \code{zmq.recvdir()} return
#' number of bytes (invisible) in the sent message if successful,
#' otherwise returns -1 (invisible) and sets \code{errno} to the error
#' value, see ZeroMQ manual for details.
#' In addition, \code{zmq.recvdir()} returns a zipped file name in a list.
#' 
#' @author Wei-Chen Chen
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
#' ### Receiver
#' library(pbdZMQ, quietly = TRUE)
#' zmq.recvdir(55555, "localhost", outfile = "./backup_2019.zip")
#' ### or unzip to exdir
#' # zmq.recvdir(55555, "localhost", exdir = "./backup_2019")
#' 
#' ### Sender
#' library(pbdZMQ, quietly = TRUE)
#' zmq.senddir(55555, c("./pbdZMQ/R", "./pbdZMQ/src"))
#' }
#' 
#' @keywords programming
#' @seealso \code{\link{zmq.sendfile}()}, \code{\link{zmq.recvfile}()}.
#' @rdname b2_sendrecvdir
#' @name Transfer Functions for Files or Directories
NULL



#' @rdname b2_sendrecvdir
#' @export
zmq.senddir <- function(port, infiles, verbose = FALSE,
                        flags = .pbd_env$ZMQ.SR$BLOCK,
                        ctx = NULL, socket = NULL)
{
  if (is.null(ctx))
  {
    ctx <- zmq.ctx.new()
    ctx.destroy <- TRUE
  }
  else
    ctx.destroy <- FALSE

  if (is.null(socket))
  {
    socket <- zmq.socket(ctx, .pbd_env$ZMQ.ST$PUSH)
    socket.close <- TRUE
  }
  else
    socket.close <- FALSE

  if (!verbose)
    extras <- "-q"
  else
    extras <- ""

  tmp.fn <- tempfile(fileext = ".zip")
  zip(tmp.fn, infiles, extras = extras)
  ret <- zmq.sendfile(port, tmp.fn, verbose = verbose, flags = flags,
                      forcebin = TRUE, ctx = ctx, socket = socket)
  
  if (socket.close || ctx.destroy)
    zmq.close(socket)

  if (ctx.destroy)
    zmq.ctx.destroy(ctx)
  
  invisible(list(ret = ret, infile = tmp.fn))
}


#' @rdname b2_sendrecvdir
#' @export
zmq.recvdir <- function(port, endpoint, outfile = NULL, exdir = NULL,
                        verbose = FALSE, flags = .pbd_env$ZMQ.SR$BLOCK,
                        ctx = NULL, socket = NULL)
{
  if (is.null(ctx))
  {
    ctx <- zmq.ctx.new()
    ctx.destroy <- TRUE
  }
  else
    ctx.destroy <- FALSE

  if (is.null(socket))
  {
    socket <- zmq.socket(ctx, .pbd_env$ZMQ.ST$PULL)
    socket.close <- TRUE
  }
  else
    socket.close <- FALSE

  if (is.null(outfile))
    outfile <- tempfile()

  ret <- zmq.recvfile(port, endpoint, outfile, verbose = verbose,
                      flags = flags, forcebin = TRUE,
                      ctx = ctx, socket = socket)

  if (!is.null(exdir))
    unzip(outfile, exdir = exdir)

  if (socket.close || ctx.destroy)
    zmq.close(socket)

  if (ctx.destroy)
    zmq.ctx.destroy(ctx)
  
  invisible(list(ret = ret, outfile = outfile))
}
