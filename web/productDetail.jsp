<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>${product['pname']} - 商品详情</title>
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
        
        /* 顶部导航栏 */
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
            cursor: pointer;
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
            padding: 5px 0;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .nav-item:hover {
            color: #ff6700;
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
            padding: 5px 15px;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .auth-link:hover {
            color: #ff6700;
        }
        
        .divider {
            color: white;
            font-size: 15px;
        }
        
        /* 商品详情容器 */
        .product-detail-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .product-detail-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: flex;
            gap: 40px;
            padding: 40px;
        }
        
        .product-image-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .product-image-section img {
            max-width: 100%;
            max-height: 500px;
            object-fit: contain;
        }
        
        .product-info-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .product-title {
            font-size: 32px;
            font-weight: bold;
            color: #333;
        }
        
        .product-desc {
            font-size: 16px;
            color: #666;
            line-height: 1.6;
        }
        
        .product-price {
            font-size: 36px;
            color: #ff6700;
            font-weight: bold;
        }
        
        .product-price span {
            font-size: 20px;
        }
        
        .add-to-cart-btn {
            padding: 15px 40px;
            background-color: #ff6700;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s;
            width: fit-content;
        }
        
        .add-to-cart-btn:hover {
            background-color: #ff8533;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(255, 103, 0, 0.3);
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
        
        /* 底部 */
        .footer {
            background-color: #333;
            color: white;
            padding: 40px 50px;
            text-align: center;
            margin-top: 50px;
        }
        
        .footer-links {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 20px;
        }
        
        .footer-link {
            color: #ccc;
            text-decoration: none;
            font-size: 14px;
        }
        
        .footer-link:hover {
            color: #ff6700;
        }
        
        .footer-text {
            color: #999;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <!-- 顶部导航栏 -->
    <div class="top-nav">
        <div class="logo">mi</div>
        
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">小米官网</a>
            <a href="#" class="nav-item">小米商城</a>
            <a href="#" class="nav-item">小米澎湃OS</a>
            <a href="#" class="nav-item">小米汽车</a>
        </div>
        
        <div class="auth-links">
            <a href="${pageContext.request.contextPath}/cart/list" class="auth-link">购物车</a>
            <span class="divider">|</span>
            <c:choose>
                <c:when test="${empty currentUser}">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="auth-link">登录</a>
                    <span class="divider">|</span>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="auth-link">注册</a>
                </c:when>
                <c:otherwise>
                    <div class="user-dropdown">
                        <span class="user-trigger">欢迎，${currentUser.username} ▼</span>
                        <div class="dropdown-menu">
                            <a href="${pageContext.request.contextPath}/order/list" class="dropdown-item">我的订单</a>
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">退出登录</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- 商品详情 -->
    <div class="product-detail-container">
        <a href="${pageContext.request.contextPath}/home" class="back-link">← 返回首页</a>
        
        <div class="product-detail-card">
            <!-- 商品图片 -->
            <div class="product-image-section">
                <img src="${pageContext.request.contextPath}/images/${product['pimage']}" alt="${product['pname']}">
            </div>
            
            <!-- 商品信息 -->
            <div class="product-info-section">
                <h1 class="product-title">${product['pname']}</h1>
                <p class="product-desc">${product['pdesc']}</p>
                <p class="product-price"><span>¥</span>${product['price']}</p>
                <form action="${pageContext.request.contextPath}/cart/add" method="post" style="margin: 0;">
                    <input type="hidden" name="pid" value="${product['pid']}">
                    <button type="submit" class="add-to-cart-btn">加入购物车</button>
                </form>
            </div>
        </div>
    </div>
    
    <!-- 底部 -->
    <div class="footer">
        <div class="footer-links">
            <a href="#" class="footer-link">帮助中心</a>
            <a href="#" class="footer-link">账户管理</a>
            <a href="#" class="footer-link">售后服务</a>
            <a href="#" class="footer-link">关于我们</a>
            <a href="#" class="footer-link">联系我们</a>
        </div>
        <p class="footer-text">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
</body>
</html>
