\name{ZMQ Control Functions}
\alias{ZMQ.ST}
\alias{ZMQ.SO}
\alias{ZMQ.SR}
\alias{ZMQ.MC}

\title{Sets of controls in pbdZMQ.}
\description{
  These sets of controls are used to provide default values in this package.
}
\usage{
ZMQ.SO(
  AFFINITY = 4L,
  IDENTITY = 5L,
  SUBSCRIBE = 6L,
  UNSUBSCRIBE = 7L,
  RATE = 8L,
  RECOVERY_IVL = 9L,
  SNDBUF = 11L,
  RCVBUF = 12L,
  RCVMORE = 13L,
  FD = 14L,
  EVENTS = 15L,
  TYPE = 16L,
  LINGER = 17L,
  RECONNECT_IVL = 18L,
  BACKLOG = 19L,
  RECONNECT_IVL_MAX = 21L,
  MAXMSGSIZE = 22L,
  SNDHWM = 23L,
  RCVHWM = 24L,
  MULTICAST_HOPS = 25L,
  RCVTIMEO = 27L,
  SNDTIMEO = 28L,
  LAST_ENDPOINT = 32L,
  ROUTER_MANDATORY = 33L,
  TCP_KEEPALIVE = 34L,
  TCP_KEEPALIVE_CNT = 35L,
  TCP_KEEPALIVE_IDLE = 36L,
  TCP_KEEPALIVE_INTVL = 37L,
  TCP_ACCEPT_FILTER = 38L,
  IMMEDIATE = 39L,
  XPUB_VERBOSE = 40L,
  ROUTER_RAW = 41L,
  IPV6 = 42L,
  MECHANISM = 43L,
  PLAIN_SERVER = 44L,
  PLAIN_USERNAME = 45L,
  PLAIN_PASSWORD = 46L,
  CURVE_SERVER = 47L,
  CURVE_PUBLICKEY = 48L,
  CURVE_SECRETKEY = 49L,
  CURVE_SERVERKEY = 50L,
  PROBE_ROUTER = 51L,
  REQ_CORRELATE = 52L,
  REQ_RELAXED = 53L,
  CONFLATE = 54L,
  ZAP_DOMAIN = 55L,
  ROUTER_HANDOVER = 56L,
  TOS = 57L,
  IPC_FILTER_PID = 58L,
  IPC_FILTER_UID = 59L,
  IPC_FILTER_GID = 60L,
  CONNECT_RID = 61L,
  GSSAPI_SERVER = 62L,
  GSSAPI_PRINCIPAL = 63L,
  GSSAPI_SERVICE_PRINCIPAL = 64L,
  GSSAPI_PLAINTEXT = 65L,
  HANDSHAKE_IVL = 66L,
  IDENTITY_FD = 67L,
  SOCKS_PROXY = 68L,
  XPUB_NODROP = 69L
)

ZMQ.ST(
  PAIR = 0L,
  PUB = 1L,
  SUB = 2L,
  REQ = 3L,
  REP = 4L,
  DEALER = 5L,
  ROUTER = 6L,
  PULL = 7L,
  PUSH = 8L,
  XPUB = 9L,
  XSUB = 10L,
  STREAM = 11L
)

ZMQ.SR(
  BLOCK = 0L,
  DONTWAIT = 1L,
  NOBLOCK = 1L,
  SNDMORE = 2L
)

ZMQ.MC(
  warning.at.error = TRUE,
  stop.at.error = FALSE
)
}
\arguments{
  \item{AFFINITY}{see details}
  \item{IDENTITY}{see details}
  \item{SUBSCRIBE}{see details}
  \item{UNSUBSCRIBE}{see details}
  \item{RATE}{see details}
  \item{RECOVERY_IVL}{see details}
  \item{SNDBUF}{see details}
  \item{RCVBUF}{see details}
  \item{RCVMORE}{see details}
  \item{FD}{see details}
  \item{EVENTS}{see details}
  \item{TYPE}{see details}
  \item{LINGER}{see details}
  \item{RECONNECT_IVL}{see details}
  \item{BACKLOG}{see details}
  \item{RECONNECT_IVL_MAX}{see details}
  \item{MAXMSGSIZE}{see details}
  \item{SNDHWM}{see details}
  \item{RCVHWM}{see details}
  \item{MULTICAST_HOPS}{see details}
  \item{RCVTIMEO}{see details}
  \item{SNDTIMEO}{see details}
  \item{LAST_ENDPOINT}{see details}
  \item{ROUTER_MANDATORY}{see details}
  \item{TCP_KEEPALIVE}{see details}
  \item{TCP_KEEPALIVE_CNT}{see details}
  \item{TCP_KEEPALIVE_IDLE}{see details}
  \item{TCP_KEEPALIVE_INTVL}{see details}
  \item{TCP_ACCEPT_FILTER}{see details}
  \item{IMMEDIATE}{see details}
  \item{XPUB_VERBOSE}{see details}
  \item{ROUTER_RAW}{see details}
  \item{IPV6}{see details}
  \item{MECHANISM}{see details}
  \item{PLAIN_SERVER}{see details}
  \item{PLAIN_USERNAME}{see details}
  \item{PLAIN_PASSWORD}{see details}
  \item{CURVE_SERVER}{see details}
  \item{CURVE_PUBLICKEY}{see details}
  \item{CURVE_SECRETKEY}{see details}
  \item{CURVE_SERVERKEY}{see details}
  \item{PROBE_ROUTER}{see details}
  \item{REQ_CORRELATE}{see details}
  \item{REQ_RELAXED}{see details}
  \item{CONFLATE}{see details}
  \item{ZAP_DOMAIN}{see details}
  \item{ROUTER_HANDOVER}{see details}
  \item{TOS}{see details}
  \item{IPC_FILTER_PID}{see details}
  \item{IPC_FILTER_UID}{see details}
  \item{IPC_FILTER_GID}{see details}
  \item{CONNECT_RID}{see details}
  \item{GSSAPI_SERVER}{see details}
  \item{GSSAPI_PRINCIPAL}{see details}
  \item{GSSAPI_SERVICE_PRINCIPAL}{see details}
  \item{GSSAPI_PLAINTEXT}{see details}
  \item{HANDSHAKE_IVL}{see details}
  \item{IDENTITY_FD}{see details}
  \item{SOCKS_PROXY}{see details}
  \item{XPUB_NODROP}{see details}

  \item{PAIR}{see details}
  \item{PUB}{see details}
  \item{SUB}{see details}
  \item{REQ}{see details}
  \item{REP}{see details}
  \item{DEALER}{see details}
  \item{ROUTER}{see details}
  \item{PULL}{see details}
  \item{PUSH}{see details}
  \item{XPUB}{see details}
  \item{XSUB}{see details}
  \item{STREAM}{see details}

  \item{BLOCK}{see details}
  \item{DONTWAIT}{see details}
  \item{NOBLOCK}{see details}
  \item{SNDMORE}{see details}
 
  \item{warning.at.error}{see details}
  \item{stop.at.error}{see details}
}
\details{
  The elements of \code{.SPMD.ST} are default values for socket types
  as defined in `zmq.h' including
\tabular{lcl}{
  Elements          \tab Value   \tab Usage \cr
  \code{PAIR}       \tab 0L      \tab socket type PAIR \cr
  \code{PUB}        \tab 1L      \tab socket type PUB \cr
  \code{SUB}        \tab 2L      \tab socket type SUB \cr
  \code{REQ}        \tab 3L      \tab socket type REQ \cr
  \code{REP}        \tab 4L      \tab socket type REP \cr
  \code{DEALER}     \tab 5L      \tab socket type DEALER \cr
  \code{ROUTER}     \tab 6L      \tab socket type ROUTER \cr
  \code{PULL}       \tab 7L      \tab socket type PULL \cr
  \code{PUSH}       \tab 8L      \tab socket type PUSH \cr
  \code{XPUB}       \tab 9L      \tab socket type XPUB \cr
  \code{XSUB}       \tab 10L     \tab socket type XSUB \cr
  \code{STREAM}     \tab 11L     \tab socket type STREAM
}

  The elements of \code{.pbdZMQEnv$ZMQ.SO} are default values for socket options
  as defined in `zmq.h' including 60 different values, see \code{.pbdZMQEnv$ZMQ.SO}
  and `zmq.h' for details.

  The elements of \code{.pbdZMQEnv$ZMQ.SR} are default values for send/recv options
  as defined in `zmq.h' including
\tabular{lcl}{
  Elements          \tab Value   \tab Usage \cr
  \code{BLOCK}      \tab 0L      \tab send/recv option BLOCK \cr
  \code{DONTWAIT}   \tab 1L      \tab send/recv option DONTWAIT \cr
  \code{NOBLOCK}    \tab 1L      \tab send/recv option NOBLOCK \cr
  \code{SNDMORE}    \tab 2L      \tab send/recv option SNDMORE (not supported)
}

  The elements of \code{.pbdZMQEnv$ZMQ.MC} are default values for warning and stop
  controls in R. These are not the ZeroMQ's internal default values. They
  are defined as
\tabular{lcl}{
  Elements                 \tab Value \tab Usage \cr
  \code{warning.at.error}  \tab TRUE  \tab if warn at error \cr
  \code{stop.at.error}     \tab TRUE     \tab if stop at error
}
}
\value{
  A list with controlling parameters and values is returns.
}
\references{
  ZeroMQ/4.1.0 API Reference:
  \url{http://api.zeromq.org/4-1:_start}

  Programming with Big Data in R Website:
  \url{http://r-pbd.org/}
}
\author{
  Wei-Chen Chen \email{wccsnow@gmail.com}.
}
\keyword{global variables}
