### Use this to replace shell.exec() in windows R because
### shell.exec() only supports SW_SHOW.

### Possible values of SW.cmd, see MS website for details.
### https://msdn.microsoft.com/en-us/library/windows/desktop/bb762153%28v=vs.85%29.aspx
###
### SW_SHOW (5)
###     Activates the window and displays it in its current size
###     and position.
###
### SW_SHOWMINIMIZED (2)
###     Activates the window and displays it as a minimized window.
###
### SW_SHOWMINNOACTIVE (7)
###     Displays the window as a minimized window.
###     The active window remains active.
###
### SW_SHOWNA (8)
###      Displays the window in its current state.
###      The active window remains active.

shellexec.wcc <- function(file, SW.cmd = 7L){
  if(length(file) == 1 && is.character(file)){
    .Call("shellexec_wcc", file, as.integer(SW.cmd),
          PACKAGE = "pbdZMQ")
  } else{
    stop("file should be a character vector of length 1.")
  }
} # End of shellexec.wcc().

