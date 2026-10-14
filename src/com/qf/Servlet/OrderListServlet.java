package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.OrderDao;
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
import java.util.List;

/**
 * 处理订单列表请求（带分页）
 */
@WebServlet("/order/list")
public class OrderListServlet extends HttpServlet {

    /* 每页显示数量 */
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();

        /* 从 Session中获取当前登录用户 */
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        /* 管理员统一走后台订单管理，不进入“我的订单”页 */
        if (currentUser.getRole() != null && currentUser.getRole() == 2) {
            resp.sendRedirect(req.getContextPath() + "/admin/order/list");
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

        SqlSession sqlSession = null;
        try {
            /* 获取SqlSession */
            sqlSession = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = sqlSession.getMapper(OrderDao.class);

            /* 计算偏移量 */
            int offset = (currentPage - 1) * PAGE_SIZE;

            /* 查询当前用户的订单列表和总数 */
            String userName = currentUser.getUsername();
            List<Order> orderList = orderDao.selectByUserNameWithPagination(userName, offset, PAGE_SIZE);
            int totalCount = orderDao.countByUserName(userName);

            /* 加载每个订单的商品明细（用于展示图片） */
            for (Order order : orderList) {
                order.setItems(orderDao.selectItemsByOrderId(order.getOrderId()));
            }

            /* 计算总页数 */
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

            /* 将数据传递到JSP */
            req.setAttribute("orderList", orderList);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);

            /* 转发到订单列表页面 */
            req.getRequestDispatcher("/orderList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "加载订单失败，请稍后重试");
            req.getRequestDispatcher("/orderList.jsp").forward(req, resp);
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
    }
}
