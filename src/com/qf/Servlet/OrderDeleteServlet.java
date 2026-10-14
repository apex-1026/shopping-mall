package com.qf.Servlet;

import com.qf.Utils.Logger;
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
 * 处理订单删除请求
 */
@WebServlet("/order/delete")
public class OrderDeleteServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(OrderDeleteServlet.class);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 获取订单ID */
        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            logger.warn("订单ID为空，无法删除");
            resp.sendRedirect(req.getContextPath() + "/order/list");
            return;
        }

        try {
            Integer orderId = Integer.parseInt(orderIdStr);

            /* 从Session中获取当前登录用户 */
            HttpSession session = req.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                logger.warn("未登录用户尝试删除订单");
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            /* 删除订单 */
            SqlSession sqlSession = null;
            try {
                sqlSession = MyBatisUtil.getSqlSession(false);
                OrderDao orderDao = sqlSession.getMapper(OrderDao.class);

                Order order = orderDao.selectByOrderId(orderId);
                if (order == null) {
                    logger.warn("订单不存在，订单ID: " + orderId);
                    sqlSession.rollback();
                    resp.sendRedirect(req.getContextPath() + "/order/list");
                    return;
                }

                boolean isAdmin = currentUser.getRole() != null && currentUser.getRole() == 2;
                if (!isAdmin && !currentUser.getUsername().equals(order.getUserName())) {
                    logger.warn("越权删除订单，用户: " + currentUser.getUsername() + ", 订单ID: " + orderId);
                    sqlSession.rollback();
                    resp.sendRedirect(req.getContextPath() + "/order/list");
                    return;
                }

                /* 执行删除操作 */
                orderDao.deleteOrderItemsByOrderId(orderId);
                int result = orderDao.deleteOrder(orderId);

                if (result > 0) {
                    sqlSession.commit();
                    logger.info("订单删除成功，订单ID: " + orderId);
                } else {
                    sqlSession.rollback();
                    logger.warn("订单删除失败，订单ID: " + orderId);
                }
            } catch (Exception e) {
                if (sqlSession != null) {
                    sqlSession.rollback();
                }
                logger.error("删除订单异常，订单ID: " + orderId, e);
            } finally {
                if (sqlSession != null) {
                    sqlSession.close();
                }
            }

            /* 重定向回订单列表 */
            boolean isAdmin = currentUser.getRole() != null && currentUser.getRole() == 2;
            resp.sendRedirect(req.getContextPath() + (isAdmin ? "/admin/order/list" : "/order/list"));
        } catch (NumberFormatException e) {
            logger.error("订单ID格式异常", e);
            resp.sendRedirect(req.getContextPath() + "/order/list");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
