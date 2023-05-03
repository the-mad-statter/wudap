#' Washington University LDAP query
#'
#' @param user WUSTL Key username
#' @param pass WUSTL Key password
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ## an unrestricted query will result in error
#' wudap_query() %>%
#'   content_to_tibble()
#'
#' ## retrieve just base information
#' wudap_query(scope = "base") %>%
#'   content_to_tibble()
#' }
#'
#' @inherit ldap::ldap_query
#' @note Must use campus IP address.
wudap_query <- function(
    hostname = "accounts.ad.wustl.edu",
    base_dn = "OU=Current,OU=People,DC=accounts,DC=ad,DC=wustl,DC=edu",
    attributes = "",
    scope = "sub",
    filter = "(objectClass=*)",
    user = sprintf("%s@wustl.edu", Sys.getenv("WUSTL_KEY_USER")),
    pass = Sys.getenv("WUSTL_KEY_PASS")) {
  ldap::ldap_query(
    hostname,
    base_dn,
    attributes,
    scope,
    filter,
    user,
    pass,
    protocol = "ldap"
  )
}

#' Washington University LDAP quick query
#'
#' @param type the type of filter to construct
#' @param value the value for which to filter
#' @param separate logical to detect and expand recursive columns
#'
#' @export
#'
#' @examples
#' \dontrun{
#' wudap_quick_query("sAMAccountName", "schuelke")
#'
#' wudap_quick_query("userPrincipalName", "schuelke@wustl.edu")
#'
#' wudap_quick_query("mail", "schuelke@wustl.edu")
#' }
#'
#' @inherit wudap_query
wudap_quick_query <- function(
    type = c("sAMAccountName", "userPrincipalName", "mail"),
    value,
    user = sprintf("%s@wustl.edu", Sys.getenv("WUSTL_KEY_USER")),
    pass = Sys.getenv("WUSTL_KEY_PASS"),
    separate = FALSE) {
  type <- match.arg(type)

  x <- switch(type,
    "sAMAccountName" =
      wudap_quick_query_sAMAccountName(value, user, pass),
    "userPrincipalName" =
      wudap_quick_query_userPrincipalName(value, user, pass),
    "mail" =
      wudap_quick_query_mail(value, user, pass)
  )

  ldap::content_to_tibble(x, separate)
}

#' @inherit wudap_quick_query
#' @param sAMAccountName a logon name used to support clients and servers from
#' previous version of Windows, such as Windows NT 4.0, Windows 95, Windows 98,
#' and LAN Manager
wudap_quick_query_sAMAccountName <- function(
    sAMAccountName,
    user,
    pass) {
  wudap_query(
    filter = sprintf("(sAMAccountName=%s)", sAMAccountName),
    user = user,
    pass = pass
  )
}

#' @inherit wudap_quick_query
#' @param userPrincipalName a User Principal Name (UPN) is a username and
#' domain in an email address format
wudap_quick_query_userPrincipalName <- function(
    userPrincipalName,
    user,
    pass) {
  wudap_query(
    filter = sprintf("(userPrincipalName=%s)", userPrincipalName),
    user = user,
    pass = pass
  )
}

#' @inherit wudap_quick_query
#' @param mail email address
wudap_quick_query_mail <- function(
    mail,
    user,
    pass) {
  wudap_query(
    filter = sprintf("(mail=%s)", mail),
    user = user,
    pass = pass
  )
}
