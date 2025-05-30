<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경물관리 통합정보 플랫폼 - 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .pagination .page-item.active .page-link {
            background-color: #1E88E5;
            border-color: #1E88E5;
            color: white;
        }
        .pagination .page-link { color: #1E88E5; }
    </style>
</head>
<body>
<div class="top-header">
    <h2>환경물관리 통합정보 플랫폼</h2>

</div>
<div class="menu-bar">
    <a href="/">지도</a>
    <a href="/list.do" class="active">목록</a>
    <a href="/simulation.do">시뮬레이션</a>
</div>
<div class="container mt-4">
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-light"><strong>검색 조건</strong></div>
        <form method="get" action="/list.do">
        <div class="card-body">
            <div class="mb-3">
                <label class="form-label d-block">검색 데이터:</label>
                <c:forEach var="cat" items="${categoryList}">
                    <div class="form-check form-check-inline">
                        <input type="radio" name="dataType" value="${cat}"
                               <c:if test="${cat eq selectedDataType}">checked</c:if> 
                               onclick="resetSearchConditions()"/>
                        <label class="form-check-label">${cat}</label>
                    </div>
                </c:forEach>
            </div>
            <div class="row mb-1">
                <div class="col-md-auto"><label class="form-label">시작기간:</label></div>
                <div class="col-md-2">
                    <input type="date" class="form-control" name="startDate" value="${selectedStartDate}">
                </div>
                <div class="col-md-auto"><label class="form-label">종료기간:</label></div>
                <div class="col-md-2">
                    <input type="date" class="form-control" name="endDate" value="${selectedEndDate}">
                </div>
            </div>
            
            <div class="row mb-3 align-items-end">
             <div class="col d-flex align-items-center">
                 <label class="form-label me-2 mb-0">테이블 선택:</label>
                 <select class="form-select me-2" name="tableName" id="tableSelect" style="width: 40%;">
                     <option disabled <c:if test="${empty selectedTable}">selected</c:if>>테이블을 선택하세요</option>
                     <c:forEach var="t" items="${tableList}">
                         <option value="${t}" <c:if test="${t eq selectedTable}">selected</c:if>>${t}</option>
                     </c:forEach>
                 </select>
                 <button type="submit" class="btn btn-primary px-3 rounded-0">검색</button>
         
                 <button type="button" class="btn btn-outline-secondary px-3 ms-2 rounded-0" onclick="openLocationModal()">행정구역 검색</button>
             </div>
         </div>
            
            
            

            <!-- 행정구역 검색 모달 -->
         <div class="modal fade" id="locationModal" tabindex="-1" aria-labelledby="locationModalLabel" aria-hidden="true">
           <div class="modal-dialog modal-lg">
             <div class="modal-content">
               <div class="modal-header">
                 <h5 class="modal-title">행정구역 기반 지점 검색</h5>
                 <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
               </div>
               <div class="modal-body">
                 <div class="mb-3">
                   <label>기관 선택</label>
                   <select id="organizationSelect" class="form-select" onchange="loadInitialOptions()">
                     <option value="">기관 선택</option>
                     <option value="기상청">기상청</option>
                     <option value="환경부">환경부</option>
                   </select>
                 </div>
         
                 <div id="searchOptions">
                   <!-- 선택 옵션들(stn, 권역 등)이 여기에 삽입됩니다 -->
                 </div>
               </div>
               <div class="modal-footer">
                 <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                 <button type="button" class="btn btn-primary" id="applySelectionBtn" onclick="applySelectedLocation()">선택 적용</button>
               </div>
             </div>
           </div>
         </div>
        </form>
    </div>
    <div class="card-header bg-light"><strong>검색 결과</strong></div>
   <div class="card-body p-0" style="max-height: 600px; overflow-y: auto;">
       <div style="overflow-x: auto;">
           <table class="table table-bordered text-center mb-0" style="min-width: 1200px;">
         <thead>
<tr>
    <c:forEach var="col" items="${columns}">
        <th>
            <c:choose>
                <c:when test="${not empty columnLabelMap[col]}">
                    ${columnLabelMap[col]}
                </c:when>
                <c:otherwise>
                    ${col}
                </c:otherwise>
            </c:choose>
        </th>
    </c:forEach>
</tr>
</thead>
         <tbody>
             <c:forEach var="row" items="${list}">
                 <tr>
                     <c:forEach var="col" items="${columns}">
                         <td>${row[col]}</td>
                         
                     </c:forEach>
                 </tr>
             </c:forEach>
         </tbody>


        <c:if test="${totalPages > 1}">
            <div class="card-footer">
                <nav aria-label="페이지네이션">
                    <ul class="pagination justify-content-center mb-0 mt-3">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?dataType=${selectedDataType}&tableName=${selectedTable}&startDate=${selectedStartDate}&endDate=${selectedEndDate}&location=${selectedLocation}&page=${currentPage - 1}">이전</a>
                        </li>
                        <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}"/>
                        <c:set var="endPage" value="${startPage + 4 <= totalPages ? startPage + 4 : totalPages}"/>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?dataType=${selectedDataType}&tableName=${selectedTable}&startDate=${selectedStartDate}&endDate=${selectedEndDate}&location=${selectedLocation}&page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?dataType=${selectedDataType}&tableName=${selectedTable}&startDate=${selectedStartDate}&endDate=${selectedEndDate}&location=${selectedLocation}&page=${currentPage + 1}">다음</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function openLocationModal() {
    const modal = new bootstrap.Modal(document.getElementById("locationModal"));
    modal.show();
}

