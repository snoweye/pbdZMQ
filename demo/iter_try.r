### Iterative pollers
# SHELL> Rscript iter_try.r

suppressMessages(library(pbdZMQ, quietly = TRUE))

### Initial.
context <- zmq.ctx.new()
receiver <- zmq.socket(context, ZMQ.ST()$PULL)
zmq.connect(receiver, "tcp://localhost:5557")

### Process messages from the socket.
for(i in 1:5){
  cat("Press Ctrl+C or Esc to stop iter_script ... ", i, "\n", sep = "")
  aa <- tryCatch(zmq.poll(c(receiver), c(ZMQ.PO()$POLLIN)),
                 interrupt = function(c){ c$ret$pollret })
  print(aa)
}

### Finish.
zmq.close(receiver)
zmq.ctx.destroy(context)
