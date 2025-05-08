<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경물관리 지도</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- OpenLayers -->
    <script src="https://cdn.jsdelivr.net/npm/ol@latest/dist/ol.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@latest/ol.css">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
        }
        .top-header {
            background: #1E88E5;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .top-header h2 {
            margin: 0;
            font-size: 24px;
        }
        .top-header a {
            color: white;
            text-decoration: none;
            margin-left: 15px;
            font-size: 16px;
        }
        .top-header a:hover {
            text-decoration: underline;
        }
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
        .menu-bar a.active {
            border-bottom: 3px solid #1E88E5;
        }
        .menu-bar a:hover {
            text-decoration: underline;
        }
        .ol-zoom {
         top: 10px;
         right: 10px;
         left: auto !important;
      }
        .map-container {
            position: relative;
            width: 100%;
            height: calc(100vh - 107px);
            overflow: hidden;
        }
        #map {
            width: 100%;
            height: 100%;
        }
     .layer-panel-full {
          position: absolute;
          top: 0;
          left: 0;
          width: 260px;
          height: 100%;
          background: #f9f9f9;
          border-right: 1px solid #ccc;
          box-shadow: 2px 0 6px rgba(0, 0, 0, 0.1);
          z-index: 1000;
          display: flex;
          flex-direction: column;
          font-family: 'Noto Sans KR', sans-serif;
      }
      
      .layer-group {
          flex: 1;
          overflow-y: auto;
          padding: 20px;
          background: #f9f9f9;
      }
      
      .group-item {
          padding: 10px 15px;
          background: #e3f2fd;
          color: #0d47a1;
          font-weight: bold;
          border-radius: 6px;
          margin-bottom: 5px;
          cursor: pointer;
          transition: background 0.2s;
      }
      
      .group-item:hover {
          background: #bbdefb;
      }

      .layer-list {
          display: none;
          flex-direction: column !important;
          align-items: flex-start;
          gap: 6px;
      }
      .layer-list label {
          display: block !important;
          width: 100%;
      }

  .layer-entry {
    padding: 6px 0;
    font-size: 14px;
  }
        .layer-switcher {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 220px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            padding: 10px;
            z-index: 1000;
        }
        .layer-switcher h6 {
            font-size: 16px;
            margin: 0 0 10px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .layer-switcher label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            cursor: pointer;
        }
        .collapse-content {
            margin-top: 10px;
        }
        
       
      .tooltip-measure {
          position: absolute;
          background: rgba(0, 0, 0, 0.7);
          color: white;
          padding: 4px 8px;
          border-radius: 4px;
          font-size: 12px;
          white-space: nowrap;
          border: 1px solid white;
      }

      .ol-overviewmap {
          position: absolute !important;
          bottom: 10px !important;
          right: 10px !important;
          left: auto !important;
          top: auto !important;
          display: block !important;
          width: 150px !important;
          height: 150px !important;
          background: white;
          z-index: 1100 !important;
      }
      
      .ol-scale-line {
          position: absolute !important;
          right: 170px !important;
          bottom: 10px !important;
          left: auto !important;
          z-index: 1100 !important;
          background-color: rgba(255,255,255,0.8) !important;
          padding: 4px 8px !important;
          border: 1px solid #ccc !important;
          border-radius: 4px !important;
      }
      
    </style>
</head>
<body>

<!-- 상단 헤더 -->
<div class="top-header">
    <h2>환경물관리 통합정보 플랫폼</h2>
</div>

<!-- 중앙 메뉴 -->
<div class="menu-bar">
    <a href="/map.do" class="active">지도</a>
    <a href="/list.do">목록</a>
    <a href="/simulation.do">시뮬레이션</a>
</div>

<!-- 지도 및 레이어 -->
<div class="map-container">
    <div id="map"></div>

    <!-- 좌측 레이어 패널 (탭 및 그룹 박스) -->
