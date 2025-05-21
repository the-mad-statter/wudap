#' Connect to WashU LDAP Server
#'
#' @param washu_key_id WashU Key ID
#' @param washu_key_password WashU Key password
#'
#' @return object of type "ldap3.core.connection.Connection"
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- wudap_connect()
#' }
wudap_connect <- function(
    washu_key_id = sprintf("%s@wustl.edu", Sys.getenv("WASHU_KEY_ID")),
    washu_key_password = Sys.getenv("WASHU_KEY_PASSWORD")) {
  server <- ldap3$Server("accounts.ad.wustl.edu")

  connection <- ldap3$Connection(
    server,
    washu_key_id,
    washu_key_password,
    client_strategy = ldap3$SAFE_SYNC,
    auto_bind = ldap3$AUTO_BIND_NO_TLS
  )

  return(connection)
}

# nolint start: line_length_linter.

#' Perform LDAP Search
#'
#' @param conn object of type "ldap3.core.connection.Connection" created with [wudap_connect()]
#' @param search_filter [search filter](https://ldap3.readthedocs.io/en/latest/searches.html#the-ldap-filter)
#' @param attributes character vector of desired [attributes](https://ldap3.readthedocs.io/en/latest/searches.html#attributes)
#' @param search_base search base
#' @param ... additional arguments for the [Search operation](https://ldap3.readthedocs.io/en/latest/searches.html)
#'
#' @return an object of type "ldap3_response"
#' @export
#'
#' @examples
#' \dontrun{
#' conn <- wudap_connect()
#' response <- wudap_search(conn, "(mail=schuelke@wustl.edu)")
#' data <- as_tibble(response)
#' }
wudap_search <- function(
    conn,
    search_filter,
    attributes = c("*"),
    search_base = "OU=Current,OU=People,DC=accounts,DC=ad,DC=wustl,DC=edu",
    ...) {
  response <- conn[["search"]](
    search_base,
    search_filter,
    attributes = attributes,
    ...
  )

  class(response) <- "ldap3_response"

  return(response)
}

# nolint end
