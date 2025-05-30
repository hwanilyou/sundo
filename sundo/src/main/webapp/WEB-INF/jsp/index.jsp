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

	 /* 아래쪽 고정된 순서 영역 */
      .selected-layer-panel {
        border-top: 1px solid #ccc;
        background: #fff;
        padding: 12px 16px;
        height: 300px;
      }
      
       /* 선택된 레이어 목록 스타일 */
      .selected-layer-list {
        list-style: none;
        padding: 0;
        margin: 0;
        background: #fff;
        border: 1px solid #ccc;
        border-radius: 6px;
        padding: 8px;
      }

      .selected-layer-list li {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #e3f2fd;
        padding: 6px 8px;
        margin-bottom: 6px;
        border-radius: 4px;
        font-size: 14px;
        color: #0d47a1;
      }

      .selected-layer-list li button {
        background: #bbdefb;
        border: none;
        padding: 4px 6px;
        margin-left: 4px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
      }

      .selected-layer-list li button:hover {
        background: #90caf9;
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
          /* 팝업 */
    .ol-popup { position:absolute; background:white; border:1px solid #ccc; border-radius:6px; padding:10px; box-shadow:0 2px 6px rgba(0,0,0,0.3); width:220px; z-index:1500; }
    .ol-popup a { position:absolute; top:2px; right:8px; text-decoration:none; color:#aaa; font-size:16px; }
    .ol-popup a:hover { color:#000; }
    .popup-table { width:100%; border-collapse:collapse; }
    .popup-table th, .popup-table td { padding:4px 6px; border-bottom:1px solid #eee; text-align:left; }
    .popup-table th { background:#f5f5f5; }

      
      #popup {
	  position: absolute;
	  pointer-events: auto;
	  user-select: none;
	  -webkit-user-select: none;
	  outline: none;
	}
      
      #popup-content {
          margin-top: 10px;
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
    <div id="map">
       <!-- 팝업 요소 추가 -->
      <div id="popup" class="ol-popup" style="display: none;">
          <a href="#" id="popup-closer" style="float:right;">✖</a>
          <div id="popup-content"></div>
      </div>
</div>

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
      <label><input type="checkbox" name="datalayer" value="weather"> 기상 데이터</label>
      <label><input type="checkbox" name="datalayer" value="dam"> 댐 데이터</label>
      <label><input type="checkbox" name="datalayer" value="fish"> 지표생물 데이터</label>
    </div>
  </div>

  <!-- 하단: 선택된 레이어 순서 -->
  <div class="selected-layer-panel">
    <div class="group-item" style="margin-bottom: 10px; cursor: default;">
      선택한 레이어 순서
    </div>
    <ul id="selectedLayerList" class="selected-layer-list">
      <!-- 동적으로 항목 추가됨 -->
    </ul>
  </div>
</div>


<!-- 범례 -->
<div id="legendBox" style="display:none; position:absolute; bottom:170px; right:10px; z-index:1100; background:white; border:1px solid #ccc; padding:10px; max-height:300px; overflow-y:auto;">
    <div id="legendContainer"></div>
</div>

</div>


<!-- 지도 스크립트 -->
<script>

//범례 추가/제거 함수
function addLegend(layerId, title) {
  const container = document.getElementById('legendContainer');
  if (document.getElementById('legend-' + layerId)) return;

  const item = document.createElement('div');
  item.id = 'legend-' + layerId;
  item.style.display = 'flex';
  item.style.alignItems = 'center';
  item.style.marginBottom = '5px';

  if (layerId === 'waterLayer') {
    // 이미지 대신 스타일 직접 표현 (기상 데이터 전용)
    const circle = document.createElement('div');
       circle.style.width = '15px';
       circle.style.height = '15px';
       circle.style.borderRadius = '50%';
       circle.style.backgroundColor = 'blue';
       circle.style.border = '2px solid white';
       circle.style.marginRight = '10px';

    const lbl = document.createElement('span');
    lbl.textContent = title;

    item.appendChild(circle);
    item.appendChild(lbl);
  }
  else if (layerId === 'bioLayer') {
       // 이미지 대신 스타일 직접 표현 (기상 데이터 전용)
       const circle = document.createElement('div');
       circle.style.width = '15px';
       circle.style.height = '15px';
       circle.style.borderRadius = '50%';
       circle.style.backgroundColor = 'brown';
       circle.style.border = '1px solid white';
       circle.style.marginRight = '10px';

       const lbl = document.createElement('span');
       lbl.textContent = title;

       item.appendChild(circle);
       item.appendChild(lbl);
     }
  else if (layerId === 'weather') {
       // 이미지 대신 스타일 직접 표현 (기상 데이터 전용)
       const circle = document.createElement('div');
       circle.style.width = '15px';
       circle.style.height = '15px';
       circle.style.borderRadius = '50%';
       circle.style.backgroundColor = 'skyblue';
       circle.style.border = '2px solid white';
       circle.style.marginRight = '10px';

       const lbl = document.createElement('span');
       lbl.textContent = title;

       item.appendChild(circle);
       item.appendChild(lbl);
     }
  else if (layerId === 'dam') {
      // 이미지 대신 스타일 직접 표현 (기상 데이터 전용)
      const circle = document.createElement('div');
      circle.style.width = '15px';
      circle.style.height = '15px';
      circle.style.borderRadius = '50%';
      circle.style.backgroundColor = 'gray';
      circle.style.border = '2px solid white';
      circle.style.marginRight = '10px';

      const lbl = document.createElement('span');
      lbl.textContent = title;

      item.appendChild(circle);
      item.appendChild(lbl);
    }
  else if (layerId === 'fishLayer') {
      // 이미지 대신 스타일 직접 표현 (기상 데이터 전용)
      const circle = document.createElement('div');
      circle.style.width = '15px';
      circle.style.height = '15px';
      circle.style.borderRadius = '50%';
      circle.style.backgroundColor = 'pink';
      circle.style.border = '1px solid white';
      circle.style.marginRight = '10px';

      const lbl = document.createElement('span');
      lbl.textContent = title;

      item.appendChild(circle);
      item.appendChild(lbl);
    }
  else {
    // WMS 범례 이미지
    const img = document.createElement('img');
    img.src = `http://localhost:8282/geoserver/sundo3/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&LAYER=${layerId}`;
    img.style.width = '30px';
    img.style.marginRight = '10px';

    const lbl = document.createElement('span');
    lbl.textContent = title;

    item.appendChild(img);
    item.appendChild(lbl);
  }

  container.appendChild(item);
  document.getElementById('legendBox').style.display = 'block';
}


function removeLegend(layerId) {
  const item = document.getElementById('legend-' + layerId);
  if (item) item.remove();
  if (!document.getElementById('legendContainer').children.length) {
    document.getElementById('legendBox').style.display = 'none'; // 범례 박스 숨김
  }
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


// 수질 데이터
const waterLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        format: new ol.format.GeoJSON(),
        url: extent => (
          'http://localhost:8282/geoserver/sundo3/ows?' +
          'service=WFS&version=2.0.0&request=GetFeature&' +
          'typeName=sundo3:water_data&outputFormat=application/json&' +
          'srsName=EPSG:3857&bbox=' + extent.join(',') + ',EPSG:3857'
        ),
        strategy: ol.loadingstrategy.bbox
      }),
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 5,
          fill: new ol.style.Fill({ color: 'blue' }),
          stroke: new ol.style.Stroke({ color: 'white', width: 1 })
        })
      }),
      visible: false
    });

