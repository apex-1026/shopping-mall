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
 * 处理商品搜索请求
 */
@WebServlet("/product/search")
public class ProductSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 获取搜索关键词 */
        String keyword = req.getParameter("keyword");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            /* 如果没有关键词，跳转到首页 */
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        /* 去除首尾空格 */
        keyword = keyword.trim();
        
        SqlSession session = null;
        try {
            /* 获取SqlSession对象 */
            session = MyBatisUtil.getSqlSession();
            ProductDao productDao = session.getMapper(ProductDao.class);
            
            /* 执行搜索 */
            List<Product> searchResults = productDao.selectByKeyword(keyword);
            
            /* 将搜索结果和关键词存储到请求域 */
            req.setAttribute("searchResults", searchResults);
            req.setAttribute("keyword", keyword);
            
            /* 转发到搜索结果页面 */
            req.getRequestDispatcher("/searchResult.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "搜索失败，请稍后重试");
            req.setAttribute("keyword", keyword);
            req.getRequestDispatcher("/searchResult.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
