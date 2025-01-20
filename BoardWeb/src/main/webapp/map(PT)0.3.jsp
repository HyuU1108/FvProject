<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Flight Tracker</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        #map {
            height: 100vh;
        }

        .plane-icon {
            width: 32px;
            height: 32px;
            background-image: url("/resources/img/2plane.png");
            background-size: cover;
            transform-origin: center center;
        }

        .plane-wrapper {
            display: inline-block;
            transform-origin: center center;
        }
    </style>
</head>
<body>
    <input type="text" id="flightNumber" placeholder="항공편명 검색">
    <button id="searchFlight">검색</button>
    <div id="map"></div>

    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
    <script>
        var ICN_COORDS = [37.469075, 126.450517];
        var map = L.map("map").setView(ICN_COORDS, 9);

        // 맵에 이동 제한 설정 (ICN_COORDS 기준으로 경계 설정)
        var minLat = ICN_COORDS[0] - 15.0; // 최소 위도
        var minLon = ICN_COORDS[1] - 15.0; // 최소 경도
        var maxLat = ICN_COORDS[0] + 15.0; // 최대 위도
        var maxLon = ICN_COORDS[1] + 30.0; // 최대 경도

        // 맵 이동 제한 설정 범위
        var bounds = L.latLngBounds([minLat, minLon], [maxLat, maxLon]);

        // 맵 이동 제한 설정
        map.setMaxBounds(bounds);

        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
            maxZoom: 18,
        }).addTo(map);

        var markers = {};
        var flightPaths = {};
        var currentPath = null;
        var allPlanesVisible = true;
        var currentFlightNumber = "";
         var selectedPlaneId = null;



          document.getElementById("searchFlight").addEventListener("click", function() {
            var flightNumber = document.getElementById("flightNumber").value.toUpperCase();
            currentFlightNumber = flightNumber;
             selectedPlaneId = null;
            for(let key in markers){
                  map.removeLayer(markers[key]);
                }
             markers = {};

            fetchFlights();
         });


        // 항공기 데이터 가져오기 함수
        function fetchFlights() {
            var username = "HyuU";
            var password = "qwer1234";
            var base64Credentials = btoa(username + ":" + password);

            var bounds = {
                lamin: ICN_COORDS[0] - 10.0,
                lomin: ICN_COORDS[1] - 10.0,
                lamax: ICN_COORDS[0] + 25.0,
                lomax: ICN_COORDS[1] + 25.0,
            };

            var url = "https://opensky-network.org/api/states/all?lamin=" + bounds.lamin + "&lomin=" + bounds.lomin + "&lamax=" + bounds.lamax + "&lomax=" + bounds.lomax;

            var xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.setRequestHeader("Authorization", "Basic " + base64Credentials);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    var data = JSON.parse(xhr.responseText);

                    var currentPlaneIds = new Set();

                    data.states.forEach(function (plane) {
                        var lat = plane[6];
                        var lon = plane[5];
                        var heading = plane[10];
                        var planeId = plane[0];
                        var flight = plane[1];


                        if (lat && lon && heading !== null) {
                           if (currentFlightNumber === "" || (flight && flight.toUpperCase() === currentFlightNumber)) {
                                  if (!flightPaths[planeId]) {
                                        flightPaths[planeId] = [];
                                  }
                                    flightPaths[planeId].push([lat, lon]);

                                     var icon = L.divIcon({
                                        className: "",
                                        html: '<div class="plane-wrapper" style="transform: rotate(' + heading + 'deg)"><div class="plane-icon"></div></div>',
                                        iconSize: [32, 32],
                                        iconAnchor: [16, 16],
                                    });

                                    if (markers[planeId]) {
                                        var marker = markers[planeId];
                                         var startLatLng = marker.getLatLng();
                                          var endLatLng = L.latLng(lat, lon);
                                          
                                            var startTime = null;
                                            function animate(timestamp) {
                                              if (!startTime) startTime = timestamp;
                                              var progress = (timestamp - startTime) / 5000;
                                                if (progress > 1) progress = 1;
  
                                                var newLat = startLatLng.lat + (endLatLng.lat - startLatLng.lat) * progress;
                                                 var newLng = startLatLng.lng + (endLatLng.lng - startLatLng.lng) * progress;
  
                                                  marker.setLatLng([newLat, newLng]);
  
                                                 if (progress < 1) {
                                                     requestAnimationFrame(animate);
                                                 }
                                             }
                                           requestAnimationFrame(animate);
                                         marker.getElement().querySelector(".plane-wrapper").style.transform = "rotate(" + heading + "deg)";

                                    } else {
                                        var marker = L.marker([lat, lon], { icon: icon })
                                            .addTo(map)
                                            .bindPopup("Flight: " + plane[1] + "<br>Latitude: " + lat + "<br>Longitude: " + lon);
                                            
                                          marker.on("click", function () {
                                            allPlanesVisible = false;
                                              selectedPlaneId = planeId;

                                            if (currentPath) {
                                                map.removeLayer(currentPath);
                                             }

                                             for (let key in markers) {
                                                 if (markers[key] !== marker) {
                                                     map.removeLayer(markers[key]);
                                                 }
                                             }

                                             currentPath = L.polyline(flightPaths[planeId], {
                                                 color: "blue",
                                                 weight: 3,
                                             }).addTo(map);

                                             var flightInfo = {
                                                 id: plane[0],
                                                 flight: plane[1],
                                                 latitude: plane[6],
                                                 longitude: plane[5],
                                                 altitude: plane[7],
                                                 velocity: plane[9],
                                                 heading: plane[10],
                                             };

                                             window.parent.postMessage(flightInfo, "*");
                                            });

                                    markers[planeId] = marker;
                                    }
                                currentPlaneIds.delete(planeId);

                            } else if (currentFlightNumber !== "" && markers[planeId]){
                                 map.removeLayer(markers[planeId]);
                                        delete markers[planeId];

                            }
                        }
                    });
                } else {
                    console.error("Error fetching flight data:", xhr.statusText);
                }
            };
            xhr.onerror = function () {
                console.error("Request failed");
            };
            xhr.send();
        }

        // 지도 배경 클릭 이벤트 추가 (모든 항공기 표시)
        map.on("click", function () {
            if (!allPlanesVisible || currentFlightNumber !== "") {
                 allPlanesVisible = true;
                currentFlightNumber = "";
                 document.getElementById("flightNumber").value = "";
                 selectedPlaneId = null;
                if (currentPath) {
                  map.removeLayer(currentPath);
                    currentPath = null;
                }

                 for (let planeId in markers) {
                    map.addLayer(markers[planeId]);
                  }
            }
        });

        // 일정 간격으로 항공기 데이터 업데이트 (5초마다)
       fetchFlights();
       setInterval(fetchFlights, 5000);
    </script>
</body>
</html>