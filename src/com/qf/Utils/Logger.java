package com.qf.Utils;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 简单的日志工具类
 */
public class Logger {
    
    private static final String INFO = "INFO";
    private static final String WARN = "WARN";
    private static final String ERROR = "ERROR";
    private static final String DEBUG = "DEBUG";
    
    private Class<?> clazz;
    
    public Logger(Class<?> clazz) {
        this.clazz = clazz;
    }
    
    public static Logger getLogger(Class<?> clazz) {
        return new Logger(clazz);
    }
    
    /**
     * 输出INFO级别日志
     */
    public void info(String message) {
        log(INFO, message, null);
    }
    
    /**
     * 输出INFO级别日志（带异常）
     */
    public void info(String message, Throwable t) {
        log(INFO, message, t);
    }
    
    /**
     * 输出WARN级别日志
     */
    public void warn(String message) {
        log(WARN, message, null);
    }
    
    /**
     * 输出WARN级别日志（带异常）
     */
    public void warn(String message, Throwable t) {
        log(WARN, message, t);
    }
    
    /**
     * 输出ERROR级别日志
     */
    public void error(String message) {
        log(ERROR, message, null);
    }
    
    /**
     * 输出ERROR级别日志（带异常）
     */
    public void error(String message, Throwable t) {
        log(ERROR, message, t);
    }
    
    /**
     * 输出DEBUG级别日志
     */
    public void debug(String message) {
        log(DEBUG, message, null);
    }
    
    /**
     * 输出DEBUG级别日志（带异常）
     */
    public void debug(String message, Throwable t) {
        log(DEBUG, message, t);
    }
    
    /**
     * 核心日志方法
     */
    private void log(String level, String message, Throwable t) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        String time = sdf.format(new Date());
        String threadName = Thread.currentThread().getName();
        String className = clazz.getSimpleName();
        
        /* 控制台输出 */
        StringBuilder sb = new StringBuilder();
        sb.append("[").append(time).append("] ");
        sb.append("[").append(threadName).append("] ");
        sb.append("[").append(level).append("] ");
        sb.append(className).append(" - ");
        sb.append(message);
        
        if (level.equals(ERROR) || level.equals(WARN)) {
            System.err.println(sb.toString());
            if (t != null) {
                t.printStackTrace(System.err);
            }
        } else {
            System.out.println(sb.toString());
            if (t != null) {
                t.printStackTrace(System.out);
            }
        }
    }
}
