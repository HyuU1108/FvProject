<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Flight Information</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 
<script>
    $(document).ready(function() {
        $.ajax({
            url: "/flightInfo", // 컨트롤러 URL
            data: { flightId: "KE1430" }, // 필요한 파라미터
            success: function(flightInfo) {
                // flightInfo 객체를 사용하여 화면에 정보 표시
                $("#flight").text(flightInfo.flight);
                $("#icao24").text(flightInfo.id);
                $("#latitude").text(flightInfo.latitude);
                // ... 나머지 정보도 동일한 방식으로 표시
            }
        });
    });
</script>
</head>
<body>
    <h1><span id="flight"></span></h1>
    <p>
        <span id="icao24"></span>
    </p>
    <table>
        <tr>
            <th>Latitude</th>
            <td><span id="latitude"></span></td>
        </tr>
        <tr>
            <th>Longitude</th>
            <td><span id="longitude"></span></td>
        </tr>
        </table>
</body>
</html>