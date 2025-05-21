ldap3 <- NULL

.onLoad <- function(libname, pkgname) {
  # py_require() has no effect if using a self-managed Python installation
  reticulate::py_require("ldap3")
  ldap3 <<- reticulate::import("ldap3", delay_load = TRUE)
}

install_ldap3 <- function(envname = "r-ldap3", method = "auto", ...) {
  reticulate::py_install("ldap3", envname = envname, method = method, ...)
}
