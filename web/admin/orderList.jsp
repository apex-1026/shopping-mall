<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>订单管理 - 后台管理系统</title>
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

        .filter-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 16px;
            background: #fff;
            padding: 12px 16px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .filter-bar select {
            padding: 6px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .filter-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
        }

        .filter-submit {
            background: #1890ff;
            color: #fff;
        }

        .filter-reset {
            background: #f0f0f0;
            color: #333;
            text-decoration: none;
            display: inline-block;
        }
        
        .section-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        
        .order-table {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .order-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .order-table th {
            background-color: #1e3c72;
            color: white;
            padding: 15px;
            text-align: left;
            font-size: 14px;
        }
        
        .order-table th:first-child,
        .order-table td:first-child {
            width: 50px;
            text-align: center;
        }
        
        .order-checkbox {
            width: 18px;
            height: 18px;
            cursor: pointer;
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
        
        .order-table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }
        
        .order-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .btn {
            padding: 6px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            text-decoration: none;
            display: inline-block;
            margin-right: 5px;
            transition: all 0.3s;
        }
        
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #ff7875;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-1 {
            background-color: #faad14;
            color: white;
        }
        
        .status-2 {
            background-color: #1890ff;
            color: white;
        }
        
        .status-3 {
            background-color: #52c41a;
            color: white;
        }
        
        .status-4 {
            background-color: #999;
            color: white;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
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
            background-color: #1890ff;
            color: white;
            border-color: #1890ff;
        }
        
        .page-btn.active {
            background-color: #1890ff;
            color: white;
            border-color: #1890ff;
        }
        
        .page-btn.disabled {
            background-color: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }
        
        .error-message {
            color: #ff4d4f;
            background-color: #fff1f0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            border: 1px solid #ffa39e;
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
        <div class="admin-logo">订单管理</div>
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/index">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/user/list">用户管理</a>
            <a href="${pageContext.request.contextPath}/admin/product/list">商品管理</a>
            <a href="${pageContext.request.contextPath}/home">返回前台</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>
    
    <div class="admin-container">
        <h2 class="section-title">订单列表</h2>

        <form action="${pageContext.request.contextPath}/admin/order/list" method="get" class="filter-bar">
            <span>状态筛选：</span>
            <select name="status">
                <option value="" ${empty selectedStatus ? 'selected' : ''}>全部</option>
                <option value="1" ${selectedStatus == 1 ? 'selected' : ''}>待付款</option>
                <option value="2" ${selectedStatus == 2 ? 'selected' : ''}>已付款</option>
                <option value="3" ${selectedStatus == 3 ? 'selected' : ''}>已发货</option>
                <option value="4" ${selectedStatus == 4 ? 'selected' : ''}>已完成</option>
            </select>
            <button type="submit" class="filter-btn filter-submit">查询</button>
            <a href="${pageContext.request.contextPath}/admin/order/list" class="filter-btn filter-reset">重置</a>
        </form>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
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
        
        <form action="${pageContext.request.contextPath}/order/batchDelete" method="post" id="batchDeleteForm">
        <div class="order-table">
            <table>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAllHeader" onclick="toggleSelectAll()"></th>
                        <th>订单ID</th>
                        <th>用户</th>
                        <th>订单金额</th>
                        <th>下单时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td><input type="checkbox" name="orderIds" value="${order.orderId}" class="order-checkbox" onchange="updateSelectedCount()"></td>
                        <td>${order.orderId}</td>
                        <td>${order.userName}</td>
                        <td>¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></td>
                        <td><fmt:formatDate value="${order.orderTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/order/updateStatus" method="post" style="display: inline;">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <select name="status" onchange="if(confirm('确定要将订单 ${order.orderId} 的状态修改为 ' + this.options[this.selectedIndex].text + ' 吗？')){this.form.submit();} else {this.value='${order.status}';}" style="padding: 4px 12px; border-radius: 12px; border: none; font-size: 12px; font-weight: bold; cursor: pointer; background-color: ${order.status == 1 ? '#faad14' : order.status == 2 ? '#1890ff' : order.status == 3 ? '#52c41a' : '#999'}; color: white;">
                                    <option value="1" ${order.status == 1 ? 'selected' : ''}>待付款</option>
                                    <option value="2" ${order.status == 2 ? 'selected' : ''}>已付款</option>
                                    <option value="3" ${order.status == 3 ? 'selected' : ''}>已发货</option>
                                    <option value="4" ${order.status == 4 ? 'selected' : ''}>已完成</option>
                                </select>
                            </form>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/order/delete" method="post" style="display: inline;">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <button type="submit" class="btn btn-danger" 
                                        onclick="return confirm('确定要删除订单 ${order.orderId} 吗？此操作不可恢复！');">删除</button>
                            </form>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        </form>
        
        <!-- 分页控件 -->
        <div class="pagination">
            <span class="pagination-info">
                共 ${totalCount} 个订单，第 ${currentPage}/${totalPages} 页
            </span>
            
            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/admin/order/list?page=${currentPage - 1}${statusQuery}" class="page-btn">上一页</a>
                </c:when>
                <c:otherwise>
                    <a href="javascript:void(0)" class="page-btn disabled">上一页</a>
                </c:otherwise>
            </c:choose>
            
            <c:forEach var="i" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="page-btn active">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/admin/order/list?page=${i}${statusQuery}" class="page-btn">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/admin/order/list?page=${currentPage + 1}${statusQuery}" class="page-btn">下一页</a>
                </c:when>
                <c:otherwise>
                    <a href="javascript:void(0)" class="page-btn disabled">下一页</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="footer">
        <p style="color: #999; font-size: 12px;">© 2026 Xiaomi. All Rights Reserved. | 仅供学习使用</p>
    </div>
    
    <script>
        /* 全选/取消全选 */
        function toggleSelectAll() {
            var selectAll = document.getElementById('selectAll');
            var selectAllHeader = document.getElementById('selectAllHeader');
            var checkboxes = document.querySelectorAll('.order-checkbox');
            
            // 同步两个全选按钮的状态
            if (event.target.id === 'selectAll') {
                selectAllHeader.checked = selectAll.checked;
            } else {
                selectAll.checked = selectAllHeader.checked;
            }
            
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
