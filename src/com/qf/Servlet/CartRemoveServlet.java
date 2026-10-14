package com.qf.Servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import com.qf.pojo.CartItem;

@WebServlet("/cart/remove")
public class CartRemoveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 获取要删除的商品ID */
        String pidStr = req.getParameter("pid");
        if (pidStr == null || pidStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart/list");
            return;
        }

        Integer pid = Integer.parseInt(pidStr);

        /* 从购物车中移除商品 */
        HttpSession session = req.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null) {
            cart.removeIf(item -> item.getPid().equals(pid));
            session.setAttribute("cart", cart);
        }

        /* 重定向回购物车页面 */
        resp.sendRedirect(req.getContextPath() + "/cart/list");
    }
}
