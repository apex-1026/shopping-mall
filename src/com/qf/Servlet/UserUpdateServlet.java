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

@WebServlet("/user/update")
public class UserUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String uid = req.getParameter("uid");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        SqlSession session = null;

        try {
            session = MyBatisUtil.getSqlSession(true);
            UserDao userDao = session.getMapper(UserDao.class);

            User user = new User();
            user.setUid(uid);
            user.setUsername(username);
            user.setPassword(password);

            int result = userDao.updateUser(user);

            if (result > 0) {
                // 修改成功，添加提示信息
                req.getSession().setAttribute("message", "修改成功");
                
                // 更新Session中的currentUser，保持数据一致
                User currentUser = (User) req.getSession().getAttribute("currentUser");
                if (currentUser != null && currentUser.getUid().equals(uid)) {
                    currentUser.setUsername(username);
                    currentUser.setPassword(password);
                    req.getSession().setAttribute("currentUser", currentUser);
                }
            } else {
                // 修改失败
                req.getSession().setAttribute("error", "修改失败，用户不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "修改失败：" + e.getMessage());
        } finally {
            if (session != null) {
                session.close();
            }
        }
        
        /* 普通用户修改后返回首页 */
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 普通用户修改后返回首页 */
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
