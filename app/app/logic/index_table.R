box::use(
  dplyr,
  glue,
  purrr,
  stringr,
)

box::use(
  app / logic / scales_and_palettes,
)

make_categories_table <- function(acute_breaks, rehab_breaks) {
  acute_table <- make_cat_and_label_table(
    labels = breaks_to_labels(acute_breaks),
    header_text = "Time to Acute Care",
    cat_type = "number"
  )

  rehab_table <- make_cat_and_label_table(
    labels = breaks_to_labels(rehab_breaks),
    header_text = "Time to Rehabilitation Care",
    cat_type = "letter"
  )

  paste0("<br>", acute_table, rehab_table)
}

make_cat_and_label_table <- function(labels, header_text, cat_type = c("number", "letter")) {
  cat_type <- match.arg(cat_type)
  rows <- dplyr$tibble(labels = labels) |>
    dplyr$mutate(idx = dplyr$row_number()) |>
    (\(d) {
      if (cat_type == "letter") {
        d$idx <- LETTERS[d$idx]
      }
      d
    })() |>
    dplyr$mutate(
      dplyr$across(dplyr$everything(), \(x) paste0("<td>", x, "</td>")),
      tr = paste0("<tr>", idx, labels, "</tr>")
    ) |>
    dplyr$pull(tr)

  header <- "
      <tr>
          <th style='width:30%'>Cat</th>
          <th style='width:50%'>Travel-time (hours)</th>
      </tr>
    "
  header_label <- paste0(
    "<h4>",
    header_text,
    "</h4>"
  )

  glue$glue(
    "{header_label}",
    "<table style='width:100%'>",
    header,
    paste0(rows, collapse = ""),
    "</table>"
  )
}

breaks_to_labels <- function(x) {
  cut(1, breaks = x) |>
    levels() |>
    stringr$str_split(",") |>
    purrr$map(~ stringr$str_extract(.x, "[0-9]+")) |>
    purrr$map(\(.x) {
      if (is.na(.x[1])) {
        c <- paste0("<", .x[2])
      } else if (is.na(.x[2])) {
        c <- paste0(">", .x[1])
      } else {
        c <- paste0(.x[1], " – ", .x[2])
      }
      c
    }) |>
    unlist()
}

#' @export
itraqi_categories_table <- make_categories_table(
  acute_breaks = scales_and_palettes$itraqi_acute_breaks,
  rehab_breaks = scales_and_palettes$itraqi_rehab_breaks
)
