package com.qf.Servlet;

import com.qf.Utils.Logger;
import com.qf.Utils.MyBatisUtil;
import com.qf.dao.OrderDao;
import com.qf.pojo.CartItem;
import com.qf.pojo.Order;
import com.qf.pojo.User;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/order/create")
public class OrderCreateServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(OrderCreateServlet.class);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();

        /* 获取购物车 */
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart/list");
            return;
        }

        /* 从Session中获取当前登录用户 */
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            logger.warn("未登录用户尝试创建订单");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
        logger.info("用户 " + currentUser.getUsername() + " 开始创建订单");

        /* 计算总价 */
        double totalPrice = 0;
        for (CartItem item : cart) {
            totalPrice += item.getTotalPrice();
        }

        /* 创建订单对象 */
        Order order = new Order();
        order.setUserName(currentUser.getUsername());
        order.setTotalPrice(totalPrice);
        order.setOrderTime(new Date());
        order.setStatus(1); /* 1-待付款 */

        SqlSession sqlSession = null;
        try {
            /* 订单主表和明细表要保持一致，使用手动提交事务 */
            sqlSession = MyBatisUtil.getSqlSession(false);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);

            /* 插入订单到数据库 */
            int result = orderDao.insertOrder(order);

            if (result > 0) {
                /* 插入订单商品快照明细 */
                if (cart != null && !cart.isEmpty()) {
                    orderDao.insertOrderItems(order.getOrderId(), cart);
                }
                sqlSession.commit();
                logger.info("订单创建成功，订单ID: " + order.getOrderId());
                /* 清空购物车 */
                session.removeAttribute("cart");

                /* 重定向到订单成功页面 */
                resp.sendRedirect(req.getContextPath() + "/order/success?orderId=" + order.getOrderId());
            } else {
                sqlSession.rollback();
                logger.error("订单创建失败，返回结果为: " + result);
                req.setAttribute("error", "订单创建失败");
                req.getRequestDispatcher("/cart.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            if (sqlSession != null) {
                sqlSession.rollback();
            }
            logger.error("订单创建异常", e);
            req.setAttribute("error", "系统异常，请稍后重试");
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}
