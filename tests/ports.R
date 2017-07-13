suppressPackageStartupMessages(library(pbdZMQ))

min = 49152
max = 65536

rp = random_port(min_port=min, max_port=max)
stopifnot(isTRUE(rp > min) && isTRUE(rp < max))

rop = random_open_port(min_port=49152, max_port=65536, max_tries=100)
stopifnot(isTRUE(rop > min) && isTRUE(rop < max))
