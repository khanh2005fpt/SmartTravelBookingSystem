<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<title>Thêm / Chỉnh sửa Đảo</title>
<jsp:include page="../common/css.jsp"/>
<style>
body{background-color:#f8f9fa;font-family:'Poppins',sans-serif;}
.main-content{margin-left:250px;padding:30px;min-height:100vh;}
.form-card{background:white;padding:30px;border-radius:15px;
           box-shadow:0 5px 20px rgba(0,0,0,0.1);}
.form-label{font-weight:600;}
.preview-img{width:200px;height:auto;border-radius:10px;margin-top:10px;}
.error-message{color:#dc3545;font-size:0.875rem;margin-top:0.25rem;display:none;}
.error-message.show{display:block;}
.form-control.is-invalid{border-color:#dc3545;}
.form-select.is-invalid{border-color:#dc3545;}
</style>
</head>
<body>
<jsp:include page="sidebar.jsp"><jsp:param name="page" value="islands"/></jsp:include>

<div class="main-content">
  <div class="form-card">
    <h2><i class="fa fa-pen"></i>
      <c:choose>
        <c:when test="${not empty island}">Chỉnh sửa Đảo</c:when>
        <c:otherwise>Thêm Đảo Mới</c:otherwise>
      </c:choose>
    </h2>
    <form action="${pageContext.request.contextPath}/staff/islands"
          method="post" enctype="multipart/form-data">

      <c:choose>
        <c:when test="${not empty island}">
          <input type="hidden" name="action" value="update">
          <input type="hidden" name="islandId" value="${island.islandId}">
        </c:when>
        <c:otherwise>
          <input type="hidden" name="action" value="create">
        </c:otherwise>
      </c:choose>

      <div class="mb-3">
        <label class="form-label">Tên đảo</label>
        <input type="text" class="form-control" id="islandName" name="islandName"
               value="${island.islandName}">
        <span class="error-message" id="islandNameError">Tên đảo không được để trống</span>
      </div>

      <div class="mb-3">
        <label class="form-label">Quốc gia</label>
        <select class="form-control" id="countryId" name="countryId">
          <option value="">-- Chọn quốc gia --</option>
          <c:forEach var="country" items="${countries}">
            <option value="${country.countryId}"
                    <c:if test="${island.countryId == country.countryId}">selected</c:if>>
              ${country.countryName}
            </option>
          </c:forEach>
        </select>
        <span class="error-message" id="countryIdError">Quốc gia không được để trống</span>
      </div>

      <div class="mb-3">
        <label class="form-label">Mùa đẹp nhất</label>
        <select class="form-control" id="bestSeason" name="bestSeason">
          <option value="">-- Chọn mùa --</option>
          <option value="Xuân" <c:if test="${island.bestSeason == 'Xuân'}">selected</c:if>>Xuân</option>
          <option value="Hạ" <c:if test="${island.bestSeason == 'Hạ'}">selected</c:if>>Hạ</option>
          <option value="Thu" <c:if test="${island.bestSeason == 'Thu'}">selected</c:if>>Thu</option>
          <option value="Đông" <c:if test="${island.bestSeason == 'Đông'}">selected</c:if>>Đông</option>
        </select>
        <span class="error-message" id="bestSeasonError">Mùa đẹp nhất không được để trống</span>
      </div>

      <div class="mb-3">
        <label class="form-label">Hoạt động nổi bật</label>
        <input type="text" class="form-control" name="activities"
               value="${island.activities}">
      </div>

      <div class="mb-3">
        <label class="form-label">Mô tả ngắn</label>
        <textarea class="form-control" name="shortDescription" rows="2">${island.shortDescription}</textarea>
      </div>

      <div class="mb-3">
        <label class="form-label">Mô tả chi tiết</label>
        <textarea class="form-control" name="longDescription" rows="4">${island.longDescription}</textarea>
      </div>

      <div class="mb-3">
        <label class="form-label">Ảnh đảo (chọn từ máy)</label>
        <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*">
        <span class="error-message" id="imageFileError">Ảnh đảo không được để trống</span>


      <div class="text-center">
        <button type="submit" class="btn btn-success px-4"><i class="fa fa-save"></i> Lưu</button>
        <a href="${pageContext.request.contextPath}/staff/islands" class="btn btn-secondary px-4">
          <i class="fa fa-arrow-left"></i> Quay lại
        </a>
      </div>
    </form>
  </div>
</div>

<jsp:include page="../common/script.jsp"/>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('form');
  const islandNameInput = document.getElementById('islandName');
  const countryIdSelect = document.getElementById('countryId');
  const bestSeasonSelect = document.getElementById('bestSeason');
  const imageFileInput = document.getElementById('imageFile');

  // Hàm hiển thị lỗi
  function showError(input, errorElement) {
    input.classList.add('is-invalid');
    errorElement.classList.add('show');
  }

  // Hàm ẩn lỗi
  function hideError(input, errorElement) {
    input.classList.remove('is-invalid');
    errorElement.classList.remove('show');
  }

  // Validate khi submit form
  form.addEventListener('submit', function(e) {
    let isValid = true;

    // Validate Tên đảo
    if (!islandNameInput.value.trim()) {
      showError(islandNameInput, document.getElementById('islandNameError'));
      isValid = false;
    } else {
      hideError(islandNameInput, document.getElementById('islandNameError'));
    }

    // Validate Quốc gia
    if (!countryIdSelect.value) {
      showError(countryIdSelect, document.getElementById('countryIdError'));
      isValid = false;
    } else {
      hideError(countryIdSelect, document.getElementById('countryIdError'));
    }

    // Validate Mùa đẹp nhất
    if (!bestSeasonSelect.value) {
      showError(bestSeasonSelect, document.getElementById('bestSeasonError'));
      isValid = false;
    } else {
      hideError(bestSeasonSelect, document.getElementById('bestSeasonError'));
    }

    // Validate Ảnh đảo (chỉ bắt buộc khi thêm mới, không bắt buộc khi chỉnh sửa)
    const isEditMode = document.querySelector('input[name="action"]').value === 'update';
    const hasExistingImage = document.querySelector('.preview-img') !== null;

    if (!isEditMode && !imageFileInput.files.length) {
      showError(imageFileInput, document.getElementById('imageFileError'));
      isValid = false;
    } else if (isEditMode && !imageFileInput.files.length && !hasExistingImage) {
      showError(imageFileInput, document.getElementById('imageFileError'));
      isValid = false;
    } else {
      hideError(imageFileInput, document.getElementById('imageFileError'));
    }

    if (!isValid) {
      e.preventDefault();
    }
  });

  // Xóa lỗi khi người dùng bắt đầu nhập
  islandNameInput.addEventListener('input', function() {
    if (this.value.trim()) {
      hideError(this, document.getElementById('islandNameError'));
    }
  });

  countryIdSelect.addEventListener('change', function() {
    if (this.value) {
      hideError(this, document.getElementById('countryIdError'));
    }
  });

  bestSeasonSelect.addEventListener('change', function() {
    if (this.value) {
      hideError(this, document.getElementById('bestSeasonError'));
    }
  });

  imageFileInput.addEventListener('change', function() {
    if (this.files.length) {
      hideError(this, document.getElementById('imageFileError'));
      // Hiển thị tên file đã chọn
      const fileName = this.files[0].name;
      document.getElementById('fileName').textContent = '✓ Đã chọn: ' + fileName;
    }
  });
});
</script>

</body>
</html>