// 생물 데이터
const bioLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      format: new ol.format.GeoJSON(),
      url: extent => (
        'http://localhost:8282/geoserver/sundo3/ows?' +
        'service=WFS&version=2.0.0&request=GetFeature&' +
        'typeName=sundo3:biological_monitoring&outputFormat=application/json&' +
        'srsName=EPSG:3857&bbox=' + extent.join(',') + ',EPSG:3857'
      ),
      strategy: ol.loadingstrategy.bbox
    }),
    style: new ol.style.Style({
      image: new ol.style.Circle({
        radius: 5,
        fill: new ol.style.Fill({ color: 'brown' }),
        stroke: new ol.style.Stroke({ color: 'white', width: 1 })
      })
    }),
    visible: false
  });

//지표생물 데이터
const fishLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        format: new ol.format.GeoJSON(),
        url: extent => (
          'http://localhost:8282/geoserver/sundo3/ows?' +
          'service=WFS&version=2.0.0&request=GetFeature&' +
          'typeName=sundo3:fish_data&outputFormat=application/json&' +
          'srsName=EPSG:3857&bbox=' + extent.join(',') + ',EPSG:3857'
        ),
        strategy: ol.loadingstrategy.bbox
      }),
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 5,
          fill: new ol.style.Fill({ color: 'pink' }),
          stroke: new ol.style.Stroke({ color: 'white', width: 1 })
        })
      }),
      visible: false
    });

