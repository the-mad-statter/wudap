#' @exportS3Method wudap::as_tibble
as_tibble.ldap3_response <- function(x) {
  entries <- x[[3]]

  purrr::map(entries, \(entry) {
    dict <- entry[["attributes"]]

    purrr::map(parse_keys(dict), \(key) {
      value <- dict[["get"]](key)

      if ("python.builtin.bytes" %in% class(value)) {
        value <- as.raw(value)
      }

      if (length(value) > 1) {
        value <- list(value)
      }

      tibble::tibble(!!key := value)
    }) |>
      purrr::list_cbind()
  }) |>
    purrr::list_rbind()
}

#' @export
as_tibble <- function(x, ...) UseMethod("as_tibble")
