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
 * 处理订单状态更新请求
 */
@WebServlet("/order/updateStatus")
public class OrderUpdateStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        /* 获取订单ID和新状态 */
        String orderIdStr = req.getParameter("orderId");
        String statusStr = req.getParameter("status");

        if (orderIdStr == null || statusStr == null) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
            return;
        }

        /* 从Session中获取当前登录用户 */
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        SqlSession sqlSession = null;
        try {
            Integer orderId = Integer.parseInt(orderIdStr);
            Integer targetStatus = Integer.parseInt(statusStr);

            /* 获取SqlSession并开启自动提交 */
            sqlSession = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);

            Order order = orderDao.selectByOrderId(orderId);
            if (order == null) {
                req.setAttribute("error", "订单不存在");
                req.getRequestDispatcher("/order/list").forward(req, resp);
                return;
            }

            boolean isAdmin = currentUser.getRole() != null && currentUser.getRole() == 2;
            if (!isAdmin && !currentUser.getUsername().equals(order.getUserName())) {
                req.setAttribute("error", "无权修改他人订单");
                req.getRequestDispatcher("/order/list").forward(req, resp);
                return;
            }

            Integer currentStatus = order.getStatus();
            if (!isValidTransition(currentStatus, targetStatus, isAdmin)) {
                req.setAttribute("error", "订单状态流转不合法");
                req.getRequestDispatcher(isAdmin ? "/admin/order/list" : "/order/list").forward(req, resp);
                return;
            }

            /* 更新订单状态到数据库 */
            int result = orderDao.updateOrderStatus(orderId, targetStatus);

            if (result > 0) {
                /* 重定向回订单列表 */
                resp.sendRedirect(req.getContextPath() + (isAdmin ? "/admin/order/list" : "/order/list"));
            } else {
                req.setAttribute("error", "订单状态更新失败");
                req.getRequestDispatcher(isAdmin ? "/admin/order/list" : "/order/list").forward(req, resp);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/order/list");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "系统异常，请稍后重试");
            req.getRequestDispatcher("/order/list").forward(req, resp);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    /**
     * 状态流转规则：
     * 普通用户：仅允许 待付款(1) -> 已付款(2)
     * 管理员：允许 1->2, 2->3, 3->4，以及保持原状态
     */
    private boolean isValidTransition(Integer currentStatus, Integer targetStatus, boolean isAdmin) {
        if (currentStatus == null || targetStatus == null) {
            return false;
        }
        if (currentStatus.equals(targetStatus)) {
            return true;
        }
        if (!isAdmin) {
            return currentStatus == 1 && targetStatus == 2;
        }
        if (currentStatus == 1 && targetStatus == 2) {
            return true;
        }
        if (currentStatus == 2 && targetStatus == 3) {
            return true;
        }
        return currentStatus == 3 && targetStatus == 4;
    }
}
