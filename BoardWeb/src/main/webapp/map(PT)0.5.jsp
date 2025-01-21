<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>비행 추적기</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        /* 지도 스타일 */
        #map {
            height: 100vh;
            position: relative;
        }

        /* 비행기 아이콘 스타일 */
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

        /* iframe 스타일 (필요한 경우) */
        iframe {
            border: none;
            overflow: hidden;
        }

        /* 지도 타일 스타일 (흐림 효과) */
        .leaflet-tile {
            filter: blur(0.5px);
            opacity: 0.9;
        }

        /* 비행 정보 테이블 스타일 */
        .flight-info-container {
            position: absolute;
            top: 10px;
            left: 10px;
            background-color: white;
            padding: 10px;
            border: 1px solid #ccc;
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);
            z-index: 1000;
            display: none;
            width: 280px;
        }

        .flight-info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .flight-info-table th, .flight-info-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .flight-info-table th {
            background-color: #f2f2f2;
        }
    </style>
</head>

<body>
<div id="map">
    <div id="flight-info-container" class="flight-info-container">
        <table class="flight-info-table">
            <thead>
            <tr>
                <th>항목</th>
                <th>정보</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<script>
    var ICN_COORDS = [37.469075, 126.450517];
    var map = L.map("map", { zoomControl: false }).setView(ICN_COORDS, 9);
    L.control.zoom({ position: 'bottomright' }).addTo(map);

    var minLat = ICN_COORDS[0] - 15.0;
    var minLon = ICN_COORDS[1] - 15.0;
    var maxLat = ICN_COORDS[0] + 15.0;
    var maxLon = ICN_COORDS[1] + 30.0;
    var bounds = L.latLngBounds([minLat, minLon], [maxLat, maxLon]);
    map.setMaxBounds(bounds);

    var CartoDB_Voyager = L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors © <a href="https://carto.com/attributions">CARTO</a>',
        subdomains: 'abcd',
        maxZoom: 20
    });
    CartoDB_Voyager.addTo(map);

    var markers = {};
    var flightPaths = {};
    var currentPath = null;
    var allPlanesVisible = true;

    var flightInfoContainer = document.getElementById('flight-info-container');
    var flightInfoTableBody = document.querySelector('#flight-info-container .flight-info-table tbody');

    function fetchFlights() {
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
                var currentPlaneIds = new Set(Object.keys(markers));

                if (data && data.states) {
                    data.states.forEach(function (plane) {
                        var lat = plane[6];
                        var lon = plane[5];
                        var heading = plane[10];
                        var planeId = plane[0];
                        var callsign = plane[1]; // callsign 추가
                        var origin_country = plane[2]; // origin_country 추가
                        var on_ground = plane[8] ? "착륙" : "비행중"; // on_ground 추가

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
                                var marker = L.marker([lat, lon], {icon: icon})
                                    .addTo(map)
                                    .bindPopup("비행편: " + plane[1] + "<br>위도: " + lat + "<br>경도: " + lon);

                                marker.on("click", function (e) {
                                    L.DomEvent.stopPropagation(e);
                                    allPlanesVisible = false;

                                    if (currentPath) {
                                        map.removeLayer(currentPath);
                                    }

                                    for (let key in markers) {
                                        if (markers[key] !== marker)
                                            map.removeLayer(markers[key]);
                                    }

                                    currentPath = L.polyline(flightPaths[planeId], {
                                        color: "blue",
                                        weight: 3,
                                    }).addTo(map);

                                    var flightInfo = {
                                        "비행편명": callsign, // 변경
                                        "식별 코드": planeId, // 변경
                                        "위도": lat.toFixed(6), // 변경
                                        "경도": lon.toFixed(6), // 변경
                                        "고도": plane[7], // 변경 (단위: 미터)
                                        "속도": plane[9], // 변경 (단위: m/s)
                                        "방향": heading, // 변경 (단위: 도)
                                        "출발 국가": origin_country, // 변경
                                        "상태": on_ground, // 변경
                                    };

                                    updateTable(flightInfo);
                                    flightInfoContainer.style.display = 'block';
                                    map.setView(marker.getLatLng(), map.getZoom(), { // 현재 위치로 시점 이동
                                        animate: true,
                                        duration: 1
                                    });
                                    window.parent.postMessage(flightInfo, "*");
                                });

                                markers[planeId] = marker;
                            }
                            currentPlaneIds.delete(planeId);
                        }
                    });
                } else {
                    console.error("API에서 'states' 데이터를 찾을 수 없습니다.");
                }

                currentPlaneIds.forEach(function (planeId) {
                    map.removeLayer(markers[planeId]);
                    delete markers[planeId];
                });
            } else {
                console.error("비행 데이터 가져오기 오류:", xhr.statusText);
            }
        };
        xhr.onerror = function () {
            console.error("요청 실패");
        };
        xhr.send();
    }


    // 지도 클릭 이벤트 처리 (기존 코드 유지)
    // ...

    function updateTable(flightInfo) {
        flightInfoTableBody.innerHTML = '';
        for (const key in flightInfo) {
            let row = flightInfoTableBody.insertRow();
            let propertyCell = row.insertCell();
            let valueCell = row.insertCell();

            // 항목을 한국어로 표시
            propertyCell.textContent = key;
            valueCell.textContent = flightInfo[key];
        }
    }

    setInterval(fetchFlights, 5000);
    fetchFlights();
</script>
</body>

</html>