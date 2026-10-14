<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户注册</title>
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
        .register-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 350px;
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
            border-color: #2196F3;
        }
        .avatar-preview {
            margin-top: 10px;
            text-align: center;
        }
        .avatar-preview img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #ddd;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #1976D2;
        }
        .error-message {
            color: #f44336;
            background-color: #ffebee;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        .login-link a {
            color: #2196F3;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>用户注册</h2>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/user/register" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="userName">用户名：</label>
                <input type="text" id="username" name="username" required placeholder="请输入用户名">
            </div>

            <div class="form-group">
                <label for="password">密码：</label>
                <input type="password" id="password" name="password" required placeholder="请输入密码">
            </div>

            <div class="form-group">
                <label for="confirmPassword">确认密码：</label>
                <input type="password" id="confirmPassword" required placeholder="请再次输入密码">
            </div>

            <div class="form-group">
                <label for="avatarFile">头像（可选）：</label>
                <input type="file" id="avatarFile" name="avatarFile" accept="image/*" onchange="previewAvatar(this)">
                <div class="avatar-preview" id="avatarPreview" style="display:none;">
                    <img id="previewImg" src="" alt="头像预览">
                </div>
            </div>

            <button type="submit" class="btn">注册</button>
        </form>

        <div class="login-link">
            <p>已有账号？<a href="${pageContext.request.contextPath}/login.jsp">立即登录</a></p>
        </div>
    </div>

    <script>
        // 前端密码验证
        document.querySelector('form').addEventListener('submit', function(e) {
            var password = document.getElementById('password').value;
            var confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的密码不一致，请重新输入！');
                return false;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('密码长度不能少于6位！');
                return false;
            }
        });

        /* 头像预览功能 */
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
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
    </script>
</body>
</html>