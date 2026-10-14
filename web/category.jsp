<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${categoryTitle}</title>
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
        
        .top-nav {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 0 50px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .logo {
            width: 50px;
            height: 50px;
            background-color: #ff6700;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: bold;
        }
        
        .nav-menu {
            display: flex;
            align-items: center;
            gap: 35px;
        }
        
        .nav-item {
            color: white;
            text-decoration: none;
            font-size: 15px;
        }
        
        .auth-links {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .auth-link {
            color: white;
            text-decoration: none;
            font-size: 15px;
        }
        
        .divider {
            color: white;
        }
        
        .category-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .category-header {
            background-color: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .category-title {
            font-size: 28px;
            color: #333;
            font-weight: bold;
        }
        
        .category-tabs {
            display: flex;
            gap: 10px;
        }
        
        .category-tab {
            padding: 8px 20px;
            border: 2px solid #ff6700;
            background-color: white;
            color: #ff6700;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .category-tab:hover {
            background-color: #ff6700;
            color: white;
        }
        
        .category-tab.active {
            background-color: #ff6700;
            color: white;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .product-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }
        
        .product-image {
            width: 100%;
            height: 280px;
            background-color: #fafafa;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .product-image img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        
        .product-info {
            padding: 20px;
        }
        
        .product-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .product-desc {
            font-size: 14px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .product-price {
            font-size: 20px;
            color: #ff6700;
            font-weight: bold;
        }
        
        .no-product {
            text-align: center;
            padding: 80px 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .no-product-icon {
            font-size: 80px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .no-product p {
            font-size: 18px;
            color: #999;
            margin-bottom: 10px;
        }
        
        .back-link {
            display: inline-block;
            color: #666;
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .back-link:hover {
            color: #ff6700;
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
    <div class="top-nav">
        <div class="logo">mi</div>
        
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">小米官网</a>
            <a href="${pageContext.request.contextPath}/cart/list" class="nav-item">购物车</a>
        </div>
        
        <div class="auth-links">
            <c:choose>
                <c:when test="${empty currentUser}">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="auth-link">登录</a>
                    <span class="divider">|</span>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="auth-link">注册</a>
                </c:when>
                <c:otherwise>
                    <span style="color: white; font-size: 14px;">欢迎，${currentUser.username}</span>
                    <span class="divider">|</span>
                    <a href="${pageContext.request.contextPath}/logout" class="auth-link">退出登录</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="category-container">
        <a href="${pageContext.request.contextPath}/home" class="back-link">← 返回首页</a>
        
        <div class="category-header">
            <h1 class="category-title">${categoryTitle}</h1>
            <div class="category-tabs">
                <a href="${pageContext.request.contextPath}/product/category?category=1" class="category-tab ${category == 1 ? 'active' : ''}">热门产品</a>
                <a href="${pageContext.request.contextPath}/product/category?category=2" class="category-tab ${category == 2 ? 'active' : ''}">智能生活</a>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty products}">
                <div class="no-product">
                    <div class="no-product-icon">📦</div>
                    <p>该分类下暂无商品</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="product" items="${products}">
                    <div class="product-card">
                        <a href="${pageContext.request.contextPath}/product/detail?pid=${product['pid']}">
                            <div class="product-image">
                                <img src="${pageContext.request.contextPath}/images/${product['pimage']}" alt="${product['pname']}">
                            </div>
                        </a>
                        <div class="product-info">
                            <h3 class="product-name">${product['pname']}</h3>
                            <p class="product-desc">${product['pdesc']}</p>
                            <p class="product-price">¥${product['price']}起</p>
                        </div>
                    </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <div class="footer">
        <p style="color: #999; font-size: 12px;">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
</body>
</html>
