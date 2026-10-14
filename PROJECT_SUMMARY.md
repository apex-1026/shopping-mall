# Mybatis04 项目总结与复盘文档

> 生成用途：答辩、复盘、交接。技术栈：**Servlet + JSP + JSTL + MyBatis + MySQL**。

---

## 一、项目定位

简易电商学习项目：商品浏览与搜索、购物车、下单（订单主表 + 明细快照）、用户订单与后台管理；在此基础上扩展了**支付流程（支付宝沙箱 + 微信演示页）**及**权限、状态流转、展示规范**等工程细节。

---

## 二、功能清单

| 模块 | 说明 |
|------|------|
| 用户 | 注册/登录；`User.role`：`1` 普通用户，`2` 管理员 |
| 商品 | 前台列表/详情/分类/搜索；后台增删改、分页 |
| 购物车 | Session 存储；加购、改数量、结算 |
| 订单 | 创建订单（事务写入 `orders` + `order_items`）；我的订单分页；订单成功页 |
| 后台 | 用户管理、商品管理、订单管理（分页 + **按状态筛选**） |
| 支付 | 收银台选渠道；**支付宝**表单签名跳转沙箱；**微信**学习版模拟页；同步回跳更新状态 |

---

## 三、数据库要点

- **`orders`**：订单主表（`username`, `totalprice`, `ordertime`, `status`）。
- **`order_items`**：明细快照（商品名、图、单价、数量），保证历史订单展示不随商品表变更而错乱。
- 状态约定：`1` 待付款，`2` 已付款，`3` 已发货，`4` 已完成（与业务注释一致时可扩展 `5` 已取消）。

---

## 四、支付相关（实现思路）

### 4.1 流程入口

- 用户端：`/order/pay` → 收银台 JSP → `/payment/start?channel=alipay|wechat`。

### 4.2 支付宝（沙箱）

- 使用 **RSA2** 对请求参数签名，生成 **POST 自动提交表单** 跳转 `openapi-sandbox` 网关（`alipay.trade.page.pay`）。
- 配置：`src/payment.properties`（或构建后 `WEB-INF/classes/payment.properties`），含 `appId`、应用私钥、**支付宝公钥**、网关、`notify`/`return` 路径前缀。
- **注意**：异步通知 `notify_url` 若指向 `localhost`，支付宝服务器通常无法访问；学习阶段可先依赖**同步回跳**验证页面流程，生产需公网或内网穿透。

### 4.3 微信（学习版）

- 与支付宝**视觉与流程对齐**的模拟收银台页，确认支付后走 `/payment/return` 更新状态；真实微信需商户号、证书、统一下单等，复杂度高于当前演示范围。

### 4.4 配置与部署踩坑

- IDE 构建偶发将 `payment.properties` 打成**空文件**，运行时读不到 `payment.mode` 等会退回 mock。解决思路：检查 `out/.../classes` 与 war 内 `WEB-INF/classes` 是否非空，或保证构建把资源正确拷贝。

---

## 五、安全与业务规则（已实现）

1. **管理员订单入口**：访问前台 `/order/list` 时，若 `role == 2`，重定向到 `/admin/order/list`，避免商家看到「我的订单」文案与逻辑混用。
2. **订单归属**：普通用户删除/批量删除/改状态时，校验订单 `username` 与当前登录用户一致；管理员可操作全部（按当前设计）。
3. **状态流转**：
   - 普通用户：仅允许 `待付款(1) → 已付款(2)`。
   - 管理员：允许 `1→2→3→4` 递进，且允许保持原状态；非法跳转拒绝更新。
4. **支付宝异步通知（若启用）**：验签、校验 `trade_status`、`app_id`、回调金额与订单金额一致后再幂等更新状态（本地 notify 可达性另论）。

---

## 六、展示与体验

- 订单相关金额：JSP 使用 `fmt:formatNumber` 统一 **两位小数**。
- 后台订单时间：使用 `fmt:formatDate`，格式 `yyyy-MM-dd HH:mm:ss`，避免 `Date.toString()` 英文默认格式。
- 后台订单：**状态筛选** + 分页链接携带筛选参数。

---

## 七、主要文件索引（便于复盘对照）

| 类型 | 路径 |
|------|------|
| 订单列表（用户） | `OrderListServlet.java`，`web/orderList.jsp` |
| 订单列表（后台） | `AdminOrderListServlet.java`，`web/admin/orderList.jsp` |
| 订单状态 | `OrderUpdateStatusServlet.java` |
| 支付准备/发起 | `OrderPayServlet.java`，`PaymentStartServlet.java` |
| 支付宝工具 | `AlipayPagePayUtil.java`，`AlipayNotifyVerifyUtil.java` |
| 支付回跳 | `PaymentReturnServlet.java` |
| 支付宝异步通知 | `AlipayNotifyServlet.java` |
| 支付配置 | `payment.properties`，`PaymentConfigUtil.java` |
| MyBatis 订单 SQL | `OrderDao.java`，`OrderDaoMapper.xml` |
| 学习路线文档 | `LEARNING_IMPROVEMENT_GUIDE.md` |
| 支付沙箱步骤 | `PAYMENT_SANDBOX_NEXT_STEP.md` |

---

## 八、后续可扩展（非必须）

- 金额与表结构：`DECIMAL` + Java `BigDecimal`。
- 下单同时扣库存，与订单写入同一事务。
- `Filter` 统一登录拦截，减少各 Servlet 重复判断。
- 支付流水表、异步通知幂等与对账。

---

## 九、答辩可用的一句话总结

> 本项目在 Servlet 与 MyBatis 基础上完成了电商主流程与后台管理，并接入支付宝沙箱网页支付跳转；同时区分管理员与普通用户的订单入口，对订单操作做归属校验与状态流转限制，后台支持订单状态筛选，金额与时间展示规范化，使演示更贴近真实业务与安全习惯。

---

## 十、密钥与安全提醒

- **切勿**将真实私钥、生产密钥提交到公开仓库或长期截图外传。
- 学习阶段沙箱密钥泄露后建议在开放平台**轮换密钥**并更新本地配置。

---

*文档随项目迭代可继续增补「接口列表」「表结构 ER」「部署步骤」等章节。*
