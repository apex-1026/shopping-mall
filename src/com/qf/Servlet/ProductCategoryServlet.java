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
import java.util.List;

/**
 * 处理商品分类筛选请求
 */
@WebServlet("/product/category")
public class ProductCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 获取分类参数 */
        String categoryStr = req.getParameter("category");
        
        if (categoryStr == null || categoryStr.isEmpty()) {
            /* 如果没有分类参数，跳转到首页 */
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        Integer category = Integer.parseInt(categoryStr);
        
        SqlSession session = null;
        try {
            /* 获取SqlSession对象 */
            session = MyBatisUtil.getSqlSession();
            ProductDao productDao = session.getMapper(ProductDao.class);
            
            /* 根据分类查询商品 */
            List<Product> products = productDao.selectByCategory(category);
            
            /* 将商品列表和分类存储到请求域 */
            req.setAttribute("products", products);
            req.setAttribute("category", category);
            
            /* 根据分类设置标题 */
            String categoryTitle = "";
            if (category == 1) {
                categoryTitle = "热门产品";
            } else if (category == 2) {
                categoryTitle = "智能生活";
            } else {
                categoryTitle = "商品列表";
            }
            req.setAttribute("categoryTitle", categoryTitle);
            
            /* 转发到分类页面 */
            req.getRequestDispatcher("/category.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "加载失败，请稍后重试");
            req.getRequestDispatcher("/category.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
