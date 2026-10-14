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
 * 支付回调演示接口（学习版）：
 * - 支持支付宝/微信两种渠道（通过 channel 参数区分）
 * - 实际接第三方支付时，这里应先验签，再更新订单状态。
 * - 当前先做模拟：点击支付网关页面按钮后回调，把待付款改为已付款。
 */
@WebServlet("/payment/return")
public class PaymentReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleReturn(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleReturn(req, resp);
    }

    private void handleReturn(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 模拟页传 orderId；支付宝同步回跳常用 out_trade_no。
        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            orderIdStr = req.getParameter("out_trade_no");
        }
        String channel = req.getParameter("channel");
        String tradeNo = req.getParameter("tradeNo");
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

            // 安全校验：只允许用户更新自己的订单
            if (order == null || !currentUser.getUsername().equals(order.getUserName())) {
                resp.sendRedirect(req.getContextPath() + "/order/list");
                return;
            }

            // 学习版渠道校验：只接受支付宝和微信两个值（第三方回跳可能不带 channel，允许为空）
            if (channel != null && !"alipay".equals(channel) && !"wechat".equals(channel)) {
                resp.sendRedirect(req.getContextPath() + "/order/list");
                return;
            }

            // 只允许从待付款 -> 已付款（幂等：重复回调不会继续改变）
            if (order.getStatus() != null && order.getStatus() == 1) {
                orderDao.updateOrderStatus(orderId, 2);
            }

            // tradeNo 在学习版中仅用于演示参数传递。
            // 真实支付接入时，应该把 tradeNo、channel、支付时间、原始回调报文入库留痕。
            if (tradeNo != null) {
                req.getSession().setAttribute("lastTradeNo", tradeNo);
            }

            resp.sendRedirect(req.getContextPath() + "/order/list");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}

