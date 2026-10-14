# Learning Improvement Guide (Servlet + MyBatis)

This document is written for a learning project.  
Goal: after "function works", continue improving in a structured way.

---

## 0) Current baseline

You already have:
- Order creation: `OrderCreateServlet`
- Order list + pagination: `OrderListServlet`
- Order status update: `OrderUpdateStatusServlet`
- Batch delete: `OrderBatchDeleteServlet`
- Order master/detail persistence: `orders` + `order_items`

This is a very good base. Next, improve from these 4 directions:
1. business correctness
2. security and permission
3. maintainability
4. engineering quality

---

## 1) Improve money precision (must do)

### Why
- `DOUBLE` and `double` can produce precision drift.
- Order systems should use decimal math.

### Files to modify
- `database_orders.sql`
- `src/com/qf/pojo/Order.java`
- `src/com/qf/pojo/CartItem.java`
- `src/com/qf/pojo/Product.java` (if price still uses `double`)
- `src/com/qf/Servlet/OrderCreateServlet.java`
- `src/com/qf/mapper/OrderDaoMapper.xml`
- `src/com/qf/mapper/ProductDaoMapper.xml` (if related SQL exists)

### What to change
1. SQL column type:
   - `orders.totalprice` -> `DECIMAL(10,2)`
   - `order_items.price` -> `DECIMAL(10,2)`
2. Java type:
   - use `BigDecimal` for price fields
3. total calculation:
   - replace `+` with `BigDecimal#add`

### Commented sample (for learning)

```java
// Use BigDecimal for currency to avoid double precision issues.
BigDecimal totalPrice = BigDecimal.ZERO;
for (CartItem item : cart) {
    // add() returns a new object, so re-assign to totalPrice.
    totalPrice = totalPrice.add(item.getTotalPrice());
}
order.setTotalPrice(totalPrice);
```

---

## 2) Add stock deduction in one transaction (high value)

### Why
- Order is complete only when:
  - order inserted
  - order_items inserted
  - inventory deducted
- These three steps must succeed or fail together.

### Files to modify
- `src/com/qf/Servlet/OrderCreateServlet.java`
- `src/com/qf/dao/ProductDao.java`
- `src/com/qf/mapper/ProductDaoMapper.xml`

### What to change
1. Add "deduct stock with condition" SQL:
   - `update product set stock = stock - #{qty} where pid = #{pid} and stock >= #{qty}`
2. In `OrderCreateServlet`, do this in one manual transaction:
   - insert order
   - insert items
   - loop deduct stock
   - if any deduct result is 0 -> rollback + show "库存不足"
   - else commit

### Commented sample (for learning)

```java
// Manual transaction: keep order, items, and stock in one atomic unit.
sqlSession = MyBatisUtil.getSqlSession(false);
try {
    orderDao.insertOrder(order);
    orderDao.insertOrderItems(order.getOrderId(), cart);

    for (CartItem item : cart) {
        // If affected rows == 0, stock is not enough.
        int affected = productDao.deductStock(item.getPid(), item.getQuantity());
        if (affected == 0) {
            throw new RuntimeException("Stock not enough for pid=" + item.getPid());
        }
    }

    sqlSession.commit();
} catch (Exception e) {
    // Rollback on any error to avoid partial success.
    sqlSession.rollback();
    throw e;
}
```

---

## 3) Add login filter + route protection

### Why
- Repeating session checks in every servlet is error-prone.
- Filter is cleaner and closer to real project practice.

### Files to modify
- `src/com/qf/filter/LoginFilter.java` (new)
- `web/WEB-INF/web.xml` (or use `@WebFilter`)
- Existing servlets can keep logic, then gradually simplify.

### What to change
1. Create filter to block anonymous access to:
   - `/order/*`
   - `/cart/*`
   - `/admin/*`
2. Whitelist:
   - `/login.jsp`, `/user/login`, static files

### Commented sample (for learning)

```java
// Filter centralizes login check so each servlet has less duplicated code.
if (currentUser == null) {
    // Not logged in: redirect to login page.
    httpResp.sendRedirect(httpReq.getContextPath() + "/login.jsp");
    return;
}
chain.doFilter(req, resp);
```

---

## 4) Order ownership check (security)

### Why
- Current update/delete by `orderId` only can be abused by changing request params.
- Must ensure user can only operate own order.

