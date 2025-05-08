<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>환경물관리 통합정보 플랫폼 - 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body { margin: 0; padding: 0; height: 100%; }
        .top-header {
            background: #1E88E5; color: white;
            padding: 15px 30px; display: flex; justify-content: space-between; align-items: center;
        }
        .top-header h2 { margin: 0; font-size: 24px; }
        .top-header a { color: white; margin-left: 15px; font-size: 16px; text-decoration: none; }
        .top-header a:hover { text-decoration: underline; }
        .menu-bar {
            background-color: #f8f9fa; padding: 10px 0;
            text-align: center; border-bottom: 1px solid #ddd;
        }
        .menu-bar a {
            color: #1E88E5; font-weight: bold;
            text-decoration: none; margin: 0 20px; font-size: 18px; padding-bottom: 5px;
            border-bottom: 3px solid transparent;
        }
        .menu-bar a.active { border-bottom: 3px solid #1E88E5; }
        .menu-bar a:hover { text-decoration: underline; }

        .treeview ul { list-style: none; padding-left: 1em; }
        .treeview li { margin: 0.3em 0; }
        .treeview label { cursor: pointer; }
        .treeview input.toggle ~ ul { display: none; }
        .treeview input.toggle:checked ~ ul { display: block; }
        .treeview input.selector { margin-right: 5px; }
    </style>
</head>
<body>
<div class="top-header">
    <h2>환경물관리 통합정보 플랫폼</h2>
    <div>
        <a href="/about.do">시스템 소개</a>
        <a href="/notice.do">공지사항</a>
        <a href="/login.do">로그인</a>
    </div>
</div>
<div class="menu-bar">
    <a href="/">지도</a>
    <a href="/list.do" class="active">목록</a>
    <a href="/simulation.do">시뮬레이션</a>
</div>
<div class="container mt-4">
    <div class="card mb-4 shadow-sm">
        <div class="card-header bg-light"><strong>검색 조건</strong></div>
        <div class="card-body">
            <div class="mb-3">
                <label class="form-label d-block">검색 데이터:</label>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="dataType" value="수질" checked>
                    <label class="form-check-label">수질 데이터</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="dataType" value="생물">
                    <label class="form-check-label">생물 데이터</label>
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-md-auto"><label class="form-label">시작기간:</label></div>
                <div class="col-md-2"><select class="form-select"><option>2024</option><option>2025</option></select></div>
                <div class="col-md-2"><select class="form-select"><option>1월</option><option>2월</option></select></div>
                <div class="col-md-auto"><label class="form-label">종료기간:</label></div>
                <div class="col-md-2"><select class="form-select"><option>2024</option><option>2025</option></select></div>
                <div class="col-md-2"><select class="form-select"><option>12월</option><option>11월</option></select></div>
            </div>
            <div class="row align-items-center mb-3">
                <div class="col-md-4"><input type="text" class="form-control" placeholder="지점명을 입력하세요"></div>
                <div class="col-md-auto">
                    <button class="btn btn-primary me-2">검색</button>
                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#regionModal">지역선택</button>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header bg-light"><strong>검색 결과</strong></div>
        <div class="card-body p-0">
            <table class="table table-bordered text-center mb-0">
                <thead class="table-light">
                    <tr><th>번호</th><th>조사년도</th><th>조사회차</th><th>대권역</th><th>중권역</th><th>조사지점</th><th>건강생물등급</th></tr>
                </thead>
                <tbody>
                    <tr><td>1</td><td>2024</td><td>1</td><td>한강</td><td>한강서울</td><td>탄천5</td><td>C</td></tr>
                    <tr><td>2</td><td>2024</td><td>1</td><td>한강</td><td>한강서울</td><td>탄천5</td><td>C</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Modal -->
<div class="modal fade" id="regionModal" tabindex="-1" aria-labelledby="regionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">지역 선택</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <ul class="nav nav-tabs">
                    <li class="nav-item">
                        <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#watershed">수계로 찾기</button>
                    </li>
                    <li class="nav-item">
                        <button class="nav-link" data-bs-toggle="tab" data-bs-target="#admin">행정구역으로 찾기</button>
                    </li>
                </ul>
                <div class="tab-content border p-3">
                    <div class="tab-pane fade show active" id="watershed">
                        <div class="treeview">
                            <ul>
                                <li>
                                    <input type="checkbox" id="toggle-w1" class="toggle">
                                    <label for="toggle-w1"><input type="checkbox" class="selector"> 한강</label>
                                    <ul>
                                        <li><label><input type="checkbox" class="selector"> 한강서해</label></li>
                                        <li><label><input type="checkbox" class="selector"> 한강동해</label></li>
                                    </ul>
                                </li>
                                <li><label><input type="checkbox" class="selector"> 낙동강</label></li>
                                <li><label><input type="checkbox" class="selector"> 금강</label></li>
                                <li><label><input type="checkbox" class="selector"> 영산강</label></li>
                            </ul>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="admin">
                        <div class="treeview">
                            <ul>
                                <li>
                                    <input type="checkbox" id="toggle-a1" class="toggle">
                                    <label for="toggle-a1"><input type="checkbox" class="selector"> 서울특별시</label>
                                    <ul>
                                        <li><label><input type="checkbox" class="selector"> 강남구</label></li>
                                        <li><label><input type="checkbox" class="selector"> 서초구</label></li>
                                    </ul>
                                </li>
                                <li><label><input type="checkbox" class="selector"> 부산광역시</label></li>
                                <li><label><input type="checkbox" class="selector"> 대구광역시</label></li>
                                <li><label><input type="checkbox" class="selector"> 인천광역시</label></li>
                                <li><label><input type="checkbox" class="selector"> 광주광역시</label></li>
                                <li><label><input type="checkbox" class="selector"> 대전광역시</label></li>
                                <li><label><input type="checkbox" class="selector"> 울산광역시</label></li>
                                <li><label><input type="checkbox" class="selector"> 세종특별자치시</label></li>
                                <li><label><input type="checkbox" class="selector"> 경기도</label></li>
                                <li><label><input type="checkbox" class="selector"> 강원도</label></li>
                                <li><label><input type="checkbox" class="selector"> 충청북도</label></li>
                                <li><label><input type="checkbox" class="selector"> 충청남도</label></li>
                                <li><label><input type="checkbox" class="selector"> 전라북도</label></li>
                                <li><label><input type="checkbox" class="selector"> 전라남도</label></li>
                                <li><label><input type="checkbox" class="selector"> 경상북도</label></li>
                                <li><label><input type="checkbox" class="selector"> 경상남도</label></li>
                                <li><label><input type="checkbox" class="selector"> 제주특별자치도</label></li>
                            </ul>
                        </div>
                    </div>
                </div>
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
