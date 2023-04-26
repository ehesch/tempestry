Tempestry aRt
================
25 April 2023

This script produces a climate art! It is inspired by the [Tempestry
Project](https://www.tempestryproject.com/) and [warming
stripes](https://en.wikipedia.org/wiki/Warming_stripes).

It will help you make a poster showing about 100 years of temperature
data for various places. You’ll get the **annual trend** along with 365
days of **daily temperature** for each year! For some places, you can
also add other weather data (e.g. over a century of data on when Lake
Superior’s ice road to Madeline Island is open)!

Since this is art, there are some small creative liberties taken (i.e.,
filling in of missing data, usage of different color breaks based on
what looks good, using multiple NOAA weather stations which aren’t
aligned with their dates of records, etc.). Also, since this is art,
many details and data best practices are intentionally left out (i.e.,
you won’t find a figure legend here!). The data is roughly at the county
level, but modifications to different geographies should be possible!

Once you make your poster art, I have had good luck [printing at
FedEx](https://www.office.fedex.com/default/posters.html). Cost of
\$17.25 for a poster print (matte paper, vertical orientation, size
16x20). But feel free to figure out what works for you (more convenient
location/store, maybe you have a bigger or smaller picture frame already
on hand that you’d like to use, maybe you want a fancier option like a
foam board backing, etc.).

# Creating your poster

## Set-up

You will need to use an API key to connect to the NOAA database.
[Request an API key here](https://www.ncdc.noaa.gov/cdo-web/token), then
add the key to your `.Renviron` file. Enter in the console
`usethis::edit_r_environ()` and type
`NOAA_KEY="KEY GOES HERE, INSIDE QUOTES"`. Save and close the
`.Renviron` file, and restart R.

## Daily temperatures

### Fetch station data

The daily temperatures are fetched from stations within a certain
distance from a given latitude and longitude (i.e., your home or another
sentimental place). Sometimes the distance radius needs to be increased
if stations are sparse, and other times the specific latitude and
longitude might need to be adjusted to get what you want. Basically,
this is part of the art - figure out what looks good.

As an FYI, fetching station data does take a while. The very first time
this code is run, you’ll get stations names for all NOAA stations in the
US (that takes a while, but only needs to happen once). Whenever you
change the location for which you’d like to get data, it’ll also take a
while to run.

Sometimes the closest stations to the site need to be adjusted. A couple
tips: 1) The maximum number of stations to fetch data from is capped at
15. You may want to increase or decrease this number (edit the `limit`
call). 2) The stations can have different data availability, but
generally it seems like longer-term stations are more ideal for the art.
Still, you might need to adjust (edit the `year_min` and `year_max`
calls).  
3) The code will attempt to fetch data through the most recently
completed year, but you may need to write over your data cache to start
displaying the most up-to-date data.