const map = new ol.Map({
    target: 'map',
    layers: [
        osmLayer, landcoverLayer, ecoLayer,
        waterLayer, bioLayer, fishLayer
    ],
    view: new ol.View({
        center: ol.proj.fromLonLat([127.7669, 35.9078]),
        zoom: 8
    })
});

function logUserLayerAction(layerName, status = "성공") {
	  fetch('/api/user-log/save', {
	    method: 'POST', // ⬅️ 반드시 POST여야 합니다
	    headers: {
	      'Content-Type': 'application/x-www-form-urlencoded'
	    },
	    body: new URLSearchParams({
	      dataName: layerName,
	      logType: '수신',
	      status: status
	    })
	  })
	    .then(res => {
	      if (!res.ok) throw new Error("로그 저장 실패");
	      return res.json();
	    })
	    .then(data => {
	      console.log(`✅ 로그 저장 완료:`, data);
	    })
	    .catch(err => console.error("❌ 로그 전송 오류:", err));
	}

const selectedLayers = [];

function updateSelectedLayerListUI() {
    const ul = document.getElementById('selectedLayerList');
    ul.innerHTML = '';
    selectedLayers.forEach((layerId, index) => {
      const li = document.createElement('li');
      li.textContent = layerId === 'water' ? '수질 데이터'
                   : layerId === 'bio' ? '생물 데이터'
                   : layerId === 'weather' ? '기상 데이터'
                   : layerId === 'fish' ? '지표생물 데이터'	   
                   : '댐 데이터';

      // 위로 버튼
      const upBtn = document.createElement('button');
      upBtn.textContent = '↑';
      upBtn.disabled = index === 0;
      upBtn.onclick = () => {
        [selectedLayers[index - 1], selectedLayers[index]] = [selectedLayers[index], selectedLayers[index - 1]];
        updateSelectedLayerListUI();
        reorderMapLayers();
      };

      // 아래로 버튼
      const downBtn = document.createElement('button');
      downBtn.textContent = '↓';
      downBtn.disabled = index === selectedLayers.length - 1;
      downBtn.onclick = () => {
        [selectedLayers[index + 1], selectedLayers[index]] = [selectedLayers[index], selectedLayers[index + 1]];
        updateSelectedLayerListUI();
        reorderMapLayers();
      };

      li.appendChild(upBtn);
      li.appendChild(downBtn);
      ul.appendChild(li);
    });
  }


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

// 데이터 범례 연결
document.querySelectorAll('input[name="datalayer"]').forEach(function(checkbox) {
  checkbox.addEventListener('change', function () {
    const id = this.value;

    if (id === 'water') {
      waterLayer.setVisible(this.checked);
      this.checked ? addLegend('waterLayer', '수질 데이터') : removeLegend('waterLayer');
      if (this.checked) logUserLayerAction('수질 데이터');
    } else if (id === 'bio') {
      bioLayer.setVisible(this.checked);
      this.checked ? addLegend('bioLayer', '생물 데이터') : removeLegend('bioLayer');
      if (this.checked) logUserLayerAction('생물 데이터');
    } else if (id === 'weather') {
      weatherLayer.setVisible(this.checked);
      this.checked ? loadWeatherData() : weatherSource.clear();
      this.checked ? addLegend('weather', '기상 데이터') : removeLegend('weather');
      if (this.checked) logUserLayerAction('기상 데이터');
    } else if (id === 'dam') {
      damLayer.setVisible(this.checked);
      this.checked ? loadDamData() : damSource.clear();
      this.checked ? addLegend('dam', '댐 데이터') : removeLegend('dam');
      if (this.checked) logUserLayerAction('댐 데이터');
    } else if (id === 'fish') {
      fishLayer.setVisible(this.checked);
      this.checked ? addLegend('fishLayer', '지표생물 데이터') : removeLegend('fishLayer');
      if (this.checked) logUserLayerAction('지표생물 데이터');
    }

    // ✅ 이건 if~else 문 바깥에 있어야 합니다!
    if (this.checked) {
      if (!selectedLayers.includes(id)) selectedLayers.push(id);
    } else {
      const idx = selectedLayers.indexOf(id);
      if (idx !== -1) selectedLayers.splice(idx, 1);
    }

    updateSelectedLayerListUI();
    reorderMapLayers();
  });
});


