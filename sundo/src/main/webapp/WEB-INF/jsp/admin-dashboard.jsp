<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환경물관리 통합정보 플랫폼 - 관리자페이지</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    html, body { height: 100%; margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif; }
    .top-header {
      background: #1E88E5; color: white; padding: 15px 30px;
      display: flex; justify-content: space-between; align-items: center;
    }
    .top-header h2 { margin: 0; font-size: 24px; }
    .top-header a { color: white; text-decoration: none; margin-left: 15px; font-size: 16px; }
    .top-header a:hover { text-decoration: underline; }
    .menu-bar {
      background-color: #f8f9fa; padding: 10px 0; text-align: center; border-bottom: 1px solid #ddd;
    }
    .menu-bar a {
      color: #1E88E5; text-decoration: none; margin: 0 20px; font-size: 18px;
      font-weight: bold; padding-bottom: 5px; border-bottom: 3px solid transparent;
    }
    .menu-bar a.active { border-bottom: 3px solid #1E88E5; }
    .card { margin-bottom: 20px; }
    .section-title { font-size: 18px; font-weight: bold; margin-bottom: 10px; }
  </style>
</head>
<body>

<!-- 상단 헤더 -->
<div class="top-header">
  <h2>환경물관리 통합정보 플랫폼</h2>
</div>

<!-- 중앙 메뉴 -->
<div class="menu-bar">
  <a href="/">지도</a>
  <a href="/list.do">목록</a>
  <a href="/simulation.do">시뮬레이션</a>
  <a href="/adminpage.do" class="active">관리자페이지</a>
</div>

<!-- 본문 관리자 콘텐츠 -->
<div class="container mt-4">
  <div class="row">
    <!-- 기관 정보 -->
    <div class="col-md-12 mb-3">
      <div class="card h-100">
        <div class="card-header section-title">기관 정보</div>
        <div class="card-body">
        <table id="institutionTable" class="table table-striped text-center mb-0">
        <thead class="table-light">
          <tr>
            <th>데이터명</th>
            <th>기관명</th>
            <th>데이터 수</th>
            <th>오류 수</th>
            <th>마지막 갱신일</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
        </div>
      </div>
    </div>

 
    <!-- 데이터 업데이트 로그 목록 -->
    <div class="col-md-12">
      <div class="card">
        <div class="card-header section-title">데이터 업데이트 로그 목록</div>
        <div class="card-body">
          <table id="dataUpdateLogTable" class="table table-striped text-center mb-0">
            <thead class="table-light">
              <tr>
                <th>데이터명</th>
                <th>데이터 수</th>
                <th>마지막 갱신일</th>
                <th>다음 갱신 예정일</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  
  <!-- ✅ 데이터 관리 (관리자용 CRUD) -->
  <div class="card">
    <div class="card-header section-title">데이터 관리 (관리자)</div>
    <div class="card-body">
    
    <!-- ✅ 파일 업로드 (CSV / SHP) -->
   <div class="card">
     <div class="card-header section-title">기존 테이블에 데이터 업로드</div>
     <div class="card-body">
       <form method="post" action="/admin/upload" enctype="multipart/form-data" class="row g-3 mb-3">
         
         <!-- 드롭다운: 기존 등록된 테이블 목록 -->
         <div class="col-md-6">
           <label class="form-label">업데이트 대상 테이블</label>
           <select name="tableName" class="form-select" required>
             <c:forEach var="meta" items="${metadataList}">
               <option value="${meta.tableName}">${meta.tableName} - ${meta.title}</option>
             </c:forEach>
           </select>
         </div>
   
         <!-- 파일 선택 -->
         <div class="col-md-6">
           <label class="form-label">CSV 또는 SHP 파일</label>
           <input type="file" name="file" class="form-control" accept=".csv,.zip" required>
         </div>
   
         <!-- 제출 버튼 -->
         <div class="col-12 text-end">
           <button type="submit" class="btn btn-success">업로드</button>
         </div>
   
       </form>
     </div>
   </div>

    

   <!-- ✅ 등록 폼 (새 테이블 생성 + CSV 또는 SHP 등록) -->
   <div class="card">
     <div class="card-header section-title">데이터 등록</div>
     <div class="card-body">
       <form class="row g-3 mb-4" action="/admin/register" method="post" enctype="multipart/form-data">
         <div class="col-md-4">
           <label class="form-label">테이블명</label>
           <input type="text" class="form-control" name="tableName" required>
         </div>
         <div class="col-md-4">
           <label class="form-label">제목</label>
           <input type="text" class="form-control" name="title" required>
         </div>
         <div class="col-md-4">
           <label class="form-label">기관명</label>
           <input type="text" class="form-control" name="organization" required>
         </div>
         <div class="col-md-4">
          <label class="form-label">시작기간</label>
          <input type="date" class="form-control" name="startDate" required> <!-- 필수로 설정 -->
      </div>
         <div class="col-md-4">
           <label class="form-label">종료기간</label>
           <input type="date" class="form-control" name="endDate" required> <!-- 필수로 설정 -->
         </div>
         <!-- 새로 추가된 필드들 -->
         <div class="col-md-4">
           <label class="form-label">설명</label>
           <input type="text" class="form-control" name="description">
         </div>
         <div class="col-md-4">
           <label class="form-label">외부 URL</label>
           <input type="url" class="form-control" name="externalUrl">
         </div>
         <div class="col-md-4">
           <label class="form-label">데이터 정보</label>
           <input type="text" class="form-control" name="dataInformation">
         </div>
         <div class="col-md-4">
           <label class="form-label">파일 형식</label>
           <select name="fileType" class="form-select" required>
             <option value="csv">CSV</option>
             <option value="shp">SHP (zip)</option>
           </select>
         </div>
         <div class="col-md-12">
           <label class="form-label">파일</label>
           <input type="file" class="form-control" name="file" accept=".csv,.zip" required>
         </div>
         <div class="col-12 text-end">
           <button type="submit" class="btn btn-primary">등록</button>
         </div>
       </form>
     </div>
   </div>
   

  <!-- ✅ 등록된 메타데이터 목록 출력 -->
  <div class="card">
    <div class="card-header section-title">등록된 데이터 목록</div>
    <div class="card-body">
     
        <c:if test="${not empty metadataList}">
       <table class="table table-bordered text-center">
           <thead class="table-light">
               <tr>
                   <th>ID</th>
                   <th>제목</th>
                   <th>기관</th>
                   <th>기준일</th>
                   <th>관리</th>
               </tr>
           </thead>
           <tbody>
               <c:forEach var="meta" items="${metadataList}" varStatus="status">
                <tr>
                    <td>${status.index + 1}</td>
                    <td>${meta.title}</td>
                    <td>${meta.organization}</td>
                    <td>${meta.createdAt != null ? meta.createdAt : '등록된 날짜 없음'}</td>
                    <td>
                        <button class="btn btn-sm btn-warning"
                         onclick="openEditModal(
                             ${meta.id},
                             '${meta.tableName}',
                             '${meta.title}',
                             '${meta.organization}',
                             '${meta.startDate}',
                             '${meta.endDate}',
                             '${meta.description}',
                             '${meta.externalUrl}',
                             '${meta.dataInformation}',
                             '${meta.category}'
                         )">수정</button>
                        <button class="btn btn-sm btn-danger" onclick="deleteMetadata(${meta.id})">삭제</button>
                        <button class="btn btn-sm btn-info" onclick="viewTable('${meta.tableName}', '${meta.title}')">상세보기</button>
                    </td>
                </tr>
            </c:forEach>
           </tbody>
       </table>
   </c:if>
   <c:if test="${empty metadataList}">
       <p>데이터가 없습니다.</p>
   </c:if>
        
        
    </div>
  </div>
  
  <!-- ✅ 상세 데이터 미리보기 테이블 -->
  <div id="previewArea" class="mt-4" style="display: none;">
    <h5 id="previewTitle" class="mb-3"></h5>
    <div class="table-responsive">
      <table id="previewTable" class="table table-bordered text-center table-sm">
        <thead id="previewHead" class="table-light"></thead>
        <tbody id="previewBody"></tbody>
      </table>
    </div>
  </div>
  
  
