<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>트래커</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <style>
        /* 지도 스타일 */
        #map {
            height: 100vh; /* 뷰포트 높이의 100%로 지도의 높이를 설정, 화면 전체 높이로 지도를 채움 */
            position: relative; /* 지도를 기준으로 상대적인 위치 설정을 가능하게 함 (flight-info-container를 절대 위치로 배치하기 위해) */
        }

        /* 비행기 아이콘 스타일 */
        .plane-icon {
            width: 32px; /* 비행기 아이콘의 너비 */
            height: 32px; /* 비행기 아이콘의 높이 */
            background-image: url("/resources/img/2plane.png"); /* 비행기 아이콘 이미지 파일 경로, 실제 이미지 파일 경로를 확인해야 함 */
            background-size: cover; /* 배경 이미지를 요소에 꽉 채우도록 설정 */
            transform-origin: center center; /* 회전 변환의 중심점을 요소의 중앙으로 설정 */
        }
        .plane-wrapper {
            display: inline-block; /* 인라인 블록 요소로 만들어 transform-origin을 적용하기 쉽게 함 */
            transform-origin: center center; /* 회전 변환의 중심점을 요소의 중앙으로 설정 */
        }

        /* iframe 스타일 (필요한 경우) */
        iframe {
            border: none; /* iframe 테두리 제거 */
            overflow: hidden; /* iframe 내용이 넘칠 경우 숨김 */
        }

        /* 지도 타일 스타일 (흐림 효과) */
        .leaflet-tile {
            filter: blur(0.5px); /* 지도 타일에 약간의 흐림 효과 적용 */
            opacity: 0.9; /* 지도 타일의 투명도를 90%로 설정 (약간 반투명하게) */
        }

        /* 비행 정보 테이블 스타일 */
        .flight-info-container {
            position: absolute; /* 지도 컨테이너 (#map)를 기준으로 절대 위치 설정 */
            top: 10px; /* 상단에서 10px 떨어진 위치 */
            left: 10px; /* 왼쪽에서 10px 떨어진 위치 */
            background-color: white; /* 배경색을 흰색으로 설정 */
            padding: 10px; /* 내부 여백 10px 설정 */
            border: 1px solid #ccc; /* 1px 두께의 회색 테두리 설정 */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3); /* 그림자 효과 설정 */
            z-index: 1000; /* 다른 요소 위에 표시되도록 z-index 값을 높게 설정 */
            display: none; /* 초기 상태에서 숨김, JavaScript로 표시/숨김 제어 */
            width: 280px; /* 컨테이너 너비 280px 설정 */
        }

        .flight-info-table {
            width: 100%; /* 테이블 너비를 컨테이너에 꽉 채우도록 설정 */
            border-collapse: collapse; /* 테이블 테두리를 병합하여 한 줄로 표시 */
        }

        .flight-info-table th, .flight-info-table td {
            border: 1px solid #ddd; /* 테이블 셀 테두리 설정 */
            padding: 8px; /* 테이블 셀 내부 여백 설정 */
            text-align: left; /* 테이블 셀 텍스트 왼쪽 정렬 */
        }

        .flight-info-table th {
            background-color: #f2f2f2; /* 테이블 헤더 배경색 설정 */
        }
    </style>
</head>

