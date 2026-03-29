ldap3 <- NULL
server <- NULL

.onLoad <- function(libname, pkgname) {
  reticulate::py_require("ldap3")
  ldap3 <<- reticulate::import("ldap3")
  ssl <- reticulate::import("ssl")

  tls <- ldap3[["Tls"]](
    ca_certs_file = system.file("ca", "ldap-ca-bundle.crt", package = pkgname),
    validate = ssl[["CERT_REQUIRED"]]
  )

  server <<- ldap3[["Server"]](
    host = "accounts-ldap.wustl.edu",
    port = 636L,
    use_ssl = TRUE,
    tls = tls
  )
}

py_install_ldap3 <- function(envname = "r-wudap", method = "auto", ...) {
  reticulate::py_install("ldap3", envname = envname, method = method, ...)
}

py_install_ssl <- function(envname = "r-wudap", method = "auto", ...) {
  reticulate::py_install("ssl", envname = envname, method = method, ...)
}
