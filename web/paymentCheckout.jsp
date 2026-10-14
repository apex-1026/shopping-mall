<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>支付收银台</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 0; }
        .container { width: 600px; margin: 40px auto; background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 2px 12px rgba(0,0,0,.08); }
        .title { margin: 0 0 16px; font-size: 22px; color: #333; }
        .line { margin: 10px 0; color: #555; }
        .amount { color: #ff6700; font-size: 28px; font-weight: bold; }
        .btns { margin-top: 24px; display: flex; gap: 12px; }
        .btn { border: none; border-radius: 4px; padding: 10px 16px; cursor: pointer; font-size: 14px; }
        .btn-primary { background: #ff6700; color: #fff; }
        .btn-default { background: #eaeaea; color: #333; text-decoration: none; line-height: 36px; }
        .tip { margin-top: 18px; color: #999; font-size: 13px; line-height: 1.7; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="title">支付收银台（学习版）</h2>

    <div class="line">订单编号：${order.orderId}</div>
    <div class="line">支付金额：<span class="amount">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></span></div>
    <div class="line">当前状态：待付款</div>

    <div class="btns">
        <!-- 选择支付宝渠道 -->
        <form action="${pageContext.request.contextPath}/payment/start" method="get" style="margin: 0;">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="channel" value="alipay">
            <button type="submit" class="btn btn-primary">支付宝支付</button>
        </form>

        <!-- 选择微信支付渠道 -->
        <form action="${pageContext.request.contextPath}/payment/start" method="get" style="margin: 0;">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="channel" value="wechat">
            <button type="submit" class="btn btn-primary">微信支付</button>
        </form>

        <a class="btn btn-default" href="${pageContext.request.contextPath}/order/list">返回订单列表</a>
    </div>

    <div class="tip">
        提示：当前是“双通道学习版”：支付宝/微信均可进入模拟网关。<br>
        下一步把 `/payment/start` 中的模拟跳转替换为真实 SDK 下单即可。
    </div>
</div>
</body>
</html>