// 초기 옵션 로드
function loadInitialOptions() {
    const organization = document.getElementById("organizationSelect").value;
    const container = document.getElementById("searchOptions");
    container.innerHTML = '';  // 기존 내용 초기화

    if (organization === '기상청') {
        fetch('/api/station/list-by-organization?organization=기상청')
            .then(res => res.json())
            .then(data => {
                // station_cido 값 중 NULL인 값은 필터링
                const uniqueCidoNames = [...new Set(data.map(st => st.station_cido).filter(cido => cido !== null))]; // null 값 제외

                const selectCido = document.createElement("select");
                selectCido.id = "stationCidoSelect";
                selectCido.className = "form-select";
                const defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.textContent = "행정 구역 선택";
                selectCido.appendChild(defaultOption);

                uniqueCidoNames.forEach(cido => {
                    const option = document.createElement("option");
                    option.value = cido;
                    option.textContent = cido;
                    selectCido.appendChild(option);
                });

                const labelCido = document.createElement("label");
                labelCido.textContent = "행정 구역 선택";

                const stationDiv = document.createElement("div");
                stationDiv.id = "stationCheckboxList";
                stationDiv.classList.add("mt-2");

                // 기존 드롭다운을 제거하지 않고 새로운 선택 항목을 추가
                container.appendChild(labelCido);
                container.appendChild(selectCido);
                container.appendChild(stationDiv);

                // station_cido 선택 시 해당 station_name들을 로드하도록 이벤트 추가
                selectCido.addEventListener("change", function() {
                    loadStationNamesByCido(this.value, data);
                });
            })
            .catch(error => {
                console.error("❌ 기상청 API 호출 중 오류 발생:", error);
            });
    } else if (organization === '환경부') {
        fetch('/api/station/list-by-organization?organization=환경부')
            .then(res => res.json())
            .then(data => {
                const uniqueNames = [...new Set(data.map(b => {
                    return typeof b === 'string' ? b.trim() : (b.first_basin || '').trim();
                }).filter(Boolean))];

                const select = document.createElement("select");
                select.id = "firstBasinSelect";
                select.className = "form-select";

                const defaultOption = document.createElement("option");
                defaultOption.value = "";
                defaultOption.textContent = "권역 선택";
                select.appendChild(defaultOption);

                uniqueNames.forEach(name => {
                    const opt = document.createElement("option");
                    opt.value = name;
                    opt.textContent = name;
                    select.appendChild(opt);
                });

                const label = document.createElement("label");
                label.textContent = "권역 선택";

                const label2 = document.createElement("label");
                label2.classList.add("mt-2");
                label2.textContent = "대권역 선택";

                const majorSelect = document.createElement("select");
                majorSelect.id = "majorBasinSelect";
                majorSelect.className = "form-select";
                majorSelect.innerHTML = '<option value="">대권역 선택</option>';

                const label3 = document.createElement("label");
                label3.classList.add("mt-2");
                label3.textContent = "중권역 선택";

                const midSelect = document.createElement("select");
                midSelect.id = "midBasinSelect";
                midSelect.className = "form-select";
                midSelect.innerHTML = '<option value="">중권역 선택</option>';

                const stationDiv = document.createElement("div");
                stationDiv.id = "stationCheckboxList";
                stationDiv.classList.add("mt-2");

                container.appendChild(label);
                container.appendChild(select);
                container.appendChild(label2);
                container.appendChild(majorSelect);
                container.appendChild(label3);
                container.appendChild(midSelect);
                container.appendChild(stationDiv);

                // 이벤트 바인딩
                select.addEventListener("change", loadMajorBasins); // 'change' 이벤트 바인딩
                majorSelect.addEventListener("change", loadMidBasins);
                midSelect.addEventListener("change", loadStationsByMid);
            });
    }
}