//순서대로 맵에 레이어 재배치 (zIndex 설정)
function reorderMapLayers() {
  const layerMap = {
    water: waterLayer,
    bio: bioLayer,
    weather: weatherLayer,
    dam : damLayer,
    fish : fishLayer
  };

  selectedLayers.forEach((id, i) => {
    const layer = layerMap[id];
    if (layer) layer.setZIndex(100 - i);  // zIndex는 높은 숫자가 위
  });
}

const weatherSource = new ol.source.Vector();
const weatherLayer = new ol.layer.Vector({
    source: weatherSource,
    zIndex: 999,        // 다른 레이어 위로
    declutter: true     // 겹침 방지
    
});
map.addLayer(weatherLayer);
weatherLayer.setVisible(true);

const damSource = new ol.source.Vector();
const damLayer = new ol.layer.Vector({
    source: damSource,
    zIndex: 1001,        // 다른 레이어 위로
    declutter: true     // 겹침 방지
    
});
map.addLayer(damLayer);
damLayer.setVisible(true);

//팝업 오버레이 생성
const popup = new ol.Overlay({
    element: document.getElementById('popup'),
    positioning: 'bottom-center',
    offset: [0, -10],
    autoPan: false
});
map.addOverlay(popup);

document.getElementById('popup-closer').onclick = function () {
	event.preventDefault();
    document.getElementById('popup').style.display ='none';
    popup.setPosition(undefined);
    return false;
};

// 기상 데이터 좌표 로드
let stationCoords = {};
async function loadStationCoords() {
	const res = await fetch('/proxy/station-info');
    const txt = await res.text();
    txt.split('\n').filter(l=>!l.startsWith('#')).forEach(line=>{
    	const p = line.trim().split(/\s+/),
    		stn = p[0].padStart(3,'0'),
	        lon = parseFloat(p[1]),
	        lat = parseFloat(p[2]),
        	name = p[8];

        	if (!isNaN(lon) && !isNaN(lat)) {
        		stationCoords[stn] = { coord: [lon, lat], name };
            }
        	console.log('station name:', name);
    });
}

//기상 데이터 로드
async function loadWeatherData() {
    if (Object.keys(stationCoords).length === 0) {
        await loadStationCoords();
    }

    const res = await fetch('/proxy/weather-data');
    const txt = await res.text();

    weatherSource.clear();

    txt.split('\n').filter(l => !l.startsWith('#')).forEach(line => {
    	const p = line.trim().split(/\s+/),
    	stn = p[1].padStart(3,'0'),
        temp = p[8];
    	
    	if (temp === '-99.9' || isNaN(+temp)) return;
    	
    	const station = stationCoords[stn];
    	if (!station) return;

    	const coord = station.coord;
    	const name = station.name;

        const feature = new ol.Feature({
            geometry: new ol.geom.Point(ol.proj.fromLonLat(coord)),
            name: name,
            stn: stn,
            wd_1m: p[2],
            ws_1m: p[3],
            wds: p[4],
            wss: p[5],
            wd_10m: p[6],
            ws_10m: p[7],
            temp: p[8],
            re: p[9],
            rn_15: p[10],
            rn_60: p[11],
            rn_12h: p[12],
            rn_day: p[13],
            humidity: p[14],
            pa: p[15],
            ps: p[16],
            dew: p[17]
        });

        feature.setStyle(new ol.style.Style({
            image: new ol.style.Circle({
                radius: 5,
                fill: new ol.style.Fill({ color: 'skyblue' }),
                stroke: new ol.style.Stroke({ color: 'white', width: 1 })
            })
        }));

        weatherSource.addFeature(feature);
    });
}