<!-- 수정용 모달 -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="/admin/update">
        <div class="modal-header">
          <h5 class="modal-title" id="editModalLabel">메타데이터 수정</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="id" id="edit-id">
          
          <!-- 테이블명 -->
          <div class="mb-3">
            <label class="form-label">테이블명</label>
            <input type="text" class="form-control" name="tableName" id="edit-tableName" readonly>
          </div>

          <!-- 제목 -->
          <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" class="form-control" name="title" id="edit-title" required>
          </div>

          <!-- 기관명 -->
          <div class="mb-3">
            <label class="form-label">기관명</label>
            <input type="text" class="form-control" name="organization" id="edit-organization" required>
          </div>

          <!-- 시작일 -->
          <div class="mb-3">
            <label class="form-label">시작일</label>
            <input type="date" class="form-control" name="startDate" id="edit-startDate" required>
          </div>

          <!-- 종료일 -->
          <div class="mb-3">
            <label class="form-label">종료일</label>
            <input type="date" class="form-control" name="endDate" id="edit-endDate" required>
          </div>

          <!-- 설명 -->
          <div class="mb-3">
            <label class="form-label">설명</label>
            <input type="text" class="form-control" name="description" id="edit-description">
          </div>

          <!-- 외부 URL -->
          <div class="mb-3">
            <label class="form-label">외부 URL</label>
            <input type="url" class="form-control" name="externalUrl" id="edit-externalUrl">
          </div>

          <!-- 데이터 정보 -->
          <div class="mb-3">
            <label class="form-label">데이터 정보</label>
            <input type="text" class="form-control" name="dataInformation" id="edit-dataInformation">
          </div>

          <!-- 카테고리 -->
          <div class="mb-3">
            <label class="form-label">카테고리</label>
            <input type="text" class="form-control" name="category" id="edit-category">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
          <button type="submit" class="btn btn-primary">저장</button>
        </div>
      </form>
    </div>
  </div>

  
  
