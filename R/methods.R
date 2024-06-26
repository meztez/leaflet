#' Methods to manipulate the map widget
#'
#' A series of methods to manipulate the map.
#' @param map a map widget object created from [leaflet()]
#' @param lng The longitude of the map center
#' @param lat The latitude of the map center
#' @param zoom the zoom level
#' @param options a list of zoom/pan options (see
#'   <https://web.archive.org/web/20220702182250/https://leafletjs.com/reference-1.3.4.html#zoom/pan-options>)
#' @references <https://web.archive.org/web/20220702182250/https://leafletjs.com/reference-1.3.4.html#map-methods-for-modifying-map-state>
#' @return The modified map widget.
#' @describeIn map-methods Set the view of the map (center and zoom level)
#' @export
#' @examples
#' \donttest{m <- leaflet() %>% addTiles() %>% setView(-71.0382679, 42.3489054, zoom = 18)
#' m  # the RStudio 'headquarter'
#' m %>% fitBounds(-72, 40, -70, 43)
#' m %>% clearBounds()  # world view
#' }
setView <- function(map, lng, lat, zoom, options = list()) {
  view <- evalFormula(list(c(lat, lng), zoom, options))

  dispatch(map,
    "setView",
    leaflet = {
      changeView(map, setView = view)
    },
    leaflet_proxy = {
      invokeRemote(map, "setView", view)
      map
    }
  )
}

#' @describeIn map-methods Flys to a given location/zoom-level using smooth pan-zoom.
#' @export
flyTo <- function(map, lng, lat, zoom, options = list()) {
  view <- evalFormula(list(c(lat, lng), zoom, options))

  dispatch(map,
    "flyTo",
    leaflet = {
      changeView(map, flyTo = view)
    },
    leaflet_proxy = {
      invokeRemote(map, "flyTo", view)
      map
    }
  )
}


#' @describeIn map-methods Set the bounds of a map
#' @param lng1,lat1,lng2,lat2 the coordinates of the map bounds
#' @export
fitBounds <- function(map, lng1, lat1, lng2, lat2, options = list()) {
  bounds <- evalFormula(list(lat1, lng1, lat2, lng2, options), getMapData(map))

  dispatch(map,
    "fitBounds",
    leaflet = {
      changeView(map, fitBounds = bounds)
    },
    leaflet_proxy = {
      invokeRemote(map, "fitBounds", bounds)
      map
    }
  )
}

#' @describeIn map-methods Flys to given bound using smooth pan/zoom.
#' @export
flyToBounds <- function(map, lng1, lat1, lng2, lat2, options = list()) {
  bounds <- evalFormula(list(lat1, lng1, lat2, lng2, options), getMapData(map))

  dispatch(map,
    "flyToBounds",
    leaflet = {
      changeView(map, flyToBounds = bounds)
    },
    leaflet_proxy = {
      invokeRemote(map, "flyToBounds", bounds)
      map
    }
  )
}

#' @describeIn map-methods Restricts the map view to the given bounds
#' @export
setMaxBounds <- function(map, lng1, lat1, lng2, lat2) {
  invokeMethod(map, getMapData(map), "setMaxBounds", lat1, lng1, lat2, lng2)
}

#' @describeIn map-methods Clear the bounds of a map, and the bounds will be
#'   automatically determined from latitudes and longitudes of the map elements
#'   if available (otherwise the full world view is used)
#' @export
clearBounds <- function(map) {
  dispatch(map,
    "clearBounds",
    leaflet = {
      changeView(map)
    }
  )
}


changeView <- function(map, setView = NULL, fitBounds = NULL, flyTo = NULL, flyToBounds = NULL) {
  map$x$setView <- setView
  map$x$fitBounds <- fitBounds
  map$x$flyTo <- flyTo
  map$x$flyToBounds <- flyToBounds

  map
}
