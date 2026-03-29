#' @export
#' @method as_tibble ldap_entries
as_tibble.ldap_entries <- function(
  x,
  ...,
  collapse = "; ",
  binary = c("list", "base64", "hex", "drop")
) {
  binary <- match.arg(binary)

  is_binary_value <- function(x) {
    is.raw(x) ||
      inherits(x, "python.builtin.bytes") ||
      (is.list(x) && length(x) > 0 && any(vapply(x, is.raw, logical(1))))
  }

  encode_binary <- function(x, mode) {
    if (mode == "drop") {
      return(NA_character_)
    }

    raws <- if (is.raw(x)) {
      list(x)
    } else if (
      is.list(x) && length(x) > 0 && any(vapply(x, is.raw, logical(1)))
    ) {
      x
    } else {
      list(charToRaw(as.character(x)))
    }

    if (mode == "list") {
      return(list(raws))
    }

    enc_one <- function(r) {
      if (mode == "hex") {
        paste(sprintf("%02x", as.integer(r)), collapse = "")
      } else {
        jsonlite::base64_enc(r)
      }
    }

    vals <- vapply(raws, enc_one, character(1))
    if (length(vals) == 1) vals[[1]] else paste(vals, collapse = collapse)
  }

  records <- purrr::map(x, \(e) {
    attrs <- reticulate::py_to_r(e[["entry_attributes_as_dict"]])
    list(
      attrs = attrs,
      dn = reticulate::py_to_r(e[["entry_dn"]])
    )
  })

  all_names <- records |>
    purrr::map(\(x) names(x[["attrs"]]) %||% character()) |>
    unlist(use.names = FALSE) |>
    unique()

  all_names <- all_names[nzchar(all_names)]

  purrr::map_dfr(records, \(rec) {
    row <- vector("list", length(all_names) + 1)
    names(row) <- c(all_names, "dn")

    for (nm in all_names) {
      x <- rec[["attrs"]][[nm]]

      row[[nm]] <-
        if (is.null(x) || length(x) == 0) {
          NA_character_
        } else if (is_binary_value(x)) {
          encode_binary(x, binary)
        } else if (is.atomic(x) || is.character(x)) {
          paste(as.character(x), collapse = collapse)
        } else if (is.list(x)) {
          vals <- unlist(x, recursive = FALSE, use.names = FALSE)
          if (any(vapply(vals, is.raw, logical(1)))) {
            encode_binary(vals, binary)
          } else {
            paste(
              as.character(unlist(vals, use.names = FALSE)),
              collapse = collapse
            )
          }
        } else {
          as.character(x)
        }
    }

    row[["dn"]] <- rec[["dn"]]
    tibble::as_tibble(row)
  })
}

#' @importFrom tibble as_tibble
#' @export
tibble::as_tibble
