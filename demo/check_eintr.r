library(pbdZMQ, quietly = TRUE)

context <- zmq.ctx.new()
receiver <- zmq.socket(context, .pbd_env$ZMQ.ST$PULL)
zmq.connect(receiver, "tcp://localhost:5557")

a1 <- zmq.poll(c(receiver), .pbd_env$ZMQ.PO$POLLIN)
print(a1)

a2 <- tryCatch(zmq.poll(c(receiver), .pbd_env$ZMQ.PO$POLLIN),
       interrupt = function(c) return(9),
       error = function(c) return(99))
print(a2)

a3 <- tryCatch(zmq.poll(c(receiver), .pbd_env$ZMQ.PO$POLLIN,
                       MC = ZMQ.MC(check.eintr = TRUE)),
        interrupt = function(c) return(9),
        error = function(c) return(99))
print(a3)

a4 <- zmq.poll(c(receiver), .pbd_env$ZMQ.PO$POLLIN,
               MC = ZMQ.MC(check.eintr = TRUE))
print(a4)
print("This message should not be reached.")

