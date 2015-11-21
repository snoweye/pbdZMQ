#' Set controls in pbdZMQ
#' 
#' Control functions
#' 
#' \code{.zmqopt_get()} gets a ZMQ control.
#'
#' \code{.zmqopt_set()} sets a ZMQ control.
#' 
#' \code{.zmqopt_init()} initials default ZMQ controls.
#' 
#' @param main 
#' a ZMQ control variable
#' @param sub 
#' a ZMQ control sub-variable
#' @param val 
#' a value for the ZMQ control
#' @param envir 
#' an environment where ZMQ controls locate
#' 
#' @return 
#' \code{.zmqopt_get()} returns the value of the ZMQ control.
#' 
#' \code{.zmqopt_set()} sets the value to the ZMQ control.
#' 
#' \code{.zmqopt_init()} initial the ZMQ control to \code{\link{.pbd_env}}
#' at \code{envir}.
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
#' library(pbdZMQ, quietly = TRUE)
#' 
#' ls(.pbd_env)
#' rm(.pbd_env)
#' .zmqopt_init()
#' ls(.pbd_env)
#'
#' .pbd_env$ZMQ.SR$BLOCK
#' .zmqopt_set(0L, "ZMQ.SR", "BLOCK")
#' }
#' 
#' @keywords programming
#' @seealso \code{\link{.pbd_env}}.
#' @rdname a0_c_options
#' @name Control Functions
NULL


### Get ZMQ options.
#' @export
#' @rdname a0_c_options
.zmqopt_get <- function(main, sub = NULL, envir = .GlobalEnv){
  if(!is.null(sub)){
    envir$.pbd_env[[main]][[sub]]
  } else{
    envir$.pbd_env[[main]]
  }
} # End of .zmqopt_get().

### Set ZMQ options.
#' @export
#' @rdname a0_c_options
.zmqopt_set <- function(val, main, sub = NULL, envir = .GlobalEnv){
  if(!is.null(sub)){
    envir$.pbd_env[[main]][[sub]] <- val
  } else{
    envir$.pbd_env[[main]] <- val
  }

  invisible()
} # End of .zmqopt_set().

### Initial ZMQ options.
#' @export
#' @rdname a0_c_options
.zmqopt_init <- function(envir = .GlobalEnv){
  if(!exists(".pbd_env", envir = envir)){
    envir$.pbd_env <- new.env()
  } 
  envir$.pbd_env$ZMQ.MC <- ZMQ.MC()
  envir$.pbd_env$ZMQ.SR <- ZMQ.SR()
  envir$.pbd_env$ZMQ.SO <- ZMQ.SO()
  envir$.pbd_env$ZMQ.ST <- ZMQ.ST()

  invisible()
} # End of .zmqopt_init().

