#' ZMQ Flags
#' 
#' ZMQ Flags
#' 
#' \code{get.zmq.cppflags()} gets CFLAGS or CPPFLAGS
#'
#' \code{get.zmq.ldflags()} gets LDFLAGS for libzmq.so, libzmq.dll, or libzmq.*.dylib
#'
#' \code{get.pbdZMQ.ldflags()} gets LDFLAGS for pbdZMQ.so or pbdZMQ.dll
#' 
#' \code{test.load.zmq()} tests load libzmq and pbdZMQ shared libraries
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
#' get.pbdZMQ.ldflags(arch = '/x64')
#' test.load.zmq(arch = '/x64')
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
    zmq.ldflags <- paste("-L\"", dir.path, "\" -lzmq", sep = "")
  } else{
    ### For non windows system.
    file.name <- paste("./etc", arch, "/Makeconf", sep = "")
    file.path <- tools::file_path_as_absolute(
                   system.file(file.name, package = package))
    ret <- scan(file.path, what = character(), sep = "\n", quiet = TRUE)

    ### Check if system zmq is used.
    arg <- "SYSTEM_ZMQ_LIBDIR"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    sys.zmq.ld <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check if external zmq is used.
    arg <- "EXTERNAL_ZMQ_LDFLAGS"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    ext.zmq.ld <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check if internal zmq is used.
    arg <- "ENABLE_INTERNAL_ZMQ"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    en.int.zmq <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check which zmq should be used.
    if((sys.zmq.ld == "" && ext.zmq.ld == "") || en.int.zmq == "yes"){
      file.name <- paste("./libs", arch, "/", sep = "")
      dir.path <- tools::file_path_as_absolute(
                    system.file(file.name, package = package))
      if(Sys.info()[['sysname']] == "Darwin"){
        lib.osx <- list.files(dir.path, pattern = "libzmq\\.(.*)\\.dylib")
        i.ver <- gsub("libzmq\\.(.*)\\.dylib", "\\1", lib.osx)
	i.ver <- max(as.integer(i.ver))
        zmq.ldflags <- paste("-L", dir.path, " -lzmq.", i.ver, sep = "")
      } else{
        zmq.ldflags <- paste("-L", dir.path, " -lzmq", sep = "")
      }
    } else{
      arg <- "ZMQ_LDFLAGS"
      id <- grep(paste("^", arg, " = ", sep = ""), ret)
      zmq.ldflags <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])
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
    zmq.cppflags <- paste("-I\"", dir.path, "\"", sep = "")
  } else{
    ### For non windows system.
    file.name <- paste("./etc", arch, "/Makeconf", sep = "")
    file.path <- tools::file_path_as_absolute(
                   system.file(file.name, package = package))
    ret <- scan(file.path, what = character(), sep = "\n", quiet = TRUE)

    ### Check if system zmq is used.
    arg <- "SYSTEM_ZMQ_INCLUDEDIR"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    sys.zmq.inc <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check if external zmq is used.
    arg <- "EXTERNAL_ZMQ_INCLUDE"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    ext.zmq.inc <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check if internal zmq is used.
    arg <- "ENABLE_INTERNAL_ZMQ"
    id <- grep(paste("^", arg, " = ", sep = ""), ret)
    en.int.zmq <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])

    ### Check which zmq should be used.
    if((sys.zmq.inc == "" && ext.zmq.inc == "") || en.int.zmq == "yes"){
      file.name <- paste("./zmq", arch, "/include/", sep = "")
      dir.path <- tools::file_path_as_absolute(
                    system.file(file.name, package = package))
      zmq.cppflags <- paste("-I", dir.path, sep = "")
    } else{
      arg <- "ZMQ_INCLUDE"
      id <- grep(paste("^", arg, " = ", sep = ""), ret)
      zmq.cppflags <- gsub(paste("^", arg, " = (.*)", sep = ""), "\\1", ret[id[1]])
    }
  }

  ### Cat back to "Makevars".
  cat(zmq.cppflags)

  invisible(zmq.cppflags)
} # End of get.zmq.cppflags().



#' @rdname zz_zmq_flags
#' @export
test.load.zmq <- function(arch = '', package = "pbdZMQ"){
  file.name <- paste("./libs", arch, "/", sep = "")
  dir.path <- tools::file_path_as_absolute(
                system.file(file.name, package = package))

  files <- c("libzmq.so", "libzmq.so.dSYM", "libzmq.dylib", "libzmq.4.dylib",
             "libzmq.5.dylib", "libzmq.dll")
  for(i.file in files){
    fn <- paste(dir.path, "/", i.file, sep = "")
    if(file.exists(fn)){
      ret <- try(dyn.load(fn, local = FALSE), silent = TRUE)
      print(ret)
      cat("\n")
    }
  }

  invisible(NULL)
} # End of test.load.zmq().



#' @rdname zz_zmq_flags
#' @export
get.pbdZMQ.ldflags <- function(arch = '', package = "pbdZMQ"){
  file.name <- paste("./libs", arch, "/", sep = "")
  dir.path <- tools::file_path_as_absolute(
                system.file(file.name, package = package))

  if(arch == "/i386" || arch == "/x64"){
    pbdZMQ.ldflags <- paste(dir.path, "/pbdZMQ.dll", sep = "")
  } else{
    pbdZMQ.ldflags <- paste(dir.path, "/pbdZMQ.so", sep = "")
  }

  ### Cat back to "Makevars".
  cat(pbdZMQ.ldflags)

  invisible(pbdZMQ.ldflags)
} # End of get.pbdZMQ.ldflags().



