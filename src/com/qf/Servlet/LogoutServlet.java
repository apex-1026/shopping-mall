package com.qf.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 处理用户退出登录
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 获取当前用户信息 */
        com.qf.pojo.User user = (com.qf.pojo.User) req.getSession().getAttribute("currentUser");
        
        /* 清除会话 */
        req.getSession().invalidate();
        
        /* 根据用户角色跳转到不同页面 */
        if (user != null && user.getRole() != null && user.getRole() == 2) {
            /* 管理员退出，跳转到登录页 */
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            /* 普通用户退出，跳转到首页 */
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
