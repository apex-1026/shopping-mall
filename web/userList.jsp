<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>用户列表</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 20px;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        table { 
            border-collapse: collapse; 
            width: 100%;
            margin: 20px 0;
        }
        th, td { 
            border: 1px solid #ddd; 
            padding: 12px; 
            text-align: center; 
        }
        th { 
            background-color: #4CAF50; 
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .btn {
            padding: 6px 12px;
            margin: 0 3px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        .btn-edit {
            background-color: #2196F3;
            color: white;
        }
        .btn-edit:hover {
            background-color: #0b7dda;
        }
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
        .btn-delete:hover {
            background-color: #da190b;
        }
        .btn-add {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
        }
        .btn-add:hover {
            background-color: #45a049;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .header h2 {
            margin: 0;
        }
        .error-message {
            color: #f44336;
            background-color: #ffebee;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }
        .success-message {
            color: #4CAF50;
            background-color: #e8f5e9;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }

        /* 全局提示（一次性消息） */
        .toast {
            position: fixed;
            top: 30px;
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
        .logout-link {
            color: #666;
            text-decoration: none;
            margin-left: 10px;
        }
        .logout-link:hover {
            text-decoration: underline;
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
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .pagination .current {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        
        .pagination .disabled {
            color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<div class="container">
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
    <div class="header">
        <h2>用户列表</h2>
        <div>
            <a href="${pageContext.request.contextPath}/user/register" class="btn btn-add">新增用户</a>
            <a href="javascript:void(0)" onclick="logout()" class="logout-link">退出登录</a>
        </div>
    </div>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error-message"><%= error %></div>
    <%
        }
    %>

    <table>
        <tr>
            <th>ID</th>
            <th>账号</th>
            <th>密码</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${userList}" var="user">
            <tr>
                <td>${user.uid}</td>
                <td>${user.username}</td>
                <td>${user.password}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/user/edit?uid=${user.uid}" class="btn btn-edit">修改</a>
                    <a href="javascript:void(0)" onclick="confirmDelete('${user.uid}')" class="btn btn-delete">删除</a>
                </td>
            </tr>
        </c:forEach>
    </table>
    
    <!-- 分页导航 -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${currentPage == 1}">
                <span class="disabled">上一页</span>
            </c:if>
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/user/list?page=${currentPage - 1}">上一页</a>
            </c:if>
            
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/user/list?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/user/list?page=${currentPage + 1}">下一页</a>
            </c:if>
            <c:if test="${currentPage == totalPages}">
                <span class="disabled">下一页</span>
            </c:if>
        </div>
        <p style="text-align: center; color: #666; margin-top: 10px;">共 ${totalCount} 条记录，第 ${currentPage}/${totalPages} 页</p>
    </c:if>
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

    function confirmDelete(uid) {
        if (confirm('确定要删除该用户吗？')) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/user/delete';
            
            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'uid';
            input.value = uid;
            form.appendChild(input);
            
            document.body.appendChild(form);
            form.submit();
        }
    }

    function logout() {
        if (confirm('确定要退出登录吗？')) {
            window.location.href = '${pageContext.request.contextPath}/logout';
        }
    }
</script>
</body>
</html>