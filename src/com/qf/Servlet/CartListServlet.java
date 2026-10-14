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
import java.util.List;

@WebServlet("/cart/list")
public class CartListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        /* 获取购物车 */
        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new java.util.ArrayList<>();
        }

        /* 计算总价 */
        double totalPrice = 0;
        for (CartItem item : cart) {
            totalPrice += item.getTotalPrice();
        }

        req.setAttribute("cart", cart);
        req.setAttribute("totalPrice", totalPrice);

        /* 转发到购物车页面 */
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }
}
