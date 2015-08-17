### This file is only called by
###   "pbd*/src/Makevars.in" and "pbd*/src/Makevar.win"
### to find the default configurations from
###   "pbd*/etc${R_ARCH}/Makconf".
get.mingw.lib <- function(arch = ''){
  if(arch == "/i386"){
    lib.path <- "/i686-w64-mingw32/lib/"
  } else if(arch == "/x64"){
    lib.path <- "/i686-w64-mingw32/lib64/"
  } else{
    stop(paste(arch, " is not found.", sep = ""))
  }

  path <- Sys.getenv("PATH")
  path <- unlist(strsplit(path, ";"))
  id <- grep("gcc-", path)

  if(length(id) == 0){
    print(path)
    stop("gcc is not found.")
  } else{
    path.rtools <- gsub("\\\\", "/", path[id[1]]) 
    path.lib <- gsub("/bin.*", lib.path, path.rtools)

    ### Check libraries.
    fn <- paste(path.lib, "libiphlpapi.a", sep = "")
    check <- file.exists(fn)
    if(!check){
      stop(paste(fn, " is not found.", sep = ""))
    }

    fn <- paste(path.lib, "librpcrt4.a", sep = "")
    check <- file.exists(fn)
    if(!check){
      stop(paste(fn, " is not found.", sep = ""))
    }

    fn <- paste(path.lib, "libws2_32.a", sep = "")
    check <- file.exists(fn)
    if(!check){
      stop(paste(fn, " is not found.", sep = ""))
    }

    ### Cat back to "Makefile.win".
    cat(path.lib)
  }

  invisible()
} # End of get.mingw.lib().


get.stdcxx.lib <- function(arch = ''){
  if(arch == "/i386"){
    lib.path <- "/lib/"
  } else if(arch == "/x64"){
    lib.path <- "/lib64/"
  } else{
    stop(paste(arch, " is not found.", sep = ""))
  }

  path <- Sys.getenv("PATH")
  path <- unlist(strsplit(path, ";"))
  id <- grep("gcc-", path)

  if(length(id) == 0){
    print(path)
    stop("gcc is not found.")
  } else{
    path.rtools <- gsub("\\\\", "/", path[id[1]]) 
    path.lib <- gsub("/bin.*", lib.path, path.rtools)

    ### Check libraries.
    fn <- paste(path.lib, "libstdc++.a", sep = "")
    check <- file.exists(fn)
    if(!check){
      stop(paste(fn, " is not found.", sep = ""))
    }

    ### Cat back to "Makefile.win".
    cat(path.lib)
  }

  invisible()
} # End of get.stdcxx.lib().
