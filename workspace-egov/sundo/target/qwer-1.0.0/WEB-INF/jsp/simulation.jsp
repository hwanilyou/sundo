<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageMenu", "simulation");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경물관리 통합정보 플랫폼 - 시뮬레이션</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
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

<!-- ✅ 중앙 메뉴 -->
<div class="menu-bar">
    <a href="/" >지도</a>
    <a href="/list.do">목록</a>
    <a href="/simulation.do" class="active">시뮬레이션</a>
    <a href="/adminpage.do">관리자페이지</a>
</div>

<div class="container mt-5">
    <!-- 제목 -->
    <h3 class="text-center mb-4 border-bottom pb-2">시뮬레이션 전·후 비교</h3>

    <!-- 이미지 2개 정렬 -->
    <div class="row justify-content-center">
        <!-- 왼쪽: 시뮬레이션 전 -->
        <div class="col-md-5 text-center mb-4">
            <h6 class="mb-3">시뮬레이션 전</h6>
            <img src="${pageContext.request.contextPath}/resources/images/before.jpg"
                 class="img-fluid rounded shadow border" alt="시뮬레이션 전">
        </div>

        <!-- 오른쪽: 시뮬레이션 후 -->
        <div class="col-md-5 text-center mb-4">
            <h6 class="mb-3">시뮬레이션 후</h6>
            <img src="${pageContext.request.contextPath}/resources/images/after.jpg"
                 class="img-fluid rounded shadow border" alt="시뮬레이션 후">
        </div>
    </div>

    <!-- 버튼 정렬 -->
    <div class="text-center mt-4">
        <button class="btn btn-secondary me-2">초기화</button>
        <button class="btn btn-primary">시뮬레이션 실행</button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>