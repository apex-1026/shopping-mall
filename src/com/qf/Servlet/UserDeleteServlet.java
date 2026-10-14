package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.UserDao;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user/delete")
public class UserDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String uid = req.getParameter("uid");
        SqlSession session = null;

        try {
            session = MyBatisUtil.getSqlSession(true);
            UserDao userDao = session.getMapper(UserDao.class);

            int result = userDao.deleteUser(uid);

            if (result > 0) {
                // 删除成功，添加提示信息
                req.getSession().setAttribute("message", "删除成功");
            } else {
                // 删除失败
                req.getSession().setAttribute("error", "删除失败，用户不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "删除失败：" + e.getMessage());
        } finally {
            if (session != null) {
                session.close();
            }
        }
        
        resp.sendRedirect(req.getContextPath() + "/user/list");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/user/list");
    }
}
