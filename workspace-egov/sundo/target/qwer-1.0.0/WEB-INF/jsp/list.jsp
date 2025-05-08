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
        }
        /* 헤더 스타일 */
        .top-header {
            background: #1E88E5; /* 기존보다 밝은 파란색 (#005BAC → #1E88E5) */
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

        /* 중앙 메뉴 스타일 */
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
            border-bottom: 3px solid transparent; /* 기본은 투명 */
        }
        .menu-bar a.active {
            border-bottom: 3px solid #1E88E5; /* 선택된 메뉴는 파란 밑줄 */
        }
        .menu-bar a:hover {
            text-decoration: underline;
        }

        #map {
            width: 100%;
            height: calc(100vh - 120px); /* (헤더 60px + 메뉴 60px) 정확히 제외 */
            border: none;
        }
    </style>
</head>
<body>
<!-- ✅ 상단 헤더 -->
<div class="top-header">
    <h2>환경물관리 통합정보 플랫폼</h2>
    <div>
        <a href="/about.do">시스템 소개</a>
        <a href="/notice.do">공지사항</a>
        <a href="/login.do">로그인</a>
    </div>
</div>

<!-- ✅ 중앙 정렬 메뉴 -->
<div class="menu-bar">
    <a href="/" >지도</a> <!-- 현재 지도 페이지니까 active 클래스 추가 -->
    <a href="/list.do"class="active">목록</a>
    <a href="/simulation.do">시뮬레이션</a>
    <a href="/adminpage.do">관리자페이지</a>
</div>
    <!-- 2. 검색 조건 -->
    <div class="card mb-3">
        <div class="card-body">
            <h5 class="card-title">검색 조건</h5>
            
            <div class="row mb-3">
                <label class="form-label">검색 데이터:</label>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="dataType" value="수질" checked>
                    <label class="form-check-label">수질 데이터</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="dataType" value="생물">
                    <label class="form-check-label">생물 데이터</label>
                </div>
                <!-- 추가 항목 생략 가능 -->
            </div>

            <div class="row g-3 align-items-center mb-3">
                <div class="col-auto">
                    <label>시작기간:</label>
                </div>
                <div class="col-auto">
                    <select class="form-select">
                        <option>2024</option>
                        <option>2025</option>
                    </select>
                </div>
                <div class="col-auto">
                    <select class="form-select">
                        <option>1월</option>
                        <option>2월</option>
                        <option>3월</option>
                        <!-- ... -->
                    </select>
                </div>

                <div class="col-auto ms-4">
                    <label>종료기간:</label>
                </div>
                <div class="col-auto">
                    <select class="form-select">
                        <option>2024</option>
                        <option>2025</option>
                    </select>
                </div>
                <div class="col-auto">
                    <select class="form-select">
                        <option>12월</option>
                        <option>11월</option>
                        <!-- ... -->
                    </select>
                </div>
            </div>

            <!-- 3~4. 지역 선택 / 검색 버튼 -->
            <div class="d-flex gap-2">
                <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#regionModal">지역선택</button>
                <button class="btn btn-primary">검색</button>
            </div>
        </div>
    </div>

    <!-- 5. 검색 결과 테이블 -->
    <div class="card">
        <div class="card-body p-0">
            <table class="table table-striped text-center mb-0">
                <thead class="table-light">
                    <tr>
                        <th>번호</th>
                        <th>조사년도</th>
                        <th>조사회차</th>
                        <th>대권역</th>
                        <th>중권역</th>
                        <th>조사지점</th>
                        <th>건강생물등급</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td><td>2024</td><td>1</td><td>한강</td><td>한강서울</td><td>탄천5</td><td>C</td>
                    </tr>
                    <tr>
                        <td>2</td><td>2024</td><td>1</td><td>한강</td><td>한강서울</td><td>탄천5</td><td>C</td>
                    </tr>
                    <!-- c:forEach로 반복 -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 지역 선택 모달 -->
<div class="modal fade" id="regionModal" tabindex="-1" aria-labelledby="regionModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">지역 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <!-- 예시 트리 구조 -->
        <ul>
            <li><strong>서울특별시</strong>
                <ul><li>강남구</li><li>서초구</li></ul>
            </li>
            <li><strong>경기도</strong>
                <ul><li>수원시</li><li>성남시</li></ul>
            </li>
            <!-- 추후 실제 JS 트리 적용 -->
        </ul>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary">선택 완료</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>