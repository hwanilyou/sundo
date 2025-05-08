<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
  <div>
    <a href="/about.do">시스템 소개</a>
    <a href="/notice.do">공지사항</a>
    <a href="/login.do">로그인</a>
  </div>
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

  <div class="card">
    <div class="card-header section-title">기관 정보</div>
    <div class="card-body">
      <div class="row">
        <div class="col-md-6">
          <h6>물환경 정보 시스템</h6>
          <p>기준일: 25.05.01 | 상태: 정상 | 정상 건수: 38 | 오류 건수: 0</p>
        </div>
        <div class="col-md-6">
          <h6>국립 환경과학원</h6>
          <p>기준일: 25.05.01 | 상태: 정상 | 정상 건수: 0 | 오류 건수: 0</p>
        </div>
      </div>
    </div>
  </div>

  <div class="card">
    <div class="card-header section-title">빅데이터 플랫폼</div>
    <div class="card-body">
      <p>기준일: 25.05.01 | 분류: 물환경 정보 시스템 | 정상 건수: 0 | 오류 건수: 0</p>
    </div>
  </div>

  <div class="card">
    <div class="card-header section-title">연계 처리 결과</div>
    <div class="card-body">
      <p>기준일: 25.05.01 | 상태: 정상 | 전송 건수: 0 | 오류 건수: 0</p>
    </div>
  </div>

  <div class="card">
    <div class="card-header section-title">자동 실행 로그 목록</div>
    <div class="card-body">
      <table class="table table-striped text-center mb-0">
        <thead class="table-light">
          <tr><th>실행 구분</th><th>리소스</th><th>상태</th><th>실행 일자</th><th>기준일</th><th>정상</th><th>성공</th><th>오류</th></tr>
        </thead>
        <tbody>
          <tr><td>자동 동기화</td><td>물환경 정보</td><td>실행 완료</td><td>2025-05-01 11:01</td><td>25.05.01</td><td>3</td><td>3</td><td>0</td></tr>
          <tr><td>자동 동기화</td><td>생물 모니터링</td><td>실행 완료</td><td>2025-05-01 11:01</td><td>25.05.01</td><td>3</td><td>3</td><td>0</td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="card">
    <div class="card-header section-title">사용자 실행 로그 목록</div>
    <div class="card-body">
      <table class="table table-striped text-center mb-0">
        <thead class="table-light">
          <tr><th>No.</th><th>일시</th><th>사용자명</th><th>구분</th><th>결과</th></tr>
        </thead>
        <tbody>
          <tr><td>1</td><td>25-05-01</td><td>물환경 정보 시스템</td><td>수신</td><td>성공</td></tr>
          <tr><td>2</td><td>25-05-01</td><td>국립 환경과학원</td><td>수신</td><td>성공</td></tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ✅ 데이터 관리 (관리자용 CRUD) -->
  <div class="card">
    <div class="card-header section-title">데이터 관리 (관리자)</div>
    <div class="card-body">
    
    <!-- ✅ 파일 업로드 (CSV / SHP) -->
	<div class="card">
	  <div class="card-header section-title">파일 업로드</div>
	  <div class="card-body">
	    <form method="post" action="/admin/upload" enctype="multipart/form-data" class="row g-3 mb-3">
	      <div class="col-md-6">
	        <label class="form-label">CSV 또는 SHP(zip) 파일 업로드</label>
	        <input type="file" name="file" class="form-control" accept=".csv,.zip" required>
	      </div>
	      <div class="col-md-6">
	        <label class="form-label">데이터 유형</label>
	        <select name="dataType" class="form-select" required>
	          <option value="water">수질 데이터</option>
	          <option value="bio">생물 데이터</option>
	          <option value="shp">GIS 공간 데이터</option>
	        </select>
	      </div>
	      <div class="col-12 text-end">
	        <button type="submit" class="btn btn-success">업로드</button>
	      </div>
	    </form>
	  </div>
	</div>
    

      <!-- 등록 폼 -->
      <form class="row g-3 mb-4">
        <div class="col-md-4">
          <label class="form-label">제목</label>
          <input type="text" class="form-control" name="title" placeholder="예: 생물 모니터링">
        </div>
        <div class="col-md-4">
          <label class="form-label">기관명</label>
          <input type="text" class="form-control" name="agency" placeholder="예: 국립환경과학원">
        </div>
        <div class="col-md-4">
          <label class="form-label">기준일</label>
          <input type="date" class="form-control" name="date">
        </div>
        <div class="col-12 text-end">
          <button type="submit" class="btn btn-primary">등록</button>
        </div>
      </form>

      <!-- 관리 테이블 -->
      <table class="table table-bordered text-center">
        <thead class="table-light">
          <tr><th>ID</th><th>제목</th><th>기관</th><th>기준일</th><th>관리</th></tr>
        </thead>
        <tbody>
          <tr>
            <td>1</td><td>생물 모니터링</td><td>환경부</td><td>2025-05-01</td>
            <td>
              <button class="btn btn-sm btn-warning">수정</button>
              <button class="btn btn-sm btn-danger">삭제</button>
            </td>
          </tr>
          <!-- 향후 c:forEach로 반복 출력 -->
        </tbody>
      </table>
    </div>
  </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