<div class="layer-panel-full">
  <div class="layer-group">

    <div class="group-item" onclick="toggleLayerList('group1')">
     지도 선택 <span class="toggle-icon">▼</span>
   </div>
   <div class="layer-list" id="group1">
     <label><input type="radio" name="basemap" value="none" checked> 없음</label>
     <label><input type="radio" name="basemap" value="landcover"> 토지피복도</label>
     <label><input type="radio" name="basemap" value="eco"> 생태자연도</label>
   </div>

    <div class="group-item" onclick="toggleLayerList('group2')">
      표시 데이터 선택 <span class="toggle-icon">▼</span>
    </div>
    <div class="layer-list" id="group2">
      <label><input type="checkbox" name="datalayer" value="water"> 수질 데이터</label>
      <label><input type="checkbox" name="datalayer" value="bio"> 생물 데이터</label>
    </div>
</div>
</div>

<!-- 범례 -->
<div id="legendBox" style="display:none; position:absolute; bottom:170px; right:10px; z-index:1100; background:white; border:1px solid #ccc; padding:10px;">
    <img id="legendImage" src="" alt="범례 이미지" style="max-width: 200px;">
</div>

<!-- 측정 -->
<div style="position:absolute; top:130px; right:10px; z-index:1100; padding:10px;">
    <button id="measure-distance" class="btn btn-sm btn-outline-primary mb-1">거리 측정</button><br>
    <button id="measure-area" class="btn btn-sm btn-outline-success">면적 측정</button>
</div>
    
</div>

<!-- 지도 스크립트 -->
<script>

function showLegend(layerName) {
    const legendBox = document.getElementById('legendBox');
    const legendImage = document.getElementById('legendImage');
    legendImage.src = `http://localhost:8282/geoserver/sundo3/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&LAYER=${layerName}`;
    legendBox.style.display = 'block';
}
function hideLegend() {
    document.getElementById('legendBox').style.display = 'none';
}

// 지도 레이어
const osmLayer = new ol.layer.Tile({
    source: new ol.source.OSM(),
    visible: true
});
const landcoverLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        url: 'https://egisapp.me.go.kr/geoserver/gwc/service/wms?',
        params: {
            'LAYERS': 'EGIS:lv3_2024y',
            'TILED': true,
            'SRS': 'EPSG:3857'
        },
        serverType: 'geoserver',
        transition: 0
    }),
    visible: false
});

const ecoLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
       url: 'http://egisapp.me.go.kr/geoserver/gwc/service/wms?',
        params: {
          'LAYERS': 'EGIS:eco_2015_g',
          'TILED': true,
          'SRS': 'EPSG:3857'
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false

});

// 데이터 레이어 (수질만)
const waterLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        url: 'http://localhost:8282/geoserver/sundo3/wms',
        params: { 'LAYERS': 'sundo3:water_data', 'TILED': true },
        serverType: 'geoserver'
    }),
    visible: false
});

const bioLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
        url: 'http://localhost:8282/geoserver/sundo3/wms',
        params: { 'LAYERS': 'sundo3:biological_monitoring', 'TILED': true },
        serverType: 'geoserver'
    }),
    visible: false
});

const map = new ol.Map({
    target: 'map',
    layers: [
        osmLayer, landcoverLayer, ecoLayer,
        waterLayer, bioLayer
    ],
    view: new ol.View({
        center: ol.proj.fromLonLat([127.7669, 35.9078]),
        zoom: 7
    })
});

// 지도 선택
document.querySelectorAll('input[name="basemap"]').forEach(function(radio) {
    radio.addEventListener('change', function () {
        const value = this.value;
        landcoverLayer.setVisible(value === 'landcover');
        ecoLayer.setVisible(value === 'eco');
        // OSM 기본 지도는 항상 보이게 유지
        osmLayer.setVisible(true);
    });
});

// 수질 데이터 범례 연결
document.querySelectorAll('input[name="datalayer"]').forEach(function(checkbox) {
    checkbox.addEventListener('change', function() {
        if (this.value === 'water') {
            waterLayer.setVisible(this.checked);
            this.checked ? showLegend('sundo3:water_data') : hideLegend();
        }
        else if (this.value === 'bio') {
            bioLayer.setVisible(this.checked);
            this.checked ? showLegend('sundo3:biological_monitoring') : hideLegend();
        }
    });
});

