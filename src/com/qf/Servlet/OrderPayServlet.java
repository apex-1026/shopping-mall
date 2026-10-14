package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.OrderDao;
import com.qf.pojo.Order;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 支付准备接口：
 * 1. 校验登录和订单归属
 * 2. 仅允许待付款订单进入支付
 * 3. 转发到支付页（真实项目里可改为重定向到第三方支付网关）
 */
@WebServlet("/order/pay")
public class OrderPayServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
            return;
        }

        SqlSession sqlSession = null;
        try {
            Integer orderId = Integer.parseInt(orderIdStr);
            sqlSession = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);
            Order order = orderDao.selectByOrderId(orderId);

            // 安全校验：订单必须存在，且属于当前用户
            if (order == null || !currentUser.getUsername().equals(order.getUserName())) {
                resp.sendRedirect(req.getContextPath() + "/order/list");
                return;
            }

            // 仅待付款订单可进入支付
            if (order.getStatus() == null || order.getStatus() != 1) {
                resp.sendRedirect(req.getContextPath() + "/order/list");
                return;
            }

            req.setAttribute("order", order);
            req.getRequestDispatcher("/paymentCheckout.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}

