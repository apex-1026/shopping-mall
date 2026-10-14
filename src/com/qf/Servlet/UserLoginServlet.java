package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.UserDao;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 处理用户登录请求
 */
@WebServlet("/user/login")
public class UserLoginServlet extends HttpServlet {

    /**
     * 处理POST请求，执行用户登录
     *
     * @param req  HttpServletRequest对象，包含客户端请求信息
     * @param resp HttpServletResponse对象，用于向客户端发送响应
     * @throws ServletException 当Servlet处理请求发生错误时抛出
     * @throws IOException 当发生I/O错误时抛出
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 设置请求编码
        req.setCharacterEncoding("UTF-8");

        // 获取登录参数
        String userName = req.getParameter("username");
        String password = req.getParameter("password");

        SqlSession session = null;
        try {
            // 获取SqlSession对象
            session = MyBatisUtil.getSqlSession();
            // 获取UserDao映射器接口
            UserDao userDao = session.getMapper(UserDao.class);
            // 执行登录查询
            User user = userDao.login(userName, password);

            if (user != null) {
                /* 登录成功，将用户信息存储到会话中 */
                req.getSession().setAttribute("currentUser", user);
                /* 根据用户角色跳转到不同页面 */
                if (user.getRole() != null && user.getRole() == 2) {
                    /* 管理员跳转到后台管理 */
                    resp.sendRedirect(req.getContextPath() + "/admin/index");
                } else {
                    /* 普通用户跳转到首页 */
                    resp.sendRedirect(req.getContextPath() + "/home");
                }
            } else {
                // 登录失败，存储错误信息并转发回登录页面
                req.setAttribute("error", "用户名或密码错误");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "登录失败，请稍后重试");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * 处理GET请求，转发到登录页面
     *
     * @param req  HttpServletRequest对象，包含客户端请求信息
     * @param resp HttpServletResponse对象，用于向客户端发送响应
     * @throws ServletException 当Servlet处理请求发生错误时抛出
     * @throws IOException 当发生I/O错误时抛出
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}