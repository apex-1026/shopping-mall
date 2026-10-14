package com.qf.Servlet;

import com.qf.Utils.FileUploadUtil;
import com.qf.Utils.Logger;
import com.qf.Utils.MyBatisUtil;
import com.qf.dao.ProductDao;
import com.qf.pojo.Product;
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

/**
 * 编辑商品
 */
@WebServlet("/admin/product/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, /* 1MB */
        maxFileSize = 1024 * 1024 * 5,   /* 5MB */
        maxRequestSize = 1024 * 1024 * 10 /* 10MB */
)
public class AdminProductEditServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AdminProductEditServlet.class);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("========== AdminProductEditServlet.doGet 被调用 ==========");
        
        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            System.out.println("权限验证失败，用户信息: " + user);
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        System.out.println("管理员验证通过");

        /* 获取商品ID */
        String pidStr = req.getParameter("pid");
        System.out.println("获取到的商品ID: " + pidStr);
        
        if (pidStr == null || pidStr.isEmpty()) {
            System.out.println("商品ID为空，重定向到列表页");
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
            return;
        }

        int pid = Integer.parseInt(pidStr);
        System.out.println("准备查询商品，PID: " + pid);

        /* 查询商品信息 */
        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession(true);
            ProductDao productDao = session.getMapper(ProductDao.class);
            Product product = productDao.selectByPid(pid);
            
            System.out.println("查询到的商品: " + product);
            
            if (product == null) {
                System.out.println("商品不存在，PID: " + pid);
                req.setAttribute("error", "商品不存在");
                req.getRequestDispatcher("/admin/product/list").forward(req, resp);
                return;
            }
            
            req.setAttribute("product", product);
            req.setAttribute("isEdit", true);
            System.out.println("转发到编辑页面");
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
        } catch (Exception e) {
            System.out.println("查询商品异常: ");
            e.printStackTrace();
            req.setAttribute("error", "加载商品信息失败: " + e.getMessage());
            req.getRequestDispatcher("/admin/product/list").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("========== AdminProductEditServlet.doPost 被调用 ==========");
        req.setCharacterEncoding("UTF-8");

        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            logger.warn("非管理员尝试访问商品编辑功能");
            System.out.println("权限验证失败，重定向到首页");
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        logger.info("开始处理商品编辑请求");
        System.out.println("管理员验证通过");

        /* 获取商品ID和原有图片名 */
        String pidStr = req.getParameter("pid");
        String oldPimage = req.getParameter("pimage");
        String pimage = oldPimage;
        
        logger.debug("商品ID: " + pidStr + ", 原图片: " + oldPimage);

        try {
            /* 处理文件上传 */
            Part filePart = req.getPart("pimageFile");
            if (filePart != null && filePart.getSize() > 0) {
                /* 获取上传目录的绝对路径 */
                String uploadPath = req.getServletContext().getRealPath("/images");
                
                /* 使用工具类处理上传 */
                String uploadedFileName = FileUploadUtil.uploadFile(filePart, uploadPath);
                if (uploadedFileName != null) {
                    pimage = uploadedFileName;
                    
                    /* 删除旧图片（如果不是默认图片） */
                    if (oldPimage != null && !"default.png".equals(oldPimage)) {
                        String webRootPath = req.getServletContext().getRealPath("");
                        FileUploadUtil.deleteFile(oldPimage, webRootPath);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            req.setAttribute("error", "图片上传失败: " + e.getMessage());
            req.setAttribute("isEdit", true);
            
            /* 重新查询商品信息并显示 */
            if (pidStr != null) {
                try {
                    SqlSession session = MyBatisUtil.getSqlSession(true);
                    ProductDao productDao = session.getMapper(ProductDao.class);
                    Product product = productDao.selectByPid(Integer.parseInt(pidStr));
                    req.setAttribute("product", product);
                    session.close();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
            return;
        }

        /* 获取商品参数 */
        String pname = req.getParameter("pname");
        String pdesc = req.getParameter("pdesc");
        String priceStr = req.getParameter("price");
        String categoryStr = req.getParameter("category");

        if (pidStr == null || pname == null || pname.trim().isEmpty() || priceStr == null) {
            req.setAttribute("error", "商品信息不完整");
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
            return;
        }

        SqlSession session = null;
        try {
            int pid = Integer.parseInt(pidStr);
            double price = Double.parseDouble(priceStr);
            int category = Integer.parseInt(categoryStr);

            logger.info("更新商品信息 - ID: " + pid + ", 名称: " + pname + ", 价格: " + price);

            Product product = new Product();
            product.setPid(pid);
            product.setPname(pname);
            product.setPdesc(pdesc);
            product.setPrice(price);
            product.setPimage(pimage);
            product.setCategory(category);

            /* 获取SqlSession并开启自动提交 */
            session = MyBatisUtil.getSqlSession(true);
            ProductDao productDao = session.getMapper(ProductDao.class);
            productDao.updateProduct(product);
            
            logger.info("商品更新成功，重定向到列表页面");
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
        } catch (NumberFormatException e) {
            logger.error("数字格式异常", e);
            req.setAttribute("error", "价格和分类格式不正确");
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
        } catch (Exception e) {
            logger.error("更新商品异常", e);
            req.setAttribute("error", "更新商品失败: " + e.getMessage());
            req.setAttribute("isEdit", true);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
