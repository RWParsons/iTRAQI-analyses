box::use(
  glue,
  here,
  shiny,
)

#' @export
tour_card_width <- 300

separator <- "<br>"

img_width <- tour_card_width * 0.9

app_src_dir <- here$here("app/static")
tour_images_dir <- here$here("app/static/tour")

#' @export
get_tour_content <- function(tab) {
  card_content <- content[[tab]]$card_content

  list(
    card_content = card_content
  )
}

#' @export
content <- list(
  t1 = list(
    card_content = paste(
      sep = separator,
      "<h3>Welcome to iTRAQI: injury Treatment & Rehabilitation Accessibility Queensland Index</h3>",
      "This pilot study uses moderate-to-severe traumatic brain injury (TBI) to map and rank access to acute treatment and rehabilitation units.",
      "Take this self-paced tour to explore and understand iTRAQI.",
      glue$glue('<br><img src="tour-1-tbi-image.jpg" alt="tbi-image" style="width:{img_width}px;">')
    )
  ),
  t2 = list(
    card_content = paste(
      sep = separator,
      "<h3>Accessibility Indices</h3>",
      "The most common measure of remoteness used in Australia is ARIA+ (Accessibility and Remoteness Index of Australia) and variants. ARIA+ groups are shown on this map. While most of Queensland’s land area is remote or very remote, these do not specifically consider access to health care.",
      "For many injury types, timely access to treatment is a matter of life and death. For more severe injuries, such as TBI, access to rehabilitation is vital to regain function and improve quality of life."
    )
  ),
  t3 = list(
    card_content = paste(
      sep = separator,
      "<h3>Queensland</h3>",
      "Since emergency services and hospitals are organised at the State level, our focus is on Queensland. Covering 1.7 million square kilometres, including very remote islands in the Torres Strait, moving seriously injured patients to the right hospital for time-sensitive emergency care is a challenge. In Queensland, we use helicopters, planes and road ambulances to transport patients quickly, with bases scattered throughout the State (see map).",
      glue$glue(
        '<div class="container">',
        '<img src="tour-3-plane.jfif" alt="plane-image" align="left" style="width:{(img_width-15)*(4/9)}px;">',
        '<img src="tour-3-ambulance.png" alt="ambulance-image" style="width:{(img_width-15)*(5/9)}px;">',
        "</div>"
      ),
      '<img src="rsq.png" width="50"/>         : Aeromedical bases (n=13)',
      '<img src="red-cross.png" width="50"/>   : Queensland Ambulance (n=302)'
    )
  )

)

#' @export
n_tours <- length(content)
