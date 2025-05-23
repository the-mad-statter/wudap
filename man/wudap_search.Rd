% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wudap.R
\name{wudap_search}
\alias{wudap_search}
\title{Perform LDAP Search}
\usage{
wudap_search(
  conn,
  search_filter,
  attributes = c("*"),
  search_base = "OU=Current,OU=People,DC=accounts,DC=ad,DC=wustl,DC=edu",
  ...
)
}
\arguments{
\item{conn}{object of type "ldap3.core.connection.Connection" created with \code{\link[=wudap_connect]{wudap_connect()}}}

\item{search_filter}{\href{https://ldap3.readthedocs.io/en/latest/searches.html#the-ldap-filter}{search filter}}

\item{attributes}{character vector of desired \href{https://ldap3.readthedocs.io/en/latest/searches.html#attributes}{attributes}}

\item{search_base}{search base}

\item{...}{additional arguments for the \href{https://ldap3.readthedocs.io/en/latest/searches.html}{Search operation}}
}
\value{
an object of type "ldap3_response"
}
\description{
Perform LDAP Search
}
\examples{
\dontrun{
## connect to server
conn <- wudap_connect()

## Example 1: all attributes for Winnie using his mail attribute
conn |>
  wudap_search("(mail=pooh@wustl.edu)") |>
  as_tibble()

## Example 2: all attributes for Paddington and Yogi
conn |>
  wudap_search("(&(|(givenName=Paddington)(givenName=Yogi))(sn=Bear))") |>
  as_tibble()

## Example 3: sn, givenName, and personalTitle attributes for Fozzie
conn |>
  wudap_search(
    "(&(givenName=Fozzie)(sn=Bear))",
    c("sn", "givenName", "personalTitle")
  ) |>
  as_tibble()
}
}
