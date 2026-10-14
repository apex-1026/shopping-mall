<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>小米官网 - 首页</title>
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
            position: relative;
            z-index: 1000;
        }
        
        /* Logo */
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
        
        /* 导航菜单 */
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
        
        .nav-item.active {
            color: #ff6700;
            font-weight: bold;
        }
        
        /* 右侧登录注册 */
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
        
        /* 搜索框 */
        .search-box {
            display: flex;
            align-items: center;
            margin-left: 20px;
        }
        
        .search-input {
            padding: 6px 12px;
            border: none;
            border-radius: 20px 0 0 20px;
            outline: none;
            font-size: 14px;
            width: 200px;
        }
        
        .search-btn {
            padding: 6px 15px;
            background-color: #ff6700;
            color: white;
            border: none;
            border-radius: 0 20px 20px 0;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .search-btn:hover {
            background-color: #ff8533;
        }
        
        /* 用户下拉菜单 */
        .user-menu {
            position: relative;
            display: inline-block;
        }
        
        .user-trigger {
            color: white;
            font-size: 14px;
            cursor: pointer;
            padding: 5px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        
        .user-trigger:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background-color: white;
            min-width: 120px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 4px;
            overflow: hidden;
            margin-top: 5px;
            z-index: 1000;
        }
        
        .user-menu:hover .dropdown-content {
            display: block;
        }
        
        .dropdown-item {
            display: block;
            padding: 10px 15px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s;
            white-space: nowrap;
        }
        
        .dropdown-item:hover {
            background-color: #f5f5f5;
            color: #ff6700;
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
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .user-trigger:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .user-avatar-nav {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid white;
        }
        
        .user-avatar-placeholder {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: bold;
            border: 2px solid white;
        }
        
        .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background-color: white;
            min-width: 150px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 4px;
            overflow: hidden;
            z-index: 9999;
            margin-top: 0;
            padding-top: 10px;
        }
        
        /* 添加桥接区域，防止鼠标移动时菜单消失 */
        .dropdown-menu::before {
            content: '';
            position: absolute;
            top: -10px;
            left: 0;
            right: 0;
            height: 10px;
            background: transparent;
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
        
        /* 轮播图容器 */
        .carousel-container {
            width: 100%;
            height: 600px;
            position: relative;
            overflow: hidden;
            background-color: #f5f5f5;
        }
        
        /* 轮播图容器 */
        .carousel {
            display: flex;
            width: 300%;
            height: 100%;
            transition: transform 0.5s ease-in-out;
        }
        
        /* 单个轮播项 */
        .carousel-item {
            width: 100%;
            height: 100%;
            position: relative;
            flex-shrink: 0;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .carousel-item img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            display: block;
        }
        
        /* 轮播图内容覆盖层 */
        .carousel-overlay {
            position: absolute;
            bottom: 80px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #333;
            text-align: center;
            pointer-events: none;
        }
        
        .carousel-overlay * {
            pointer-events: auto;
        }
        
        .carousel-title {
            font-size: 42px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        
        .carousel-subtitle {
            font-size: 18px;
            margin-bottom: 20px;
            color: #666;
        }
        
        .carousel-btn {
            padding: 12px 40px;
            background-color: transparent;
            color: #333;
            border: 2px solid #333;
            border-radius: 20px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            pointer-events: auto;
        }
        
        .carousel-btn:hover {
            background-color: #ff6700;
            border-color: #ff6700;
            color: white;
        }
        
        /* 左右箭头 */
        .carousel-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background-color: rgba(255, 255, 255, 0.8);
            color: #333;
            border: none;
            width: 40px;
            height: 60px;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s;
            z-index: 10;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .carousel-arrow:hover {
            background-color: rgba(255, 255, 255, 1);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        
        .carousel-arrow.prev {
            left: 0;
        }
        
        .carousel-arrow.next {
            right: 0;
        }
        
        /* 轮播指示器 */
        .carousel-indicators {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 10;
        }
        
        .indicator {
            width: 80px;
            height: 3px;
            background-color: rgba(0, 0, 0, 0.2);
            border-radius: 2px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .indicator.active {
            background-color: #ff6700;
        }
        
        .indicator:hover {
            background-color: rgba(0, 0, 0, 0.4);
        }
        
        /* 产品展示区 */
        .product-section {
            padding: 50px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .section-title {
            text-align: center;
            font-size: 32px;
            color: #333;
            margin-bottom: 40px;
        }
        
        /* 分类筛选按钮 */
        .category-filter {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 40px;
        }
        
        .category-btn {
            padding: 8px 25px;
            border: 2px solid #ff6700;
            background-color: white;
            color: #ff6700;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .category-btn:hover {
            background-color: #ff6700;
            color: white;
        }
        
        .category-btn.active {
            background-color: #ff6700;
            color: white;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .product-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }
        
        .product-image {
            width: 100%;
            height: 250px;
            background-color: #f8f8f8;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #999;
            font-size: 16px;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .product-info {
            padding: 20px;
            text-align: center;
        }
        
        .product-name {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
            font-weight: bold;
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
        
        /* 分页控件 */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 40px;
            padding: 20px 0;
        }
        
        .pagination-info {
            font-size: 14px;
            color: #666;
            margin-right: 20px;
        }
        
        .page-btn {
            padding: 8px 15px;
            border: 1px solid #ddd;
            background-color: white;
            color: #333;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-block;
        }
        
        .page-btn:hover {
            background-color: #ff6700;
            color: white;
            border-color: #ff6700;
        }
        
        .page-btn.active {
            background-color: #ff6700;
            color: white;
            border-color: #ff6700;
        }
        
        .page-btn.disabled {
            background-color: #f5f5f5;
            color: #999;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .page-numbers {
            display: flex;
            gap: 5px;
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

        /* 全局提示（一次性消息） */
        .toast {
            position: fixed;
            top: 80px;
            right: 30px;
            min-width: 200px;
            max-width: 360px;
            padding: 12px 16px;
            border-radius: 8px;
            color: #fff;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.18);
            z-index: 100000;
            font-size: 14px;
            line-height: 1.4;
        }
        .toast-success { background: rgba(76, 175, 80, 0.95); }
        .toast-error { background: rgba(244, 67, 54, 0.95); }
    </style>
</head>
<body>
    <%
        String toastMessage = (String) session.getAttribute("message");
        String toastError = (String) session.getAttribute("error");
        if (toastMessage != null) { session.removeAttribute("message"); }
        if (toastError != null) { session.removeAttribute("error"); }
    %>
    <% if (toastMessage != null) { %>
    <div class="toast toast-success" id="toast"><%= toastMessage %></div>
    <% } else if (toastError != null) { %>
    <div class="toast toast-error" id="toast"><%= toastError %></div>
    <% } %>
    <!-- 顶部导航栏 -->
    <div class="top-nav">
        <!-- Logo -->
        <div class="logo">mi</div>
        
        <!-- 导航菜单 -->
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item active">小米官网</a>
            <a href="#" class="nav-item">小米商城</a>
            <a href="#" class="nav-item">小米澎湃OS</a>
            <a href="#" class="nav-item">小米汽车</a>
            <a href="#" class="nav-item">小米影像</a>
            <a href="#" class="nav-item">云服务</a>
            <a href="#" class="nav-item">IoT</a>
            <a href="#" class="nav-item">有品</a>
            <a href="#" class="nav-item">小爱开放平台</a>
            <a href="#" class="nav-item">Location</a>
        </div>
        
        <!-- 搜索框 -->
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/product/search" method="get" style="display: flex;">
                <input type="text" name="keyword" class="search-input" placeholder="搜索商品..." required>
                <button type="submit" class="search-btn">搜索</button>
            </form>
        </div>
        
        <!-- 登录注册 -->
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
                        <div class="user-trigger">
                            <c:choose>
                                <c:when test="${not empty currentUser.avatar}">
                                    <img src="${pageContext.request.contextPath}/uploads/avatar/${currentUser.avatar}" class="user-avatar-nav" alt="头像">
                                </c:when>
                                <c:otherwise>
                                    <div class="user-avatar-placeholder">
                                        ${currentUser.username.substring(0, 1)}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <span>欢迎，${currentUser.username} ▼</span>
                        </div>
                        <div class="dropdown-menu">
                            <c:if test="${currentUser.role == 2}">
                                <a href="${pageContext.request.contextPath}/admin/index" class="dropdown-item">后台管理</a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/user/edit?uid=${currentUser.uid}" class="dropdown-item">个人资料</a>
                            <a href="${pageContext.request.contextPath}/order/list" class="dropdown-item">我的订单</a>
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item">退出登录</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <!-- 轮播图 -->
    <div class="carousel-container">
        <div class="carousel" id="carousel" style="width: 100%;">
            <!-- 轮播图 -->
            <div class="carousel-item">
                <img src="images/pms_1708570853.64084628.png" alt="小米14 Ultra" >
                <div class="carousel-overlay">
                    <h1 class="carousel-title">小米14 Ultra</h1>
                    <p class="carousel-subtitle">影像新层次 | 徕卡光学镜头</p>
                    <button class="carousel-btn">立即购买</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 产品展示区 -->
    <div class="product-section">
        <!-- 分类筛选按钮 -->
        <div class="category-filter">
            <a href="${pageContext.request.contextPath}/home" class="category-btn ${empty currentCategory ? 'active' : ''}">全部</a>
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/home?category=${cat}" class="category-btn ${currentCategory == cat ? 'active' : ''}">
                    <c:choose>
                        <c:when test="${cat == 1}">热门产品</c:when>
                        <c:when test="${cat == 2}">智能生活</c:when>
                        <c:otherwise>分类${cat}</c:otherwise>
                    </c:choose>
                </a>
            </c:forEach>
        </div>
        
        <!-- 产品网格 -->
        <div class="product-grid">
            <c:forEach var="product" items="${hotProducts}">
            <div class="product-card">
                <a href="${pageContext.request.contextPath}/product/detail?pid=${product['pid']}">
                    <div class="product-image">
                        <img src="images/${product['pimage']}" alt="${product['pname']}">
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
        
        <!-- 分页控件 -->
        <div class="pagination">
            <span class="pagination-info">
                共 ${totalProducts} 件商品，第 ${currentPage}/${totalPages} 页
            </span>
            
            <div class="page-numbers">
                <!-- 上一页 -->
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/home?page=${currentPage - 1}${currentCategory != null ? '&category=' : ''}${currentCategory}" class="page-btn">上一页</a>
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:void(0)" class="page-btn disabled">上一页</a>
                    </c:otherwise>
                </c:choose>
                
                <!-- 页码 -->
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="page-btn active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/home?page=${i}${currentCategory != null ? '&category=' : ''}${currentCategory}" class="page-btn">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <!-- 下一页 -->
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/home?page=${currentPage + 1}${currentCategory != null ? '&category=' : ''}${currentCategory}" class="page-btn">下一页</a>
                    </c:when>
                    <c:otherwise>
                        <a href="javascript:void(0)" class="page-btn disabled">下一页</a>
                    </c:otherwise>
                </c:choose>
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

    <script>
        (function () {
            var toast = document.getElementById('toast');
            if (!toast) return;
            setTimeout(function () {
                toast.style.opacity = '0';
                toast.style.transition = 'opacity 300ms ease';
                setTimeout(function () { toast.remove(); }, 350);
            }, 1800);
        })();
    </script>
</body>
</html>
