\name{ Utility Functions}
\alias{zmq.strerror}
\alias{zmq.version}
\title{ Utility Functions }
\description{ Utility functions }
\usage{
  zmq.strerror(errno)

  zmq.version()
}
\arguments{
  \item{errno}{an integer for the error number}
}
\details{
  \code{zmq.strerror()} gets ZeroMQ error message string.

  \code{zmq.version()} print current ZeroMQ version.
}
\value{
  \code{zmq.strerror()} returns an R string containing ZeroMQ error message.
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
  \code{\link{zmq.ctx.new}()}, \code{\link{zmq.ctx.destroy}()},
  \code{\link{zmq.socket}()}, \code{\link{zmq.close}()}.
}
\examples{
\dontrun{
library(pbdZMQ, quietly = TRUE)

context <- zmq.ctx.new()
zmq.ctx.destroy(context)
zmq.strerror(0)

zmq.ctx.destroy(context) # Error since context is free.
zmq.strerror(14)
}
}
\keyword{internal}
