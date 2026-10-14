package com.qf.dao;

import com.qf.pojo.Order;
import com.qf.pojo.CartItem;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderDao {
    /**
     * 创建新订单
     * @param order 订单对象
     * @return 影响的行数
     */
    int insertOrder(Order order);

    /**
     * 批量插入订单明细
     * @param orderId 订单ID
     * @param items 商品快照列表
     * @return 影响行数
     */
    int insertOrderItems(@Param("orderId") Integer orderId, @Param("items") List<CartItem> items);

    /**
     * 根据订单ID查询订单
     * @param orderId 订单ID
     * @return 订单对象
     */
    Order selectByOrderId(Integer orderId);

    /**
     * 根据订单ID查询订单商品明细
     * @param orderId 订单ID
     * @return 商品明细列表
     */
    List<CartItem> selectItemsByOrderId(Integer orderId);

    /**
     * 根据用户名查询订单列表
     * @param userName 用户名
     * @return 订单列表
     */
    List<Order> selectByUserName(String userName);

    /**
     * 根据用户名分页查询订单列表
     * @param userName 用户名
     * @param offset 偏移量
     * @param limit 每页数量
     * @return 订单列表
     */
    List<Order> selectByUserNameWithPagination(@Param("userName") String userName, @Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 根据用户名查询订单总数
     * @param userName 用户名
     * @return 订单总数
     */
    int countByUserName(String userName);

    /**
     * 查询所有订单(管理员)
     * @return 订单列表
     */
    List<Order> selectAllOrders();

    /**
     * 更新订单状态
     * @param orderId 订单ID
     * @param status 新状态
     * @return 影响的行数
     */
    int updateOrderStatus(@Param("orderId") Integer orderId, @Param("status") Integer status);

    /**
     * 删除订单
     * @param orderId 订单ID
     * @return 影响的行数
     */
    int deleteOrder(Integer orderId);

    /**
     * 删除订单明细
     * @param orderId 订单ID
     * @return 影响行数
     */
    int deleteOrderItemsByOrderId(Integer orderId);

    /**
     * 分页查询订单
     * @param offset 偏移量
     * @param limit 每页数量
     * @return 订单列表
     */
    List<Order> selectOrdersWithPagination(@Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 按状态分页查询订单（管理员）
     * @param status 订单状态
     * @param offset 偏移量
     * @param limit 每页数量
     * @return 订单列表
     */
    List<Order> selectOrdersByStatusWithPagination(@Param("status") Integer status, @Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 查询订单总数
     * @return 订单总数
     */
    int countAllOrders();

    /**
     * 按状态查询订单总数（管理员）
     * @param status 订单状态
     * @return 订单总数
     */
    int countOrdersByStatus(@Param("status") Integer status);

    /**
     * 统计今日订单数
     * @return 今日订单数
     */
    int countTodayOrders();

    /**
     * 统计今日销售额
     * @return 今日销售额
     */
    double sumTodaySales();

    /**
     * 统计总销售额
     * @return 总销售额
     */
    double sumTotalSales();
}
