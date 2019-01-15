#' Wrapper around dplyr::mutate and related functions
#' that prints information about the operation
#'
#' @param .data a tbl; see \link[dplyr]{mutate}
#' @param ... see \link[dplyr]{mutate}
#' @return see \link[dplyr]{mutate}
#' @import dplyr
#' @export
mutate <- function(.data, ...) {
    log_mutate(.data, dplyr::mutate, "mutate", ...)
}

#' @rdname mutate
#' @export
mutate_all <- function(.data, ...) {
    log_mutate(.data, dplyr::mutate_all, "mutate_all", ...)
}

#' @rdname mutate
#' @export
mutate_if <- function(.data, ...) {
    log_mutate(.data, dplyr::mutate_if, "mutate_if", ...)
}

#' @rdname mutate
#' @export
mutate_at <- function(.data, ...) {
    log_mutate(.data, dplyr::mutate_at, "mutate_at", ...)
}

log_mutate <- function(.data, fun, funname, ...) {
    cols <- names(.data)
    newdata <- fun(.data, ...)
    has_changed <- FALSE
    for (var in names(newdata)) {
        # existing var
        if (var %in% cols) {
            # use identical to account for missing values
            different <- !identical(newdata[[var]], .data[[var]])
            if (any(different)) {
                n <- sum(different)
                p <- round(100 * (n / length(different)))
                cat(glue::glue("{funname}: changed {plural(n, 'value')} ({p}%) of '{var}'"), "\n")
                has_changed <- TRUE
            }
        # new var
        } else {
            n <- length(unique(newdata[[var]]))
            cat(glue::glue("{funname}: new variable '{var}' with {plural(n, 'value', 'unique ')}"),
                "\n")
            has_changed <- TRUE
        }
    }
    if (!has_changed) {
        cat(glue::glue("{funname}: no changes"), "\n")
    }
    newdata
}