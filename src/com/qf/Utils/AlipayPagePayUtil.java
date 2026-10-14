package com.qf.Utils;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * 支付宝电脑网站支付（alipay.trade.page.pay）学习版工具：
 * - 不依赖 SDK，便于你理解签名和表单跳转过程
 * - 仅用于沙箱学习，生产环境建议使用官方 SDK
 */
public class AlipayPagePayUtil {

    private static final String CHARSET = "UTF-8";

    private AlipayPagePayUtil() {
    }

    public static String buildAutoSubmitForm(
            String gateway,
            String appId,
            String privateKey,
            String notifyUrl,
            String returnUrl,
            Integer orderId,
            Double totalAmount
    ) throws Exception {
        // 支付宝要求金额为字符串，保留两位小数。
        String amount = new DecimalFormat("0.00").format(totalAmount);
        String bizContent = "{"
                + "\"out_trade_no\":\"" + orderId + "\","
                + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\","
                + "\"total_amount\":\"" + amount + "\","
                + "\"subject\":\"订单-" + orderId + "\""
                + "}";

        // 用 TreeMap 保证按字典序拼接签名串。
        Map<String, String> signParams = new TreeMap<String, String>();
        signParams.put("app_id", appId);
        signParams.put("method", "alipay.trade.page.pay");
        signParams.put("format", "JSON");
        signParams.put("charset", CHARSET);
        signParams.put("sign_type", "RSA2");
        signParams.put("timestamp", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        signParams.put("version", "1.0");
        signParams.put("notify_url", notifyUrl);
        signParams.put("return_url", returnUrl);
        signParams.put("biz_content", bizContent);

        String signContent = buildSignContent(signParams);
        String sign = rsa2Sign(signContent, privateKey);

        // 表单参数顺序按常见文档顺序输出，便于调试查看。
        Map<String, String> formParams = new LinkedHashMap<String, String>();
        formParams.put("app_id", signParams.get("app_id"));
        formParams.put("method", signParams.get("method"));
        formParams.put("format", signParams.get("format"));
        formParams.put("charset", signParams.get("charset"));
        formParams.put("sign_type", signParams.get("sign_type"));
        formParams.put("timestamp", signParams.get("timestamp"));
        formParams.put("version", signParams.get("version"));
        formParams.put("notify_url", signParams.get("notify_url"));
        formParams.put("return_url", signParams.get("return_url"));
        formParams.put("biz_content", signParams.get("biz_content"));
        formParams.put("sign", sign);

        return buildHtmlForm(gateway, formParams);
    }

    private static String buildSignContent(Map<String, String> params) {
        StringBuilder content = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            if (value == null || value.length() == 0) {
                continue;
            }
            if (content.length() > 0) {
                content.append("&");
            }
            content.append(key).append("=").append(value);
        }
        return content.toString();
    }

    private static String rsa2Sign(String content, String privateKeyPlain) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(privateKeyPlain.replaceAll("\\s+", ""));
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(keySpec);

        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initSign(privateKey);
        signature.update(content.getBytes(StandardCharsets.UTF_8));
        byte[] signed = signature.sign();
        return Base64.getEncoder().encodeToString(signed);
    }

    private static String buildHtmlForm(String gateway, Map<String, String> params) {
        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><title>Redirecting...</title></head><body>");
        sb.append("<form id=\"alipaySubmit\" name=\"alipaySubmit\" action=\"").append(escapeHtml(gateway)).append("\" method=\"POST\">");
        for (Map.Entry<String, String> entry : params.entrySet()) {
            sb.append("<input type=\"hidden\" name=\"")
                    .append(escapeHtml(entry.getKey()))
                    .append("\" value=\"")
                    .append(escapeHtml(entry.getValue()))
                    .append("\"/>");
        }
        sb.append("</form>");
        sb.append("<script>document.forms['alipaySubmit'].submit();</script>");
        sb.append("</body></html>");
        return sb.toString();
    }

    private static String escapeHtml(String src) {
        if (src == null) {
            return "";
        }
        return src.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}

