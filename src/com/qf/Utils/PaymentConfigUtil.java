package com.qf.Utils;

import java.io.InputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;

/**
 * 支付配置读取工具（学习版）
 *
 * 用法：
 * 1. 把 src/payment.properties.example 复制为 src/payment.properties
 * 2. 填写真实商户参数
 * 3. 通过 get("key") 读取配置
 */
public class PaymentConfigUtil {

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream in = PaymentConfigUtil.class.getClassLoader().getResourceAsStream("payment.properties")) {
            if (in != null) {
                PROPS.load(in);
            }

            // 有些 IDE 构建会把 payment.properties 拷贝成空文件，这里做一次本地兜底读取。
            if (PROPS.isEmpty()) {
                Path fallback = Paths.get("src", "payment.properties");
                if (Files.exists(fallback)) {
                    try (InputStream fin = Files.newInputStream(fallback)) {
                        PROPS.load(fin);
                    }
                }
            }

            // 再兜底：从 classes 目录向上查找项目根目录下的 src/payment.properties。
            if (PROPS.isEmpty()) {
                Path discovered = discoverProjectPaymentProperties();
                if (discovered != null) {
                    try (InputStream fin = Files.newInputStream(discovered)) {
                        PROPS.load(fin);
                    }
                }
            }

            if (PROPS.isEmpty()) {
                // 没有配置文件时保持空配置，系统会自动回退 mock 模式
                System.out.println("[PaymentConfigUtil] payment.properties not found/empty, fallback to mock mode.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("加载 payment.properties 失败", e);
        }
    }

    public static String get(String key) {
        return PROPS.getProperty(key);
    }

    public static String getOrDefault(String key, String defaultValue) {
        return PROPS.getProperty(key, defaultValue);
    }

    public static boolean isMockMode() {
        return "mock".equalsIgnoreCase(getOrDefault("payment.mode", "mock"));
    }

    private static Path discoverProjectPaymentProperties() {
        try {
            // 方案1：基于代码实际运行目录（通常是 out/.../classes 或 WEB-INF/classes）
            Path codeSource = Paths.get(PaymentConfigUtil.class.getProtectionDomain().getCodeSource().getLocation().toURI())
                    .toAbsolutePath()
                    .normalize();
            Path fromCodeSource = searchUpForSrcPayment(codeSource);
            if (fromCodeSource != null) {
                return fromCodeSource;
            }

            // 方案2：基于 ClassLoader 根路径
            URL rootUrl = PaymentConfigUtil.class.getClassLoader().getResource("");
            if (rootUrl == null) {
                // continue
            } else {
                Path cursor = Paths.get(rootUrl.toURI()).toAbsolutePath().normalize();
                Path fromClassLoader = searchUpForSrcPayment(cursor);
                if (fromClassLoader != null) {
                    return fromClassLoader;
                }
            }

            // 方案3：基于 user.dir（IDE/容器工作目录）
            String userDir = System.getProperty("user.dir");
            if (userDir != null && !userDir.trim().isEmpty()) {
                Path fromUserDir = searchUpForSrcPayment(Paths.get(userDir).toAbsolutePath().normalize());
                if (fromUserDir != null) {
                    return fromUserDir;
                }
            }
        } catch (Exception ignored) {
            // 兜底逻辑失败不影响主流程，继续回落到 mock。
        }
        return null;
    }

    private static Path searchUpForSrcPayment(Path start) {
        Path cursor = start;
        for (int i = 0; i < 12 && cursor != null; i++) {
            Path candidate = cursor.resolve("src").resolve("payment.properties");
            if (Files.exists(candidate)) {
                return candidate;
            }
            cursor = cursor.getParent();
        }
        return null;
    }
}

