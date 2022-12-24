### Multiple socket reader as in the ZeroMQ guide.
# SHELL> Rscript wuserver.r &
# SHELL> Rscript taskvent.r &
# SHELL> Rscript mspoller.r
# SHELL> rm weather.ipc

suppressMessages(library(pbdZMQ, quietly = TRUE))

### Initial.
context <- zmq.ctx.new()
receiver <- zmq.socket(context, ZMQ.ST()$PULL)
zmq.connect(receiver, "tcp://localhost:5557")
subscriber <- zmq.socket(context, ZMQ.ST()$SUB)
zmq.connect(subscriber, "tcp://localhost:5556")
zmq.setsockopt(subscriber, ZMQ.SO()$SUBSCRIBE, "20993")

### Process messages from both sockets.
cat("Press Ctrl+C or Esc to stop mspoller.\n")
i.rec <- 0
i.sub <- 0
while(TRUE){
  ### Set poller.
  poller <- zmq.poll(c(receiver, subscriber),
                     c(ZMQ.PO()$POLLIN, ZMQ.PO()$POLLIN))

  ### Check receiver.
  if(bitwAnd(zmq.poll.get.revents(1), ZMQ.PO()$POLLIN)){
    ret <- zmq.recv(receiver)
    if(ret$len != -1){
      cat("task ventilator:", ret$buf, "at", i.rec, "\n")
      i.rec <- i.rec + 1
    }
  }

  ### Check subscriber.
  if(bitwAnd(zmq.poll.get.revents(2), ZMQ.PO()$POLLIN)){
    ret <- zmq.recv(subscriber)
    if(ret$len != -1){
      cat("weather update:", ret$buf, "at", i.sub, "\n")
      i.sub <- i.sub + 1
    }
  }

  if(i.rec >= 5 & i.sub >= 5){
    break
  }

  Sys.sleep(runif(1, 0.5, 1))
}

### Finish.
zmq.poll.free()
zmq.close(receiver)
zmq.close(subscriber)
zmq.ctx.destroy(context)
