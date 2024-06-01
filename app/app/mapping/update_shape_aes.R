box::use(
  app / mapping / update_styles [...]
)



#' @export
update_shape_aes <- function(proxy_map) {

  ids <- c("30101100101-polygon-1", "30101100102-polygon-1",
           "30101100103-polygon-1", "30101100104-polygon-1", "30101100105-polygon-1",
           "30101100106-polygon-1", "30101100107-polygon-1", "30101100108-polygon-1",
           "30101100109-polygon-1", "30101100110-polygon-1", "30101100111-polygon-1",
           "30101100112-polygon-1", "30101100113-polygon-1", "30101100114-polygon-1",
           "30101100115-polygon-1", "30101100116-polygon-1", "30101100117-polygon-1",
           "30101100118-polygon-1", "30101100119-polygon-1", "30101100120-polygon-1",
           "30101100121-polygon-1", "30101100122-polygon-1", "30101100123-polygon-1",
           "30101100124-polygon-1", "30101100125-polygon-1", "30101100126-polygon-1",
           "30101100127-polygon-1", "30101100128-polygon-1", "30101100129-polygon-1",
           "30101100130-polygon-1", "30101100131-polygon-1", "30101100132-polygon-1",
           "30101100133-polygon-1", "30101100134-polygon-1", "30101100135-polygon-1",
           "30101100136-polygon-1", "30101100137-polygon-1", "30101100138-polygon-1",
           "30101100139-polygon-1", "30101100140-polygon-1", "30101100141-polygon-1",
           "30101100142-polygon-1", "30101100143-polygon-1", "30101100144-polygon-1",
           "30101100145-polygon-1", "30101100201-polygon-1", "30101100202-polygon-1",
           "30101100203-polygon-1", "30101100204-polygon-1", "30101100205-polygon-1",
           "30101100206-polygon-1", "30101100207-polygon-1", "30101100208-polygon-1",
           "30101100209-polygon-1", "30101100210-polygon-1", "30101100211-polygon-1",
           "30101100212-polygon-1", "30101100213-polygon-1", "30101100214-polygon-1",
           "30101100215-polygon-1", "30101100216-polygon-1", "30101100217-polygon-1",
           "30101100218-polygon-1", "30101100219-polygon-1", "30101100220-polygon-1",
           "30101100221-polygon-1", "30101100301-polygon-1", "30101100302-polygon-1",
           "30101100303-polygon-1", "30101100304-polygon-1", "30101100305-polygon-1",
           "30101100306-polygon-1", "30101100307-polygon-1", "30101100308-polygon-1",
           "30101100309-polygon-1", "30101100310-polygon-1", "30101100311-polygon-1",
           "30101100312-polygon-1", "30101100313-polygon-1", "30101100314-polygon-1",
           "30101100315-polygon-1", "30101100316-polygon-1", "30101100317-polygon-1",
           "30101100318-polygon-1", "30101100319-polygon-1", "30101100320-polygon-1",
           "30101100321-polygon-1", "30101100322-polygon-1", "30101100323-polygon-1",
           "30101100324-polygon-1", "30101100325-polygon-1", "30101100326-polygon-1",
           "30101100327-polygon-1", "30101100329-polygon-1", "30101100330-polygon-1",
           "30101100331-polygon-1", "30101100332-polygon-1", "30101100333-polygon-1",
           "30101100334-polygon-1", "30101100335-polygon-1")
  set_shape_style(proxy_map, layer_id = ids, fill_color = "#FF0000")
}
