<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>用户管理 - 后台管理系统</title>
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
        
        .section-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        
        .user-table {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .user-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .user-table th {
            background-color: #1e3c72;
            color: white;
            padding: 15px;
            text-align: left;
            font-size: 14px;
        }
        
        .user-table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }
        
        .user-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .avatar-small {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #ddd;
        }
        
        .avatar-placeholder {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #1e3c72;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: bold;
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
        
        .btn-primary {
            background-color: #1890ff;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #40a9ff;
        }
        
        .btn-danger {
            background-color: #ff4d4f;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #ff7875;
        }
        
        .role-badge {
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .role-admin {
            background-color: #ff6700;
            color: white;
        }
        
        .role-user {
            background-color: #52c41a;
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
    <div class="admin-header">
        <div class="admin-logo">用户管理</div>
        <div class="admin-nav">
            <a href="${pageContext.request.contextPath}/admin/index">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/product/list">商品管理</a>
            <a href="${pageContext.request.contextPath}/home">返回前台</a>
            <a href="${pageContext.request.contextPath}/logout">退出登录</a>
        </div>
    </div>
    
    <div class="admin-container">
        <h2 class="section-title">用户列表</h2>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <div class="user-table">
            <table>
                <thead>
                    <tr>
                        <th>头像</th>
                        <th>用户名</th>
                        <th>用户ID</th>
                        <th>角色</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>
                            <c:choose>
                                <c:when test="${not empty user.avatar}">
                                    <img src="${pageContext.request.contextPath}/uploads/avatar/${user.avatar}" class="avatar-small" alt="头像">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-placeholder">
                                        ${user.username.substring(0, 1)}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${user.username}</td>
                        <td>${user.uid}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 2}">
                                    <span class="role-badge role-admin">管理员</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="role-badge role-user">普通用户</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/user/edit?uid=${user.uid}" class="btn btn-primary">编辑</a>
                            <c:if test="${user.uid != currentUser.uid}">
                                <a href="${pageContext.request.contextPath}/user/delete?uid=${user.uid}" class="btn btn-danger" 
                                   onclick="return confirm('确定要删除用户 ${user.username} 吗？此操作不可恢复！');">删除</a>
                            </c:if>
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <!-- 分页控件 -->
        <div class="pagination">
            <span class="pagination-info">
                共 ${totalCount} 个用户，第 ${currentPage}/${totalPages} 页
            </span>
            
            <c:choose>
                <c:when test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage - 1}" class="page-btn">上一页</a>
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
                        <a href="${pageContext.request.contextPath}/admin/user/list?page=${i}" class="page-btn">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:choose>
                <c:when test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/admin/user/list?page=${currentPage + 1}" class="page-btn">下一页</a>
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
