package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.OrderDao;
import com.qf.dao.ProductDao;
import com.qf.dao.UserDao;
import com.qf.pojo.Product;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台管理首页（带数据统计）
 */
@WebServlet("/admin/index")
public class AdminIndexServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            /* 不是管理员，跳转到首页 */
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        SqlSession session = null;
        try {
            /* 获取SqlSession */
            session = MyBatisUtil.getSqlSession(true);

            /* 获取各个DAO */
            OrderDao orderDao = session.getMapper(OrderDao.class);
            ProductDao productDao = session.getMapper(ProductDao.class);
            UserDao userDao = session.getMapper(UserDao.class);

            /* 统计数据 */
            Map<String, Object> statistics = new HashMap<>();

            /* 订单统计 */
            int totalOrders = orderDao.countAllOrders();
            int todayOrders = orderDao.countTodayOrders();
            double totalSales = orderDao.sumTotalSales();
            double todaySales = orderDao.sumTodaySales();

            /* 商品和用户统计 */
            int totalProducts = productDao.countAll();
            int totalUsers = userDao.selectAll().size();

            /* 封装数据 */
            statistics.put("totalOrders", totalOrders);
            statistics.put("todayOrders", todayOrders);
            statistics.put("totalSales", totalSales);
            statistics.put("todaySales", todaySales);
            statistics.put("totalProducts", totalProducts);
            statistics.put("totalUsers", totalUsers);

            /* 获取最近添加的5个商品 */
            List<Product> recentProducts = productDao.selectAll();
            if (recentProducts.size() > 5) {
                recentProducts = recentProducts.subList(0, 5);
            }

            /* 传递到JSP */
            req.setAttribute("statistics", statistics);
            req.setAttribute("recentProducts", recentProducts);

            req.getRequestDispatcher("/admin/index.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "加载数据失败");
            req.getRequestDispatcher("/admin/index.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