// dam
function dmsToDecimal(dms) {
    // 공백 또는 - 로 구분된 도-분-초 문자열 → 소수점 좌표로 변환
    const parts = dms.trim().split(/[-\s]+/).map(Number);
    if (parts.length !== 3 || parts.some(isNaN)) return NaN;
    return parts[0] + parts[1] / 60 + parts[2] / 3600;
}

let damCoords = {};

async function loadDamCoords() {
    const res = await fetch('/proxy/dam_info');
    const data = await res.json();
    const filteredContent = data.content.filter(dam => dam !== null && dam !== undefined);

    filteredContent.forEach(dam => {
        if (!dam.dmobscd) {
            console.warn('dmobscd is missing in dam object, skipping...');
            return;
        }
        const lon = dmsToDecimal(dam.lon);
        const lat = dmsToDecimal(dam.lat);
        const name = dam.obsnm;

        if (!isNaN(lon) && !isNaN(lat)) {
            damCoords[dam.dmobscd] = {
                coord: [lon, lat],
                name: dam.obsnm,
                agency: dam.agcnm,
                address: dam.addr
            };
        }
    });
}

async function loadDamData() {
    if (Object.keys(damCoords).length === 0) {
        await loadDamCoords();
    }

    const res = await fetch('/proxy/dam_data');
    const data = await res.json();
    damSource.clear(); // VectorSource 객체

    data.content.forEach(dam => {
        const id = dam.dmobscd;
        const coordInfo = damCoords[id];
        if (!coordInfo) return;

        const coord = ol.proj.fromLonLat(coordInfo.coord);

        const feature = new ol.Feature({
            geometry: new ol.geom.Point(coord),
            obsnm: coordInfo.name,
            agcnm: coordInfo.agency,
            address: coordInfo.address,
            level: parseFloat(dam.swl),       // 수위
            inflow: parseFloat(dam.inf),      // 유입량
            outflow: parseFloat(dam.tototf),  // 방류량
            timestamp: dam.ymdhm
        });

        feature.setStyle(new ol.style.Style({
            image: new ol.style.Circle({
                radius: 6,
                fill: new ol.style.Fill({ color: 'gray' }),
                stroke: new ol.style.Stroke({ color: 'white', width: 1 })
            })
        }));

        damSource.addFeature(feature);
    });
}



