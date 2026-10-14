package com.qf.Servlet;

import com.qf.Utils.MyBatisUtil;
import com.qf.dao.UserDao;
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
 * 用户列表（带分页）
 */
@WebServlet("/user/list")
public class UserListServlet extends HttpServlet {

    /* 每页显示数量 */
    private static final int PAGE_SIZE = 10;

    /**
     * 处理GET请求，获取用户列表并跳转到用户列表页面
     *
     * @param req  HttpServletRequest对象，包含客户端请求信息
     * @param resp HttpServletResponse对象，用于向客户端发送响应
     * @throws ServletException 当Servlet处理请求发生错误时抛出
     * @throws IOException 当发生I/O错误时抛出
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            /* 获取SqlSession */
            session = MyBatisUtil.getSqlSession(true);
            UserDao userDao = session.getMapper(UserDao.class);

            /* 查询所有用户（暂时不分页，后续可扩展） */
            List<User> userList = userDao.selectAll();

            /* 计算总数和总页数 */
            int totalCount = userList.size();
            int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

            /* 手动分页 */
            int fromIndex = (currentPage - 1) * PAGE_SIZE;
            int toIndex = Math.min(fromIndex + PAGE_SIZE, totalCount);
            
            if (fromIndex < totalCount) {
                List<User> pagedUserList = userList.subList(fromIndex, toIndex);
                req.setAttribute("userList", pagedUserList);
            } else {
                req.setAttribute("userList", new java.util.ArrayList<>());
            }

            /* 将分页信息传递到JSP */
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);

            /* 请求转发到用户列表页面 */
            req.getRequestDispatcher("/userList.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "加载用户列表失败");
            req.getRequestDispatcher("/userList.jsp").forward(req, resp);
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }
}
