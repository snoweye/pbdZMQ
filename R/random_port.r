#' Random Port
#' 
#' Generate a valid, random TCP port.
#' 
#' By definition, a TCP port is an unsigned short, and so it can not
#' exceed 65535.  Additionally, ports in the range 1024 to 49151 are
#' (possibly) registered by ICANN for specific uses.
#' 
#' @param min_port,max_port
#' The minimum/maximum value to be generated.  The minimum should not
#' be below 49152 and the maximum should not exceed 65536 (see
#' details).
#' 
#' @references
#' "The Ephemeral Port Range" by Mike Gleason.  
#' \url{http://www.ncftp.com/ncftpd/doc/misc/ephemeral_ports.html}
#' 
#' @export
random_port <- function(min_port=49152, max_port=65536)
{
  if (min_port < 49152)
    warning("non-recommended 'min_port' value; see ?random_port for details")
  if (max_port > 65536)
    warning("non-recommended 'max_port' value; see ?random_port for details")
  
  
  as.integer(runif(1, min_port, max_port+1))
}
