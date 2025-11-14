    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Chi tiết Đảo Du Lịch</title>
<jsp:include page="../common/css.jsp"/>
<style>
body{background-color:#f8f9fa;font-family:'Poppins',sans-serif;}
.main-content{margin-left:250px;padding:30px;min-height:100vh;}
.header{background:linear-gradient(135deg,#667eea,#764ba2);color:white;
        padding:30px;border-radius:15px;margin-bottom:30px;}
.detail-card{background:white;padding:30px;border-radius:15px;
             box-shadow:0 4px 20px rgba(0,0,0,0.1);}
.detail-img{max-width:100%;border-radius:10px;box-shadow:0 5px 20px rgba(0,0,0,0.1);}
.info{margin-top:20px;}
.info h5{color:#667eea;font-weight:600;}
</style>
</head>
<body>
<jsp:include page="sidebar.jsp"><jsp:param name="page" value="islands"/></jsp:include>

<div class="main-content">
<div class="header"><h1><i class="fa fa-eye"></i> Chi tiết Đảo</h1></div>

<c:choose>
  <c:when test="${not empty island}">
    <div class="detail-card">
      <h2>${island.islandName}</h2>
      <p><i class="fa fa-map-marker"></i> ${island.location}</p>
      <div class="text-center my-4">
        <c:choose>
          <c:when test="${not empty island.imageUrl}">
            <img src="${pageContext.request.contextPath}/views/home/images/islands/${island.imageUrl}"
                 alt="${island.islandName}" class="detail-img">
          </c:when>
          <c:otherwise>
            <div class="text-muted">Chưa có hình ảnh</div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="info">
        <h5>Quốc gia:</h5><p>${island.countryName}</p>
        <h5>Mùa du lịch đẹp nhất:</h5><p>${island.bestSeason}</p>
        <h5>Hoạt động nổi bật:</h5><p>${island.activities}</p>
        <h5>Mô tả ngắn:</h5><p>${island.shortDescription}</p>
        <h5>Mô tả chi tiết:</h5><p>${island.longDescription}</p>
      </div>

      <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/staff/islands" class="btn btn-secondary">
          <i class="fa fa-arrow-left"></i> Quay lại
        </a>
        <a href="${pageContext.request.contextPath}/staff/islands?action=edit&id=${island.islandId}"
           class="btn btn-warning"><i class="fa fa-edit"></i> Chỉnh sửa</a>
      </div>
    </div>
  </c:when>
  <c:otherwise>
    <div class="alert alert-warning">Không tìm thấy thông tin đảo.</div>
  </c:otherwise>
</c:choose>
</div>

<jsp:include page="../common/script.jsp"/>
</body>
</html>