map.on('singleclick', evt => {
    popup.setPosition(undefined);
    document.getElementById('popup').style.display='none';
	
    const hitW = map.forEachFeatureAtPixel(evt.pixel,(feature,layer)=>{
    	if (layer === weatherLayer) {
    		
            const p = feature.getProperties();
            const c = feature.getGeometry().getCoordinates();
      	document.getElementById('popup-content').innerHTML=`
          <table class="popup-table">
      		<tr><th>속성</th><th>값</th></tr>
      		<tr><td>지점명</td><td>\${p.name || '-'}</td></tr>
            <tr><td>온도</td><td>\${p.temp || '0'} °C</td></tr>
            <tr><td>풍속</td><td>\${p.ws_1m || '0'} m/s</td></tr>
            <tr><td>습도</td><td>\${p.humidity || '0'} %</td></tr>
            <tr><td>해면기압</td><td>\${p.ps || '0'} hPa</td></tr>
            <tr><td>현지기압</td><td>\${p.pa || '0'} hPa</td></tr>
            <tr><td>강수감지</td><td>\${p.re || '0'}</td></tr>
            <tr><td>15분 강수량</td><td>\${p.rn_15 || '0'} mm</td></tr>
            <tr><td>일 강수량</td><td>\${p.rn_day || '0'} mm</td></tr>
          </table>`;

      	popup.setPosition(c);
        document.getElementById('popup').style.display='block';
        return true;
      }
    });
    if(hitW) return;

    // 2) 수질
    const hitU = map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
    if (layer === waterLayer) {
      const p = feature.getProperties();
      const c = feature.getGeometry().getCoordinates();
      document.getElementById('popup-content').innerHTML = `
        <table class="popup-table">
            <tr><th>속성</th><th>값</th></tr>
            <tr><td>지점명</td><td>\${p.ptnm||'-'}</td></tr>
            <tr><td>DOC</td><td>\${p.itemDoc||'-'} mg/L</td></tr>
            <tr><td>BOD</td><td>\${p.itemBod||'-'} mg/L</td></tr>
            <tr><td>COD</td><td>\${p.itemCod||'-'} ppm</td></tr>
            <tr><td>SS</td><td>\${p.itemSs||'-'} mg/L</td></tr>
            <tr><td>Tn</td><td>\${p.itemTn||'-'} mg/L</td></tr>
            <tr><td>TP</td><td>\${p.itemTp||'-'} mg/L</td></tr>
            <tr><td>TOC</td><td>\${p.itemToc||'-'} mg/L</td></tr>
          </table>`;
        popup.setPosition(c);
        document.getElementById('popup').style.display='block';
        return true;
      }
    });
    if(hitU) return;
    
    // 3) 생물
    map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
      if (layer === bioLayer) {
        const p = feature.getProperties();
        const c = feature.getGeometry().getCoordinates();
        document.getElementById('popup-content').innerHTML = `
          <table class="popup-table">
            <tr><th>속성</th><th>값</th></tr>
            <tr><td>지점명</td><td>\${p.ptnm || '-'}</td></tr>
            <tr><td>학명</td><td>\${p.scientific || '-'}</td></tr>
            <tr><td>한글 이름</td><td>\${p.KoreanName || '-'}</td></tr>
            <tr><td>개체수</td><td>\${p.individual || '-'}</td></tr>
          </table>`;
        popup.setPosition(c);
        document.getElementById('popup').style.display = 'block';
        return true;
      }
    });
    
    // 2) 지표생물
   map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
    if (layer === fishLayer) {
      const p = feature.getProperties();
      const c = feature.getGeometry().getCoordinates();
      document.getElementById('popup-content').innerHTML = `
        <table class="popup-table">
            <tr><th>속성</th><th>값</th></tr>
            <tr><td>조사일</td><td>\${p.date||'-'}</td></tr>
            <tr><td>유역</td><td>\${p.basin||'-'}</td></tr>
            <tr><td>중권역</td><td>\${p.mid_watershed||'-'}</td></tr>
            <tr><td>조사정점명</td><td>\${p.site_name||'-'}</td></tr>
            <tr><td>학명</td><td>\${p.scientific_name||'-'}</td></tr>
            <tr><td>한글명</td><td>\${p.korean_name||'-'}</td></tr>
            <tr><td>세포밀도</td><td>\${p.cell_density_cm2||'-'}</td></tr>
            <tr><td>건강등급</td><td>\${p.health_grade||'-'}</td></tr>
            <tr><td>조사유형</td><td>\${p.survey_type||'-'}</td></tr>
          </table>`;
        popup.setPosition(c);
        document.getElementById('popup').style.display='block';
        return true;
      }
    });
    
    // 댐
    const hitD = map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
        if (layer === damLayer) {
        	const p = feature.getProperties();
        	console.log('[팝업 디버그] feature properties:', p);
            const c = feature.getGeometry().getCoordinates();

            document.getElementById('popup-content').innerHTML = `
              <table class="popup-table">
                <tr><th>속성</th><th>값</th></tr>
                <tr><td>댐 이름</td><td>\${p.obsnm || '-'}</td></tr>
                <tr><td>소속 기관</td><td>\${p.agcnm || '-'}</td></tr>
                <tr><td>수위</td><td>\${p.level || '-'} m</td></tr>
                <tr><td>유입량</td><td>\${p.inflow || '-'} m³/s</td></tr>
                <tr><td>방류량</td><td>\${p.outflow || '-'} m³/s</td></tr>
              </table>`;

            popup.setPosition(c);
            document.getElementById('popup').style.display = 'block';
            return true;
        }
    });
});




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
