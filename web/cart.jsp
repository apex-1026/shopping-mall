<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>购物车</title>
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
            transition: all 0.3s;
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
            transition: all 0.3s;
        }
        
        .auth-link:hover {
            color: #ff6700;
        }
        
        .divider {
            color: white;
        }
        
        /* 用户下拉菜单 */
        .user-dropdown {
            position: relative;
            display: inline-block;
            margin-left: 10px;
        }
        
        .user-trigger {
            color: white;
            font-size: 14px;
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .user-trigger:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background-color: white;
            min-width: 120px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 4px;
            overflow: hidden;
            z-index: 100;
            margin-top: 5px;
        }
        
        .user-dropdown:hover .dropdown-menu {
            display: block;
        }
        
        .dropdown-item {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            transition: background-color 0.2s;
            white-space: nowrap;
        }
        
        .dropdown-item:hover {
            background-color: #f5f5f5;
            color: #ff6700;
        }
        
        .cart-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .cart-header {
            background-color: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .cart-title {
            font-size: 28px;
            font-weight: bold;
            color: #333;
        }
        
        .cart-item {
            background-color: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .cart-item-image {
            width: 120px;
            height: 120px;
            object-fit: contain;
        }
        
        .cart-item-info {
            flex: 1;
        }
        
        .cart-item-name {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .cart-item-price {
            font-size: 18px;
            color: #ff6700;
            font-weight: bold;
        }
        
        .cart-item-quantity {
            font-size: 16px;
            color: #666;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0;
        }
        
        .quantity-btn {
            width: 32px;
            height: 32px;
            border: 1px solid #ddd;
            background-color: #f5f5f5;
            color: #333;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }
        
        .quantity-btn:hover:not(:disabled) {
            background-color: #ff6700;
            color: white;
            border-color: #ff6700;
        }
        
        .quantity-btn:disabled {
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        .quantity-btn:first-child {
            border-radius: 5px 0 0 5px;
        }
        
        .quantity-btn:last-child {
            border-radius: 0 5px 5px 0;
        }
        
        .quantity-input {
            width: 50px;
            height: 32px;
            border: 1px solid #ddd;
            border-left: none;
            border-right: none;
            text-align: center;
            font-size: 16px;
            color: #333;
            outline: none;
        }
        
        .cart-item-total {
            font-size: 20px;
            color: #ff6700;
            font-weight: bold;
            min-width: 150px;
            text-align: right;
        }
        
        .remove-btn {
            padding: 8px 20px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .remove-btn:hover {
            background-color: #ff7875;
        }
        
        .cart-footer {
            background-color: white;
            padding: 20px 30px;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .total-price {
            font-size: 24px;
            color: #333;
        }
        
        .total-price span {
            color: #ff6700;
            font-weight: bold;
            font-size: 32px;
        }
        
        .checkout-btn {
            padding: 15px 40px;
            background-color: #ff6700;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .checkout-btn:hover {
            background-color: #ff8533;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .empty-cart p {
            font-size: 18px;
            color: #999;
            margin-bottom: 20px;
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
    <div class="top-nav">
        <div class="logo">mi</div>
        
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">小米官网</a>
            <a href="#" class="nav-item">小米商城</a>
        </div>
        
        <div class="auth-links">
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
    
    <div class="cart-container">
        <a href="${pageContext.request.contextPath}/home" class="back-link">← 返回首页</a>
        
        <div class="cart-header">
            <h1 class="cart-title">我的购物车</h1>
        </div>
        
        <c:choose>
            <c:when test="${empty cart}">
                <div class="empty-cart">
                    <p>购物车是空的，快去选购商品吧！</p>
                    <a href="${pageContext.request.contextPath}/home" style="color: #ff6700; text-decoration: none;">去购物</a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="item" items="${cart}">
                <div class="cart-item">
                    <img src="${pageContext.request.contextPath}/images/${item.pimage}" alt="${item.pname}" class="cart-item-image">
                    
                    <div class="cart-item-info">
                        <div class="cart-item-name">${item.pname}</div>
                        <div class="cart-item-price">¥${item.price}</div>
                        
                        <!-- 数量加减控件 -->
                        <div class="quantity-control">
                            <form action="${pageContext.request.contextPath}/cart/update" method="post" style="margin: 0; display: inline;">
                                <input type="hidden" name="pid" value="${item.pid}">
                                <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                <button type="submit" class="quantity-btn" ${item.quantity <= 1 ? 'disabled style="cursor: not-allowed; opacity: 0.5;"' : ''}>−</button>
                            </form>
                            <input type="text" class="quantity-input" value="${item.quantity}" readonly>
                            <form action="${pageContext.request.contextPath}/cart/update" method="post" style="margin: 0; display: inline;">
                                <input type="hidden" name="pid" value="${item.pid}">
                                <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                <button type="submit" class="quantity-btn" ${item.quantity >= 99 ? 'disabled style="cursor: not-allowed; opacity: 0.5;"' : ''}>+</button>
                            </form>
                        </div>
                    </div>
                    
                    <div class="cart-item-total">
                        ¥${item.totalPrice}
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/cart/remove" method="post" style="margin: 0;">
                        <input type="hidden" name="pid" value="${item.pid}">
                        <button type="submit" class="remove-btn">删除</button>
                    </form>
                </div>
                </c:forEach>
                
                <div class="cart-footer">
                    <div class="total-price">
                        总计：<span>¥${totalPrice}</span>
                    </div>
                    <form action="${pageContext.request.contextPath}/order/create" method="post" style="margin: 0;">
                        <button type="submit" class="checkout-btn">去结算</button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <div class="footer">
        <div class="footer-links">
            <a href="#" class="footer-link">帮助中心</a>
            <a href="#" class="footer-link">账户管理</a>
            <a href="#" class="footer-link">售后服务</a>
        </div>
        <p class="footer-text">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
</body>
</html>
