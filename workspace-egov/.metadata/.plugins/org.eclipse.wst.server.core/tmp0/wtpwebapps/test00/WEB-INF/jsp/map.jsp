<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경 지도 (GeoServer 연동)</title>
    <script src="https://cdn.jsdelivr.net/npm/ol@latest/dist/ol.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.8.0/proj4.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
    <style>
        #map { width: 100%; height: 700px; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <h2 style="text-align:center;">환경 지도 (GeoServer 레이어: eco_map_seoul)</h2>
    <div id="map"></div>

    <script>
        // EPSG:5179 좌표계 정의
        proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs");
        ol.proj.proj4.register(proj4);

        const map = new ol.Map({
            target: 'map',
            layers: [
                // 1️⃣ 배경 지도 (OSM)
                new ol.layer.Tile({
                    source: new ol.source.OSM()
                }),
                // 2️⃣ GeoServer WMS 레이어
                new ol.layer.Image({
                    source: new ol.source.ImageWMS({
                        url: 'http://localhost:8282/geoserver/map/wms',  // 네임스페이스: map
                        params: {
                            'LAYERS': 'map:eco_map_seoul',            // 네임스페이스:레이어이름
                            'TILED': true
                        },
                        ratio: 1,
                        serverType: 'geoserver'
                    })
                })
            ],
            view: new ol.View({
                projection: 'EPSG:5179',
                center: [200000, 500000],  // 중심 좌표 (중부원점 기준)
                zoom: 7
            })
        });
    </script>
</body>
</html>
