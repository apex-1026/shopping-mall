package com.qf.Servlet;

import com.qf.Utils.FileUploadUtil;
import com.qf.Utils.OperationLogUtil;
import com.qf.Utils.MyBatisUtil;
import com.qf.dao.UserDao;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;

/**
 * 处理编辑用户页面的请求
 */
@WebServlet("/user/edit")
@MultipartConfig
public class UserEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uid = req.getParameter("uid");
        
        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession();
            UserDao userDao = session.getMapper(UserDao.class);
            
            // 根据UID查询用户信息
            User user = userDao.findByUid(uid);
            
            if (user != null) {
                // 将用户信息存储到请求域中
                req.setAttribute("user", user);
                // 转发到编辑页面
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
            } else {
                // 用户不存在，返回列表页
                req.setAttribute("error", "用户不存在");
                resp.sendRedirect(req.getContextPath() + "/user/list");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "获取用户信息失败：" + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/user/list");
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* multipart/form-data 格式无法用 getParameter 获取，需要从 Part 中读取文本 */
        String uid = getPartValue(req, "uid");
        String username = getPartValue(req, "username");
        String password = getPartValue(req, "password");
        String confirmPassword = getPartValue(req, "confirmPassword");
        String removeAvatar = getPartValue(req, "removeAvatar");

        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession(true);
            UserDao userDao = session.getMapper(UserDao.class);

            /* 查询原有用户信息，获取旧头像 */
            User oldUser = userDao.findByUid(uid);
            if (oldUser == null) {
                req.setAttribute("error", "用户不存在，无法更新");
                resp.sendRedirect(req.getContextPath() + "/user/list");
                return;
            }

            if (username == null || username.trim().isEmpty()) {
                req.setAttribute("error", "用户名不能为空");
                req.setAttribute("user", oldUser);
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                return;
            }
            if (password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "密码不能为空");
                req.setAttribute("user", oldUser);
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                return;
            }
            if (password.length() < 6) {
                req.setAttribute("error", "密码长度不能少于6位");
                req.setAttribute("user", oldUser);
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                return;
            }
            if (!password.equals(confirmPassword)) {
                req.setAttribute("error", "两次输入的密码不一致");
                req.setAttribute("user", oldUser);
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                return;
            }
            if (!username.equals(oldUser.getUsername())) {
                User userWithSameName = userDao.findByUserName(username);
                if (userWithSameName != null && !uid.equals(userWithSameName.getUid())) {
                    req.setAttribute("error", "用户名已存在，请更换一个用户名");
                    req.setAttribute("user", oldUser);
                    req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                    return;
                }
            }

            String oldAvatar = oldUser != null ? oldUser.getAvatar() : null;
            String uploadPath = req.getServletContext().getRealPath("/uploads/avatar");
            boolean avatarChanged = false;

            /* 处理头像上传 */
            String avatarFileName = oldAvatar;
            if ("on".equalsIgnoreCase(removeAvatar)) {
                if (oldAvatar != null && !oldAvatar.isEmpty()) {
                    FileUploadUtil.deleteOldFile(oldAvatar, uploadPath);
                    avatarChanged = true;
                }
                avatarFileName = null;
            }
            try {
                Part avatarPart = req.getPart("avatarFile");
                if (avatarPart != null && avatarPart.getSize() > 0) {
                    if ("on".equalsIgnoreCase(removeAvatar)) {
                        req.setAttribute("error", "请不要同时选择“恢复默认头像”和上传新头像");
                        req.setAttribute("user", oldUser);
                        req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                        return;
                    }
                    /* 使用文件上传工具处理头像 */
                    avatarFileName = FileUploadUtil.uploadFile(avatarPart, uploadPath);

                    /* 删除旧头像 */
                    if (oldAvatar != null && !oldAvatar.isEmpty()) {
                        FileUploadUtil.deleteOldFile(oldAvatar, uploadPath);
                    }
                    avatarChanged = true;
                }
            } catch (Exception e) {
                /* 上传失败不要“默默成功”，直接提示用户原因 */
                req.setAttribute("error", "头像上传失败：" + e.getMessage());
                req.setAttribute("user", oldUser);
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
                return;
            }

            /* 更新用户信息 */
            User user = new User();
            user.setUid(uid);
            user.setUsername(username);
            user.setPassword(password);
            user.setAvatar(avatarFileName);
            user.setRole(oldUser != null ? oldUser.getRole() : 1);

            int result = userDao.updateUser(user);

            if (result > 0) {
                /* 一次性提示信息（重定向后显示） */
                String successMessage = avatarChanged ? "资料和头像已更新" : "资料修改成功";
                req.getSession().setAttribute("message", successMessage);

                /* 更新Session中的currentUser，保持数据一致 */
                User currentUser = (User) req.getSession().getAttribute("currentUser");
                if (currentUser != null && currentUser.getUid().equals(uid)) {
                    currentUser.setUsername(username);
                    currentUser.setPassword(password);
                    currentUser.setAvatar(avatarFileName);
                    req.getSession().setAttribute("currentUser", currentUser);
                }

                String operator = currentUser != null ? currentUser.getUsername() : "unknown";
                String action = buildActionSummary(oldUser, username, password, avatarChanged, removeAvatar);
                OperationLogUtil.logProfileUpdate(req.getServletContext().getRealPath("/"), operator, uid, action);
                
                /* 根据当前登录用户的角色决定跳转页面 */
                if (currentUser != null && currentUser.getRole() == 2) {
                    /* 管理员返回后台用户管理 */
                    resp.sendRedirect(req.getContextPath() + "/admin/user/list");
                } else {
                    /* 普通用户返回首页 */
                    resp.sendRedirect(req.getContextPath() + "/home");
                }
            } else {
                req.setAttribute("error", "更新用户信息失败");
                req.setAttribute("user", user);
                req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "更新失败：" + e.getMessage());
            req.getRequestDispatcher("/userEdit.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
    
    /**
     * 从 multipart/form-data 请求中获取普通文本参数的值
     * @param req 请求对象
     * @param fieldName 字段名称
     * @return 字段值
     */
    private String getPartValue(HttpServletRequest req, String fieldName) {
        try {
            Part part = req.getPart(fieldName);
            if (part != null) {
                java.io.BufferedReader reader = new java.io.BufferedReader(
                    new java.io.InputStreamReader(part.getInputStream(), "UTF-8"));
                StringBuilder sb = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }
                return sb.toString();
            }
        } catch (Exception e) {
            System.out.println("获取字段 " + fieldName + " 失败: " + e.getMessage());
        }
        return "";
    }

    private String buildActionSummary(User oldUser, String username, String password, boolean avatarChanged, String removeAvatar) {
        StringBuilder summary = new StringBuilder();
        if (!username.equals(oldUser.getUsername())) {
            summary.append("用户名变更");
        }
        if (!password.equals(oldUser.getPassword())) {
            if (summary.length() > 0) {
                summary.append("，");
            }
            summary.append("密码变更");
        }
        if (avatarChanged) {
            if (summary.length() > 0) {
                summary.append("，");
            }
            summary.append("on".equalsIgnoreCase(removeAvatar) ? "头像恢复默认" : "头像更新");
        }
        if (summary.length() == 0) {
            summary.append("无字段变化");
        }
        return summary.toString();
    }
}
