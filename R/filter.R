#' Wrapper around dplyr::filter and related functions
#' that prints information about the operation
#'
#'
#' @param .data a tbl; see \link[dplyr]{filter}
#' @param ... see \link[dplyr]{filter}
#' @return see \link[dplyr]{filter}
#' @import dplyr
#' @export
filter <- function(.data, ...) {
    log_filter(.data, dplyr::filter, "filter", ...)
}

#' @rdname filter
#' @export
filter_all <- function(.data, ...) {
    log_filter(.data, dplyr::filter_all, "filter_all", ...)
}

#' @rdname filter
#' @export
filter_if <- function(.data, ...) {
    log_filter(.data, dplyr::filter_if, "filter_if", ...)
}

#' @rdname filter
#' @export
filter_at <- function(.data, ...) {
    log_filter(.data, dplyr::filter_at, "filter_at", ...)
}

#' @rdname filter
#' @export
distinct <- function(.data, ...) {
    log_filter(.data, dplyr::distinct, "distinct", ...)
}

log_filter <- function(.data, fun, funname, ...) {
    newdata <- fun(.data, ...)
    if (!"data.frame" %in% class(.data) | !should_display()) {
        return(newdata)
    }
    n <- nrow(.data) - nrow(newdata)
    if (n == 0) {
        display(glue::glue("{funname}: no rows removed"))
    } else if (n == nrow(.data)) {
        display(glue::glue("{funname}: removed all rows (100%)"))
    } else {
        display(glue::glue("{funname}: removed {plural(n, 'row')} ({percent(n, nrow(.data))})"))
    }
    newdata
}
