% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/layers.R
\name{addRasterImage}
\alias{addRasterImage}
\alias{projectRasterForLeaflet}
\title{Add a raster image as a layer}
\usage{
addRasterImage(
  map,
  x,
  colors = if (is.factor(x)[1]) "Set1" else "Spectral",
  opacity = 1,
  attribution = NULL,
  layerId = NULL,
  group = NULL,
  project = TRUE,
  method = c("auto", "bilinear", "ngb"),
  maxBytes = 4 * 1024 * 1024,
  options = gridOptions(),
  data = getMapData(map)
)

projectRasterForLeaflet(x, method)
}
\arguments{
\item{map}{a map widget object}

\item{x}{a \code{\link[terra:SpatRaster-class]{terra::SpatRaster()}} or a \code{RasterLayer} object--see \code{\link[raster:raster]{raster::raster()}}}

\item{colors}{the color palette (see \code{\link[=colorNumeric]{colorNumeric()}}) or function
to use to color the raster values (hint: if providing a function, set
\code{na.color} to \code{"#00000000"} to make \code{NA} areas transparent).
The palette is ignored if \code{x} is a SpatRaster with a color table or if
it has RGB channels.}

\item{opacity}{the base opacity of the raster, expressed from 0 to 1}

\item{attribution}{the HTML string to show as the attribution for this layer}

\item{layerId}{the layer id}

\item{group}{the name of the group this raster image should belong to (see
the same parameter under \code{\link[=addTiles]{addTiles()}})}

\item{project}{if \code{TRUE}, automatically project \code{x} to the map
projection expected by Leaflet (\code{EPSG:3857}); if \code{FALSE}, it's
the caller's responsibility to ensure that \code{x} is already projected,
and that \code{extent(x)} is expressed in WGS84 latitude/longitude
coordinates}

\item{method}{the method used for computing values of the new, projected raster image.
\code{"bilinear"} (the default) is appropriate for continuous data,
\code{"ngb"} - nearest neighbor - is appropriate for categorical data.
Ignored if \code{project = FALSE}. See \code{\link[=projectRaster]{projectRaster()}} for details.}

\item{maxBytes}{the maximum number of bytes to allow for the projected image
(before base64 encoding); defaults to 4MB.}

\item{options}{a list of additional options, intended to be provided by
a call to \code{\link[=gridOptions]{gridOptions()}}}

\item{data}{the data object from which the argument values are derived; by
default, it is the \code{data} object provided to \code{leaflet()}
initially, but can be overridden}
}
\description{
Create an image overlay from a \code{RasterLayer} or a \code{SpatRaster}
object. \emph{This is only suitable for small to medium sized rasters},
as the entire image will be embedded into the HTML page (or passed over
the websocket in a Shiny context).
}
\details{
The \code{maxBytes} parameter serves to prevent you from accidentally
embedding an excessively large amount of data into your htmlwidget. This
value is compared to the size of the final compressed image (after the raster
has been projected, colored, and PNG encoded, but before base64 encoding is
applied). Set \code{maxBytes} to \code{Inf} to disable this check, but be
aware that very large rasters may not only make your map a large download but
also may cause the browser to become slow or unresponsive.

To reduce the size of a SpatRaster, you can use \code{\link[terra:sample]{terra::spatSample()}}
as in \code{x = spatSample(x, 100000, method="regular", as.raster=TRUE)}. With
a \code{RasterLayer} you can use \code{\link[raster:sampleRegular]{raster::sampleRegular()}} as in
\code{sampleRegular(x, 100000, asRaster=TRUE)}.

By default, \code{addRasterImage()} will project the raster data
\code{x} to the Pseudo-Mercator projection (EPSG:3857). This can be a
time-consuming operation for even moderately sized rasters; although it is much
faster for SpatRasters than for RasterLayers.
If you are repeatedly adding a particular raster to your Leaflet
maps, you can perform the projection ahead of time using
\code{projectRasterForLeaflet()}, and call \code{addRasterImage()} with
\code{project = FALSE}.
}
\examples{
\donttest{library(raster)

r <- raster(xmn = -2.8, xmx = -2.79, ymn = 54.04, ymx = 54.05, nrows = 30, ncols = 30)
values(r) <- matrix(1:900, nrow(r), ncol(r), byrow = TRUE)
crs(r) <- CRS("+init=epsg:4326")

pal <- colorNumeric("Spectral", domain = c(0, 1000))
leaflet() \%>\% addTiles() \%>\%
  addRasterImage(r, colors = pal, opacity = 0.8) \%>\%
  addLegend(pal = pal, values = c(0, 1000))
}
}
\seealso{
\code{\link[=addRasterLegend]{addRasterLegend()}} for an easy way to add a legend for a
SpatRaster with a color table.
}
