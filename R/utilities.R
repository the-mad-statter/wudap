str_remove <- function(string, pattern, ...) {
  gsub(pattern = pattern, replacement = "", x = string, ...)
}

str_split_1 <- function(string, pattern, ...) {
  strsplit(string, pattern, ...)[[1]]
}

parse_keys <- function(dict) {
  dict[["keys"]]() |>
    utils::capture.output() |>
    str_remove("dict_keys\\(\\[") |>
    str_remove("\\]\\)") |>
    str_remove("'") |>
    str_split_1(", ")
}

`%is%` <- function(lhs, rhs) {
  rhs %in% class(lhs)
}

`%is_not%` <- function(lhs, rhs) {
  !(lhs %is% rhs)
}

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
