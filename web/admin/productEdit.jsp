<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${isEdit ? '编辑商品' : '添加商品'}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: "Helvetica Neue", Helvetica, Arial, "Microsoft Yahei", sans-serif;
            background-color: #f5f5f5;
        }
        
        .admin-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 0 50px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .admin-logo {
            color: white;
            font-size: 24px;
            font-weight: bold;
        }
        
        .admin-nav {
            display: flex;
            gap: 30px;
        }
        
        .admin-nav a {
            color: white;
            text-decoration: none;
            font-size: 15px;
            padding: 5px 15px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .admin-nav a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .admin-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .form-card {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .form-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-size: 14px;
            color: #333;
            margin-bottom: 8px;
            font-weight: bold;
        }
        
        .form-input, .form-textarea, .form-select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-input:focus, .form-textarea:focus, .form-select:focus {
            outline: none;
            border-color: #ff6700;
        }
        
        .form-textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .error-message {
            background-color: #fff1f0;
            color: #ff4d4f;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #ffa39e;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: #ff6700;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #ff8533;
        }
        
        .btn-default {
            background-color: #e8e8e8;
            color: #333;
        }
        
        .btn-default:hover {
            background-color: #d9d9d9;
        }
        
        .footer {
            background-color: #333;
            color: white;
            padding: 40px 50px;
            text-align: center;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <div class="admin-header">
        <div class="admin-logo">小米后台管理系统</div>
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/home">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/product/list">商品管理</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>
    
    <div class="admin-container">
        <div class="form-card">
            <h1 class="form-title">${isEdit ? '编辑商品' : '添加商品'}</h1>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/product/${isEdit ? 'edit' : 'add'}" method="post" enctype="multipart/form-data">
                <c:if test="${isEdit}">
                    <input type="hidden" name="pid" value="${product.pid}">
                    <%-- 调试信息：显示当前编辑的商品ID --%>
                    <!-- 编辑模式 - 商品ID: ${product.pid} -->
                </c:if>
                
                <div class="form-group">
                    <label class="form-label">商品名称 *</label>
                    <input type="text" name="pname" class="form-input" value="${product.pname}" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">商品描述</label>
                    <textarea name="pdesc" class="form-textarea">${product.pdesc}</textarea>
                </div>
                
                <div class="form-group">
                    <label class="form-label">价格 *</label>
                    <input type="number" name="price" class="form-input" value="${product.price}" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">商品图片</label>
                    <input type="file" name="pimageFile" id="pimageFile" accept="image/*" onchange="previewImage(this)">
                    <input type="hidden" name="pimage" id="pimage" value="${product.pimage}">
                    <div id="imagePreview" style="margin-top: 10px; ${empty product.pimage ? 'display:none;' : ''}">
                        <c:choose>
                            <c:when test="${not empty product.pimage}">
                                <img id="previewImg" src="${pageContext.request.contextPath}/images/${product.pimage}" alt="预览" style="max-width: 200px; max-height: 200px; border: 1px solid #ddd; border-radius: 5px;">
                                <p style="color: #666; font-size: 12px; margin-top: 5px;">当前图片: ${product.pimage}</p>
                            </c:when>
                            <c:otherwise>
                                <img id="previewImg" src="" alt="预览" style="max-width: 200px; max-height: 200px; border: 1px solid #ddd; border-radius: 5px; display: none;">
                                <p style="color: #666; font-size: 12px; margin-top: 5px;">当前图片: 无</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p style="color: #999; font-size: 12px; margin-top: 5px;">支持格式: jpg, jpeg, png, gif, webp，最大5MB</p>
                </div>
                
                <div class="form-group">
                    <label class="form-label">分类 *</label>
                    <select name="category" class="form-select" required>
                        <option value="">请选择分类</option>
                        <option value="1" ${product.category == 1 ? 'selected' : ''}>热门产品</option>
                        <option value="2" ${product.category == 2 ? 'selected' : ''}>智能生活</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">${isEdit ? '保存修改' : '添加商品'}</button>
                    <a href="${pageContext.request.contextPath}/admin/product/list" class="btn btn-default">取消</a>
                </div>
            </form>
        </div>
    </div>
    
    <div class="footer">
        <p style="color: #999; font-size: 12px;">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
    
    <script>
        function previewImage(input) {
            var preview = document.getElementById('imagePreview');
            var previewImg = document.getElementById('previewImg');
            
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    previewImg.src = e.target.result;
                    preview.style.display = 'block';
                };
                
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>
