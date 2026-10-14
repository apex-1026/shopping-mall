package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.ProductDao;
import com.qf.pojo.Product;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 商品管理 - 查看列表（带分页）
 */
@WebServlet("/admin/product/list")
public class AdminProductListServlet extends HttpServlet {

    /* 每页显示数量 */
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 检查是否为管理员 */
        User user = (User) req.getSession().getAttribute("currentUser");
        if (user == null || user.getRole() == null || user.getRole() != 2) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        /* 获取页码参数 */
        String pageStr = req.getParameter("page");
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession(true);
            ProductDao productDao = session.getMapper(ProductDao.class);

            /* 计算偏移量 */
            int offset = (currentPage - 1) * PAGE_SIZE;

            /* 查询商品列表和总数 */
            List<Product> products = productDao.selectAllWithPagination(offset, PAGE_SIZE);
            int totalCount = productDao.countAll();

            /* 计算总页数 */
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

            /* 将数据传递到JSP */
            req.setAttribute("products", products);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);

            req.getRequestDispatcher("/admin/productList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "加载商品列表失败");
            req.getRequestDispatcher("/admin/productList.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