</div>

   

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', () => {
  // ✅ 메시지 자동 숨기기
  const success = document.querySelector('.alert-success');
  const error = document.querySelector('.alert-danger');
  if (success || error) {
    setTimeout(() => {
      if (success) success.style.display = 'none';
      if (error) error.style.display = 'none';
    }, 3000);
  }

  // ✅ URL 정리
  if (window.location.search.includes("message") || window.location.search.includes("error")) {
    const cleanURL = window.location.origin + window.location.pathname;
    window.history.replaceState({}, document.title, cleanURL);
  }

});


//✅ 전역 함수 등록 (window 붙이기)
window.openEditModal = function (id, tableName, title, organization, startDate, endDate, description, externalUrl, dataInformation, category) {
  console.log("startDate:", startDate); // 디버깅 로그 추가
  console.log("endDate:", endDate);  // 디버깅 로그 추가
  
  document.getElementById("edit-id").value = id || '';
  document.getElementById("edit-tableName").value = tableName || '';
  document.getElementById("edit-title").value = title || '';
  document.getElementById("edit-organization").value = organization || '';
  
  // 값이 제대로 전달되고 있는지 확인
  document.getElementById("edit-startDate").value = startDate || '';  // 시작일
  document.getElementById("edit-endDate").value = endDate || '';      // 종료일
  document.getElementById("edit-description").value = description || '';  // 설명
  document.getElementById("edit-externalUrl").value = externalUrl || '';  // 외부 URL
  document.getElementById("edit-dataInformation").value = dataInformation || '';  // 데이터 정보
  document.getElementById("edit-category").value = category || '';  // 카테고리

  // 모달 열기
  const modalEl = document.getElementById('editModal');
  if (modalEl) {
    const modal = new bootstrap.Modal(modalEl);
    modal.show();
  } else {
    console.error("❌ editModal 요소를 찾을 수 없습니다.");
  }
};


window.deleteMetadata = function (id) {
  if (!confirm("정말 삭제하시겠습니까?")) return;

  fetch('/admin/delete', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: 'id=' + id
  })
  .then(response => {
    if (response.ok) {
      alert("삭제 완료");
      location.reload();
    } else {
      return response.text().then(msg => { throw new Error(msg); });
    }
  })
  .catch(err => {
    alert("❌ 삭제 실패: " + err.message);
  });
};

window.viewTable = function (tableName, title) {
     fetch('/admin/table-data?tableName=' + encodeURIComponent(tableName))
       .then(res => res.json())
       .then(data => {
         if (!data || data.length === 0) {
           alert("데이터가 없습니다.");
           return;
         }

         document.getElementById('previewTitle').textContent = title + ' - 데이터 미리보기';
         const head = document.getElementById('previewHead');
         const body = document.getElementById('previewBody');
         head.innerHTML = '';
         body.innerHTML = '';

         // 헤더 배열에서 geom, wkt_geom 인덱스 찾기
         const originalHeaders = data[0];
         const skipCols = [
           originalHeaders.indexOf('geom'),
           originalHeaders.indexOf('wkt_geom')
         ];

         // 헤더 렌더링 (건너뛸 인덱스 체크)
         const headerRow = document.createElement('tr');
         originalHeaders.forEach((col, idx) => {
           if (skipCols.includes(idx)) return;
           const th = document.createElement('th');
           th.textContent = col;
           headerRow.appendChild(th);
         });
         head.appendChild(headerRow);

         // 데이터 행 렌더링
         for (let i = 1; i < data.length; i++) {
           const row = document.createElement('tr');
           data[i].forEach((cell, idx) => {
             if (skipCols.includes(idx)) return;
             const td = document.createElement('td');
             td.textContent = cell;
             row.appendChild(td);
           });
           body.appendChild(row);
         }

         document.getElementById('previewArea').style.display = 'block';
         window.scrollTo({ top: document.getElementById('previewArea').offsetTop - 100, behavior: 'smooth' });
       })
       .catch(err => {
         console.error("❌ 상세보기 실패:", err);
         alert("상세보기 실패: " + err.message);
       });
   };



