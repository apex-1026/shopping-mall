<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>搜索结果</title>
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
        
        .search-result-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .search-header {
            background-color: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .search-info {
            font-size: 18px;
            color: #333;
        }
        
        .search-info span {
            color: #ff6700;
            font-weight: bold;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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
            height: 250px;
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
        
        .no-result {
            text-align: center;
            padding: 80px 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .no-result-icon {
            font-size: 80px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .no-result p {
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
    
    <div class="search-result-container">
        <a href="${pageContext.request.contextPath}/home" class="back-link">← 返回首页</a>
        
        <div class="search-header">
            <div class="search-info">
                搜索 "<span>${keyword}</span>" 的结果
                <c:choose>
                    <c:when test="${empty searchResults}">
                        - 共 0 件商品
                    </c:when>
                    <c:otherwise>
                        - 共 ${searchResults.size()} 件商品
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty searchResults}">
                <div class="no-result">
                    <div class="no-result-icon">🔍</div>
                    <p>未找到相关商品</p>
                    <p style="font-size: 14px; color: #bbb;">请尝试其他关键词</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="product" items="${searchResults}">
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
