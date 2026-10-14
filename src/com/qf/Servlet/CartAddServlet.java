package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.ProductDao;
import com.qf.pojo.CartItem;
import com.qf.pojo.Product;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart/add")
public class CartAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 获取商品ID */
        String pidStr = req.getParameter("pid");
        if (pidStr == null || pidStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Integer pid = Integer.parseInt(pidStr);

        /* 查询商品信息 */
        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession();
            ProductDao productDao = session.getMapper(ProductDao.class);
            Product product = productDao.selectByPid(pid);

            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            /* 获取购物车（存储在Session中） */
            HttpSession httpSession = req.getSession();
            List<CartItem> cart = (List<CartItem>) httpSession.getAttribute("cart");

            if (cart == null) {
                cart = new ArrayList<>();
            }

            /* 检查购物车中是否已存在该商品 */
            boolean found = false;
            for (CartItem item : cart) {
                if (item.getPid().equals(pid)) {
                    item.setQuantity(item.getQuantity() + 1);
                    found = true;
                    break;
                }
            }

            /* 如果不存在则添加新商品 */
            if (!found) {
                CartItem newItem = new CartItem(
                        product.getPid(),
                        product.getPname(),
                        product.getPimage(),
                        product.getPrice(),
                        1
                );
                cart.add(newItem);
            }

            /* 将购物车存回Session */
            httpSession.setAttribute("cart", cart);

            /* 重定向到购物车页面 */
            resp.sendRedirect(req.getContextPath() + "/cart/list");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home");
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
