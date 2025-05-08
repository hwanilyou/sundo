<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageMenu", "simulation");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경물관리 통합정보 플랫폼 - 시뮬레이션</title>

    <!-- Bootstrap & OpenLayers CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">

    <style>
        .top-header {
            background: #1E88E5;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .top-header h2 { margin: 0; font-size: 24px; }
        .menu-bar {
            background-color: #f8f9fa;
            padding: 10px 0;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        .menu-bar a {
            color: #1E88E5;
            text-decoration: none;
            margin: 0 20px;
            font-size: 18px;
            font-weight: bold;
            padding-bottom: 5px;
            border-bottom: 3px solid transparent;
        }
        .menu-bar a.active { border-bottom: 3px solid #1E88E5; }
        .menu-bar a:hover { text-decoration: underline; }
        #mapBefore, #mapAfter {
            height: 500px;
            border: 1px solid #ccc;
        }
        .sidebar {
            padding: 15px;
            border-right: 1px solid #ddd;
        }
        .data-output {
            margin-top: 20px;
            font-size: 14px;
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
            background: #f8f9fa;
        }
    </style>
</head>
<body>
<div class="top-header">
    <h2>환경물관리 통합정보 플랫폼</h2>
</div>

<div class="menu-bar">
    <a href="/">지도</a>
    <a href="/list.do">목록</a>
    <a href="/simulation.do" class="active">시뮬레이션</a>
</div>

<div class="container-fluid mt-4">
    <h4 class="text-center mb-4 border-bottom pb-2">시뮬레이션 전·후 비교</h4>
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 sidebar">
            <input type="file" id="shpInput" multiple class="form-control mb-3" accept=".shp,.dbf">
            <div class="data-output" id="shpData">
                <p><strong>속성 정보:</strong></p>
                <ul id="attributeList">
                    <li>파일 업로드 시 속성 정보가 존경됩니다.</li>
                </ul>
            </div>
            <button class="btn btn-secondary w-100 mt-3" onclick="resetMap()">초기화</button>
        </div>

        <!-- Before Map -->
        <div class="col-md-5">
            <h6 class="text-center">시뮬레이션 전</h6>
            <div id="mapBefore"></div>
        </div>

        <!-- After Map -->
        <div class="col-md-5">
            <h6 class="text-center">시뮬레이션 후</h6>
            <div id="mapAfter"></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/ol@latest/dist/ol.js"></script>
<script src="https://unpkg.com/shapefile@0.6.6/dist/shapefile.js"></script>

<script>
    const center = ol.proj.fromLonLat([127.7669, 35.9078]);

    const baseLayerBefore = new ol.layer.Tile({ source: new ol.source.OSM() });
    const baseLayerAfter = new ol.layer.Tile({ source: new ol.source.OSM() });

    const mapBefore = new ol.Map({
        target: 'mapBefore',
        layers: [baseLayerBefore],
        view: new ol.View({ center: center, zoom: 12 })
    });

    const vectorSource = new ol.source.Vector();
    const vectorLayer = new ol.layer.Vector({ source: vectorSource });

    const mapAfter = new ol.Map({
        target: 'mapAfter',
        layers: [baseLayerAfter, vectorLayer],
        view: new ol.View({ center: center, zoom: 12 })
    });

    document.getElementById('shpInput').addEventListener('change', async function (e) {
        const files = e.target.files;
        const shpFile = [...files].find(f => f.name.endsWith('.shp'));
        const dbfFile = [...files].find(f => f.name.endsWith('.dbf'));

        if (!shpFile || !dbfFile) {
            alert('SHP와 DBF 파일을 모두 선택해야 합니다.');
            return;
        }

        try {
            const shpBuffer = await shpFile.arrayBuffer();
            const dbfBuffer = await dbfFile.arrayBuffer();
            vectorSource.clear();

            const sourceIter = await shapefile.open(shpBuffer, dbfBuffer);
            const attrList = document.getElementById('attributeList');
            attrList.innerHTML = '';

            const readNext = async () => {
                const result = await sourceIter.read();
                if (result.done) return;

                const geojson = result.value;
                console.log("GeoJSON:", geojson);
                const feature = new ol.format.GeoJSON().readFeature(geojson, {
                    featureProjection: 'EPSG:3857'
                });
                vectorSource.addFeature(feature);

                const props = geojson.properties || {};
                if (Object.keys(props).length === 0) {
                    attrList.innerHTML = '<li>속성 정보 없음</li>';
                } else {
                    for (const key in props) {
                        const li = document.createElement('li');
                        li.textContent = key + ": " + (props[key] !== undefined ? props[key] : '-');
                        attrList.appendChild(li);
                    }
                }
                await readNext();
            };
            await readNext();

        } catch (err) {
            console.error("에러:", err);
            alert("파일 업로드 중 오류가 발생했습니다.");
        }
    });

    function resetMap() {
        vectorSource.clear();
        document.getElementById('attributeList').innerHTML = '<li>초기화 됩니다.</li>';
    }
</script>
</body>
</html>