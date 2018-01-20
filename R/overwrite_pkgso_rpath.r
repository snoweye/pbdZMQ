#' Overwrite and get shared library rpath in osx
#' 
#' Overwrite and get shared library rpath (e.g. \code{lib*.*.dylib}) in osx.
#' Typically, it is called by \code{.onLoad()} to update rpath if a
#' \code{lib*.*.dylib} was installed in a personal directory. Permission may
#' be needed (e.g. \code{sudo}) to overwrite the shared libraries.
#' 
#' \code{overwrite.pkgso.rpath()} update rpath of \code{package.so} for whom is
#' linked with \code{lib*.*.dylib} shipped with targetpkg in osx.
#'
#' \code{get.pkgso.rpath()} get rpath for \code{package.so} in osx.
#' 
#' @param package
#' for where \code{package.so} will be checked or updated
#' @param targetpkg
#' for target pkg where \code{lib*.*.dylib} is located
#' @param verbose
#' if printing messages
#' 
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' 
#' Programming with Big Data in R Website: \url{http://r-pbd.org/}
#' 
#' @examples
#' \dontrun{
#' get.pkgso.rpath("JuniperKernel")
#' }
#' 
#' @keywords compile
#' @rdname zz_overwrite_pkgso_rpath
#' @name Overwrite rpath
NULL

#' @rdname zz_overwrite_pkgso_rpath
#' @export
overwrite.pkgso.rpath <- function(package, targetpkg){
  if(Sys.info()[['sysname']] == "Darwin"){
    cmd.int <- system("which install_name_tool", intern = TRUE)
    cmd.ot <- system("which otool", intern = TRUE)

    ### Get all package.so rpath
    file.name <- paste("./libs/", package, ".so", sep = "")
    fn.so <- tools::file_path_as_absolute(
               system.file(file.name, package = package))
    rpath <- system(paste(cmd.ot, " -L ", fn.so, sep = ""),
                    intern = TRUE)

    ### Get only targetpkg related rpath within package.so
    pattern <- paste(".*/", targetpkg, "/libs/lib(.*)\\.dylib$", sep = "")
    org.rpath <- rpath[grep(pattern, rpath)]
    if(length(org.rpath) > 0){
      org.rpath <- gsub("^\\t", "", org.rpath)
      pattern <- paste(".*/", targetpkg, "/libs/(lib.*\\.dylib)$", sep = "")
      org.dylib <- gsub(pattern, "\\1", org.rpath)
    } else{
      cat("\nrpath found:\n")
      print(rpath)
      stop(paste("No match (needed by rpath) in ", fn.so, "\n", sep = ""))
    }

    ### Get all dylib from targetpkg
    dir.name <- "./libs/"
    dn <- tools::file_path_as_absolute(
            system.file(dir.name, package = targetpkg))
    files.name <- list.files(path = dn, pattern = "lib(.*)\\.dylib")

    ### Match and overwrite rpath within package.so
    if(length(files.name) > 0){
      new.dylib <- files.name[files.name %in% org.dylib]
      if(length(new.dylib) > 0){
        for(i.dylib in new.dylib){
          ### Arrange install names
          org.name <- org.rpath[org.dylib == i.dylib]
          new.name <- paste(dn, "/", i.dylib, sep = "")

          ### Overwrite the matched one by installing new name
          cmd <- paste(cmd.int, " -change ", org.name, " ", new.name, " ",
                       fn.so, sep = "")
          system(cmd) 
        }
      } else{
        cat("\nrpath needed:\n")
        print(org.rpath)
        cat("\nFiles (dylib) found in rpath:\n")
        print(org.dylib)
        cat("\nFiles (dylib) found in targetpkg:\n")
        print(files.name)
        stop("No dylib is matched.")
      }
    } else{
      stop(paste("No dylib found in ", dn, "\n", sep = ""))
    }
  }

  return(invisible())
} # End of overwrite.pkgso.rpath().


#' @rdname zz_overwrite_pkgso_rpath
#' @export
get.pkgso.rpath <- function(package, verbose = TRUE){
  if(Sys.info()[['sysname']] == "Darwin"){
    cmd.int <- system("which install_name_tool", intern = TRUE)

    ### Get package.so path
    file.name <- paste("./libs/", package, ".so", sep = "")
    fn.so <- tools::file_path_as_absolute(
               system.file(file.name, package = package))

    ### Get rpath from package.so
    rpath <- system(paste(cmd.ot, " -L ", fn.so, sep = ""),
                    intern = TRUE)
    if(verbose){
      cat(paste("\nrpath found in ", fn.so, ":\n", sep = ""))
      print(rpath)
    }

    return(invisible(rpath))
  }

  return(invisible())
} # End of get.pkgso.rpath().

