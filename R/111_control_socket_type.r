### For ZMQ socket types, see zmq.h for details.
ZMQ.ST <- function(
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
){
  list(
    PAIR = PAIR,
    PUB = PUB,
    SUB = SUB,
    REQ = REQ,
    REP = REP,
    DEALER = DEALER,
    ROUTER = ROUTER,
    PULL = PULL,
    PUSH = PUSH,
    XPUB = XPUB,
    XSUB = XSUB,
    STREAM = STREAM
  )
} # End of ZMQ.ST().