// 권역 선택 시 이벤트
function loadMajorBasins() {
    const firstBasin = document.getElementById("firstBasinSelect").value.trim();
    if (!firstBasin) return;

    const encodedFirstBasin = encodeURIComponent(firstBasin); // firstBasin 값 인코딩

    const requestUrl = "/api/station/major-basins?firstBasin=" + encodedFirstBasin;
    fetch(requestUrl)
        .then(res => res.json())
        .then(data => {
            const majorBasinSelect = document.getElementById("majorBasinSelect");
            majorBasinSelect.innerHTML = "<option value=''>대권역 선택</option>";

            data.forEach(basin => {
                const option = document.createElement("option");
                option.value = basin;
                option.textContent = basin;
                majorBasinSelect.appendChild(option);
            });
        })
        .catch(err => {
            console.error("❌ major-basin API 호출 오류:", err);
        });
}

// 대권역을 선택하면 중권역을 로드하는 함수
function loadMidBasins() {
    const majorBasin = document.getElementById("majorBasinSelect").value.trim();
    if (!majorBasin) return;

    const encodedMajorBasin = encodeURIComponent(majorBasin); // majorBasin 값 인코딩

    const requestUrl = "/api/station/mid-basins?majorBasin=" + encodedMajorBasin;
    fetch(requestUrl)
        .then(res => res.json())
        .then(data => {
            const midBasinSelect = document.getElementById("midBasinSelect");
            midBasinSelect.innerHTML = "<option value=''>중권역 선택</option>";

            data.forEach(basin => {
                const option = document.createElement("option");
                option.value = basin;
                option.textContent = basin;
                midBasinSelect.appendChild(option);
            });
        })
        .catch(err => {
            console.error("❌ mid-basin API 호출 오류:", err);
        });
}

// 중권역을 선택하면 측정소를 로드하는 함수
function loadStationsByMid() {
    const midBasin = document.getElementById("midBasinSelect").value.trim();
    if (!midBasin) return;

    const encodedMidBasin = encodeURIComponent(midBasin); // midBasin 값 인코딩

    const requestUrl = "/api/station/stations-by-mid?midBasin=" + encodedMidBasin;
    fetch(requestUrl)
        .then(res => res.json())
        .then(data => {
            const stationCheckboxList = document.getElementById("stationCheckboxList");
            stationCheckboxList.innerHTML = '';

            data.forEach(station => {
                const label = document.createElement("label");
                label.textContent = station;

                const checkbox = document.createElement("input");
                checkbox.type = "checkbox";
                checkbox.name = "station";
                checkbox.value = station;

                const div = document.createElement("div");
                div.appendChild(checkbox);
                div.appendChild(label);

                stationCheckboxList.appendChild(div);
            });
        })
        .catch(err => {
            console.error("❌ stations API 호출 오류:", err);
        });
}

// station_cido 선택 시 해당 station_name들을 로드하도록 이벤트 추가
function loadStationNamesByCido(selectedCido, data) {
    const container = document.getElementById("stationCheckboxList");
    container.innerHTML = ''; // 기존 내용을 초기화

    // 선택된 station_cido에 해당하는 station_name들을 필터링
    const filteredStations = data.filter(st => st.station_cido === selectedCido);

    // 각 station_name에 대해 체크박스를 생성
    filteredStations.forEach(st => {
        const label = document.createElement("label");
        label.textContent = st.station_name;

        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.name = "station";
        checkbox.value = st.station_name;

        const div = document.createElement("div");
        div.appendChild(checkbox);
        div.appendChild(label);

        container.appendChild(div);

        // 체크박스를 클릭할 때마다 선택된 값들이 배열에 저장되도록 처리
        checkbox.addEventListener('change', function() {
            saveSelectedStations();
        });
    });
}

