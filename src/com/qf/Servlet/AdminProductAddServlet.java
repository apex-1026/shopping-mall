package com.qf.Servlet;

import com.qf.Utils.FileUploadUtil;
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
 * 添加商品
 */
@WebServlet("/admin/product/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, /* 1MB */
        maxFileSize = 1024 * 1024 * 5,   /* 5MB */
        maxRequestSize = 1024 * 1024 * 10 /* 10MB */
)
public class AdminProductAddServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        /* 显示添加页面 */
        req.setAttribute("isEdit", false);
        req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String pimage = "default.png";
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
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            req.setAttribute("error", "图片上传失败: " + e.getMessage());
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
            return;
        }

        /* 获取商品参数 */
        String pname = req.getParameter("pname");
        String pdesc = req.getParameter("pdesc");
        String priceStr = req.getParameter("price");
        String categoryStr = req.getParameter("category");

        if (pname == null || pname.trim().isEmpty() || priceStr == null) {
            req.setAttribute("error", "商品名称和价格不能为空");
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
            return;
        }

        SqlSession session = null;
        try {
            double price = Double.parseDouble(priceStr);
            int category = Integer.parseInt(categoryStr);

            Product product = new Product();
            product.setPname(pname);
            product.setPdesc(pdesc);
            product.setPrice(price);
            product.setPimage(pimage);
            product.setCategory(category);

            /* 获取SqlSession并开启自动提交 */
            session = MyBatisUtil.getSqlSession(true);
            ProductDao productDao = session.getMapper(ProductDao.class);
            productDao.insertProduct(product);
            
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            req.setAttribute("error", "价格和分类格式不正确");
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "添加商品失败，请稍后重试");
            req.setAttribute("isEdit", false);
            req.getRequestDispatcher("/admin/productEdit.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
