package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.OrderDao;
import com.qf.pojo.Order;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 微信支付异步通知接口（学习版）
 *
 * 真实环境必须做：
 * 1. 验签（平台证书 + 时间戳 + nonce + body）
 * 2. 解密回调报文 resource.ciphertext
 * 3. 校验金额与商户号
 * 4. 幂等更新订单状态
 * 5. 返回微信要求的 JSON 响应
 */
@WebServlet("/payment/notify/wechat")
public class WechatNotifyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 学习版简化：演示通过 query 参数 orderId 模拟回调
        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"code\":\"FAIL\",\"message\":\"missing orderId\"}");
            return;
        }

        SqlSession sqlSession = null;
        try {
            Integer orderId = Integer.parseInt(orderIdStr);
            sqlSession = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);
            Order order = orderDao.selectByOrderId(orderId);
            if (order == null) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write("{\"code\":\"FAIL\",\"message\":\"order not found\"}");
                return;
            }

            // 幂等更新：只把待付款改为已付款
            if (order.getStatus() != null && order.getStatus() == 1) {
                orderDao.updateOrderStatus(orderId, 2);
            }

            // 微信成功响应格式（示意）
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"code\":\"SUCCESS\",\"message\":\"成功\"}");
        } catch (Exception e) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"code\":\"FAIL\",\"message\":\"error\"}");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}

