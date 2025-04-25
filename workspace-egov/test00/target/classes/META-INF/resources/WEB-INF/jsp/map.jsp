<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경 지도 (GeoServer 연동, EPSG:5179)</title>
    <script src="https://cdn.jsdelivr.net/npm/ol@latest/dist/ol.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.8.0/proj4.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">
    <style>
        #map { width: 100%; height: 700px; border: 1px solid #ccc; }
        body { font-family: Arial, sans-serif; }
        h2 { text-align: center; margin-top: 20px; }
    </style>
</head>
<body>
<h2>환경 지도 (GeoServer 레이어: eco_map_seoul, EPSG:5179)</h2>
<div id="map"></div>

<script>
    // ✅ EPSG:5179 좌표계 정의
    proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=GRS80 +units=m +no_defs");
    ol.proj.proj4.register(proj4);

    const projection5179 = ol.proj.get('EPSG:5179');
    projection5179.setExtent([90112, 1192896, 1990673, 2761664]);  // ✅ 대한민국 전체 영역

    // ✅ 지도 생성
    const map = new ol.Map({
        target: 'map',
        layers: [
            // 🟢 배경지도 (OSM + wrapX 꺼줌)
            new ol.layer.Tile({
                source: new ol.source.OSM({
                    wrapX: false  // ✅ EPSG:5179에서는 반드시 wrapX 꺼야 됨!
                })
            }),
            // 🟠 GeoServer WMS 레이어
            new ol.layer.Image({
                source: new ol.source.ImageWMS({
                    url: 'http://localhost:8282/geoserver/map/wms',   // ✅ GeoServer WMS URL
                    params: {
                        'LAYERS': 'map:eco_map_seoul',                // ✅ namespace:layername
                        'TILED': true
                    },
                    ratio: 1,
                    serverType: 'geoserver'
                }),
                opacity: 0.7  // 🔥 투명도 조절
            })
        ],
        view: new ol.View({
            projection: 'EPSG:5179',                    // ✅ EPSG:5179 고정!
            center: [960000, 1950000],                  // ✅ 한국 중심 (중부원점)
            zoom: 7                                     // 🔍 적당한 줌 레벨
        })
    });

    // ✅ 마우스 좌표 보기 (옵션)
    map.on('pointermove', function (evt) {
        const coord = ol.proj.transform(evt.coordinate, 'EPSG:5179', 'EPSG:4326');  // 위경도 변환
        console.log('위도/경도:', coord);
    });
</script>
</body>
</html>
