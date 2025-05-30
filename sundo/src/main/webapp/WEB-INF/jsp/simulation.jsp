<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>환경물관리 통합정보 플랫폼 - 시뮬레이션</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- OpenLayers CSS -->
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
    #mapBefore, #mapAfter { height: 500px; border: 1px solid #ccc; }
    .sidebar { padding: 15px; border-right: 1px solid #ddd; }
    .data-output { margin-top: 20px; font-size: 14px; max-height: 240px; overflow-y: auto; border: 1px solid #ccc; padding: 10px; background: #f8f9fa; }
    .layer-item { display: flex; align-items: center; margin-bottom: 5px; }
    .layer-item .color-box { width: 12px; height: 12px; margin-right: 5px; }
    .layer-item input[type="checkbox"] { margin-right: 5px; }
    .layer-item button { background: none; border: none; cursor: pointer; font-size: 16px; margin-left: auto; }
  </style>
</head>
<body>
  <div class="top-header"><h2>환경물관리 통합정보 플랫폼</h2></div>
  <div class="menu-bar">
    <a href="/">지도</a>
    <a href="/list.do">목록</a>
    <a href="/simulation.do" class="active">시뮬레이션</a>
  </div>
  <div class="container-fluid mt-4">
    <h4 class="text-center mb-4 border-bottom pb-2">시뮬레이션 전·후 비교</h4>
    <div class="row">
      <div class="col-md-2 sidebar">
        <input type="file" id="shpZipInput" class="form-control mb-3" accept=".zip" multiple>
        <div class="data-output">
          <p><strong>레이어 관리:</strong></p>
          <ul id="layerList"><li>레이어가 업로드되면 목록에 표시됩니다.</li></ul>
        </div>
        <button class="btn btn-secondary w-100 mt-3" onclick="resetMap()">초기화</button>
      </div>
      <div class="col-md-5"><h6 class="text-center">시뮬레이션 전</h6><div id="mapBefore"></div></div>
      <div class="col-md-5"><h6 class="text-center">시뮬레이션 후</h6><div id="mapAfter"></div></div>
    </div>
  </div>

  <!-- Scripts -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/ol@latest/dist/ol.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script src="https://unpkg.com/shapefile@0.6.6/dist/shapefile.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.8.0/proj4.js"></script>
  <script>
    // 기본 설정
    const center = ol.proj.fromLonLat([127.7669, 35.9078]);
    const baseBefore = new ol.layer.Tile({ source: new ol.source.OSM(), zIndex: 0 });
    const baseAfter  = new ol.layer.Tile({ source: new ol.source.OSM(), zIndex: 0 });
    const viewBefore = new ol.View({ center, zoom: 10 });
    const viewAfter  = new ol.View({ center, zoom: 10 });
    const mapBefore  = new ol.Map({ target: 'mapBefore', layers: [baseBefore], view: viewBefore });
    const mapAfter   = new ol.Map({ target: 'mapAfter',  layers: [baseAfter],  view: viewAfter  });

    // 레이어 목록 및 색상
    const vectorLayers = [];
    const uploadColors = ['#e41a1c', '#4daf4a', '#984ea3'];

    // 맵 동기화
    function syncMaps(src, tgt) {
      let syncing = false;
      src.on(['change:center','change:resolution'], () => {
        if (syncing) return;
        syncing = true;
        tgt.setCenter(src.getCenter());
        tgt.setResolution(src.getResolution());
        syncing = false;
      });
    }
    syncMaps(viewBefore, viewAfter);

    // 사이드바 UI 업데이트
    function updateLayerListUI() {
      const ul = document.getElementById('layerList');
      ul.innerHTML = '';
      vectorLayers.forEach((layer, i) => {
        const li = document.createElement('li');
        li.className = 'layer-item';
        const chk = document.createElement('input');
        chk.type = 'checkbox'; chk.checked = true;
        chk.onchange = () => layer.setVisible(chk.checked);
        const cb = document.createElement('span');
        cb.className = 'color-box'; cb.style.backgroundColor = layer.get('color');
        const txt = document.createTextNode(layer.get('name'));
        const up = document.createElement('button');
        up.textContent = '▲'; up.disabled = (i === 0);
        up.onclick = () => moveLayer(i, i - 1);
        const down = document.createElement('button');
        down.textContent = '▼'; down.disabled = (i === vectorLayers.length - 1);
        down.onclick = () => moveLayer(i, i + 1);
        li.append(chk, cb, txt, up, down);
        ul.append(li);
      });
    }

    // 레이어 순서 이동 및 zIndex 재설정
    function moveLayer(from, to) {
      const layer = vectorLayers.splice(from, 1)[0];
      vectorLayers.splice(to, 0, layer);
      vectorLayers.forEach((l, idx) => l.setZIndex(vectorLayers.length - idx));
      updateLayerListUI();
    }

    // ZIP 파일 업로드 처리
    document.getElementById('shpZipInput').addEventListener('change', async e => {
      const files = Array.from(e.target.files);
      for (const file of files) {
        try {
          const zip = await JSZip.loadAsync(file);
          const buf = {};
          await Promise.all(Object.keys(zip.files).map(async name => {
            const ext = name.split('.').pop().toLowerCase();
            if (['shp','dbf','shx','cpg','prj'].includes(ext)) {
              buf[ext] = await zip.files[name].async('arraybuffer');
            }
          }));
          if (!buf.shp || !buf.dbf) {
            alert(`${file.name} 에 shp/dbf 파일이 필요합니다.`);
            continue;
          }

          // 좌표계 WKT 등록
          let dataCrs = 'EPSG:4326';
          if (buf.prj) {
            const wkt = new TextDecoder().decode(buf.prj);
            proj4.defs('SRC', wkt);
            ol.proj.proj4.register(proj4);
            dataCrs = 'SRC';
          }
          const opts = {};
          if (buf.shx) opts.shx = new Uint8Array(buf.shx);
          if (buf.cpg) opts.encoding = new TextDecoder().decode(buf.cpg).trim();

          // Shapefile 읽기
          const reader = await shapefile.open(buf.shp, buf.dbf, opts);
          const src = new ol.source.Vector();
          const color = uploadColors[vectorLayers.length % uploadColors.length];
          const [r, g, b] = color.match(/.{2}/g).map(h => parseInt(h, 16));
          const fillColor = `rgba(${r},${g},${b},0.3)`;

          // 스타일 함수
          const styleFun = feature => {
            const type = feature.getGeometry().getType();
            if (type.includes('Point')) {
              return new ol.style.Style({
                image: new ol.style.Circle({
                  radius: 6,
                  fill: new ol.style.Fill({ color }),
                  stroke: new ol.style.Stroke({ color: '#fff', width: 1 })
                })
              });
            }
            if (type.includes('LineString')) {
              return new ol.style.Style({ stroke: new ol.style.Stroke({ color, width: 3 }) });
            }
            if (type.includes('Polygon')) {
              return new ol.style.Style({
                stroke: new ol.style.Stroke({ color, width: 2 }),
                fill:   new ol.style.Fill({ color: fillColor })
              });
            }
            return new ol.style.Style();
          };

          // 레이어 생성 및 추가
          const layer = new ol.layer.Vector({ source: src, style: styleFun });
          layer.set('name', file.name);
          layer.set('color', color);
          vectorLayers.push(layer);
          mapAfter.addLayer(layer);

          // zIndex 역순 재설정 후 UI 업데이트
          vectorLayers.forEach((l, idx) => l.setZIndex(vectorLayers.length - idx));
          updateLayerListUI();

          // 피처 읽어오기
          const fmt = new ol.format.GeoJSON({ dataProjection: dataCrs, featureProjection: 'EPSG:3857' });
          let rec;
          while (!(rec = await reader.read()).done) {
            src.addFeature(fmt.readFeature(rec.value));
          }

          // 뷰 센터링
          const feats = src.getFeatures();
          if (feats.length) {
        	}
        } catch (err) {
          console.error(err);
          alert(`${file.name} 처리 중 오류가 발생했습니다.`);
        }
      }
    });

    // 초기화
    function resetMap() {
      vectorLayers.forEach(l => mapAfter.removeLayer(l));
      vectorLayers.length = 0;
      viewAfter.setCenter(center);
      viewAfter.setZoom(10);
      document.getElementById('shpZipInput').value = '';
      document.getElementById('layerList').innerHTML = '<li>레이어가 업로드되면 표시됩니다.</li>';
    }
  </script>
</body>
</html>
