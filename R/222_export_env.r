#' Sets of controls in pbdZMQ.
#' 
#' These sets of controls are used to provide default values in this package.
#' 
#' The elements of \code{.pbdZMQEnv$ZMQ.ST} are default values for socket types
#' as defined in `zmq.h' including \tabular{lcl}{ Elements \tab Value \tab
#' Usage \cr \code{PAIR} \tab 0L \tab socket type PAIR \cr \code{PUB} \tab 1L
#' \tab socket type PUB \cr \code{SUB} \tab 2L \tab socket type SUB \cr
#' \code{REQ} \tab 3L \tab socket type REQ \cr \code{REP} \tab 4L \tab socket
#' type REP \cr \code{DEALER} \tab 5L \tab socket type DEALER \cr \code{ROUTER}
#' \tab 6L \tab socket type ROUTER \cr \code{PULL} \tab 7L \tab socket type
#' PULL \cr \code{PUSH} \tab 8L \tab socket type PUSH \cr \code{XPUB} \tab 9L
#' \tab socket type XPUB \cr \code{XSUB} \tab 10L \tab socket type XSUB \cr
#' \code{STREAM} \tab 11L \tab socket type STREAM }
#' 
#' The elements of \code{.pbdZMQEnv$ZMQ.SO} are default values for socket
#' options as defined in `zmq.h' including 60 different values, see
#' \code{.pbdZMQEnv$ZMQ.SO} and `zmq.h' for details.
#' 
#' The elements of \code{.pbdZMQEnv$ZMQ.SR} are default values for send/recv
#' options as defined in `zmq.h' including \tabular{lcl}{ Elements \tab Value
#' \tab Usage \cr \code{BLOCK} \tab 0L \tab send/recv option BLOCK \cr
#' \code{DONTWAIT} \tab 1L \tab send/recv option DONTWAIT \cr \code{NOBLOCK}
#' \tab 1L \tab send/recv option NOBLOCK \cr \code{SNDMORE} \tab 2L \tab
#' send/recv option SNDMORE (not supported) }
#' 
#' The elements of \code{.pbdZMQEnv$ZMQ.MC} are default values for warning and
#' stop controls in R. These are not the ZeroMQ's internal default values. They
#' are defined as \tabular{lcl}{ Elements \tab Value \tab Usage \cr
#' \code{warning.at.error} \tab TRUE \tab if warn at error \cr
#' \code{stop.at.error} \tab TRUE \tab if stop at error }
#' 
#' @name ZMQ Control Environment
#' @aliases .pbdZMQEnv
#' @docType data
#' @format Objects contain several parameters for communicators and methods.
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' @references ZeroMQ/4.1.0 API Reference:
#' \url{http://api.zeromq.org/4-1:_start}
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' @keywords global variables
#' @rdname a0_b_control
.pbdZMQEnv <- new.env()
.pbdZMQEnv$ZMQ.MC <- ZMQ.MC()
.pbdZMQEnv$ZMQ.SR <- ZMQ.SR()
.pbdZMQEnv$ZMQ.SO <- ZMQ.SO()
.pbdZMQEnv$ZMQ.ST <- ZMQ.ST()

