\name{Message Functions}
\alias{zmq.msg.send}
\alias{zmq.msg.recv}
\title{ Message Functions }
\description{ Message functions }
\usage{
  zmq.msg.send(rmsg, socket, flags = .pbdZMQEnv$ZMQ.SR$BLOCK, serialize = TRUE)
  zmq.msg.recv(socket, flags = .pbdZMQEnv$ZMQ.SR$BLOCK, unserialize = TRUE)
}
\arguments{
  \item{rmsg}{an R message}
  \item{socket}{a ZMQ socket}
  \item{flags}{a flag for method of send and receive}
  \item{serialize}{if serialize the \code{rmsg}}
  \item{unserialize}{if unserialize the received R message}
}
\details{
  \code{zmq.msg.send()} sends an R message.

  \code{zmq.msg.recv()} receives an R message.
}
\value{
  \code{zmq.msg.send()} returns 0 if successful, otherwise returns -1
  and sets \code{errno} to \code{EFAULT}.

  \code{zmq.msg.recv()} returns the message if successful, otherwise returns -1
  and sets \code{errno} to \code{EFAULT}.
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
\seealso{
  \code{\link{zmq.send}()}, \code{\link{zmq.recv}()}.
}
\examples{
\dontrun{
### Using request-reply pattern.

### At the server, run next in background or the other window.
library(pbdZMQ, quietly = TRUE)

context <- zmq.ctx.new()
responder <- zmq.socket(context, .pbdZMQEnv$ZMQ.ST$REP)
zmq.bind(responder, "tcp://*:5555")
buf <- zmq.msg.recv(responder)
set.seed(1234)
ret <- rnorm(5)
print(ret)
zmq.msg.send(ret, responder)
zmq.close(responder)
zmq.ctx.destroy(context)


### At a client, run next in foreground.
library(pbdZMQ, quietly = TRUE)

context <- zmq.ctx.new()
requester <- zmq.socket(context, .pbdZMQEnv$ZMQ.ST$REQ)
zmq.connect(requester, "tcp://localhost:5555")
zmq.msg.send(NULL, requester)
ret <- zmq.msg.recv(requester)
print(ret)
zmq.close(requester)
zmq.ctx.destroy(context)
}
}
\keyword{programming}
