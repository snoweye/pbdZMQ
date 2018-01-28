#' Overwrite rpath of linked shared library in osx
#' 
#' Overwrite rpath of linked shared library
#' (e.g. \code{JuniperKernel/libs/JuniperKernel.so}
#' in osx only.
#' Typically, it is called by \code{.onLoad()} to update rpath if
#' \code{pbdZMQ} or \code{pbdZMQ/libs/libzmq.*.dylib} was moved to
#' a personal directory
#' (e.g. the binary package was installed to a none default path).
#' The commands \code{otool} and \code{install_name_tool} are required.
#' Permission may be needed (e.g. \code{sudo}) to overwrite the shared
#' library.
#' 
#' @param mylib
#' where \code{mypkg} was installed (default \code{NULL} that will search
#' from R's path)
#' @param mypkg
#' for where \code{mypkg.so} will be checked or updated
#' @param linkedto
#' for linkingto pkg where \code{libshpkg*.dylib} is located
#' @param shlib
#' name of shlib to be searched for
#' 
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' 
#' @examples
#' \dontrun{
#' ### Called by .onLoad() within "JuniperKernel/R/zzz.R"
#' overwrite.shpkg.rpath(mypkg = "JuniperKernel",
#'                       linkingto = "pbdZMQ",
#'                       shlib = "zmq")
#' }
#' 
#' @keywords compile
#' @rdname zz_overwrite_shpkg
#' @name Overwrite shpkg
NULL


#' @rdname zz_overwrite_shpkg
#' @export
overwrite.shpkg.rpath <- function(mylib = NULL,
    mypkg = "JuniperKernel", linkingto = "pbdZMQ", shlib = "zmq"){
  if(Sys.info()[['sysname']] == "Darwin"){
    cmd.ot <- system("which otool", intern = TRUE)

    ### Find mylib if NULL.
    if(is.null(mylib)){
      mylib <- tools::file_path_as_absolute(system.file(package = mypkg)) 
    }

    ### Get rpath from mypkg's shared library.
    fn.so <- paste(mylib, "/", mypkg, "/libs/", mypkg, ".so", sep = "")
    rpath <- system(paste(cmd.ot, " -L ", fn.so, sep = ""), intern = TRUE)

    ### Get the installed dylib from mypkg's rpath.
    ptn1 <- paste("^\\t(.*/", linkingto, "/libs/lib", shlib, ".*\\.dylib) .*$",
                  sep = "")
    i.rpath <- grep(ptn1, rpath)

    ### 0 means external shlib was linked.
    ### 1 means internal shlib was built.
    if(length(i.rpath) == 1){
      fn.dylib <- gsub(ptn1, "\\1", rpath[i.rpath])

      ### Check if the file were moved to somewhere.
      if(!file.exists(fn.dylib)){
        ### Search the new location from R's library path.
        dn <- tools::file_path_as_absolute(
                system.file("./libs", package = linkingto)) 
        ptn2 <- paste("lib", shlib, ".*\\. dylib")
        fn <- list.files(path = dn, pattern = ptn2)

        ### Install the new location to the mypkg's shared library.
        if(length(fn) == 1){
          cmd.int <- system("which install_name_tool", intern = TRUE)

          new.fn.dylib <- paste(dn, "/", fn, sep = "")
          cmd <- paste(cmd.int, " -change ", fn.dylib, " ", new.fn.dylib,
                       " ", fn.so,
                       sep = "")
          system(cmd)
        } else{
          stop("The internal shlib can not be identified in linkingto.")
        }
      }
    }
  }

  return(invisible())
} # End of overwrite.shpkg().
