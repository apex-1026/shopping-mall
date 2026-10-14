<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>我的订单</title>
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
            min-width: 120px;
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
        
        .order-list-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .page-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }
        
        .order-card {
            background-color: white;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .order-header {
            background-color: #f5f5f5;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e8e8e8;
        }
        
        .order-header-left {
            display: flex;
            gap: 30px;
        }
        
        .order-header-item {
            font-size: 14px;
            color: #666;
        }
        
        .order-header-item span {
            color: #333;
            font-weight: bold;
        }
        
        .order-status {
            color: #ff6700;
            font-weight: bold;
        }
        
        .order-items {
            padding: 20px;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item-image {
            width: 100px;
            height: 100px;
            object-fit: contain;
            margin-right: 20px;
        }
        
        .order-item-info {
            flex: 1;
        }
        
        .order-item-name {
            font-size: 16px;
            color: #333;
            margin-bottom: 8px;
        }
        
        .order-item-price {
            font-size: 14px;
            color: #ff6700;
        }
        
        .order-footer {
            padding: 15px 20px;
            background-color: #fafafa;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #e8e8e8;
        }
        
        .order-total {
            font-size: 16px;
            color: #333;
        }
        
        .order-total span {
            color: #ff6700;
            font-weight: bold;
            font-size: 20px;
        }
        
        .empty-order {
            text-align: center;
            padding: 80px 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .empty-order p {
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
        
        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
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
        
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #ff7875;
        }
        
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #ff7875;
        }
        
        .btn-success {
            background-color: #52c41a;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #73d13d;
        }
        
        .status-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .status-trigger {
            padding: 5px 15px;
            background-color: #ff6700;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .status-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background-color: white;
            min-width: 100px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            border-radius: 4px;
            overflow: hidden;
            margin-top: 5px;
            z-index: 100;
        }
        
        .status-dropdown:hover .status-menu {
            display: block;
        }
        
        .status-item {
            display: block;
            padding: 8px 15px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            transition: background-color 0.2s;
        }
        
        .status-item:hover {
            background-color: #f5f5f5;
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
        
        .batch-actions {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding: 15px 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .batch-actions label {
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            font-size: 14px;
            color: #333;
        }
        
        .batch-actions input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .batch-delete-btn {
            padding: 8px 20px;
            background-color: #ff4d4f;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .batch-delete-btn:hover {
            background-color: #ff7875;
        }
        
        .order-checkbox {
            margin-right: 15px;
        }
    </style>
</head>
<body>
    <div class="top-nav">
        <div class="logo">mi</div>
        
        <div class="nav-menu">
            <a href="${pageContext.request.contextPath}/home" class="nav-item">小米官网</a>
            <a href="${pageContext.request.contextPath}/cart/list" class="nav-item">购物车</a>
            <a href="${pageContext.request.contextPath}/order/list" class="nav-item active" style="color: #ff6700; font-weight: bold;">我的订单</a>
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
    
    <div class="order-list-container">
        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px; padding: 10px 25px; font-size: 16px;">
                ← 返回首页
            </a>
            <h1 class="page-title" style="margin: 0;">我的订单</h1>
            <div></div>
        </div>
        
        <!-- 批量操作栏 -->
        <c:if test="${not empty orderList}">
            <div class="batch-actions">
                <label>
                    <input type="checkbox" id="selectAll" onclick="toggleSelectAll()">
                    <span>全选</span>
                </label>
                <span id="selectedCount" style="color: #666; font-size: 14px;">已选择 0 个订单</span>
                <button type="button" class="batch-delete-btn" onclick="batchDelete()">批量删除</button>
            </div>
        </c:if>
        
        <!-- 提示信息 -->
        <c:if test="${not empty message}">
            <div style="background-color: #f6ffed; border: 1px solid #b7eb8f; padding: 15px; border-radius: 8px; margin-bottom: 20px; color: #52c41a;">
                ${message}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="background-color: #fff2f0; border: 1px solid #ffccc7; padding: 15px; border-radius: 8px; margin-bottom: 20px; color: #ff4d4f;">
                ${error}
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty orderList}">
                <div class="empty-order">
                    <p>暂无订单，快去购物吧！</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">去购物</a>
                </div>
            </c:when>
            <c:otherwise>
                <form action="${pageContext.request.contextPath}/order/batchDelete" method="post" id="batchDeleteForm">
                    <c:forEach var="order" items="${orderList}" varStatus="status">
                    <div class="order-card">
                        <div class="order-header">
                            <div style="display: flex; align-items: center;">
                                <input type="checkbox" name="orderIds" value="${order.orderId}" class="order-checkbox" onchange="updateSelectedCount()">
                                <div class="order-header-left">
                                    <div class="order-header-item">
                                        订单编号：<span>${order.orderId}</span>
                                    </div>
                                    <div class="order-header-item">
                                        下单时间：<span><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
                                    </div>
                                </div>
                            </div>
                        <div class="status-dropdown">
                            <c:choose>
                                <c:when test="${order.status == 1}">
                                    <button class="status-trigger" style="background-color: #ff6700;">待付款 ▼</button>
                                </c:when>
                                <c:when test="${order.status == 2}">
                                    <button class="status-trigger" style="background-color: #1890ff;">已付款 ▼</button>
                                </c:when>
                                <c:when test="${order.status == 3}">
                                    <button class="status-trigger" style="background-color: #52c41a;">已发货 ▼</button>
                                </c:when>
                                <c:when test="${order.status == 4}">
                                    <button class="status-trigger" style="background-color: #999;">已完成 ▼</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="status-trigger">未知状态 ▼</button>
                                </c:otherwise>
                            </c:choose>
                            <div class="status-menu">
                                <form action="${pageContext.request.contextPath}/order/updateStatus" method="post">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <input type="hidden" name="status" value="1">
                                    <button type="submit" class="status-item">待付款</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/order/updateStatus" method="post">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <input type="hidden" name="status" value="2">
                                    <button type="submit" class="status-item">已付款</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/order/updateStatus" method="post">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <input type="hidden" name="status" value="3">
                                    <button type="submit" class="status-item">已发货</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/order/updateStatus" method="post">
                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                    <input type="hidden" name="status" value="4">
                                    <button type="submit" class="status-item">已完成</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <div class="order-items">
                        <c:choose>
                            <c:when test="${empty order.items}">
                                <div style="color: #999; font-size: 14px; padding: 10px 0;">该订单暂无商品明细（历史订单可能未保存明细）</div>
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
                    
                    <div class="order-footer">
                        <div class="order-total">
                            订单总额：<span>¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></span>
                        </div>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <c:choose>
                                <c:when test="${order.status == 1}">
                                    <!-- 进入支付准备接口，由后端生成支付参数并跳转支付页 -->
                                    <form action="${pageContext.request.contextPath}/order/pay" method="get" style="margin: 0;">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <button type="submit" class="btn btn-primary">去付款</button>
                                    </form>
                                </c:when>
                                <c:when test="${order.status == 2}">
                                    <span style="color: #1890ff; font-size: 14px;">已付款</span>
                                </c:when>
                                <c:when test="${order.status == 3}">
                                    <span style="color: #52c41a; font-size: 14px;">已发货</span>
                                </c:when>
                                <c:when test="${order.status == 4}">
                                    <span style="color: #999; font-size: 14px;">已完成</span>
                                </c:when>
                            </c:choose>
                            
                            <!-- 删除订单按钮 -->
                            <form action="${pageContext.request.contextPath}/order/delete" method="post" style="margin: 0;" onsubmit="return confirm('确定要删除这个订单吗？此操作不可恢复！');">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <button type="submit" class="btn btn-danger">删除订单</button>
                            </form>
                            
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">继续购物</a>
                        </div>
                    </div>
                </div>
                </c:forEach>
            </form>
        </c:otherwise>
    </c:choose>
        
        <!-- 分页导航 -->
        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage == 1}">
                    <span class="disabled">上一页</span>
                </c:if>
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/order/list?page=${currentPage - 1}">上一页</a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="current">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/order/list?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/order/list?page=${currentPage + 1}">下一页</a>
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
    
    <script>
        /* 全选/取消全选 */
        function toggleSelectAll() {
            var selectAll = document.getElementById('selectAll');
            var checkboxes = document.querySelectorAll('.order-checkbox');
            checkboxes.forEach(function(checkbox) {
                checkbox.checked = selectAll.checked;
            });
            updateSelectedCount();
        }
        
        /* 更新已选择数量 */
        function updateSelectedCount() {
            var checkboxes = document.querySelectorAll('.order-checkbox:checked');
            var count = checkboxes.length;
            document.getElementById('selectedCount').textContent = '已选择 ' + count + ' 个订单';
        }
        
        /* 批量删除 */
        function batchDelete() {
            var checkboxes = document.querySelectorAll('.order-checkbox:checked');
            if (checkboxes.length === 0) {
                alert('请至少选择一个订单！');
                return;
            }
            
            if (confirm('确定要删除选中的 ' + checkboxes.length + ' 个订单吗？此操作不可恢复！')) {
                document.getElementById('batchDeleteForm').submit();
            }
        }
    </script>
</body>
</html>
