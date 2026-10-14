package com.qf.Utils;

import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.Signature;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import java.util.Map;
import java.util.TreeMap;

/**
 * 支付宝异步通知验签工具（学习版）
 */
public class AlipayNotifyVerifyUtil {

    private AlipayNotifyVerifyUtil() {
    }

    public static boolean verify(Map<String, String> params, String alipayPublicKey, String signType) {
        try {
            if (params == null || params.isEmpty()) {
                return false;
            }
            String sign = params.get("sign");
            if (sign == null || sign.trim().isEmpty()) {
                return false;
            }
            if (alipayPublicKey == null || alipayPublicKey.trim().isEmpty()) {
                return false;
            }

            // 按支付宝规则：sign/sign_type 不参与待验签串。
            Map<String, String> sorted = new TreeMap<String, String>();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (value == null || value.length() == 0) {
                    continue;
                }
                if ("sign".equals(key) || "sign_type".equals(key)) {
                    continue;
                }
                sorted.put(key, value);
            }

            String content = buildSignContent(sorted);
            String algorithm = "RSA".equalsIgnoreCase(signType) ? "SHA1withRSA" : "SHA256withRSA";
            PublicKey publicKey = loadPublicKey(alipayPublicKey);
            Signature signature = Signature.getInstance(algorithm);
            signature.initVerify(publicKey);
            signature.update(content.getBytes(StandardCharsets.UTF_8));
            return signature.verify(Base64.getDecoder().decode(sign));
        } catch (Exception e) {
            return false;
        }
    }

    private static String buildSignContent(Map<String, String> params) {
        StringBuilder content = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (content.length() > 0) {
                content.append("&");
            }
            content.append(entry.getKey()).append("=").append(entry.getValue());
        }
        return content.toString();
    }

    private static PublicKey loadPublicKey(String key) throws Exception {
        byte[] decoded = Base64.getDecoder().decode(key.replaceAll("\\s+", ""));
        X509EncodedKeySpec spec = new X509EncodedKeySpec(decoded);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        return keyFactory.generatePublic(spec);
    }
}

