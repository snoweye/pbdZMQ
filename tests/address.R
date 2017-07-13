suppressPackageStartupMessages(library(pbdZMQ))

addr = "notarealaddress.com.biz.google"
port = 8080

test = address(addr, port)
truth = paste0("tcp://", addr, ":", port)
stopifnot(identical(test, truth))

test = address(addr, transport="ipc")
truth = paste0("ipc://", addr)
stopifnot(identical(test, truth))
