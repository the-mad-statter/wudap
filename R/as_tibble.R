#' @exportS3Method wudap::as_tibble
as_tibble.ldap3_response <- function(x, ...) {
  entries <- x[[3]]

  purrr::map(entries, \(entry) {
    dict <- entry[["attributes"]]

    purrr::map(parse_keys(dict), \(key) {
      value <- dict[["get"]](key)

      if (value %is_not% "list" && length(value) > 1) {
        value <- list(value)
      }

      if (value %is% "list") {
        value <- purrr::map(value, \(list_element) {
          if (list_element %is% "python.builtin.bytes") {
            as.raw(list_element)
          } else {
            list_element
          }
        })
      }

      if (value %is% "list" && length(value) > 1) {
        value <- list(value)
      }

      tibble::tibble(!!key := value)
    }) |>
      purrr::list_cbind()
  }) |>
    purrr::list_rbind()
}

#' Coerce an ldap3 response to a data frames
#'
#' @param x object of type "ldap3_response"
#' @param ... Unused, for extensibility.
#'
#' @export
as_tibble <- function(x, ...) {
  UseMethod("as_tibble")
}
