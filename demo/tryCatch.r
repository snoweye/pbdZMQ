### Multiple socket reader as in the ZeroMQ guide.
# R> source("tryCatch.r")

library(pbdZMQ, quietly = TRUE)

### Initial.
context <- zmq.ctx.new()
receiver <- zmq.socket(context, .pbd_env$ZMQ.ST$PULL)
zmq.connect(receiver, "tcp://localhost:5557")

### Process messages from the socket.
cat("Press Ctrl+C or Esc to stop mspoller.\n")
aa <- tryCatch(zmq.poll(c(receiver), c(.pbd_env$ZMQ.PO$POLLIN)),
               interrupt = function(c){ })
print(aa)

cat("Press Ctrl+C or Esc to stop mspoller.\n")
.pbd_env$ZMQ.MC$check.ctrl.c <- FALSE
.pbd_env$ZMQ.MC$stop.at.error <- TRUE
bb <- tryCatch(zmq.poll(c(receiver), c(.pbd_env$ZMQ.PO$POLLIN)),
               warning = function(c){ "I am warning" },
               error = function(c){ "I am error" },
               finally = function(c){ "I am done" })
print(bb)

cat("Press Ctrl+C or Esc to stop mspoller.\n")
.pbd_env$ZMQ.MC$stop.at.error <- FALSE
cc <- tryCatch(zmq.poll(c(receiver), c(.pbd_env$ZMQ.PO$POLLIN)),
               warning = function(c){ "I am warning" },
               error = function(c){ "I am error" },
               finally = function(c){ "I am done" })
print(cc)

### Finish.
zmq.poll.free()
zmq.close(receiver)
zmq.ctx.destroy(context)
