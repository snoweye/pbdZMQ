#' ZMQ Flags
#' 
#' ZMQ Flags
#' 
#' \code{get.zmq.cppflags()} gets CFLAGS or CPPFLAGS
#'
#' \code{get.zmq.ldflags()} gets LDFLAGS
#' 
#' @param arch 
#' '' (default) for non-windows or '/i386' and '/ix64' for windows
#' @param package
#' the pbdZMQ package 
#' 
#' @return flags to compile and link with ZMQ.
#' 
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' 
#' @references ZeroMQ/4.1.0 API Reference:
#' \url{http://api.zeromq.org/4-1:_start}
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' 
#' @examples
#' \dontrun{
#' get.zmq.cppflags(arch = '/i386')
#' get.zmq.ldflags(arch = '/x64')
#' }
#' 
#' @keywords compile
#' @rdname zz_zmq_flags
#' @name ZMQ Flags
NULL



#' @rdname zz_zmq_flags
#' @export
get.zmq.ldflags <- function(arch = '', package = "pbdZMQ"){
  if(arch == "/i386" || arch == "/x64"){
    file.name <- paste("./libs", arch, "/", sep = "")
    dir.path <- tools::file_path_as_absolute(
                  system.file(file.name, package = package))
    zmq.ldflags <- paste("-L", dir.path, " -lzmq", sep = "")
  } else{
    ### For non windows system.
    file.name <- paste("./etc", arch, "/Makeconf", sep = "")
    file.path <- tools::file_path_as_absolute(
                   system.file(file.name, package = package))
    ret <- scan(file.path, what = character(), sep = "\n", quiet = TRUE)

    ### Check if external zmq is used.
    arg <- "EXTERNAL_ZMQ_LDFLAGS"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    ext.zmq.ld <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check if internal zmq is used.
    arg <- "ENABLE_INTERNAL_ZMQ"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    en.int.zmq <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check which zmq should be used.
    if(ext.zmq.ld == "" || en.int.zmq == "yes"){
      file.name <- paste("./libs", arch, "/", sep = "")
      dir.path <- tools::file_path_as_absolute(
                    system.file(file.name, package = package))
      if(Sys.info()[['sysname']] == "Darwin"){
        zmq.ldflags <- paste("-L", dir.path, " -lzmq.4", sep = "")
      } else{
        zmq.ldflags <- paste("-L", dir.path, " -lzmq", sep = "")
      }
    } else{
      zmq.ldflags <- ext.zmq.ld
    }
  }

  ### Cat back to "Makevars".
  cat(zmq.ldflags)

  invisible(zmq.ldflags)
} # End of get.zmq.ldflags().



#' @rdname zz_zmq_flags
#' @export
get.zmq.cppflags <- function(arch = '', package = "pbdZMQ"){
  if(arch == "/i386" || arch == "/x64"){
    file.name <- paste("./zmq", arch, "/include", sep = "")
    dir.path <- tools::file_path_as_absolute(
                  system.file(file.name, package = package))
    zmq.cppflags <- paste("-I", dir.path, sep = "")
  } else{
    ### For non windows system.
    file.name <- paste("./etc", arch, "/Makeconf", sep = "")
    file.path <- tools::file_path_as_absolute(
                   system.file(file.name, package = package))
    ret <- scan(file.path, what = character(), sep = "\n", quiet = TRUE)

    ### Check if external zmq is used.
    arg <- "EXTERNAL_ZMQ_INCLUDE"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    ext.zmq.inc <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check if internal zmq is used.
    arg <- "ENABLE_INTERNAL_ZMQ"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    en.int.zmq <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check which zmq should be used.
    if(ext.zmq.inc == "" || en.int.zmq == "yes"){
      file.name <- paste("./zmq", arch, "/include/", sep = "")
      dir.path <- tools::file_path_as_absolute(
                    system.file(file.name, package = package))
      zmq.cppflags <- paste("-I", dir.path, sep = "")
    } else{
      zmq.cppflags <- ext.zmq.inc
    }
  }

  ### Cat back to "Makevars".
  cat(zmq.cppflags)

  invisible(zmq.cppflags)
} # End of get.zmq.cppflags().
