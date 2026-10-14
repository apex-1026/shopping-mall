package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.ProductDao;
import com.qf.pojo.Product;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 处理商品详情请求
 */
@WebServlet("/product/detail")
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 获取商品ID */
        String pid = req.getParameter("pid");
        
        /* 如果pid为空，跳转到首页 */
        if (pid == null || pid.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession();
            ProductDao productDao = session.getMapper(ProductDao.class);
            
            /* 根据ID查询商品详情 */
            Product product = productDao.selectByPid(Integer.parseInt(pid));
            
            if (product != null) {
                /* 将商品信息存储到请求域 */
                req.setAttribute("product", product);
                /* 转发到商品详情页面 */
                req.getRequestDispatcher("/productDetail.jsp").forward(req, resp);
            } else {
                /* 商品不存在，跳转到首页 */
                resp.sendRedirect(req.getContextPath() + "/home");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home");
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
