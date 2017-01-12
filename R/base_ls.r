#' A wrapper function for base::ls
#' 
#' @description
#' The \code{ls()} function with modification to avoid listing hidden
#' pbd objects.
#' 
#' @details
#' As the original \code{base::ls()}, it returns the names of the objects.
#'
#' @param name,pos,envir,all.names,patten,sorted
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
    patten, sorted = TRUE)
{
  ret <- base::ls(name, pos = pos, envir = envir, all.names = all.names,
                  patten, sorted = sorted)    

  if (environmentName(envir) == "R_GlobalEnv" && all.names == TRUE)
  {
    ret <- ret[-grep("^\\.pbd(_|)env$", ret)]
  }

  ret
}
