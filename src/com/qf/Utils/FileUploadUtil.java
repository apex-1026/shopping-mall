package com.qf.Utils;

import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUploadUtil {
    
    /* 允许的图片格式 */
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    
    /* 最大文件大小：2MB（与页面提示一致） */
    private static final long MAX_FILE_SIZE = 2 * 1024 * 1024;

    /**
     * 处理文件上传，返回保存后的文件名
     * @param part 上传的文件部分
     * @param uploadPath 上传目录的绝对路径
     * @return 保存后的文件名，如果上传失败返回null
     */
    public static String uploadFile(Part part, String uploadPath) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        /* 获取原始文件名 */
        String fileName = getSubmittedFileName(part);
        
        /* 验证文件扩展名 */
        if (!isValidImageFile(fileName)) {
            throw new IOException("不支持的文件格式，仅支持: jpg, jpeg, png, gif, webp");
        }

        /* 验证文件大小 */
        if (part.getSize() > MAX_FILE_SIZE) {
            throw new IOException("文件大小不能超过2MB");
        }

        /* 生成唯一文件名 */
        String extension = getFileExtension(fileName);
        String uniqueFileName = UUID.randomUUID().toString().replace("-", "") + extension;

        /* 确保上传目录存在 */
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        /* 保存文件 */
        String filePath = uploadPath + File.separator + uniqueFileName;
        part.write(filePath);

        return uniqueFileName;
    }

    /**
     * 从Part中获取原始文件名
     */
    private static String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    /**
     * 验证是否为有效的图片文件
     */
    private static boolean isValidImageFile(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }
        String extension = getFileExtension(fileName).toLowerCase();
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (allowedExt.equals(extension)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 获取文件扩展名
     */
    private static String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex);
        }
        return "";
    }

    /**
     * 删除文件
     * @param filePath 文件路径（相对于web根目录）
     * @param webRootPath web根目录的绝对路径
     */
    public static void deleteFile(String filePath, String webRootPath) {
        if (filePath != null && !filePath.isEmpty()) {
            File file = new File(webRootPath + File.separator + "images" + File.separator + filePath);
            if (file.exists()) {
                file.delete();
            }
        }
    }

    public static void deleteOldFile(String oldAvatar, String uploadPath) {
        if (oldAvatar == null || oldAvatar.isEmpty() || uploadPath == null || uploadPath.isEmpty()) {
            return;
        }
        File file = new File(uploadPath + File.separator + oldAvatar);
        if (file.exists()) {
            file.delete();
        }
    }
}