document.addEventListener("DOMContentLoaded", function () {
     // ✅ 1. 최근 10개 전체 로그 테이블 (dataUpdateLogTable)
     fetch('http://localhost:8081/api/data-log')
       .then(response => response.json())
       .then(data => {
         const tbody = document.querySelector('#dataUpdateLogTable tbody');
         if (!tbody) return;

         tbody.innerHTML = '';

         function formatDate(dateStr) {
           const date = new Date(dateStr);
           return isNaN(date) ? '날짜 오류' : date.toISOString().slice(0, 10);
         }

         data.slice(0, 10).forEach(item => {
           const row = `
             <tr>
               <td>\${item.dataName}</td>
               <td>\${item.dataCount}</td>
               <td>\${formatDate(item.lastUpdated)}</td>
               <td>\${formatDate(item.nextUpdate)}</td>
               <td>\${item.status}</td>
             </tr>
           `;
           tbody.insertAdjacentHTML('beforeend', row);
         });
       });

     // ✅ 2. 기관별 최신 로그 테이블 (institutionTable)
     fetch('http://localhost:8081/api/data-log/latest')
       .then(res => res.json())
       .then(data => {
         const tbody = document.querySelector('#institutionTable tbody');
         if (!tbody) return;

         tbody.innerHTML = '';

         function formatDate(dateStr) {
           const date = new Date(dateStr);
           return isNaN(date) ? '날짜 오류' : date.toISOString().slice(0, 10);
         }

         data.forEach(item => {
           const row = `
             <tr>
               <td>\${item.organization}</td>
               <td>\${item.dataName}</td>
               <td>\${item.dataCount}</td>
               <td>\${item.errorCount}</td>
               <td>\${formatDate(item.lastUpdated)}</td>
             </tr>
           `;
           tbody.insertAdjacentHTML('beforeend', row);
         });
       });
   });

         
   
function logUserLayerAction(layerName, status = "성공") {
     fetch('/api/user-log/save', {
       method: 'POST',
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
       console.log(`✅ 로그 저장 완료: ${layerName}`);
     })
     .catch(err => console.error("❌ 로그 전송 오류:", err));
   }


document.addEventListener("DOMContentLoaded", function () {
   fetch('/api/user-log')
     .then(res => res.json())
     .then(data => {
       const container = document.querySelector('.container .row');
       if (!container) return;

       // ✅ 카드 HTML 템플릿 생성
       const cardHtml = `
         <div class="col-md-12 mb-3">
           <div class="card">
             <div class="card-header section-title">사용자 실행 로그 목록</div>
             <div class="card-body">
               <table id="userLogTable" class="table table-striped text-center mb-0">
                 <thead class="table-light">
                   <tr>
                     <th>No.</th>
                     <th>일시</th>
                     <th>사용자명</th>
                     <th>구분</th>
                     <th>결과</th>
                   </tr>
                 </thead>
                 <tbody></tbody>
               </table>
             </div>
           </div>
         </div>
       `;

       // ✅ HTML 삽입 (기관 정보 아래에 삽입하고 싶으면 afterend)
       const institutionCard = document.querySelector('#institutionTable')?.closest('.col-md-12');
       if (institutionCard) {
         institutionCard.insertAdjacentHTML('afterend', cardHtml);
       } else {
         container.insertAdjacentHTML('beforeend', cardHtml);
       }

       // ✅ 데이터 삽입
       const tbody = document.querySelector('#userLogTable tbody');
       if (!tbody) return;

       tbody.innerHTML = '';
       data.slice(0, 10).forEach((item, index) => {
         const row = `
           <tr>
             <td>\${index + 1}</td>
             <td>\${formatDateTime(item.executedAt)}</td>
             <td>\${item.dataName}</td>
             <td>\${item.logType}</td>
             <td>\${item.status}</td>
           </tr>
         `;
         tbody.insertAdjacentHTML('beforeend', row);
       });
     })
     .catch(err => console.error("❌ 사용자 로그 로딩 실패:", err));
});
function formatDateTime(dateStr) {
     const date = new Date(dateStr);
     if (isNaN(date)) return '날짜 오류';

     return date.toLocaleString('ko-KR', {
       year: 'numeric',
       month: '2-digit',
       day: '2-digit',
       hour: '2-digit',
       minute: '2-digit',
       second: '2-digit',
       hour12: false
     }).replace(/\./g, '-').replace(' ', ' ').replace(/- /g, '-').trim();
   }

</script>
</body>
</html>


