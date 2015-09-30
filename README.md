# pbdZMQ

* **Version:** 0.1-1
* **License:** GPL-3
* **Author:** See section below.


pbdZMQ is an R package providing a simplified interface to ZeroMQ
with a focus on client/server programming frameworks.  Notably, pbdZMQ
should allow for the use of ZeroMQ on Windows platforms.



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