<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

    <head id="Head1" runat="server">
        <style type="text/css">
            body {  font: 11pt Trebuchet MS;
                    color: #000000;
                    /*padding-top: 72px;*/
                    text-align: center }

            .text { font: 8pt Trebuchet MS }
        </style>

        <title>Using AJAX Enabled ASP.NET Service</title>
    <link rel="stylesheet" href="http://openlayers.org/en/v3.17.1/css/ol.css" type="text/css">
    <script src="http://openlayers.org/en/v3.17.1/build/ol.js"></script>
    <script src="https://code.jquery.com/jquery-3.0.0.js" integrity="sha256-jrPLZ+8vDxt2FnE1zvZXCkCcebI/C8Dt5xyaQBjxQIo=" crossorigin="anonymous"></script>
<style>
      .ol-popup {
        position: absolute;
        background-color: white;
        -webkit-filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
        filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
        padding: 15px;
        border-radius: 10px;
        border: 1px solid #cccccc;
        bottom: 12px;
        left: -50px;
        min-width: 280px;
        text-align:left;
      }
    .ol-popup:after, .ol-popup:before {
        top: 100%;
        border: solid transparent;
        content: " ";
        height: 0;
        width: 0;
        position: absolute;
        pointer-events: none;
      }
    .ol-popup:after {
        border-top-color: white;
        border-width: 10px;
        left: 48px;
        margin-left: -10px;
      }
    .ol-popup:before {
        border-top-color: #cccccc;
        border-width: 11px;
        left: 48px;
        margin-left: -11px;
      }
        .ol-popup-closer {
        text-decoration: none;
        position: absolute;
        top: 2px;
        right: 8px;
      }
      .ol-popup-closer:after {
        content: "✖";
      }
        </style>

    </head>
    <body id="myBody">
        <form id="Form1" runat="server">
            
            <div id="map" class="map">
            </div>
            <asp:ScriptManager runat="server" ID="scriptManager">
                <Services>
                    <asp:ServiceReference path="~/HelloWorld.asmx" />
                </Services>
                <Scripts>
                    <asp:ScriptReference Path="~/HelloWorld.js" />
                </Scripts>
            </asp:ScriptManager>
        <div style="position:absolute; top:15%; left:5%; text-align:left;">
            <div>
            <input id="mainWeather" name="filters" type="checkbox" value="" checked="checked" />
            <label for="mainWeather">Weather</label>
             </div>
            <div>
            <input id="minMaxTemp" name="filters" type="checkbox" value="" />
            <label for="minMaxTemp">Min/Max Temperature</label>
            </div>
            <div>
            <input id="sunriseSunset" name="filters" type="checkbox" value="" />
            <label for="sunriseSunset">Sunrise/Sunset</label>
            </div>
            <div>
            <input id="pressure" name="filters" type="checkbox" value="" />
            <label for="pressure">Pressure</label>
            </div>
            <div>
            <input id="humidity" name="filters"  type="checkbox" value="" />
            <label for="humidity">Humidity</label>
            </div>
            <div>
            <input id="wind" name="filters" type="checkbox" value="" />
            <label for="wind">Wind Speed/Degrees</label>
            </div>
            </div>
            <script>
                function filter() {
                    var filters = document.getElementsByName('filters');
                    for (i = 0; i < filters.length; i++) {
                        if(filters[i].checked) {
                            filters[i].value = getFilterColumns(filters[i].id);
                        }
                        else {
                            filters[i].value = '';
                        }
                    }
                }
                function getFilterColumns(elementId) {
                    switch (elementId) {
                        case 'mainWeather': return 'Weather, Temperature';
                        case 'minMaxTemp': return 'MinimumTemperature, MaximumTemperature';
                        case 'sunriseSunset': return 'Sunrise, Sunset';
                        case 'pressure': return 'Pressure';
                        case 'humidity': return 'Humidity';
                        case 'wind': return 'WindSpeed, WindDegrees';
                    }
                }
            </script>

    <div id="popup" class="ol-popup">
      <a href="#" id="popup-closer" class="ol-popup-closer"></a>
      <div id="popup-content">
      </div>
    </div>
        </form>

       <div>
            <span id="Results"></span>
        </div>
        <script>

      /**
       * Elements that make up the popup.
       */
      var container = document.getElementById('popup');
      var content = document.getElementById('popup-content');
      var closer = document.getElementById('popup-closer');


      /**
       * Create an overlay to anchor the popup to the map.
       */
      var overlay = new ol.Overlay(/** @type {olx.OverlayOptions} */ ({
        element: container,
        autoPan: true,
        autoPanAnimation: {
          duration: 250
        }
      }));
      /**
 * Add a click handler to hide the popup.
 * @return {boolean} Don't follow the href.
 */
      closer.onclick = function() {
          overlay.setPosition(undefined);
          closer.blur();
          return false;
      };

      /**
 * Create the map.
 */
      var map = new ol.Map({
          layers: [
        // Map ("geography-class.json") of capitals and countries http://openlayers.org/en/latest/examples/custom-interactions.html
         new ol.layer.Tile({
             source: new ol.source.TileJSON({
                 url: 'http://api.tiles.mapbox.com/v3/' +
                     'mapbox.geography-class.json',
                 crossOrigin: 'anonymous'
             })
         })
          ],
          overlays: [overlay],
          target: 'map',
          view: new ol.View({
              /* Center the map using horizontal estimate from http://openlayers.org/en/latest/examples/mouse-position.html
              and vertical estimate from http://openlayers.org/en/latest/examples/bing-maps.html */
              center: [3000000, 6709968.258934638],
              zoom: 4
          })
      });

      /**
 * Add a click handler to the map to render the popup.
 */
      map.on('singleclick', function (evt) {
          var coordinate = evt.coordinate;
          var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
              coordinate, 'EPSG:3857', 'EPSG:4326'));

          var re = hdms.match(/\d+\°/g);
          var re2 = re[0];
          var latitude;
          var longitude;
          for (i = 0; i < re.length; i++) {
              if (i == 0) {
                  latitude = re[i].replace("°", "");
              }
              else {
                  longitude = re[i].replace("°", "");
              }
          }
          //content.innerHTML = hdms;
          overlay.setPosition(coordinate);
          filter();
          OnClickWeather(longitude, latitude, mainWeather.value, minMaxTemp.value, sunriseSunset.value, pressure.value, humidity.value, wind.value); return false;
      });
    </script>
    </body>
</html>