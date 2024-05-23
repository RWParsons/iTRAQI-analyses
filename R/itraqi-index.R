get_index_f <- function(itraqi_breaks) {
  function(acute_mins, rehab_mins) {
    acute_cat <- cut(acute_mins / 60, breaks = itraqi_breaks$iTRAQI_acute_breaks)
    rehab_cat <- cut(rehab_mins / 60, breaks = itraqi_breaks$iTRAQI_rehab_breaks)

    acute_label <- as.numeric(acute_cat)
    rehab_label <- LETTERS[rehab_cat]

    paste0(acute_label, rehab_label)
  }
}
