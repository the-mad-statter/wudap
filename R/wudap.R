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
#' ## connect to server
#' conn <- wudap_connect()
#'
#' ## Example 1: all attributes for Winnie using his mail attribute
#' conn |>
#'   wudap_search("(mail=pooh@wustl.edu)") |>
#'   as_tibble()
#'
#' ## Example 2: all attributes for Paddington and Yogi
#' conn |>
#'   wudap_search("(&(|(givenName=Paddington)(givenName=Yogi))(sn=Bear))") |>
#'   as_tibble()
#'
#' ## Example 3: sn, givenName, and personalTitle attributes for Fozzie
#' conn |>
#'   wudap_search(
#'     "(&(givenName=Fozzie)(sn=Bear))",
#'     c("sn", "givenName", "personalTitle")
#'   ) |>
#'   as_tibble()
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
