<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${channelName}网关（模拟）</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fa; margin: 0; padding: 0; }
        .wrap { width: 620px; margin: 36px auto; background: #fff; border-radius: 8px; padding: 24px; box-shadow: 0 2px 10px rgba(0,0,0,.08); }
        .title { margin: 0 0 16px; font-size: 22px; color: #222; }
        .row { margin: 10px 0; color: #444; }
        .amount { color: #ff6700; font-size: 26px; font-weight: bold; }
        .btns { margin-top: 24px; display: flex; gap: 12px; }
        .btn { border: none; border-radius: 4px; padding: 10px 16px; cursor: pointer; font-size: 14px; }
        .btn-pay { background: #1677ff; color: #fff; }
        .btn-back { background: #eaeaea; color: #333; text-decoration: none; line-height: 36px; }
        .tip { margin-top: 18px; color: #888; font-size: 13px; line-height: 1.7; }
    </style>
</head>
<body>
<div class="wrap">
    <h2 class="title">${channelName} - 支付网关（学习模拟）</h2>
    <div class="row">平台交易号：${tradeNo}</div>
    <div class="row">订单号：${order.orderId}</div>
    <div class="row">支付金额：<span class="amount">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></span></div>

    <div class="btns">
        <!-- 模拟第三方支付成功后，回跳到本系统 -->
        <form action="${pageContext.request.contextPath}/payment/return" method="post" style="margin: 0;">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="channel" value="${channel}">
            <input type="hidden" name="tradeNo" value="${tradeNo}">
            <button type="submit" class="btn btn-pay">确认支付成功（模拟）</button>
        </form>
        <a class="btn btn-back" href="${pageContext.request.contextPath}/order/list">取消并返回</a>
    </div>

    <div class="tip">
        真实接入时，这一页会被支付宝收银台/微信二维码页面替代。<br>
        当前仅用于演示支付链路与订单状态更新。
        <br>
        <c:if test="${not empty realModeTips}">
            <span style="color: #d4380d;">${realModeTips}</span>
        </c:if>
    </div>
</div>
</body>
</html>

