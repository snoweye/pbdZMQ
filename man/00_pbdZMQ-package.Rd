\name{pbdZMQ-package}
\alias{pbdZMQ-package}
\alias{pbdZMQ}
\docType{package}
\title{Programming with Big Data -- Interface to ZeroMQ}
\description{
  pbdZMQ makes high level R wrapper functions to utilize ZeroMQ C API functions
  in detail manners. pbdZMQ mainly focuses on client/servers programming
  framework in an interaction style. A minimum ZeroMQ library 4.1.0 rc1 is
  built and linked within pbdZMQ if no external ZerMQ library is not provided.
  A few compatible wrapper functions to rzmq are also provided.
}
\details{
\tabular{ll}{
  Package: \tab pbdZMQ\cr
  Type: \tab Package\cr
%  Version: \tab 0.1-2\cr
%  Date: \tab 2010-02-18\cr
  License: \tab Mozilla Public License 2.0\cr
  LazyLoad: \tab yes\cr
}

  The install command using default \pkg{pbdZMQ}'s internal ZeroMQ library
  is \cr
  \cr
  \code{> R CMD INSTALL pbdZMQ_0.1-0.tar.gz } \cr
  \cr
  Other available variables include
\tabular{ll}{
  Variable \tab Default \cr
  \code{ZMQ_INCLUDE} \tab \code{-I./zmqsrc/include} \cr
  \code{ZMQ_LDFLAGS} \tab \code{-L./ -lzmq} \cr
  \code{ZMQ_POLLER}  \tab \code{select}
}
  See the package source file \code{pbdZMQ/configure} for details.

  For installation using an external ZeroMQ library, see the package
  source file \code{pbdZMQ/INSTALL} for details.
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
  \code{\link{zmq.ctx.new}()}, \code{\link{zmq.socket}()}.
}
\examples{
\dontrun{
### Some examples here.
}
}
\keyword{package}
