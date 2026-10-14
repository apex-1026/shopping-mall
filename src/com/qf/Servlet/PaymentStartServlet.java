package com.qf.Servlet;

import com.qf.Utils.AlipayPagePayUtil;
import com.qf.Utils.PaymentConfigUtil;
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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

/**
 * 双通道支付启动接口（学习版）
 * - channel=alipay / wechat
 * - 校验订单后进入“模拟网关页”
 *
 * 真实对接时，将本类中的“模拟网关转发”替换为：
 * 1) 组装第三方下单参数
 * 2) 调用 SDK 创建预支付单
 * 3) 重定向到支付宝收银台/返回微信二维码链接
 */
@WebServlet("/payment/start")
public class PaymentStartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        String channel = req.getParameter("channel");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
            return;
        }
        if (!"alipay".equals(channel) && !"wechat".equals(channel)) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
            return;
        }

        SqlSession sqlSession = null;
        try {
            Integer orderId = Integer.parseInt(orderIdStr);
            sqlSession = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);
            Order order = orderDao.selectByOrderId(orderId);

            // 订单存在、属于本人、且待付款才允许发起支付
            if (order == null
                    || !currentUser.getUsername().equals(order.getUserName())
                    || order.getStatus() == null
                    || order.getStatus() != 1) {
                resp.sendRedirect(req.getContextPath() + "/order/list");
                return;
            }

            // 学习演示用“平台交易号”
            String tradeNoPrefix = "alipay".equals(channel) ? "ALI" : "WX";
            String tradeNo = tradeNoPrefix + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()) + orderId;
            String channelName = "alipay".equals(channel) ? "支付宝" : "微信支付";

            // 微信先走简化版：可跳转、可确认支付、可回写订单状态。
            if ("wechat".equals(channel)) {
                req.setAttribute("order", order);
                req.setAttribute("channel", channel);
                req.setAttribute("channelName", channelName);
                req.setAttribute("tradeNo", tradeNo);
                req.getRequestDispatcher("/wechatPayMock.jsp").forward(req, resp);
                return;
            }

            // 优先读取动态配置，避免 IDE 把 classpath 的 payment.properties 复制成空文件。
            Properties runtimeProps = loadRuntimePaymentProperties(req);
            String mode = getConfig(runtimeProps, "payment.mode", PaymentConfigUtil.getOrDefault("payment.mode", "mock"));

            // 支付宝优先真实跳转：只要配置齐全就直接拉起沙箱收银台。
            if ("alipay".equals(channel)) {
                String notifyBaseUrl = getConfig(runtimeProps, "payment.notify.baseUrl",
                        PaymentConfigUtil.getOrDefault("payment.notify.baseUrl", ""));
                String notifyPath = getConfig(runtimeProps, "alipay.notifyPath",
                        PaymentConfigUtil.getOrDefault("alipay.notifyPath", "/payment/notify/alipay"));
                String returnPath = getConfig(runtimeProps, "alipay.returnPath",
                        PaymentConfigUtil.getOrDefault("alipay.returnPath", "/payment/return"));
                String notifyUrl = notifyBaseUrl + notifyPath;
                String returnUrl = notifyBaseUrl + returnPath;
                String appId = getConfig(runtimeProps, "alipay.appId", PaymentConfigUtil.get("alipay.appId"));
                String privateKey = getConfig(runtimeProps, "alipay.privateKey", PaymentConfigUtil.get("alipay.privateKey"));
                String gateway = getConfig(runtimeProps, "alipay.gateway", PaymentConfigUtil.get("alipay.gateway"));

                if (!isBlank(appId) && !isBlank(privateKey) && !isBlank(gateway) && !isBlank(notifyUrl) && !isBlank(returnUrl)) {
                    try {
                        String formHtml = AlipayPagePayUtil.buildAutoSubmitForm(
                                gateway,
                                appId,
                                privateKey,
                                notifyUrl,
                                returnUrl,
                                orderId,
                                order.getTotalPrice()
                        );
                        resp.setContentType("text/html;charset=UTF-8");
                        resp.getWriter().write(formHtml);
                        return;
                    } catch (Exception e) {
                        req.setAttribute("order", order);
                        req.setAttribute("channel", channel);
                        req.setAttribute("channelName", channelName);
                        req.setAttribute("tradeNo", tradeNo);
                        req.setAttribute("realModeTips",
                                "支付宝签名失败。mode=" + mode
                                        + "，请检查 appId/私钥/网关配置；异常：" + e.getClass().getSimpleName()
                                        + "；配置来源=" + describeConfigSource(runtimeProps));
                        req.getRequestDispatcher("/paymentGatewayMock.jsp").forward(req, resp);
                        return;
                    }
                } else {
                    req.setAttribute("realModeTips",
                            "未走真实支付宝：mode=" + mode
                                    + "；配置检查 appId=" + !isBlank(appId)
                                    + ", privateKey=" + !isBlank(privateKey)
                                    + ", gateway=" + !isBlank(gateway)
                                    + ", notifyUrl=" + !isBlank(notifyUrl)
                                    + ", returnUrl=" + !isBlank(returnUrl)
                                    + "；配置来源=" + describeConfigSource(runtimeProps));
                }
            }

            // 默认 mock 模式：进入本地模拟网关，方便你先跑通流程。
            if (!PaymentConfigUtil.isMockMode()) {
                req.setAttribute("order", order);
                req.setAttribute("channel", channel);
                req.setAttribute("channelName", channelName);
                req.setAttribute("tradeNo", tradeNo);
                req.setAttribute("realModeTips", "当前为 real 模式，但本次未进入支付宝真实跳转。mode=" + mode + "，先走模拟流程。");
                req.getRequestDispatcher("/paymentGatewayMock.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("order", order);
            req.setAttribute("channel", channel);
            req.setAttribute("channelName", channelName);
            req.setAttribute("tradeNo", tradeNo);
            req.setAttribute("realModeTips", "当前为 mock 模式（mode=" + mode + "），因此进入模拟网关。");

            // 学习版进入模拟网关页面
            req.getRequestDispatcher("/paymentGatewayMock.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/order/list");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String getConfig(Properties props, String key, String fallback) {
        if (props != null) {
            String v = props.getProperty(key);
            if (v != null && !v.trim().isEmpty()) {
                return v.trim();
            }
        }
        return fallback;
    }

    private Properties loadRuntimePaymentProperties(HttpServletRequest req) {
        Properties props = new Properties();
        Path discovered = null;
        try {
            String classesRealPath = req.getServletContext().getRealPath("/WEB-INF/classes");
            if (classesRealPath != null) {
                Path classesPath = Paths.get(classesRealPath).toAbsolutePath().normalize();
                Path cursor = classesPath;
                for (int i = 0; i < 12 && cursor != null; i++) {
                    Path candidate = cursor.resolve("src").resolve("payment.properties");
                    if (Files.exists(candidate)) {
                        discovered = candidate;
                        break;
                    }
                    cursor = cursor.getParent();
                }
            }

            if (discovered != null) {
                try (InputStream in = Files.newInputStream(discovered)) {
                    props.load(in);
                }
                props.setProperty("_source", discovered.toString());
            } else {
                props.setProperty("_source", "not-found");
            }
        } catch (Exception e) {
            props.setProperty("_source", "error:" + e.getClass().getSimpleName());
        }
        return props;
    }

    private String describeConfigSource(Properties props) {
        if (props == null) {
            return "unknown";
        }
        return props.getProperty("_source", "unknown");
    }
}

