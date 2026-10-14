package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.ProductDao;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 删除商品
 */
@WebServlet("/admin/product/delete")
public class AdminProductDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String pidStr = req.getParameter("pid");
        if (pidStr == null || pidStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
            return;
        }

        int pid = Integer.parseInt(pidStr);

        SqlSession session = MyBatisUtil.getSqlSession();
        try {
            ProductDao productDao = session.getMapper(ProductDao.class);
            productDao.deleteProduct(pid);
            session.commit();
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
        } finally {
            session.close();
        }
    }
}
