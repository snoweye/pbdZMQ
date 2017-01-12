#' A wrapper function for base::ls
#' 
#' @description
#' The \code{ls()} function with modification to avoid listing hidden
#' pbd objects.
#' 
#' @details
#' As the original \code{base::ls()}, it returns the names of the objects.
#'
#' @param name,pos,envir,all.names,pattern,sorted
#' as the original \code{base::ls()}.
#'
#' @return
#' As the original \code{base::ls()} except when \code{all.names} is \code{TRUE}
#' and \code{envir} is \code{.GlobalEnv}, hidden pbd objects such as
#' \code{.pbd_env} and \code{.pbdenv} will not be returned.
#' 
#' @author Wei-Chen Chen \email{wccsnow@@gmail.com}.
#' 
#' @rdname xx_ls_wrapper
#'
#' @examples
#' \dontrun{
#' library(pbdRPC, quietly = TRUE)
#' ls(all.names = TRUE)
#' base::ls(all.names = TRUE)
#' }
#'
#' @export
ls <- function(name, pos = -1L, envir = as.environment(pos), all.names = FALSE,
    pattern, sorted = TRUE)
{
  cmd <- "base::ls("
  if (!missing(name))
    cmd <- paste(cmd, as.character(name), ", ", sep = "")
  cmd <- paste(cmd, "all.names = ", all.names, ", ", sep = "")
  if (!missing(pattern))
    cmd <- paste(cmd, as.character(pattern), ", ", sep = "")
  cmd <- paste(cmd, "sorted = ", sorted, ")", sep = "")

  ret <- eval(parse(text = cmd), envir = -2L)

  if (all.names == TRUE && environmentName(parent.frame()) == "R_GlobalEnv")
    ret <- grep("^\\.pbd(_|)env$", ret, value = TRUE, invert = TRUE)

  ret
}

