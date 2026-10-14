<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>后台管理</title>
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
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .stat-title {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #ff6700;
        }
        
        .section-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        
        .product-list {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .product-item {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .product-item:last-child {
            border-bottom: none;
        }
        
        .product-item-image {
            width: 80px;
            height: 80px;
            object-fit: contain;
            margin-right: 20px;
        }
        
        .product-item-info {
            flex: 1;
        }
        
        .product-item-name {
            font-size: 16px;
            color: #333;
            margin-bottom: 5px;
        }
        
        .product-item-price {
            font-size: 14px;
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
    <div class="admin-header">
        <div class="admin-logo">小米后台管理系统</div>
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/home">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/user/list">用户管理</a>
            <a href="${pageContext.request.contextPath}/admin/product/list">商品管理</a>
            <a href="${pageContext.request.contextPath}/admin/order/list">订单管理</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>
    <div class="admin-container">
        <!-- 统计卡片 -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-title">今日订单</div>
                <div class="stat-value">${statistics.todayOrders}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">今日销售额</div>
                <div class="stat-value">¥${String.format("%.2f", statistics.todaySales)}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">总订单数</div>
                <div class="stat-value">${statistics.totalOrders}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">总销售额</div>
                <div class="stat-value">¥${String.format("%.2f", statistics.totalSales)}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">商品总数</div>
                <div class="stat-value">${statistics.totalProducts}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">用户总数</div>
                <div class="stat-value">${statistics.totalUsers}</div>
            </div>
        </div>
        
        <h2 class="section-title">最近添加的商品</h2>
        
        <div class="product-list">
            <c:forEach var="product" items="${recentProducts}">
            <div class="product-item">
                <img src="${pageContext.request.contextPath}/images/${product.pimage}" alt="${product.pname}" class="product-item-image">
                <div class="product-item-info">
                    <div class="product-item-name">${product.pname}</div>
                    <div class="product-item-price">¥${product.price}</div>
                </div>
            </div>
            </c:forEach>
        </div>
    </div>
    
    <div class="footer">
        <p style="color: #999; font-size: 12px;">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
</body>
</html>
