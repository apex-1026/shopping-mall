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
import java.io.IOException;
import java.util.List;

/**
 * 后台管理 - 订单列表（查看所有订单）
 */
@WebServlet("/admin/order/list")
public class AdminOrderListServlet extends HttpServlet {

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
        String statusStr = req.getParameter("status");
        int currentPage = 1;
        Integer selectedStatus = null;
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
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                int status = Integer.parseInt(statusStr);
                if (status >= 1 && status <= 4) {
                    selectedStatus = status;
                }
            } catch (NumberFormatException ignored) {
                selectedStatus = null;
            }
        }

        SqlSession session = null;
        try {
            session = MyBatisUtil.getSqlSession(true);
            OrderDao orderDao = session.getMapper(OrderDao.class);

            /* 计算偏移量 */
            int offset = (currentPage - 1) * PAGE_SIZE;

            /* 查询所有订单和总数（支持按状态筛选） */
            List<Order> orderList;
            int totalCount;
            if (selectedStatus == null) {
                orderList = orderDao.selectOrdersWithPagination(offset, PAGE_SIZE);
                totalCount = orderDao.countAllOrders();
            } else {
                orderList = orderDao.selectOrdersByStatusWithPagination(selectedStatus, offset, PAGE_SIZE);
                totalCount = orderDao.countOrdersByStatus(selectedStatus);
            }

            /* 计算总页数 */
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

            /* 将数据传递到JSP */
            req.setAttribute("orderList", orderList);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);
            req.setAttribute("selectedStatus", selectedStatus);
            req.setAttribute("statusQuery", selectedStatus == null ? "" : "&status=" + selectedStatus);

            req.getRequestDispatcher("/admin/orderList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "加载订单列表失败");
            req.getRequestDispatcher("/admin/orderList.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
