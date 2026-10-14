package com.qf.Utils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class OperationLogUtil {
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private OperationLogUtil() {
    }

    public static void logProfileUpdate(String webRootPath, String operator, String targetUid, String action) {
        if (webRootPath == null || webRootPath.isEmpty()) {
            return;
        }
        File logDir = new File(webRootPath, "logs");
        if (!logDir.exists()) {
            logDir.mkdirs();
        }
        File logFile = new File(logDir, "user-operation.log");
        String time = LocalDateTime.now().format(TIME_FORMATTER);
        String line = String.format("[%s] operator=%s, targetUid=%s, action=%s%n", time, operator, targetUid, action);
        try (FileWriter writer = new FileWriter(logFile, true)) {
            writer.write(line);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