<div id="htmlwidget-03a32f4b752c5a619fbe" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-03a32f4b752c5a619fbe">{"x":{"options":{"minZoom":1,"maxZoom":52,"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"preferCanvas":false,"bounceAtZoomLimits":false,"maxBounds":[[[-90,-370]],[[90,370]]]},"calls":[{"method":"addProviderTiles","args":["CartoDB.Positron","CartoDB.Positron","CartoDB.Positron",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"addProviderTiles","args":["CartoDB.DarkMatter","CartoDB.DarkMatter","CartoDB.DarkMatter",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"addProviderTiles","args":["OpenStreetMap","OpenStreetMap","OpenStreetMap",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"addProviderTiles","args":["Esri.WorldImagery","Esri.WorldImagery","Esri.WorldImagery",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"addProviderTiles","args":["OpenTopoMap","OpenTopoMap","OpenTopoMap",{"errorTileUrl":"","noWrap":false,"detectRetina":false,"pane":"tilePane"}]},{"method":"createMapPane","args":["point",440]},{"method":"addCircleMarkers","args":[[44.7597,44.8544,44.8853,44.9311,44.9322,44.9461,44.9783,44.9903,45.0417,45.0456,45.0483],[-92.8689,-92.6122,-93.2314,-93.1539,-93.0558,-93.03,-93.2469,-93.18,-92.7975,-92.8522,-93.0958],6,null,".",{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}},"pane":"point","stroke":true,"color":"#333333","weight":1,"opacity":0.9,"fill":true,"fillColor":"#6666FF","fillOpacity":0.6},null,null,["<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>1&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>HASTINGS DAM 2&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00213567&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1893-08-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>2&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>RIVER FALLS&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00477226&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1918-04-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>3&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>MINNEAPOLIS-ST PAUL INTL AP&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USW00014922&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1938-04-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>4&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>ST PAUL 3SW&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00217379&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>2006-07-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2017-07-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>5&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>ST PAUL DWTN AP&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USW00014927&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1937-01-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>6&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>ST PAUL&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00217377&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1956-12-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2006-05-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>7&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>LOWER ST ANTHONY FALLS&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00214884&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1992-06-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>8&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>U OF MN ST PAUL&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00218450&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1963-01-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>9&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>STILLWATER 1 SE&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00218037&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1958-11-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2006-01-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>10&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>STILLWATER 2SW&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00218039&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>2006-07-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>","<div class='scrollableContainer'><table class=mapview-popup id='popup'><tr class='coord'><td><\/td><th><b>Feature ID&emsp;<\/b><\/th><td>11&emsp;<\/td><\/tr><tr><td>1<\/td><th>name&emsp;<\/th><td>VADNAIS LAKE&emsp;<\/td><\/tr><tr><td>2<\/td><th>id&emsp;<\/th><td>USC00218477&emsp;<\/td><\/tr><tr><td>3<\/td><th>mindate&emsp;<\/th><td>1981-10-01&emsp;<\/td><\/tr><tr><td>4<\/td><th>maxdate&emsp;<\/th><td>2022-12-31&emsp;<\/td><\/tr><tr><td>5<\/td><th>geometry&emsp;<\/th><td>sfc_POINT&emsp;<\/td><\/tr><\/table><\/div>"],{"maxWidth":800,"minWidth":50,"autoPan":true,"keepInView":false,"closeButton":true,"closeOnClick":true,"className":""},["1","2","3","4","5","6","7","8","9","10","11"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addScaleBar","args":[{"maxWidth":100,"metric":true,"imperial":true,"updateWhenIdle":true,"position":"bottomleft"}]},{"method":"addHomeButton","args":[-93.2469,44.7597,-92.6122,45.0483,true,".","Zoom to .","<strong> . <\/strong>","bottomright"]},{"method":"addLayersControl","args":[["CartoDB.Positron","CartoDB.DarkMatter","OpenStreetMap","Esri.WorldImagery","OpenTopoMap"],".",{"collapsed":true,"autoZIndex":true,"position":"topleft"}]},{"method":"addLegend","args":[{"colors":["#6666FF"],"labels":["."],"na_color":null,"na_label":"NA","opacity":1,"position":"topright","type":"factor","title":"","extra":null,"layerId":null,"className":"info legend","group":"."}]}],"limits":{"lat":[44.7597,45.0483],"lng":[-93.2469,-92.6122]},"fitBounds":[44.7597,-93.2469,45.0483,-92.6122,[]]},"evals":[],"jsHooks":{"render":[{"code":"function(el, x, data) {\n  return (\n      function(el, x, data) {\n      // get the leaflet map\n      var map = this; //HTMLWidgets.find('#' + el.id);\n      // we need a new div element because we have to handle\n      // the mouseover output separately\n      // debugger;\n      function addElement () {\n      // generate new div Element\n      var newDiv = $(document.createElement('div'));\n      // append at end of leaflet htmlwidget container\n      $(el).append(newDiv);\n      //provide ID and style\n      newDiv.addClass('lnlt');\n      newDiv.css({\n      'position': 'relative',\n      'bottomleft':  '0px',\n      'background-color': 'rgba(255, 255, 255, 0.7)',\n      'box-shadow': '0 0 2px #bbb',\n      'background-clip': 'padding-box',\n      'margin': '0',\n      'padding-left': '5px',\n      'color': '#333',\n      'font': '9px/1.5 \"Helvetica Neue\", Arial, Helvetica, sans-serif',\n      'z-index': '700',\n      });\n      return newDiv;\n      }\n\n\n      // check for already existing lnlt class to not duplicate\n      var lnlt = $(el).find('.lnlt');\n\n      if(!lnlt.length) {\n      lnlt = addElement();\n\n      // grab the special div we generated in the beginning\n      // and put the mousmove output there\n\n      map.on('mousemove', function (e) {\n      if (e.originalEvent.ctrlKey) {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                           ' lon: ' + (e.latlng.lng).toFixed(5) +\n                           ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                           ' | zoom: ' + map.getZoom() +\n                           ' | x: ' + L.CRS.EPSG3857.project(e.latlng).x.toFixed(0) +\n                           ' | y: ' + L.CRS.EPSG3857.project(e.latlng).y.toFixed(0) +\n                           ' | epsg: 3857 ' +\n                           ' | proj4: +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs ');\n      } else {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                      ' lon: ' + (e.latlng.lng).toFixed(5) +\n                      ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                      ' | zoom: ' + map.getZoom() + ' ');\n      }\n      });\n\n      // remove the lnlt div when mouse leaves map\n      map.on('mouseout', function (e) {\n      var strip = document.querySelector('.lnlt');\n      if( strip !==null) strip.remove();\n      });\n\n      };\n\n      //$(el).keypress(67, function(e) {\n      map.on('preclick', function(e) {\n      if (e.originalEvent.ctrlKey) {\n      if (document.querySelector('.lnlt') === null) lnlt = addElement();\n      lnlt.text(\n                      ' lon: ' + (e.latlng.lng).toFixed(5) +\n                      ' | lat: ' + (e.latlng.lat).toFixed(5) +\n                      ' | zoom: ' + map.getZoom() + ' ');\n      var txt = document.querySelector('.lnlt').textContent;\n      console.log(txt);\n      //txt.innerText.focus();\n      //txt.select();\n      setClipboardText('\"' + txt + '\"');\n      }\n      });\n\n      }\n      ).call(this.getMap(), el, x, data);\n}","data":null},{"code":"function(el, x, data) {\n  return (function(el,x,data){\n           var map = this;\n\n           map.on('keypress', function(e) {\n               console.log(e.originalEvent.code);\n               var key = e.originalEvent.code;\n               if (key === 'KeyE') {\n                   var bb = this.getBounds();\n                   var txt = JSON.stringify(bb);\n                   console.log(txt);\n\n                   setClipboardText('\\'' + txt + '\\'');\n               }\n           })\n        }).call(this.getMap(), el, x, data);\n}","data":null}]}}</script>

### Decide what years to use

This is a balance! You probably want as many years of data as possible,
but some of the early records are spotty or missing. Some steps are
designed to deal with small missing data records, but you still need to
figure out a good starting year. The code below gets you to a good
estimate of what year to start at, but you may need to revisit it once
you see what the plots look like.

This `min_year` is a *global* parameter, which is passed to the
processing and plotting for both the daily and annual temperatures. So
if (when) this parameter is adjusted, all code chunks below this also
should be re-run (and subsequently styled). You’ll know an adjustment to
the `min_year` is needed if you see long “streaks” of the same daily
temperatures.

### Make daily plot

You will probably be reprocessing this piece several times to make it
look nice. The daily average temperatures get mapped (#aesthetics), so
just know that going into any manual adjustments you may be making.

Tips:

- Starting points for the temperature thresholds have been populated,
  but tweak as needed. Looking at the count of entries in each category
  can also be helpful (roughly even split between hot/cold, and even but
  less than !1000 in the extreme categories).
- You’ll probably end up trimming the dates included (i.e., starting the
  plots at a later date than the earliest potential date), which will
  mess with the starting point color scheme.
- Finally, you might have other aesthetic preferences! Establishing a
  consistent color scheme across multiple locations? Have a predefined
  parameter for extreme hot or cold temperatures?

## Annual average temperatures

### Fetch annual data

[Manually download county-level average
temperatures](https://www.ncei.noaa.gov/access/monitoring/climate-at-a-glance/county/time-series/MN-163/tavg/ann/2/1895-2023)
from NOAA. Annual averages are calculated using [some fancy
models](https://www.ncei.noaa.gov/access/monitoring/dyk/us-climate-divisions#grdd_)
(weighting station data by area, quality control algorithms, etc.). Save
this file in the data-raw folder.

### Plot annual data

The annual data is shown as deviations from the mean of all year’s
average temperature. Here too, the **years** which end up being included
matter. So if/when the `min_year` parameter is adjusted above, this
needs to get re-run.

The extreme years are labeled, but you may be adjusting the year
threshold. You also may be needing to remove labels and nudge them up or
down depending on what the data looks like.

## Combine poster elements

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