let draw; // 현재 draw interaction
const source = new ol.source.Vector();
const vector = new ol.layer.Vector({
    source: source,
    style: new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: '#ffcc33',
            width: 2
        }),
        fill: new ol.style.Fill({
            color: 'rgba(255, 204, 51, 0.2)'
        })
    })
});
map.addLayer(vector);


// 측정 결과 표시용 툴팁
let tooltipElement;
let tooltipOverlay;

// 툴팁 생성
function createTooltip() {
    if (tooltipElement) tooltipElement.remove();
    tooltipElement = document.createElement('div');
    tooltipElement.className = 'tooltip tooltip-measure';
    tooltipOverlay = new ol.Overlay({
        element: tooltipElement,
        offset: [0, -15],
        positioning: 'bottom-center'
    });
    map.addOverlay(tooltipOverlay);
}

//거리/면적 측정 시작
function addInteraction(type) {
        draw = new ol.interaction.Draw({ source: source, type: type });
        map.addInteraction(draw);
        createTooltip();

        const wgs84Sphere = new ol.Sphere(6378137);

        draw.on('drawstart', function (evt) {
            const sketch = evt.feature;
            sketch.getGeometry().on('change', function (e) {
                const geom = e.target;
                let output;
                if (geom instanceof ol.geom.Polygon) {
                    const coords = geom.getLinearRing(0).getCoordinates();
                    const area = wgs84Sphere.geodesicArea(coords.map(c => ol.proj.toLonLat(c)));
                    output = (area / 1000000).toFixed(2) + ' km²';
                } else if (geom instanceof ol.geom.LineString) {
                    const coords = geom.getCoordinates();
                    let length = 0;
                    for (let i = 0; i < coords.length - 1; i++) {
                        const c1 = ol.proj.toLonLat(coords[i]);
                        const c2 = ol.proj.toLonLat(coords[i + 1]);
                        length += wgs84Sphere.haversineDistance(c1, c2);
                    }
                    output = (length / 1000).toFixed(2) + ' km';
                }
                tooltipElement.innerHTML = output;
                tooltipOverlay.setPosition(geom.getLastCoordinate());
            });
        });
        
    draw.on('drawend', function () {
        // 툴팁 고정
        tooltipElement.className = 'tooltip-measure tooltip-static';
        tooltipOverlay.setOffset([0, -7]);
        tooltipElement = null; // 다음 측정용으로 초기화
        map.removeInteraction(draw);
    });
}

// 버튼 클릭 이벤트
document.getElementById('measure-distance').onclick = () => {
    map.removeInteraction(draw);
    addInteraction('LineString');
};
document.getElementById('measure-area').onclick = () => {
    map.removeInteraction(draw);
    addInteraction('Polygon');
};


function toggleLayerList(id) {
     const list = document.getElementById(id);
     if (!list) return;
     const isVisible = list.style.display === 'block';
     list.style.display = isVisible ? 'none' : 'block';
   }

const overviewMapControl = new ol.control.OverviewMap({
    layers: [
        new ol.layer.Tile({ source: new ol.source.OSM() })
    ],
    collapsed: false,
    minRatio: 4,  // 기본값은 8, 숫자를 줄이면 더 확대됨
    maxRatio: 16  // 필요시 조절

});
map.addControl(overviewMapControl);

const scaleLineControl = new ol.control.ScaleLine({
   units: 'metric', // 또는 'degrees', 'imperial'
   bar: true,       // 막대 형태
   text: true,
   minWidth: 120
});
map.addControl(scaleLineControl);
      
map.once('postrender', () => {
     const scaleLine = document.querySelector('.ol-scale-line');
     const scaleBar = document.querySelector('.ol-scale-bar');
     
     if (scaleLine) {
       scaleLine.style.left = 'auto';
       scaleLine.style.right = '170px';
       scaleLine.style.bottom = '10px';
       scaleLine.style.zIndex = '1100';
       scaleLine.style.backgroundColor = 'rgba(255,255,255,0.8)';
       scaleLine.style.padding = '4px 8px';
       scaleLine.style.border = '1px solid #ccc';
       scaleLine.style.borderRadius = '4px';
     }
     if (scaleBar) {
           scaleBar.style.left = 'auto';
           scaleBar.style.right = '170px';
       }
   });      
      
   
</script>

</body>
</html>
