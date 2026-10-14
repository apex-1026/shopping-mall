package com.qf.Servlet;

import com.qf.Utils.FileUploadUtil;
import com.qf.Utils.MyBatisUtil;
import com.qf.dao.UserDao;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.UUID;

/**
 * 处理用户注册请求
 */
@WebServlet("/user/register")
@MultipartConfig
public class UserRegisterServlet extends HttpServlet {

    /**
     * 处理POST请求，执行用户注册
     *
     * @param req  HttpServletRequest对象，包含客户端请求信息
     * @param resp HttpServletResponse对象，用于向客户端发送响应
     * @throws ServletException 当Servlet处理请求发生错误时抛出
     * @throws IOException 当发生I/O错误时抛出
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 获取注册参数 */
        String userName = req.getParameter("username");
        String password = req.getParameter("password");

        /* 处理头像上传 */
        String avatarFileName = null;
        try {
            Part avatarPart = req.getPart("avatarFile");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                /* 使用文件上传工具处理头像 */
                String uploadPath = req.getServletContext().getRealPath("/uploads/avatar");
                avatarFileName = FileUploadUtil.uploadFile(avatarPart, uploadPath);
            }
        } catch (Exception e) {
            System.out.println("头像上传失败: " + e.getMessage());
            /* 头像上传失败不影响注册，继续流程 */
        }

        SqlSession session = null;
        try {
            /* 获取SqlSession对象（设置为自动提交） */
            session = MyBatisUtil.getSqlSession(true);
            UserDao userDao = session.getMapper(UserDao.class);

            /* 检查用户名是否已存在 */
            User existUser = userDao.findByUserName(userName);
            if (existUser != null) {
                req.setAttribute("error", "用户名已存在");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }

            /* 创建新用户对象 */
            User user = new User();
            user.setUid(UUID.randomUUID().toString().replace("-", ""));
            user.setUsername(userName);
            user.setPassword(password);
            user.setAvatar(avatarFileName); /* 设置头像文件名 */
            user.setRole(1); /* 默认普通用户 */

            /* 执行注册操作 */
            int result = userDao.register(user);

            if (result > 0) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
            } else {
                req.setAttribute("error", "注册失败，请稍后重试");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "注册失败：" + e.getMessage());
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    /**
     * 处理GET请求，转发到注册页面
     *
     * @param req  HttpServletRequest对象，包含客户端请求信息
     * @param resp HttpServletResponse对象，用于向客户端发送响应
     * @throws ServletException 当Servlet处理请求发生错误时抛出
     * @throws IOException 当发生I/O错误时抛出
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}