// 선택된 station_name을 저장하는 함수
function saveSelectedStations() {
    const selectedStations = [...document.querySelectorAll('input[name="station"]:checked')].map(cb => cb.value);
    console.log("선택된 측정소들:", selectedStations);
    
    // 여기에서 선택된 값들을 저장하거나 서버에 전송하는 로직을 추가할 수 있습니다.
    // 예시로 선택된 station_name을 저장하는 방식:
    window.selectedStations = selectedStations; // 글로벌 변수로 저장하거나 서버에 보내기
}


function applySelectedLocation() {
    const orgElement = document.getElementById("organizationSelect");
    if (!orgElement) {
        console.error("기관 선택 요소가 없습니다.");
        return;
    }

    const organization = orgElement.value.trim();  // 선택된 기관
    let selectedStations = [];  // 측정소 리스트
    let location = '';  // location (기상청이면 station_name, 환경부이면 ptnm)

    // 기상청일 경우, station_name을 기준으로 선택된 측정소들을 가져옴
    if (organization === '기상청') {
        selectedStations = [...document.querySelectorAll('input[name="station"]:checked')].map(cb => cb.value);
        location = selectedStations.join(',');  // 기상청은 station_name을 location으로 사용
        console.log("기상청 선택된 측정소들 (station_name):", selectedStations);
        
    } 
    // 환경부일 경우, ptnm을 기준으로 선택된 측정소들을 가져옴
    else if (organization === '환경부') {
        selectedStations = [...document.querySelectorAll('input[name="station"]:checked')].map(cb => cb.value);
        location = selectedStations.join(',');  // 환경부는 ptnm을 location으로 사용
        console.log("환경부 선택된 측정소들 (ptnm):", selectedStations);
    }

    // 필수 선택 값이 없을 경우 알림 처리
    if (!organization || selectedStations.length === 0) {
        alert("모든 필수 조건을 선택해주세요.");
        return;
    }

    console.log("선택된 행정구역 조건:", organization, location);

    // 기상청과 환경부에 맞는 URL을 생성
    let requestUrl = '';
    if (organization === '기상청') {
        requestUrl = "/api/station/data?organization=" + organization + "&stations=" + location + "&searchData=" + location;
    } else if (organization === '환경부') {
        requestUrl = "/api/station/data?organization=" + organization + "&stations=" + location + "&searchData=" + location;
    }

    // 예시 데이터 조회 (fetch)
    fetch(requestUrl)
        .then(res => res.json())
        .then(data => {
            console.log("조회된 데이터:", data);
            // 데이터를 테이블에 출력하는 코드 추가
            updateTableWithData(data); // 데이터 갱신
        })
        .catch(err => {
            console.error("❌ 데이터 조회 오류:", err);
        });

    // 모달 창을 닫기
    const modalElement = document.getElementById('locationModal');
    if (modalElement) {
        const modal = bootstrap.Modal.getInstance(modalElement);
        modal.hide();
    } else {
        console.error("모달 요소가 없습니다.");
    }
}
function updateTableWithData(data) {
    const tableBody = document.querySelector("table tbody");
    tableBody.innerHTML = ""; // 기존 테이블 내용 초기화

    // 데이터가 제대로 들어오는지 확인
    console.log("Data to update table with: ", data);

    // 새로운 데이터로 테이블 내용 채우기
    data.forEach(item => {
        const tr = document.createElement("tr");

        console.log("Item data:", item);

        // 기상청 데이터와 환경부 데이터를 구분해서 컬럼명을 다르게 설정
        let columns = [];
        
        // 기상청일 때는 item 자체에서 데이터 추출
        if (item.station_name) {
            columns = ['station_name', 'date', 'rain', 'temp', 'humidity', 'wind'];  // 기상청 컬럼
        } else {
            // 환경부일 경우, 기존 컬럼명 사용
            columns = ['TYPE','ptnm', 'Y', 'X', 'itemTemp', 'itemDoc', 'itemBod', 'itemCod', 'itemSs','itemTn','itemTp','itemToc','date'];
        }

        // 각 컬럼에 대해 데이터를 추출하여 td에 추가
        columns.forEach(col => {
            const td = document.createElement("td");
            // item에서 해당 값이 있으면 출력, 없으면 '-'
            td.textContent = item[col] !== undefined ? item[col] : '-';
            tr.appendChild(td);
        });

        tableBody.appendChild(tr);
    });
}





