<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>트래커</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        /* 스타일은 이전과 동일 */
        #map { height: 100vh; position: relative; }
        .plane-icon { width: 32px; height: 32px; background-image: url("/resources/img/2plane.png"); background-size: cover; transform-origin: center center; }
        .plane-wrapper { display: inline-block; transform-origin: center center; }
        iframe { border: none; overflow: hidden; }
        .leaflet-tile { filter: blur(0.5px); opacity: 0.9; }
        .flight-info-container { position: absolute; top: 10px; left: 10px; background-color: white; padding: 10px; border: 1px solid #ccc; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3); z-index: 1000; display: none; width: 280px; }
        .flight-info-table { width: 100%; border-collapse: collapse; }
        .flight-info-table th, .flight-info-table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .flight-info-table th { background-color: #f2f2f2; }
        .reset-button { position: absolute; top: 10px; right: 10px; z-index: 1100; }
        .reset-button button { background-color: white; color: black; border: 1px solid #ccc; padding: 8px 12px; border-radius: 5px; cursor: pointer; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3); }
        .reset-button button:hover { background-color: #f0f0f0; }
        /* 링크 버튼 스타일 (줌 컨트롤 위에) */
        .link-to-jsp-button {
            position: absolute; /* 지도 컨테이너 (#map)를 기준으로 절대 위치 설정 */
            bottom: 75px; /* 줌 컨트롤 바로 위 (bottom: bottomright 줌 컨트롤 위치 + 버튼 높이 + 간격) */
            right: 10px; /* 오른쪽 여백 동일하게 */
            z-index: 1100; /* 다른 요소 위에 표시되도록 z-index 값 조정 */
        }

        .link-to-jsp-button a {
            display: block; /* a 태그를 블록 요소로 만들어 패딩 적용 및 크기 조절 용이하게 함 */
            background-color: white; /* 버튼 배경색 흰색 */
            color: black; /* 버튼 텍스트 색상 검정색 */
            border: 1px solid #ccc; /* 버튼 테두리 설정 */
            padding: 8px 12px; /* 버튼 내부 여백 설정 */
            border-radius: 5px; /* 버튼 테두리 둥글게 */
            cursor: pointer; /* 마우스 커서 모양 변경 (손가락 모양) */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3); /* 그림자 효과 */
            text-decoration: none; /* a 태그 밑줄 제거 */
            text-align: center; /* 텍스트 가운데 정렬 */
        }

        .link-to-jsp-button a:hover {
            background-color: #f0f0f0; /* 마우스 호버 시 배경색 약간 밝게 */
        }
    </style>
</head>

<body>
<div id="map">
    <div id="link-to-jsp-button" class="link-to-jsp-button">
    </div>
    <div id="reset-button" class="reset-button">
    	<!-- 새로고침 버튼 -->
        <button type="button" onclick="window.location.reload()"><img src="/resources/img/reload-icon.png" width="10px" height="10px"></button>
    </div>
    <div id="flight-info-container" class="flight-info-container">
        <img src="/resources/img/kalB787-9.jpg" width="283">
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

    var flightInfoContainer = document.getElementById('flight-info-container');
    var flightInfoTableBody = document.querySelector('#flight-info-container .flight-info-table tbody');


    function fetchFlights() {
        var username = "sugil2";
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
                        var callsign = plane[1];
                        var origin_country = plane[2];
                        var on_ground = plane[8] ? "착륙" : "비행중";

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

                                // Null 체크 추가 (에러 방지)
                                if (marker.getElement()) {
                                    marker.getElement().querySelector(".plane-wrapper").style.transform = "rotate(" + heading + "deg)";
                                }
                            } else {
                                var marker = L.marker([lat, lon], {icon: icon})
                                    .addTo(map)
                                    .bindPopup("비행편: " + plane[1] + "<br>위도: " + lat + "<br>경도: " + lon);

                                // --- MARKER SINGLE CLICK HANDLER (시점 이동) ---
                                marker.on("click", function (e) { // <-- 싱글 클릭 이벤트 핸들러 (dblclick -> click 변경 확인!)
                                    L.DomEvent.stopPropagation(e);

                                    if (currentPath) {
                                        map.removeLayer(currentPath);
                                        currentPath = null;
                                    }

                                    currentPath = L.polyline(flightPaths[planeId], {
                                        color: "blue",
                                        weight: 3,
                                    }).addTo(map);

                                    var flightInfo = {
                                        "비행편명": callsign,
                                        "식별 코드": planeId,
                                        "위도": lat.toFixed(6),
                                        "경도": lon.toFixed(6),
                                        "고도": plane[7],
                                        "속도": plane[9],
                                        "방향": heading,
                                        "출발 국가": origin_country,
                                        "상태": on_ground,
                                    };

                                    updateTable(flightInfo);
                                    flightInfoContainer.style.display = 'block';
                                    map.panTo(marker.getLatLng()); // <-- panTo 호출 (마커 중심으로 시점 이동)
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


    // 지도 클릭 이벤트 처리 (정보창 닫고 선택 해제)
    map.on('click', function(e) {
        hideFlightInfoContainer();
        if (currentPath) {
            map.removeLayer(currentPath);
            currentPath = null;
        }
    });


    function updateTable(flightInfo) {
        flightInfoTableBody.innerHTML = '';
        for (const key in flightInfo) {
            let row = flightInfoTableBody.insertRow();
            let propertyCell = row.insertCell();
            let valueCell = row.insertCell();

            propertyCell.textContent = key;
            valueCell.textContent = flightInfo[key];
        }
    }

    function hideFlightInfoContainer() {
        flightInfoContainer.style.display = 'none';
    }

    setInterval(fetchFlights, 5000);
    fetchFlights();
</script>
</body>
</html>