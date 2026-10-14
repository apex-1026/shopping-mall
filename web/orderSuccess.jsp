<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单成功</title>
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
        
        .success-container {
            max-width: 800px;
            margin: 60px auto;
            padding: 0 20px;
        }
        
        .success-card {
            background-color: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .success-icon {
            font-size: 80px;
            color: #52c41a;
            margin-bottom: 20px;
        }
        
        .success-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }
        
        .order-info {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .order-info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .order-info-label {
            color: #666;
        }
        
        .order-info-value {
            color: #333;
            font-weight: bold;
        }
        
        .order-items {
            text-align: left;
            margin-bottom: 30px;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #e8e8e8;
        }
        
        .order-item-image {
            width: 80px;
            height: 80px;
            object-fit: contain;
            margin-right: 20px;
        }
        
        .order-item-info {
            flex: 1;
        }
        
        .order-item-name {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }
        
        .order-item-price {
            font-size: 14px;
            color: #ff6700;
        }
        
        .action-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 40px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
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
    <div class="top-nav">
        <div class="logo">mi</div>
        
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">小米官网</a>
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
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">退出登录</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="success-container">
        <div class="success-card">
            <div class="success-icon">✓</div>
            <h1 class="success-title">订单提交成功！</h1>
            <p class="success-message">感谢您的购买，我们将尽快为您发货</p>
            
            <div class="order-info">
                <div class="order-info-item">
                    <span class="order-info-label">订单编号：</span>
                    <span class="order-info-value">${order.orderId}</span>
                </div>
                <div class="order-info-item">
                    <span class="order-info-label">下单时间：</span>
                    <span class="order-info-value">
                        <fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                    </span>
                </div>
                <div class="order-info-item">
                    <span class="order-info-label">订单金额：</span>
                    <span class="order-info-value" style="color: #ff6700; font-size: 20px;">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></span>
                </div>
                <div class="order-info-item">
                    <span class="order-info-label">订单状态：</span>
                    <span class="order-info-value" style="color: #52c41a;">待付款</span>
                </div>
            </div>
            
            <div class="order-items">
                <c:choose>
                    <c:when test="${empty order.items}">
                        <div style="color: #999; font-size: 14px; padding: 10px 0;">该订单暂无商品明细</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${order.items}">
                        <div class="order-item">
                            <img src="${pageContext.request.contextPath}/images/${item.pimage}" alt="${item.pname}" class="order-item-image">
                            <div class="order-item-info">
                                <div class="order-item-name">${item.pname}</div>
                                <div class="order-item-price">¥<fmt:formatNumber value="${item.price}" pattern="0.00"/> × ${item.quantity}</div>
                            </div>
                        </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-default">返回首页</a>
                <a href="${pageContext.request.contextPath}/order/list" class="btn btn-primary">查看订单</a>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <p style="color: #999; font-size: 12px;">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
</body>
</html>
