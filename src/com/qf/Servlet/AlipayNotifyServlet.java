package com.qf.Servlet;

import com.qf.Utils.AlipayNotifyVerifyUtil;
import com.qf.Utils.MyBatisUtil;
import com.qf.Utils.PaymentConfigUtil;
import com.qf.dao.OrderDao;
import com.qf.pojo.Order;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.Map;

/**
 * 支付宝异步通知接口（学习版）
 *
 * 真实环境必须做：
 * 1. 验签（支付宝公钥）
 * 2. 校验金额、商户号、订单号
 * 3. 幂等更新订单状态
 * 4. 成功返回字符串 "success"
 */
@WebServlet("/payment/notify/alipay")
public class AlipayNotifyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain;charset=UTF-8");

        Map<String, String> params = extractParams(req);

        // 1) 验签：只有支付宝发来的真实通知才允许进入后续业务。
        String alipayPublicKey = PaymentConfigUtil.get("alipay.publicKey");
        String signType = params.get("sign_type");
        boolean signOk = AlipayNotifyVerifyUtil.verify(params, alipayPublicKey, signType);
        if (!signOk) {
            resp.getWriter().write("fail");
            return;
        }

        // 2) 交易状态校验：仅支付成功状态才处理。
        String tradeStatus = params.get("trade_status");
        if (!"TRADE_SUCCESS".equals(tradeStatus) && !"TRADE_FINISHED".equals(tradeStatus)) {
            resp.getWriter().write("fail");
            return;
        }

        // 3) app_id 校验：防止处理到其他应用的回调。
        String appId = params.get("app_id");
        String configuredAppId = PaymentConfigUtil.get("alipay.appId");
        if (configuredAppId != null && !configuredAppId.trim().isEmpty()
                && appId != null && !appId.trim().isEmpty()
                && !configuredAppId.equals(appId)) {
            resp.getWriter().write("fail");
            return;
        }

        // 4) 订单号与金额校验。
        String outTradeNo = params.get("out_trade_no");
        if (outTradeNo == null || outTradeNo.trim().isEmpty()) {
            resp.getWriter().write("fail");
            return;
        }
        String totalAmountStr = params.get("total_amount");

        SqlSession sqlSession = null;
        try {
            Integer orderId = Integer.parseInt(outTradeNo);
            sqlSession = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);
            Order order = orderDao.selectByOrderId(orderId);
            if (order == null) {
                resp.getWriter().write("fail");
                return;
            }

            if (totalAmountStr == null || totalAmountStr.trim().isEmpty()) {
                resp.getWriter().write("fail");
                return;
            }
            BigDecimal notifyAmount = new BigDecimal(totalAmountStr).setScale(2, RoundingMode.HALF_UP);
            BigDecimal orderAmount = BigDecimal.valueOf(order.getTotalPrice()).setScale(2, RoundingMode.HALF_UP);
            if (notifyAmount.compareTo(orderAmount) != 0) {
                resp.getWriter().write("fail");
                return;
            }

            // 幂等：仅待付款才更新
            if (order.getStatus() != null && order.getStatus() == 1) {
                orderDao.updateOrderStatus(orderId, 2);
            }

            // 支付宝异步通知成功应返回 success
            resp.getWriter().write("success");
        } catch (Exception e) {
            resp.getWriter().write("fail");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    private Map<String, String> extractParams(HttpServletRequest req) {
        Map<String, String> params = new HashMap<String, String>();
        Map<String, String[]> requestParams = req.getParameterMap();
        for (Map.Entry<String, String[]> entry : requestParams.entrySet()) {
            String[] values = entry.getValue();
            if (values == null || values.length == 0) {
                continue;
            }
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < values.length; i++) {
                if (i > 0) {
                    sb.append(",");
                }
                sb.append(values[i]);
            }
            params.put(entry.getKey(), sb.toString());
        }
        return params;
    }
}

