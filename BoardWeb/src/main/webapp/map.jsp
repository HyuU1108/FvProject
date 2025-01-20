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

    var markers = {}; // 마커를 객체로 관리 (id를 키로 사용)
    var flightPaths = {};
    var currentPath = null;
    var allPlanesVisible = true;
    var previousPositions = {}; // 이전 위치 저장 객체

    // 애니메이션 프레임 업데이트 함수
    function updatePlanePosition(marker, nextLat, nextLon, nextHeading, duration) {
      var startLat = marker.getLatLng().lat;
      var startLon = marker.getLatLng().lng;
      var startTime = null;

      function animate(currentTime) {
        if (!startTime) {
          startTime = currentTime;
        }

        var progress = (currentTime - startTime) / duration;
        if (progress < 1) {
            var interpolatedLat = startLat + (nextLat - startLat) * progress;
            var interpolatedLon = startLon + (nextLon - startLon) * progress;

            marker.setLatLng([interpolatedLat, interpolatedLon]);
            marker._icon.querySelector('.plane-wrapper').style.transform = 'rotate(' + nextHeading + 'deg)';

            requestAnimationFrame(animate); // 다음 프레임 요청
        } else {
          marker.setLatLng([nextLat, nextLon]);
           marker._icon.querySelector('.plane-wrapper').style.transform = 'rotate(' + nextHeading + 'deg)';
        }
      }
      requestAnimationFrame(animate);
    }

    // 항공기 데이터 가져오기 함수
    function fetchFlights() {
      //var username = "HyuU";
      var username = "sugil1";
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
          var currentPlaneIds = new Set(); // 현재 데이터에 있는 비행기 id 저장

          data.states.forEach(function (plane) {
            var lat = plane[6];
            var lon = plane[5];
            var heading = plane[10];
            var planeId = plane[0];

            currentPlaneIds.add(planeId);

            if (lat && lon && heading !== null) {
              // 항공기 경로가 이미 저장되어 있으면 기존 경로에 추가
              if (!flightPaths[planeId]) {
                flightPaths[planeId] = [];
              }

              // 경로 누적
              flightPaths[planeId].push([lat, lon]);

              if(markers[planeId]){
                // 마커가 이미 있는 경우 애니메이션으로 이동
                var duration = 1000 // 1초 동안 애니메이션
                updatePlanePosition(markers[planeId], lat, lon, heading, duration)
                previousPositions[planeId] = {lat, lon};
                markers[planeId].setPopupContent("Flight: " + plane[1] + "<br>Latitude: " + lat + "<br>Longitude: " + lon);

              } else {
                // 마커가 없는 경우 새로 생성
                  var icon = L.divIcon({
                      className: "",
                      html: '<div class="plane-wrapper" style="transform: rotate(' + heading + 'deg)"><div class="plane-icon"></div></div>',
                      iconSize: [32, 32],
                      iconAnchor: [16, 16],
                    });

                var marker = L.marker([lat, lon], {icon: icon})
                    .addTo(map)
                    .bindPopup("Flight: " + plane[1] + "<br>Latitude: " + lat + "<br>Longitude: " + lon);
                    
                  // 마커 클릭 이벤트 추가 (클릭한 항공기의 경로만 표시)
                    marker.on("click", function () {
                        allPlanesVisible = false;

                        // 기존 경로 및 마커 삭제
                        if (currentPath) {
                        map.removeLayer(currentPath);
                        }
                        for(const key in markers){
                        if (markers[key] !== marker) {
                            map.removeLayer(markers[key]);
                        }
                        }


                        // 클릭한 항공기의 경로 표시
                        currentPath = L.polyline(flightPaths[planeId], {
                        color: "blue",
                        weight: 3
                        }).addTo(map);

                        // 부모 페이지에 비행기 정보를 전달
                        var flightInfo = {
                        id: plane[0],
                        flight: plane[1],
                        latitude: plane[6],
                        longitude: plane[5],
                        altitude: plane[7],
                        velocity: plane[9],
                        heading: plane[10]
                        };

                        window.parent.postMessage(flightInfo, "*");
                    });

                    markers[planeId] = marker;
              }
            }
          });

            // 현재 데이터에 없는 비행기 마커 삭제
           for (const planeId in markers) {
               if (!currentPlaneIds.has(planeId)) {
                    map.removeLayer(markers[planeId]);
                   delete markers[planeId]
               }
           }
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
      if (!allPlanesVisible) {
        allPlanesVisible = true;  

        // 현재 경로 삭제
        if (currentPath) {
          map.removeLayer(currentPath);
          currentPath = null;
        }

        // 모든 마커 다시 표시
        fetchFlights();
      }
    });

    // 일정 간격으로 항공기 데이터 업데이트 (5초마다)
    setInterval(fetchFlights, 5000);

    // 초기 데이터 로드
    fetchFlights();
  </script>
</body>

</html>