function handleSearch() {
    const searchData = document.querySelector('input[name="dataType"]:checked').value;
    const tableName = document.getElementById('tableSelect').value;
    const startDate = document.querySelector('input[name="startDate"]').value;
    const endDate = document.querySelector('input[name="endDate"]').value;

    const organization = document.getElementById("organizationSelect").value.trim();
    const firstBasin = document.getElementById("firstBasinSelect").value.trim();
    const majorBasin = document.getElementById("majorBasinSelect").value.trim();
    const midBasin = document.getElementById("midBasinSelect").value.trim();

    const selectedStations = [...document.querySelectorAll('input[name="station"]:checked')].map(cb => cb.value);

    if (!searchData || !tableName || !startDate || !endDate || !organization || !firstBasin || !majorBasin || !midBasin || selectedStations.length === 0) {
        alert("모든 필수 조건을 선택해주세요.");
        return;
    }

    const requestUrl = "/api/station/data?searchData=" + searchData +
        "&tableName=" + tableName +
        "&startDate=" + startDate +
        "&endDate=" + endDate +
        "&organization=" + encodeURIComponent(org) +
        "&firstBasin=" + encodeURIComponent(firstBasin) +
        "&majorBasin=" + encodeURIComponent(majorBasin) +
        "&midBasin=" + encodeURIComponent(midBasin) +
        "&stations=" + selectedStations.join(',');

    console.log("🔍 요청 URL:", requestUrl);

    fetch(requestUrl)
        .then(res => res.json())
        .then(data => {
            console.log("🌊 선택된 조건에 해당하는 데이터:", data);

            const tableBody = document.querySelector("table tbody");
            tableBody.innerHTML = '';

            if (data && data.length > 0) {
                data.forEach(item => {
                    const row = document.createElement("tr");
                    const columns = ['station_name', 'Y', 'X', 'itemTemp', 'itemDoc', 'itemBod'];
                    columns.forEach(col => {
                        const td = document.createElement("td");
                        td.textContent = item[col] || '-';
                        row.appendChild(td);
                    });
                    tableBody.appendChild(row);
                });
            } else {
                const row = document.createElement("tr");
                const td = document.createElement("td");
                td.colSpan = 6;
                td.textContent = "조건에 맞는 데이터가 없습니다.";
                row.appendChild(td);
                tableBody.appendChild(row);
            }
        })
        .catch(err => {
            console.error("❌ 데이터 요청 오류:", err);
        });
}


   function resetSearchConditions() {
       const startDate = document.querySelector('input[name="startDate"]');
       const endDate = document.querySelector('input[name="endDate"]');
       const location = document.querySelector('input[name="location"]');
       if (startDate) startDate.value = '';
       if (endDate) endDate.value = '';
       if (location) location.value = '';
   }
   document.addEventListener('DOMContentLoaded', () => {
       document.querySelectorAll('input[name="dataType"]').forEach(radio => {
           radio.addEventListener('change', function () {
               const category = this.value;
               fetch("/api/tables/by-category?category=" + encodeURIComponent(category))
                   .then(res => res.json())
                   .then(tables => {
                       const tableSelect = document.getElementById('tableSelect');
                       tableSelect.innerHTML = '<option disabled selected>테이블을 선택하세요</option>';
                       tables.forEach(table => {
                           const option = document.createElement('option');
                           option.value = table;
                           option.textContent = table;
                           tableSelect.appendChild(option);
                       });
                   })
                   .catch(err => console.error('❌ 테이블 로딩 실패:', err));
           });
       });
   });
</script>
</body>
</html>
