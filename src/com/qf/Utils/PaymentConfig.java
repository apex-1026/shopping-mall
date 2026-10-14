package com.qf.Utils;

import java.io.IOException;
import java.util.Properties;

public class PaymentConfig {
    private static Properties props = new Properties();

    static {
        try {
            props.load(PaymentConfig.class.getClassLoader().getResourceAsStream("payment.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}