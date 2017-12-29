### Modified from Rserve/src/install.libs.R
### For libs
files <- c("pbdZMQ.so", "pbdZMQ.so.dSYM", "pbdZMQ.dylib", "pbdZMQ.dll",
           "symbols.rds",
           "libzmq.so", "libzmq.so.dSYM", "libzmq.dll")
files <- files[file.exists(files)]
lib.osx <- list.files(pattern = "libzmq.*.dylib")
files <- c(files, lib.osx)

if(length(files) > 0){
  libsarch <- if (nzchar(R_ARCH)) paste("libs", R_ARCH, sep='') else "libs"
  dest <- file.path(R_PACKAGE_DIR, libsarch)
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  file.copy(files, dest, overwrite = TRUE, recursive = TRUE)

  ### For Mac OSX and when "internal ZMQ" is asked.
  ### Overwrite RPATH from the shared library installed to the destination.
  if(Sys.info()[['sysname']] == "Darwin"){
    cmd.int <- system("which install_name_tool", intern = TRUE)
    cmd.ot <- system("which otool", intern = TRUE) 
    fn.pbdZMQ.so <- file.path(dest, "pbdZMQ.so")

    if(length(lib.osx) != 1){
      print(lib.osx)
      stop("None or more than one libzmq.*.dylib are found.")
    } else{
      fn.libzmq.dylib <- file.path(dest, lib.osx)

      if(file.exists(fn.pbdZMQ.so) && file.exists(fn.libzmq.dylib)){
        ### For pbdZMQ.so
        rpath <- system(paste(cmd.ot, " -L ", fn.pbdZMQ.so, sep = ""),
                        intern = TRUE)
        cat("\nBefore install_name_tool (install.libs.R & pbdZMQ.so):\n")
        print(rpath)

        cmd <- paste(cmd.int, " -id ", fn.pbdZMQ.so, " ",
                     fn.pbdZMQ.so, sep = "")
        cat("\nIn install_name_tool (install.libs.R & pbdZMQ.so & id):\n")
        print(cmd) 
        system(cmd)

        str.lib <- paste("zmq/lib/", lib.osx, sep = "")
        org <- file.path(getwd(), str.lib)
        cmd <- paste(cmd.int, " -change ", org, " @loader_path/", lib.osx, " ",
                     fn.pbdZMQ.so, sep = "")
        cat("\nIn install_name_tool (install.libs.R & pbdZMQ.so & path):\n")
        print(cmd) 
        system(cmd)

        rpath <- system(paste(cmd.ot, " -L ", fn.pbdZMQ.so, sep = ""),
                        intern = TRUE)
        cat("\nAfter install_name_tool (install.libs.R & pbdZMQ.so):\n")
        print(rpath)

        ### For libzmq.dylib
        rpath <- system(paste(cmd.ot, " -L ", fn.libzmq.dylib, sep = ""),
                        intern = TRUE)
        cat("\nBefore install_name_tool (install.libs.R & libzmq.dylib):\n")
        print(rpath)

        cmd <- paste(cmd.int, " -id ", fn.libzmq.dylib, " ",
                     fn.libzmq.dylib, sep = "")
        cat("\nIn install_name_tool (install.libs.R & libzmq.dylib & id):\n")
        print(cmd) 
        system(cmd)

        rpath <- system(paste(cmd.ot, " -L ", fn.libzmq.dylib, sep = ""),
                        intern = TRUE)
        cat("\nAfter install_name_tool (install.libs.R & libzmq.dylib):\n")
        print(rpath)
      }
    }
  }
}

### For etc
file <- "Makeconf"
if(file.exists(file)){
  etcarch <- if (nzchar(R_ARCH)) paste("etc", R_ARCH, sep='') else "etc"
  dest <- file.path(R_PACKAGE_DIR, etcarch)
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  file.copy(file, dest, overwrite = TRUE)
}

### For zmq and pbdZMQ include
dir.zmq <- "./zmq"
if(file.exists(dir.zmq)){
  libarch <- if (nzchar(R_ARCH)) paste("zmq", R_ARCH, sep='') else "zmq"
  dest <- file.path(R_PACKAGE_DIR, libarch)
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  files <- paste(dir.zmq, "/include" , sep = "")
  file.copy("./R_zmq.h", files)
  file.copy(files, dest, overwrite = TRUE, recursive = TRUE)
}

