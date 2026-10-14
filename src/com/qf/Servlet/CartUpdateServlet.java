package com.qf.Servlet;

import com.qf.Utils.Logger;
import com.qf.pojo.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 处理购物车数量修改请求
 */
@WebServlet("/cart/update")
public class CartUpdateServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(CartUpdateServlet.class);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        /* 获取商品ID和数量 */
        String pidStr = req.getParameter("pid");
        String quantityStr = req.getParameter("quantity");

        if (pidStr == null || pidStr.isEmpty() || quantityStr == null || quantityStr.isEmpty()) {
            logger.warn("参数不完整，重定向到购物车列表");
            resp.sendRedirect(req.getContextPath() + "/cart/list");
            return;
        }

        try {
            Integer pid = Integer.parseInt(pidStr);
            Integer quantity = Integer.parseInt(quantityStr);

            /* 数量不能小于1 */
            if (quantity < 1) {
                quantity = 1;
            }

            /* 数量不能超过99 */
            if (quantity > 99) {
                quantity = 99;
            }

            /* 从Session中获取购物车 */
            HttpSession session = req.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart != null) {
                /* 查找并更新商品数量 */
                for (CartItem item : cart) {
                    if (item.getPid().equals(pid)) {
                        item.setQuantity(quantity);
                        logger.info("更新购物车商品数量 - PID: " + pid + ", 数量: " + quantity);
                        break;
                    }
                }
                session.setAttribute("cart", cart);
            }

            /* 重定向回购物车页面 */
            resp.sendRedirect(req.getContextPath() + "/cart/list");
        } catch (NumberFormatException e) {
            logger.error("数量格式异常", e);
            resp.sendRedirect(req.getContextPath() + "/cart/list");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