### Files to modify
- `src/com/qf/dao/OrderDao.java`
- `src/com/qf/mapper/OrderDaoMapper.xml`
- `src/com/qf/Servlet/OrderUpdateStatusServlet.java`
- `src/com/qf/Servlet/OrderDeleteServlet.java`
- `src/com/qf/Servlet/OrderBatchDeleteServlet.java`

### What to change
1. Add ownership-aware DAO methods, e.g.:
   - `updateOrderStatusByOwner(orderId, username, status)`
   - `deleteOrderByOwner(orderId, username)`
2. SQL where condition includes both `orderid` and `username`.
3. Servlet uses current session username, never trusts frontend username.

### Commented sample (for learning)

```xml
<!-- Prevent cross-user operation: both orderid and username must match. -->
<update id="updateOrderStatusByOwner">
    update orders
    set status = #{status}
    where orderid = #{orderId}
      and username = #{userName}
</update>
```

---

## 5) Add unified order status enum/constant

### Why
- Magic numbers (`1,2,3,4,5`) are hard to maintain.
- Enum improves readability and avoids invalid values.

### Files to modify
- `src/com/qf/constant/OrderStatus.java` (new enum)
- `src/com/qf/Servlet/OrderCreateServlet.java`
- `src/com/qf/Servlet/OrderUpdateStatusServlet.java`
- JSP pages where status text is rendered

### Suggested enum

```java
public enum OrderStatus {
    PENDING_PAY(1, "待付款"),
    PAID(2, "已付款"),
    SHIPPED(3, "已发货"),
    FINISHED(4, "已完成"),
    CANCELED(5, "已取消");
}
```

---

## 6) Add operation log and cleaner exception handling

### Why
- `printStackTrace()` is enough for debug, but not enough for maintainability.
- Logging should include key context: username, orderId, action, result.

### Files to modify
- `src/com/qf/Servlet/OrderCreateServlet.java`
- `src/com/qf/Servlet/OrderUpdateStatusServlet.java`
- `src/com/qf/Servlet/OrderDeleteServlet.java`
- `src/com/qf/Utils/Logger.java` (if enhancement needed)
- `src/com/qf/Utils/OperationLogUtil.java` (if already exists, reuse)

### What to change
1. Replace direct stack printing with structured logs.
2. Return clear messages to JSP:
   - parameter invalid
   - permission denied
   - stock not enough
   - system error

---

## 7) Page and SQL performance (N+1 optimization)

### Why
- In `OrderListServlet`, each order calls `selectItemsByOrderId`.
- This causes N+1 query problem when order count grows.

### Files to modify
- `src/com/qf/dao/OrderDao.java`
- `src/com/qf/mapper/OrderDaoMapper.xml`
- `src/com/qf/Servlet/OrderListServlet.java`

### What to change
1. Add batch query:
   - `selectItemsByOrderIds(List<Integer> orderIds)`
2. Group by `orderId` in Java map, then set to each order.

### Commented sample (for learning)

```java
// Avoid N+1 query: load all order items in one SQL, then map in memory.
Map<Integer, List<CartItem>> itemsMap = new HashMap<>();
for (CartItem item : allItems) {
    itemsMap.computeIfAbsent(item.getOrderId(), k -> new ArrayList<>()).add(item);
}
for (Order order : orderList) {
    order.setItems(itemsMap.getOrDefault(order.getOrderId(), Collections.emptyList()));
}
```

---

## 8) Suggested learning order (1-2 weeks)

### Week 1 (core business correctness)
1. money precision (`BigDecimal` + `DECIMAL`)
2. stock deduction transaction
3. ownership check for status/delete

### Week 2 (engineering practice)
4. login filter
5. status enum
6. log/error improvement
7. N+1 optimization

---

## 9) Quick file checklist

If you want a short "edit here first" list:

- `database_orders.sql`
- `src/com/qf/Servlet/OrderCreateServlet.java`
- `src/com/qf/Servlet/OrderUpdateStatusServlet.java`
- `src/com/qf/Servlet/OrderDeleteServlet.java`
- `src/com/qf/Servlet/OrderBatchDeleteServlet.java`
- `src/com/qf/dao/OrderDao.java`
- `src/com/qf/mapper/OrderDaoMapper.xml`
- `src/com/qf/dao/ProductDao.java`
- `src/com/qf/mapper/ProductDaoMapper.xml`
- `web/WEB-INF/web.xml` (if you configure filter via xml)

---

## 10) How to use this guide

For each improvement item:
1. create a small branch or backup
2. modify only 1 item
3. run and test
4. write short commit message
5. continue next item

This method helps you learn faster than changing everything at once.

