`%||%` <- function(x, y) if (is.null(x)) y else x

#' Save thumbnailPhoto
#'
#' @param x raw bytes to save
#' @param filename name of the file
#'
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- wudap_connect()
#' response <- wudap_search("(mail=schuelke@wustl.edu)")
#' data <- as_tibble(response)
#' save_thumbnail_photo(data$thumbnailPhoto[[1]])
#' }
save_thumbnail_photo <- function(x, filename = "thumbnailPhoto.jpg") {
  writeBin(x, filename)
}
