# 支付宝 + 微信支付 沙箱接入下一步

你现在已具备基础流程：
- `/order/pay` 进入收银台
- `/payment/start` 按渠道发起支付
- `/payment/return` 同步回跳
- `/payment/notify/alipay`、`/payment/notify/wechat` 异步通知骨架

---

## 1. 先准备配置文件

把 `src/payment.properties.example` 复制为 `src/payment.properties`，然后填写：

- 支付宝：`appId`、应用私钥、支付宝公钥、网关地址
- 微信：`appId`、`mchId`、`apiV3Key`、商户私钥路径、证书序列号

`payment.mode`:
- `mock`：走当前模拟网关（方便课堂演示）
- `real`：你开始替换真实 SDK 调用

---

## 2. 支付宝接入点（你要改哪里）

文件：`src/com/qf/Servlet/PaymentStartServlet.java`

当 `channel=alipay` 时：
1. 组装业务参数：
   - `out_trade_no`（建议用订单号）
   - `total_amount`
   - `subject`
   - `product_code=FAST_INSTANT_TRADE_PAY`
2. 设置回调地址：
   - `return_url = payment.notify.baseUrl + alipay.returnPath`
   - `notify_url = payment.notify.baseUrl + alipay.notifyPath`
3. 使用支付宝 SDK 生成跳转表单/URL并返回给前端。

异步通知处理：
- 文件：`src/com/qf/Servlet/AlipayNotifyServlet.java`
- 必做：验签后再改状态，最后输出 `success`

---

## 3. 微信支付接入点（你要改哪里）

文件：`src/com/qf/Servlet/PaymentStartServlet.java`

当 `channel=wechat` 时：
1. 调微信统一下单（Native/H5/JSAPI 任选其一）
2. 传参包含：
   - `out_trade_no`
   - `amount.total`（单位分）
   - `notify_url = payment.notify.baseUrl + wechat.notifyPath`
3. 返回 `code_url`（Native）给页面展示二维码，或返回 `mweb_url`（H5）跳转。

异步通知处理：
- 文件：`src/com/qf/Servlet/WechatNotifyServlet.java`
- 必做：验签 + 解密回调报文 + 幂等改状态

---

## 4. 核心安全检查（必须）

不管支付宝还是微信，通知里都要做：
1. 验签
2. 订单存在校验
3. 金额一致校验（数据库金额 == 支付回调金额）
4. 商户号一致校验
5. 幂等更新（仅待付款可改已付款）
6. 记录支付流水（tradeNo、channel、raw body、payTime）

---

## 5. 建议再新增一张支付流水表

建议新增：
- 表名：`payment_record`
- 字段：
  - `id`
  - `orderid`
  - `channel`（alipay/wechat）
  - `trade_no`
  - `pay_amount`
  - `pay_status`
  - `notify_raw`（可选）
  - `created_at` / `updated_at`

用途：排错、对账、避免重复处理。

---

## 6. 你可以立刻验证的接口

- 用户侧：
  - `GET /order/pay?orderId=xxx`
  - `GET /payment/start?orderId=xxx&channel=alipay`
  - `GET /payment/start?orderId=xxx&channel=wechat`
- 通知侧（学习版模拟）：
  - `POST /payment/notify/alipay` with `out_trade_no=订单号`
  - `POST /payment/notify/wechat` with `orderId=订单号`

---

## 7. 你下一步最小落地目标

1. 支付宝先接通（通常更快）
2. 完成异步通知验签
3. 再接微信
4. 最后把 `payment.mode` 切为 `real`，回归测试订单支付全链路

