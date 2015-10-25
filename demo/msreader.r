### Multiple socket reader as in the ZeroMQ guide.
# SHELL> Rscript wuserver.r &
# SHELL> Rscript taskvent.r &
# SHELL> Rscript msreader.r
# SHELL> rm weather.ipc

library(pbdZMQ, quietly = TRUE)

### Initial.
context <- zmq.ctx.new()
receiver <- zmq.socket(context, .zmqopt_get("ZMQ.ST")$PULL)
zmq.connect(receiver, "tcp://localhost:5557")
subscriber <- zmq.socket(context, .zmqopt_get("ZMQ.ST")$SUB)
zmq.connect(subscriber, "tcp://localhost:5556")
zmq.setsockopt(subscriber, .zmqopt_get("ZMQ.SO", "SUBSCRIBE"), "20993")

### Process messages from both sockets.
cat("Press Ctrl+C or Esc to stop msreader.\n")
# while(TRUE){
  # while(TRUE){
  for(i in 1:5){
    ret <- zmq.recv(receiver)
    if(ret$len != -1){
      cat("task ventilator:", ret$buf, "\n")
    } else{
      break
    }
  }

  # while(TRUE){
  for(i in 1:5){
    ret <- zmq.recv(subscriber)
    if(ret$len != -1){
      cat("weather update:", ret$buf, "\n")
    } else{
      break
    }
  }

#   Sys.sleep(1/1000)
# }

### Finish.
zmq.close(receiver)
zmq.close(subscriber)
zmq.ctx.destroy(context)
