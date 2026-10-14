<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>编辑用户</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .edit-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #666;
            font-weight: bold;
        }
        input[type="text"],
        input[type="password"],
        input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .avatar-upload {
            margin-bottom: 20px;
            text-align: center;
        }
        .avatar-upload .current-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #4CAF50;
            margin-bottom: 10px;
        }
        .avatar-upload .avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px dashed #ddd;
            margin: 10px auto;
            display: none;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-cancel {
            background-color: #999;
        }
        .btn-cancel:hover {
            background-color: #777;
        }
        .error-message {
            color: #f44336;
            background-color: #ffebee;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }
        .uid-display {
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            color: #666;
        }
        .hint {
            color: #666;
            font-size: 12px;
            margin-top: 6px;
        }
        .client-error {
            color: #f44336;
            font-size: 12px;
            margin-top: 6px;
        }
        .checkbox-row {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 8px;
            font-size: 13px;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="edit-container">
        <h2>编辑用户</h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <%
            }
        %>

        <div class="uid-display">
            <strong>用户ID：</strong>${user.uid}
        </div>

        <form id="editForm" action="${pageContext.request.contextPath}/user/edit" method="post" enctype="multipart/form-data" onsubmit="return validateAndSubmit()">
            <input type="hidden" name="uid" value="${user.uid}">
            <input type="hidden" id="originalUsername" value="${user.username}">
            <input type="hidden" id="originalPassword" value="${user.password}">
            <input type="hidden" id="originalAvatar" value="${user.avatar}">

            <!-- 头像上传区域（必须在 form 内，否则文件不会提交） -->
            <div class="avatar-upload">
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${pageContext.request.contextPath}/uploads/avatar/${user.avatar}" class="current-avatar" alt="当前头像">
                        <p style="color: #666; font-size: 12px;">当前头像</p>
                    </c:when>
                    <c:otherwise>
                        <div style="width: 100px; height: 100px; border-radius: 50%; background-color: #f0f0f0; margin: 0 auto 10px; display: flex; align-items: center; justify-content: center; font-size: 36px; color: #999;">
                            ${user.username.substring(0, 1)}
                        </div>
                        <p style="color: #666; font-size: 12px;">暂无头像</p>
                    </c:otherwise>
                </c:choose>

                <div class="avatar-preview" id="avatarPreview">
                    <img id="previewImg" src="" alt="新头像预览">
                </div>

                <label for="avatarFile" style="cursor: pointer; color: #4CAF50; font-size: 14px;">
                    📷 点击更换头像
                </label>
                <input type="file" id="avatarFile" name="avatarFile" accept="image/*" onchange="previewAvatar(this)" style="display: none;">
                <div class="checkbox-row">
                    <input type="checkbox" id="removeAvatar" name="removeAvatar">
                    <label for="removeAvatar" style="margin: 0; font-weight: normal; cursor: pointer;">恢复默认头像</label>
                </div>
                <p class="hint">支持jpg、jpeg、png、gif、webp，最大2MB</p>
                <p class="client-error" id="clientError" style="display: none;"></p>
            </div>
            
            <div class="form-group">
                <label for="username">用户名：</label>
                <input type="text" id="username" name="username" value="${user.username}" required placeholder="请输入用户名">
            </div>

            <div class="form-group">
                <label for="password">密码：</label>
                <input type="password" id="password" name="password" value="${user.password}" required placeholder="请输入密码（至少6位）">
            </div>

            <div class="form-group">
                <label for="confirmPassword">确认密码：</label>
                <input type="password" id="confirmPassword" name="confirmPassword" value="${user.password}" required placeholder="请再次输入密码">
            </div>

            <button id="submitBtn" type="submit" class="btn">保存修改</button>
            <button type="button" class="btn btn-cancel" onclick="history.back()">取消</button>
        </form>
    </div>

    <script>
        var maxSize = 2 * 1024 * 1024;
        var allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];

        /* 头像预览功能 */
        function previewAvatar(input) {
            hideClientError();
            var removeAvatar = document.getElementById('removeAvatar');
            if (removeAvatar) {
                removeAvatar.checked = false;
            }

            if (input.files && input.files[0]) {
                var file = input.files[0];
                if (allowedTypes.indexOf(file.type) === -1) {
                    input.value = '';
                    showClientError('文件格式不支持，请选择 jpg/jpeg/png/gif/webp 图片');
                    return;
                }
                if (file.size > maxSize) {
                    input.value = '';
                    showClientError('文件过大，不能超过2MB');
                    return;
                }
                var reader = new FileReader();
                reader.onload = function(e) {
                    var previewImg = document.getElementById('previewImg');
                    var avatarPreview = document.getElementById('avatarPreview');
                    previewImg.src = e.target.result;
                    avatarPreview.style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function showClientError(msg) {
            var el = document.getElementById('clientError');
            el.innerText = msg;
            el.style.display = 'block';
        }

        function hideClientError() {
            var el = document.getElementById('clientError');
            el.innerText = '';
            el.style.display = 'none';
        }

        function validateAndSubmit() {
            hideClientError();
            var password = document.getElementById('password').value || '';
            var confirmPassword = document.getElementById('confirmPassword').value || '';
            var username = document.getElementById('username').value || '';
            var avatarFile = document.getElementById('avatarFile');
            var removeAvatar = document.getElementById('removeAvatar');
            var originalUsername = document.getElementById('originalUsername').value || '';
            var originalPassword = document.getElementById('originalPassword').value || '';
            var originalAvatar = document.getElementById('originalAvatar').value || '';

            if (password.length < 6) {
                showClientError('密码至少6位');
                return false;
            }
            if (password !== confirmPassword) {
                showClientError('两次输入的密码不一致');
                return false;
            }
            if (removeAvatar.checked && avatarFile.files && avatarFile.files.length > 0) {
                showClientError('恢复默认头像和上传新头像不能同时选择');
                return false;
            }

            var changes = [];
            if (username !== originalUsername) {
                changes.push('用户名');
            }
            if (password !== originalPassword) {
                changes.push('密码');
            }
            if (removeAvatar.checked && originalAvatar) {
                changes.push('头像(恢复默认)');
            } else if (avatarFile.files && avatarFile.files.length > 0) {
                changes.push('头像(上传新图)');
            }
            if (changes.length === 0) {
                if (!confirm('你没有修改任何内容，确定仍要提交吗？')) {
                    return false;
                }
            } else {
                if (!confirm('将要修改：' + changes.join('、') + '。确定提交吗？')) {
                    return false;
                }
            }

            var submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerText = '保存中...';
            return true;
        }
    </script>
</body>
</html>