<body>
<div id="map">
    <%-- 지도가 표시될 div 요소, id="map"으로 JavaScript에서 접근하여 Leaflet 지도를 생성합니다. --%>
    <div id="flight-info-container" class="flight-info-container">
        <%-- 비행기 정보를 표시할 컨테이너, 초기에는 숨겨져 있다가 비행기 마커 클릭 시 표시됩니다. --%>
    	<img src="/resources/img/kalB787-9.jpg" width="283">
        <%-- 비행 정보 컨테이너 상단에 이미지 표시, 이미지 파일 경로는 실제 경로에 맞게 수정해야 함 --%>
        <table class="flight-info-table">
            <%-- 비행 정보를 표 형식으로 표시할 테이블 --%>
            <thead>
            <%-- 테이블 머리말 부분 --%>
            <tr>
                <%-- 테이블 행 --%>
                <th>항목</th>
                <%-- 테이블 헤더 셀, 항목 이름 표시 --%>
                <th>정보</th>
                <%-- 테이블 헤더 셀, 정보 값 표시 --%>
            </tr>
            </thead>
            <%-- 테이블 머리말 종료 --%>
            <tbody></tbody>
            <%-- 테이블 본문, JavaScript를 사용하여 비행기 정보를 동적으로 채웁니다. --%>
        </table>
    </div>
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<%-- Leaflet JavaScript 라이브러리 링크, 지도 기능을 구현하는 데 사용됩니다. --%>
<script>
    // 초기 지도 중심 좌표 (인천국제공항)
    var ICN_COORDS = [37.469075, 126.450517];
    // Leaflet 지도 객체 생성 및 초기 설정
    var map = L.map("map", { zoomControl: false }).setView(ICN_COORDS, 9);
    // L.map("map", { zoomControl: false }): id가 "map"인 div에 Leaflet 지도 객체를 생성, 줌 컨트롤 버튼은 숨김
    // .setView(ICN_COORDS, 9): 지도의 초기 중심 좌표를 ICN_COORDS로, 초기 줌 레벨을 9로 설정

    L.control.zoom({ position: 'bottomright' }).addTo(map);
    // 줌 컨트롤 버튼을 지도에 추가하고 위치를 오른쪽 아래 (bottomright)로 설정

    // 지도 경계 설정 (최대 이동 범위 제한)
    var minLat = ICN_COORDS[0] - 15.0; // 최소 위도 (인천 중심에서 남쪽으로 15도)
    var minLon = ICN_COORDS[1] - 15.0; // 최소 경도 (인천 중심에서 서쪽으로 15도)
    var maxLat = ICN_COORDS[0] + 15.0; // 최대 위도 (인천 중심에서 북쪽으로 15도)
    var maxLon = ICN_COORDS[1] + 30.0; // 최대 경도 (인천 중심에서 동쪽으로 30도)
    var bounds = L.latLngBounds([minLat, minLon], [maxLat, maxLon]); // Leaflet LatLngBounds 객체 생성, 지도 경계 정의
    map.setMaxBounds(bounds); // 지도 이동 범위를 bounds로 제한, 사용자가 지정된 범위 밖으로 지도를 이동할 수 없게 함

    // 지도 타일 레이어 추가 (CartoDB Voyager)
    var CartoDB_Voyager = L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
        // L.tileLayer(): 지도 타일 레이어 객체 생성
        // 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png': 지도 타일 URL 템플릿, CartoDB Voyager 스타일 사용
        attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors © <a href="https://carto.com/attributions">CARTO</a>',
        // 지도 데이터 출처 표시, 저작권 정보
        subdomains: 'abcd', // 서브도메인 설정, 타일 로딩 성능 향상
        maxZoom: 20 // 최대 줌 레벨 설정
    });
    CartoDB_Voyager.addTo(map); // 생성된 타일 레이어를 지도에 추가

    // 비행기 마커, 경로, 정보 컨테이너 관련 변수 초기화
    var markers = {}; // 비행기 마커 객체를 저장하는 객체 (key: planeId, value: marker)
    var flightPaths = {}; // 비행 경로 좌표를 저장하는 객체 (key: planeId, value: [latlng array])
    var currentPath = null; // 현재 표시 중인 비행 경로 (Polyline 객체)
    var allPlanesVisible = true; // 모든 비행기 마커 표시 여부 (현재 사용 안함)

    var flightInfoContainer = document.getElementById('flight-info-container'); // 비행 정보 컨테이너 div 요소 가져오기
    var flightInfoTableBody = document.querySelector('#flight-info-container .flight-info-table tbody'); // 비행 정보 테이블의 tbody 요소 가져오기

    // 비행 데이터 가져와서 지도에 표시하는 함수
    function fetchFlights() {
        var username = "sugil2"; // OpenSky Network API 사용자 이름 (실제 계정 정보로 변경 필요)
        var password = "qwer1234"; // OpenSky Network API 비밀번호 (실제 계정 정보로 변경 필요)
        var base64Credentials = btoa(username + ":" + password); // Basic Authentication 인증 정보를 Base64 인코딩

        // API 요청 범위 (인천 중심으로 설정)
        var bounds = {
            lamin: ICN_COORDS[0] - 10.0, // 최소 위도
            lomin: ICN_COORDS[1] - 10.0, // 최소 경도
            lamax: ICN_COORDS[0] + 25.0, // 최대 위도
            lomax: ICN_COORDS[1] + 25.0, // 최대 경도
        };

        // OpenSky Network API 엔드포인트 URL, 지정된 범위 내의 비행 상태 정보 요청
        var url = "https://opensky-network.org/api/states/all?lamin=" + bounds.lamin + "&lomin=" + bounds.lomin + "&lamax=" + bounds.lamax + "&lomax=" + bounds.lomax;

        var xhr = new XMLHttpRequest(); // XMLHttpRequest 객체 생성, 서버와 비동기 통신을 위해 사용
        xhr.open("GET", url, true); // HTTP GET 요청 초기화, true는 비동기 방식으로 요청
        xhr.setRequestHeader("Authorization", "Basic " + base64Credentials); // 요청 헤더에 인증 정보 추가 (Basic Authentication)
        xhr.onload = function () { // 요청이 성공적으로 완료되었을 때 실행되는 콜백 함수
            if (xhr.status === 200) { // HTTP 상태 코드가 200 (OK)이면 성공
                var data = JSON.parse(xhr.responseText); // 응답받은 JSON 데이터를 JavaScript 객체로 파싱
                var currentPlaneIds = new Set(Object.keys(markers)); // 현재 지도에 표시된 비행기 ID 목록을 Set으로 생성, 빠른 검색을 위해 사용

                if (data && data.states) { // API 응답 데이터에 states 속성이 있는지 확인
                    data.states.forEach(function (plane) { // states 배열의 각 요소(비행기 정보)에 대해 반복 처리
                        var lat = plane[6];       // 위도 (states 배열의 7번째 요소)
                        var lon = plane[5];       // 경도 (states 배열의 6번째 요소)
                        var heading = plane[10];    // 방향 (states 배열의 11번째 요소)
                        var planeId = plane[0];     // 비행기 식별 ID (states 배열의 1번째 요소)
                        var callsign = plane[1];    // 편명 (states 배열의 2번째 요소)
                        var origin_country = plane[2]; // 출발 국가 (states 배열의 3번째 요소)
                        var on_ground = plane[8] ? "착륙" : "비행중"; // 지상 여부 (states 배열의 9번째 요소), true면 "착륙", false면 "비행중"

                        if (lat && lon && heading !== null) { // 위도, 경도, 방향 정보가 유효한 경우에만 처리
                            if (!flightPaths[planeId]) {
                                flightPaths[planeId] = []; // 해당 비행기의 경로 정보 배열이 없으면 새로 생성
                            }
                            flightPaths[planeId].push([lat, lon]); // 현재 좌표를 비행 경로에 추가

                            // 비행기 아이콘 생성 (방향 회전 적용)
                            var icon = L.divIcon({
                                className: "", // CSS 클래스 이름 (사용 안함)
                                html: '<div class="plane-wrapper" style="transform: rotate(' + heading + 'deg)"><div class="plane-icon"></div></div>',
                                // divIcon의 HTML 내용, plane-wrapper div를 사용하여 비행기 아이콘을 heading 각도만큼 회전
                                iconSize: [32, 32], // 아이콘 크기 [너비, 높이]
                                iconAnchor: [16, 16], // 아이콘 기준점 [x, y], 아이콘의 중앙이 좌표에 위치하도록 설정
                            });

                            if (markers[planeId]) { // 이미 해당 ID의 마커가 존재하는 경우 (위치 업데이트)
                                var marker = markers[planeId]; // 기존 마커 객체 가져오기
                                var startLatLng = marker.getLatLng(); // 마커의 현재 위치
                                var endLatLng = L.latLng(lat, lon); // 새로운 위치
                                var startTime = null; // 애니메이션 시작 시간 초기화

                                function animate(timestamp) { // 마커 이동 애니메이션 함수
                                    if (!startTime) startTime = timestamp; // 애니메이션 시작 시간 설정 (최초 호출 시)
                                    var progress = (timestamp - startTime) / 5000; // 경과 시간 계산 (5초 애니메이션)
                                    if (progress > 1) progress = 1; // 진행률이 100%를 넘지 않도록 제한
                                    var newLat = startLatLng.lat + (endLatLng.lat - startLatLng.lat) * progress; // 보간된 위도 계산
                                    var newLng = startLatLng.lng + (endLatLng.lng - startLatLng.lng) * progress; // 보간된 경도 계산
                                    marker.setLatLng([newLat, newLng]); // 마커의 위치를 새로운 좌표로 설정
                                    if (progress < 1) {
                                        requestAnimationFrame(animate); // 애니메이션이 끝나지 않았으면 다음 프레임 요청
                                    }
                                }
                                requestAnimationFrame(animate); // 애니메이션 시작
                                
                                marker.getElement().querySelector(".plane-wrapper").style.transform = "rotate(" + heading + "deg)";
                                // 마커 내부의 plane-wrapper div의 회전 각도를 업데이트하여 비행기 아이콘 방향 변경
                            } else { // 해당 ID의 마커가 존재하지 않는 경우 (새로운 마커 생성)
                                var marker = L.marker([lat, lon], {icon: icon}) // Leaflet 마커 객체 생성, 위치와 아이콘 설정
                                    .addTo(map) // 마커를 지도에 추가
                                    .bindPopup("비행편: " + plane[1] + "<br>위도: " + lat + "<br>경도: " + lon);
                                    // 마커 클릭 시 팝업 내용 설정 (비행편명, 위도, 경도)

                                marker.on("click", function (e) { // 마커 클릭 이벤트 핸들러 함수 등록
                                    L.DomEvent.stopPropagation(e); // 지도 클릭 이벤트 전파 방지 (마커 클릭 시 지도 클릭 이벤트가 발생하지 않도록)
                                    allPlanesVisible = false; // 모든 비행기 마커 표시 여부 변수 설정 (현재 사용 안함)

                                    if (currentPath) {
                                        map.removeLayer(currentPath); // 기존에 표시된 비행 경로 제거
                                    }

                                    for (let key in markers) { // 다른 모든 비행기 마커 제거 (선택한 비행기만 강조)
                                        if (markers[key] !== marker)
                                            map.removeLayer(markers[key]);
                                    }

                                    currentPath = L.polyline(flightPaths[planeId], { // Leaflet Polyline 객체 생성, 비행 경로 표시
                                        color: "blue", // 경로 색상 설정
                                        weight: 3, // 경로 두께 설정
                                    }).addTo(map); // 경로를 지도에 추가

                                    var flightInfo = { // 비행 정보 객체 생성, 테이블에 표시할 정보
                                        "비행편명": callsign, // 편명
                                        "식별 코드": planeId, // 식별 코드 (OpenSky Network ID)
                                        "위도": lat.toFixed(6), // 위도 (소수점 6자리까지 표시)
                                        "경도": lon.toFixed(6), // 경도 (소수점 6자리까지 표시)
                                        "고도": plane[7], // 고도 (단위: 미터)
                                        "속도": plane[9], // 속도 (단위: m/s)
                                        "방향": heading, // 방향 (단위: 도)
                                        "출발 국가": origin_country, // 출발 국가
                                        "상태": on_ground, // 상태 (착륙/비행중)
                                    };

                                    updateTable(flightInfo); // 비행 정보 테이블 업데이트 함수 호출
                                    flightInfoContainer.style.display = 'block'; // 비행 정보 컨테이너 표시
                                    map.setView(marker.getLatLng(), map.getZoom(), { // 지도 중심을 클릭한 마커 위치로 이동
                                        animate: true, // 애니메이션 효과 적용
                                        duration: 1 // 애니메이션 지속 시간 1초
                                    });
                                    window.parent.postMessage(flightInfo, "*"); // 부모 창으로 비행 정보 메시지 전송 (iframe 환경에서 사용 가능)
                                });

                                markers[planeId] = marker; // 생성된 마커 객체를 markers 객체에 저장 (planeId를 키로 사용)
                            }
                            currentPlaneIds.delete(planeId); // 현재 업데이트된 비행기 ID 목록에서 제거, 남은 ID는 더 이상 데이터에 없는 비행기
                        }
                    });
                } else {
                    console.error("API에서 'states' 데이터를 찾을 수 없습니다."); // API 응답에 states 속성이 없는 경우 에러 로그 출력
                }

                currentPlaneIds.forEach(function (planeId) { // 더 이상 데이터에 없는 비행기 마커 제거
                    map.removeLayer(markers[planeId]); // 지도에서 마커 제거
                    delete markers[planeId]; // markers 객체에서 마커 정보 삭제
                });
            } else {
                console.error("비행 데이터 가져오기 오류:", xhr.statusText); // HTTP 상태 코드가 200이 아닌 경우 에러 로그 출력 (API 요청 실패)
            }
        };
        xhr.onerror = function () { // 요청 실패 (네트워크 에러 등) 시 실행되는 콜백 함수
            console.error("요청 실패"); // 요청 실패 로그 출력
        };
        xhr.send(); // HTTP 요청 전송
    }


    // 지도 클릭 이벤트 처리 (기존 코드 유지)
    function updateTable(flightInfo) { // 비행 정보 테이블 업데이트 함수
        flightInfoTableBody.innerHTML = ''; // 테이블 내용 초기화 (기존 내용 삭제)
        for (const key in flightInfo) { // flightInfo 객체의 각 속성에 대해 반복 처리
            let row = flightInfoTableBody.insertRow(); // 테이블에 새로운 행(tr 요소) 추가
            let propertyCell = row.insertCell(); // 행에 새로운 셀(td 요소) 추가 (항목 이름 용도)
            let valueCell = row.insertCell(); // 행에 새로운 셀(td 요소) 추가 (항목 값 용도)

            // 항목을 한국어로 표시
            propertyCell.textContent = key; // 항목 이름 셀에 속성 이름(key) 표시 (예: "비행편명")
            valueCell.textContent = flightInfo[key]; // 항목 값 셀에 속성 값(value) 표시 (예: "KAL123")
        }
    }

    setInterval(fetchFlights, 5000); // 5000ms (5초)마다 fetchFlights 함수 반복 실행, 실시간 데이터 업데이트
    fetchFlights(); // 페이지 로딩 시 최초 1회 fetchFlights 함수 실행, 초기 데이터 로딩
</script>
</body>

</html>
