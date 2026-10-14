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
 * 首页 Servlet，加载商品数据
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession();
            ProductDao productDao = session.getMapper(ProductDao.class);

            // 获取分页参数
            String pageStr = req.getParameter("page");
            int page = 1; // 默认第一页
            int pageSize = 8; // 每页显示8个商品
            
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            int offset = (page - 1) * pageSize;

            // 获取分类筛选参数
            String categoryStr = req.getParameter("category");
            Integer category = null;
            
            if (categoryStr != null && !categoryStr.isEmpty()) {
                try {
                    category = Integer.parseInt(categoryStr);
                } catch (NumberFormatException e) {
                    // 忽略无效的分类参数
                }
            }

            // 查询所有分类
            List<Integer> categories = productDao.selectAllCategories();
            req.setAttribute("categories", categories);
            req.setAttribute("currentCategory", category);

            // 根据分类查询商品（带分页）
            List<Product> products;
            int totalProducts;
            
            if (category != null) {
                /* 按指定分类查询 */
                products = productDao.selectByCategoryWithPagination(category, offset, pageSize);
                totalProducts = productDao.countByCategory(category);
                req.setAttribute("hotProducts", products);
                req.setAttribute("smartProducts", null);
            } else {
                /* 查询所有商品（全部） */
                products = productDao.selectAllWithPagination(offset, pageSize);
                totalProducts = productDao.countAll();
                req.setAttribute("hotProducts", products);
                req.setAttribute("smartProducts", null);
            }
            
            // 计算总页数
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            if (totalPages == 0) {
                totalPages = 1;
            }
            
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);

            // 转发到首页
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
