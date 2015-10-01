# pbdZMQ

* **Version:** 0.1-2
* **License:** GPL-3
* **Author:** See section below.


pbdZMQ is an R package providing a simplified interface to ZeroMQ
with a focus on client/server programming frameworks.  Notably, pbdZMQ
should allow for the use of ZeroMQ on Windows platforms.


## Interfaces

The package contains 3 separate interfaces:

1. One modeled after the ZeroMQ C interface (see help("czmq"))
2. One modeled after the PyZMQ interface (see help("pyzmq"))
3. One modeled after the rzmq interface (see help("rzmq"))



## Client/Server Example

The primary focus of pbdZMQ is for building client/server interfaces
for R.  An example of this can be found in the pbdCS package, which
uses this model to control batch MPI servers interactively.  There
are also several illustrative examples in the pbdZMQ package vignette.

The basic idea is that you need a server R process, and a separate
client R process.  For demonstration/simplicity, assume they are
both running on the same machine.  The server we describe here is
very basic.  You can see a more detailed example in the pbdZMQ
package vignette.


#### Setting Up The Server

Save the following as, say, `server.r` and run it in batch by 
running `Rscript server.r` from a terminal.

```r
library(pbdZMQ)
ctxt <- init.context()
socket <- init.socket(ctxt, "ZMQ_REP")
bind.socket(socket, "tcp://*:5555")

cat("Client command:  ")
msg <- receive.socket(socket)

cat(msg, "\n")
send.socket(socket, "Message received!")
```


#### Setting Up The Client

From an interactive R session (not in batch), enter the
following:

```r
library(pbdZMQ)
ctxt <- init.context()
socket <- init.socket(ctxt, "ZMQ_REQ")
connect.socket(socket, "tcp://localhost:5555")

send.socket(socket, "1+1")
```

If all goes well, your message should be sent from the client
to the server, before your server terminates.

For an example of how to do this more persistently, see the pbdZMQ
package vignette.



## Installation

pbdZMQ requires
* R version 3.0.0 or higher.
* Linux, Mac OSX, Windows, or FreeBSD (doesn't work on Solaris).
* libzmq >= 4.0.4.

A distribution of libzmq is shipped with pbdZMQ for convenience.  However,
if you already have a system installation of ZeroMQ, then it is simple
to use that with pbdZMQ.  Full details on installation and troubleshooting
can be found in the package vignette, located at `inst/doc/pbdMPI-guide.pdf` of the pbdZMQ source tree.

The package can be installed from the CRAN via the usual
`install.packages("pbdZMQ")`, or via the devtools package:

```r
library(devtools)
install_github("RBigData/pbdZMQ")
```



## Authors

pbdMPI is authored and maintained by the pbdR core team:
* Wei-Chen Chen
* Drew Schmidt

With additional contributions from:
* Whit Armstrong (some functions are modified from rzmq for backwards compatibility)
* Brian Ripley (C code of shellexec)
* The R Core team (some functions are modified from the R source code)

For the distribution of ZeroMQ that is shipped with pbdZMQ, you can find details of authorship and copyright in `inst/zmq_copyright/` of the pbdZMQ source tree, or under `zmq_copyright/` of a binary installation of pbdZMQ.
