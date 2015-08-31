### For ZMQ send/recv options, see zmq.h for details.
ZMQ.SR <- function(
  BLOCK = 0L,
  DONTWAIT = 1L,
  NOBLOCK = 1L,
  SNDMORE = 2L
){
  list(
    BLOCK = BLOCK,
    DONTWAIT = DONTWAIT,
    NOBLOCK = NOBLOCK,
    SNDMORE = SNDMORE
  )
} # End of ZMQ.SR().
