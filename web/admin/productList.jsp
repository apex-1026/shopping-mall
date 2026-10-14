<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>商品管理</title>
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
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .page-title {
            font-size: 28px;
            color: #333;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
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
        
        .btn-success {
            background-color: #52c41a;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #73d13d;
        }
        
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #ff7875;
        }
        
        .product-table {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background-color: #f5f5f5;
            padding: 15px;
            text-align: left;
            font-weight: bold;
            color: #333;
            border-bottom: 2px solid #e8e8e8;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .product-image {
            width: 60px;
            height: 60px;
            object-fit: contain;
        }
        
        .action-btns {
            display: flex;
            gap: 10px;
        }
        
        .footer {
            background-color: #333;
            color: white;
            padding: 40px 50px;
            text-align: center;
            margin-top: 50px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 20px 0;
        }
        
        .pagination a, .pagination span {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background-color: #ff6700;
            color: white;
            border-color: #ff6700;
        }
        
        .pagination .current {
            background-color: #ff6700;
            color: white;
            border-color: #ff6700;
        }
        
        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="admin-header">
        <div class="admin-logo">小米后台管理系统</div>
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/home">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/index">管理首页</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>
    
    <div class="admin-container">
        <div class="page-header">
            <h1 class="page-title">商品管理</h1>
            <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary">添加商品</a>
        </div>
        
        <div class="product-table">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>图片</th>
                        <th>商品名称</th>
                        <th>描述</th>
                        <th>价格</th>
                        <th>分类</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                    <tr>
                        <td>${product.pid}</td>
                        <td>
                            <img src="${pageContext.request.contextPath}/images/${product.pimage}" alt="${product.pname}" class="product-image">
                        </td>
                        <td>${product.pname}</td>
                        <td>${product.pdesc}</td>
                        <td>¥${product.price}</td>
                        <td>
                            <c:choose>
                                <c:when test="${product.category == 1}">热门产品</c:when>
                                <c:when test="${product.category == 2}">智能生活</c:when>
                                <c:otherwise>其他</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-btns">
                                <a href="${pageContext.request.contextPath}/admin/product/edit?pid=${product.pid}" class="btn btn-success">编辑</a>
                                <form action="${pageContext.request.contextPath}/admin/product/delete" method="post" style="margin: 0;" onsubmit="return confirm('确定要删除这个商品吗？');">
                                    <input type="hidden" name="pid" value="${product.pid}">
                                    <button type="submit" class="btn btn-danger">删除</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- 分页导航 -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage == 1}">
                    <span class="disabled">上一页</span>
                </c:if>
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/admin/product/list?page=${currentPage - 1}">上一页</a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="current">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/product/list?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/admin/product/list?page=${currentPage + 1}">下一页</a>
                </c:if>
                <c:if test="${currentPage == totalPages}">
                    <span class="disabled">下一页</span>
                </c:if>
            </div>
            <p style="text-align: center; color: #666; margin-top: 10px;">共 ${totalCount} 条记录，第 ${currentPage}/${totalPages} 页</p>
        </c:if>
    </div>
    
    <div class="footer">
        <p style="color: #999; font-size: 12px;">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
</body>
</html>
