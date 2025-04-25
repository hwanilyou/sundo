<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경물관리 센서 지도</title>

    <!-- Proj4: EPSG:5186 좌표계를 정의하기 위해 필요 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.8.0/proj4.js"></script>
    

    <!-- OpenLayers core -->
    <script src="https://cdn.jsdelivr.net/npm/ol@latest/dist/ol.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">

    <style>
        #map {
            width: 100%;
            height: 600px;
            margin: 20px auto;
            border: 1px solid #ccc;
        }
        h2 {
            text-align: center;
        }
        .controls {
            text-align: center;
            margin-bottom: 10px;
        }
        button {
            margin: 5px;
            padding: 8px 12px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <h2>📍 환경물관리 센서 위치 지도</h2>

    <!-- 레이어 토글 버튼 영역 -->
    <div class="controls">
        <button onclick="sensorLayer.setVisible(!sensorLayer.getVisible())">🟢 센서 위치 ON/OFF</button>
        <button onclick="landcoverLayer.setVisible(!landcoverLayer.getVisible())">🟤 토지피복도 ON/OFF</button>
        <button onclick="test1Layer.setVisible(!test1Layer.getVisible())">🟣 test1 레이어 ON/OFF</button>
    </div>

    <!-- 지도 표시 영역 -->
    <div id="map"></div>

    <script>
        // ✅ EPSG:5186 좌표계 등록 (GeoServer 레이어와 동일해야 함)
        proj4.defs("EPSG:5186", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs");
        ol.proj.proj4.register(proj4);

        // ✅ 기본 배경지도(OpenStreetMap) - EPSG:5186에서도 사용 가능
        const baseLayer = new ol.layer.Tile({
            source: new ol.source.OSM()
        });

        // ✅ 센서 레이어 (WMS) - GeoServer에 등록된 레이어 이름 사용
        const sensorLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                url: 'http://localhost:8282/geoserver/project/wms',
                params: {
                    'LAYERS': 'project:sensor_points',
                    'TILED': false,
                    'SRS': 'EPSG:5186'
                },
                ratio: 1,
                serverType: 'geoserver',
                crossOrigin: 'anonymous'
            }),
            visible: true
        });

        // ✅ 토지피복도 레이어
        const landcoverLayer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                url: 'http://localhost:8282/geoserver/project/wms',
                params: {
                    'LAYERS': 'project:landcover_2024',
                    'TILED': true,
                    'SRS': 'EPSG:5186'
                },
                ratio: 1,
                serverType: 'geoserver',
                crossOrigin: 'anonymous'
            }),
            visible: true
        });

        // ✅ test1 레이어
        const test1Layer = new ol.layer.Image({
            source: new ol.source.ImageWMS({
                url: 'http://localhost:8282/geoserver/project/wms',
                params: {
                    'LAYERS': 'project:test1',
                    'TILED': true,
                    'SRS': 'EPSG:5186'
                },
                ratio: 1,
                serverType: 'geoserver',
                crossOrigin: 'anonymous'
            }),
            visible: true
        });

        // ✅ 지도 생성 (EPSG:5186 좌표계, 서울 기준 중심 좌표)
        const map = new ol.Map({
            target: 'map',
            layers: [
                baseLayer,         // 배경지도
                sensorLayer,       // 센서 위치
                landcoverLayer,    // 토지피복도
                test1Layer         // 테스트용 레이어
            ],
            view: new ol.View({
                projection: 'EPSG:5186',
                center: [200000, 550000], // EPSG:5186 기준 중심 좌표
                zoom: 8
            })
        });
    </script>
</body>
</html>
