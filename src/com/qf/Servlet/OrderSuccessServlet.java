package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.OrderDao;
import com.qf.pojo.Order;
import org.apache.ibatis.session.SqlSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/order/success")
public class OrderSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        /* 获取订单ID */
        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        Integer orderId = Integer.parseInt(orderIdStr);

        /* 从数据库查询订单 */
        SqlSession sqlSession = null;
        try {
            sqlSession = MyBatisUtil.getSqlSession();
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);
            
            /* 查询订单信息 */
            Order order = orderDao.selectByOrderId(orderId);
            
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }

            /* 查询订单商品明细（包含图片快照） */
            order.setItems(orderDao.selectItemsByOrderId(orderId));
            
            req.setAttribute("order", order);
            req.getRequestDispatcher("/orderSuccess.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home");
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}
