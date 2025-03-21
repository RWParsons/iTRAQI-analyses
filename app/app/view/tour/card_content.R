box::use(
  glue,
)

box::use(
  app / logic / itraqi_categories_table,
)

#' @export
tour_card_width <- 300

separator <- "<br>"

img_width <- tour_card_width * 0.9

info_icon <- "<i class=' glyphicon glyphicon-info-sign' role='presentation' aria-label=' icon'></i>"
downloads_icon <- "<i class=' glyphicon glyphicon-download-alt' role='presentation' aria-label=' icon'></i>"

#' @export
get_tour_card_content <- function(tab) {
  paste0("<div id = 'img_div'>", content[[tab]], "</div>")
}

#' @export
content <- list(
  t1 = paste(
    sep = separator,
    "<h3>Welcome to iTRAQI: injury Treatment & Rehabilitation Accessibility Queensland Index</h3>",
    "This pilot study uses moderate-to-severe traumatic brain injury (TBI) to map and rank access to acute treatment and rehabilitation units.",
    "Take this self-paced tour to explore and understand iTRAQI.",
    glue$glue('<br><img src="static/images/tour-1-tbi-image.png" alt="tbi-image" style="width:{img_width}px;">')
  ),
  t2 = paste(
    sep = separator,
    "<h3>Accessibility Indices</h3>",
    "The most common measure of remoteness used in Australia is ARIA+ (Accessibility and Remoteness Index of Australia) and variants. ARIA+ groups are shown on this map. While most of Queensland’s land area is remote or very remote, these do not specifically consider access to health care.",
    "For many injury types, timely access to treatment is a matter of life and death. For more severe injuries, such as TBI, access to rehabilitation is vital to regain function and improve quality of life."
  ),
  t3 = paste(
    sep = separator,
    "<h3>Queensland</h3>",
    "Since emergency services and hospitals are organised at the State level, our focus is on Queensland. Covering 1.7 million square kilometres, including very remote islands in the Torres Strait, moving seriously injured patients to the right hospital for time-sensitive emergency care is a challenge. In Queensland, we use helicopters, planes and road ambulances to transport patients quickly, with bases scattered throughout the State (see map).",
    glue$glue(
      '<div class="container">',
      '<img src="static/images/tour-3-plane.png" alt="plane-image" align="left" style="width:{(img_width-15)*(4/9)}px;">',
      '<img src="static/images/tour-3-ambulance.png" alt="ambulance-image" style="width:{(img_width-15)*(5/9)}px;">',
      "</div>"
    ),
    '<img src="static/images/rsq.png" width="50"/>         : Aeromedical locations (n=13)',
    '<img src="static/images/qas.png" width="50"/>   : Queensland Ambulance (n=302)'
  ),
  t4 = paste(
    sep = separator,
    "<h3>TBI Treatment</h3>",
    "Four hospitals have the specialised staff, equipment, and infrastructure to treat adults with moderate-to-severe TBI in Queensland. Only one of these is outside the South-East corner of the State. Accessing appropriate emergency care for TBI can therefore involve long distances.",
    glue$glue('<br><img src="static/images/tour-4-ambulance.png" alt="road-image" style="width:{img_width}px;">')
  ),
  t5 = paste(
    sep = separator,
    "<h3>TBI rehabilitation</h3>",
    "While the Brain Injury Rehabilitation Unit is housed at the Princess Alexandra Hospital (PAH), initial rehabilitation will usually commence at/near the hospital providing the specialised acute care. Patients may then be transferred to another appropriate in-patient facility closer to home to continue their rehabilitation. The green hospital markers <img src='static/images/rehab-centre.png' width='25'/> show public hospital in-patient rehabilitation units where moderate-severe TBI patients usually undergo rehabilitation."
  ),
  t6 = paste(
    sep = separator,
    "<h3>Building iTRAQI &#8211; travel time to acute care</h3>",
    "The Queensland Ambulance Service and Retrieval Services Queensland provided idealised patient retrieval pathways and flight time details from 441 locations <img src='static/images/town-marker.png' width='25'/> to the most appropriate TBI acute care destination <img src='static/images/acute-centre.png' width='25'/>. Travel times were based on the most appropriate transport route using air and/or road, under ideal but realistic conditions."
  ),
  t7 = paste(
    sep = separator,
    "<h3>Building iTRAQI &#8211; visualising access to acute care</h3>",
    "These travel times were interpolated using ordinary kriging to provide coverage for all of Queensland.",
    "<br>CLICK on a location <img src='static/images/town-marker.png' width='25'/> to reveal acute care travel time details.",
    "CLICK on a TBI acute care destination <img src='static/images/acute-centre.png' width='25'/> for hospital details. "
  ),
  t8 = paste(
    sep = separator,
    "<h3>Building iTRAQI &#8211; visualising access to rehabilitation</h3>",
    "There are five rehabilitation units in Queensland public hospitals where TBI patients can receive specific brain injury rehabilitation following their acute care. Rehabilitation time is calculated as the time it takes to drive from each locality <img src='static/images/town-marker.png' width='25'/> to the closest public, in-patient rehabilitation unit <img src='static/images/rehab-centre.png' width='25'/>. These were calculated using road networks and off-peak driving conditions using ArcGIS Online. These travel times were then interpolated to provide coverage for all of Queensland.",
    "<br>CLICK on a rehabilitation destination for facility details."
  ),
  t9 = paste(
    sep = separator,
    "<h3>Building iTRAQI – aggregation into categories</h3>",
    "Travel time to acute and rehabilitation care was categorised and combined to form iTRAQI. iTRAQI can be displayed by small areas, using Statistical Areas (SA) level 1 (shown here) or Level 2.",
    itraqi_categories_table$itraqi_categories_table
  ),
  t10 = paste(
    sep = separator,
    "<h3>Using iTRAQI website</h3>",
    glue$glue("Explore and discover how your location impacts access to time-critical injury care.
  <ul>
    <li>Filter by socio-economic status and remoteness when looking at areas 'Main map' tab.</li>
    <li>Find out how to cite the website and contact options '{info_icon} Information' tab.</li>
    <li>Get the data to use iTRAQI (or components) with other datasets from the '{downloads_icon} Downloads' tab.</li>
  </ul>")
  )
)

#' @export
n_tours <- length(content)
