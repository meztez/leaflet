#' Wrapper functions for using \pkg{leaflet} in \pkg{shiny}
#'
#' Use `leafletOutput()` to create a UI element, and `renderLeaflet()`
#' to render the map widget.
#' @inheritParams htmlwidgets::shinyWidgetOutput
#' @param width,height the width and height of the map (see
#'   [htmlwidgets::shinyWidgetOutput()])
#' @rdname map-shiny
#' @export
#' @examples # !formatR
#' library(shiny)
#' app <- shinyApp(
#'   ui = fluidPage(leafletOutput('myMap')),
#'   server = function(input, output) {
#'     map = leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 17)
#'     output$myMap = renderLeaflet(map)
#'   }
#' )
#'
#' \donttest{if (interactive()) app}
leafletOutput <- function(outputId, width = "100%", height = 400) {
  htmltools::attachDependencies(
    htmlwidgets::shinyWidgetOutput(outputId, "leaflet", width, height, "leaflet"),
    leafletBindingDependencies(),
    append = TRUE
  )
}

# use expr description from htmlwidgets to avoid bad inherit params code
#' @param expr An expression that generates an HTML widget (or a
#'   [promise](https://rstudio.github.io/promises/) of an HTML widget).
#' @rdname map-shiny
#' @export
renderLeaflet <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) expr <- substitute(expr)  # force quoted
  htmlwidgets::shinyRenderWidget(expr, leafletOutput, env, quoted = TRUE)
}
