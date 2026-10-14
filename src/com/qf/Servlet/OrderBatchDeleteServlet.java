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
 * 批量删除订单
 */
@WebServlet("/order/batchDelete")
public class OrderBatchDeleteServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(OrderBatchDeleteServlet.class);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 获取选中的订单ID数组 */
        String[] orderIds = req.getParameterValues("orderIds");
        if (orderIds == null || orderIds.length == 0) {
            req.getSession().setAttribute("error", "请选择要删除的订单");
            resp.sendRedirect(req.getHeader("Referer"));
            return;
        }

        /* 获取当前用户 */
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        SqlSession sqlSession = null;
        try {
            /* 批量删除主表和明细，使用事务 */
            sqlSession = MyBatisUtil.getSqlSession(false);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);
            boolean isAdmin = currentUser.getRole() != null && currentUser.getRole() == 2;

            int successCount = 0;
            int failCount = 0;

            /* 批量删除订单 */
            for (String orderIdStr : orderIds) {
                try {
                    Integer orderId = Integer.parseInt(orderIdStr);
                    Order order = orderDao.selectByOrderId(orderId);
                    if (order == null) {
                        failCount++;
                        logger.warn("订单不存在，订单ID: " + orderId);
                        continue;
                    }
                    if (!isAdmin && !currentUser.getUsername().equals(order.getUserName())) {
                        failCount++;
                        logger.warn("越权批量删除订单，用户: " + currentUser.getUsername() + ", 订单ID: " + orderId);
                        continue;
                    }
                    orderDao.deleteOrderItemsByOrderId(orderId);
                    int result = orderDao.deleteOrder(orderId);
                    if (result > 0) {
                        successCount++;
                        logger.info("订单删除成功，订单ID: " + orderId);
                    } else {
                        failCount++;
                        logger.warn("订单删除失败，订单ID: " + orderId);
                    }
                } catch (NumberFormatException e) {
                    failCount++;
                    logger.error("订单ID格式异常: " + orderIdStr);
                }
            }

            sqlSession.commit();

            /* 设置提示信息 */
            if (failCount == 0) {
                session.setAttribute("message", "成功删除 " + successCount + " 个订单");
            } else {
                session.setAttribute("message", "成功删除 " + successCount + " 个订单，失败 " + failCount + " 个");
            }

            /* 重定向回来源页面 */
            String referer = req.getHeader("Referer");
            if (referer != null && referer.contains("/admin/")) {
                /* 来自后台管理 */
                resp.sendRedirect(req.getContextPath() + "/admin/order/list");
            } else {
                /* 来自前台 */
                resp.sendRedirect(req.getContextPath() + "/order/list");
            }
        } catch (Exception e) {
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            logger.error("批量删除订单异常", e);
            session.setAttribute("error", "批量删除失败：" + e.getMessage());
            resp.sendRedirect(req.getHeader("Referer"));
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
