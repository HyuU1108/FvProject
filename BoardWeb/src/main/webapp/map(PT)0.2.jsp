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

    var markers = {}; // 마커를 객체로 관리 (planeId를 키로 사용)
    var flightPaths = {};
    var currentPath = null;
    var allPlanesVisible = true;

    // 항공기 데이터 가져오기 함수
    function fetchFlights() {
    	var username = "HyuU";
        //var username = "sugil1";
        //var username = "sugil2";
        //var username = "sugil4";
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
          
          var currentPlaneIds = new Set(Object.keys(markers)); // 현재 표시된 마커의 ID 목록

          data.states.forEach(function (plane) {
            var lat = plane[6];
            var lon = plane[5];
            var heading = plane[10];
            var planeId = plane[0];

            if (lat && lon && heading !== null) {
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
                  // 기존 마커가 있으면 위치 업데이트 (애니메이션 적용)
                  var marker = markers[planeId];
                    
                    // 새로운 위치로 부드럽게 이동
                   var startLatLng = marker.getLatLng();
                   var endLatLng = L.latLng(lat,lon);
                   
                   
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

                  // 회전 업데이트
                  marker.getElement().querySelector(".plane-wrapper").style.transform = "rotate(" + heading + "deg)";
                } else {
                  // 새로운 마커 생성
                  var marker = L.marker([lat, lon], { icon: icon })
                    .addTo(map)
                    .bindPopup("Flight: " + plane[1] + "<br>Latitude: " + lat + "<br>Longitude: " + lon);

                    
                    marker.on("click", function () {
                        allPlanesVisible = false;

                        if (currentPath) {
                          map.removeLayer(currentPath);
                        }

                        for(let key in markers){
                          if(markers[key] !== marker)
                           map.removeLayer(markers[key]);
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
            }
          });

          // 삭제된 마커 정리
          currentPlaneIds.forEach(function (planeId) {
            map.removeLayer(markers[planeId]);
              delete markers[planeId];
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
      if (!allPlanesVisible) {
        allPlanesVisible = true;

        // 현재 경로 삭제
        if (currentPath) {
          map.removeLayer(currentPath);
          currentPath = null;
        }
        
        // 모든 마커 다시 표시
        for (let planeId in markers) {
            map.addLayer(markers[planeId]);
        }
      }
    });

    // 일정 간격으로 항공기 데이터 업데이트 (5초마다)
    setInterval(fetchFlights, 5000);

    // 초기 데이터 로드
    fetchFlights();
  </script>
</body>

</html>