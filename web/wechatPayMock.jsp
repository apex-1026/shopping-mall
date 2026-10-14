<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>微信 - 支付网关（学习模拟）</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 0; }
        .container { width: 720px; margin: 42px auto; background: #fff; border-radius: 8px; padding: 28px; box-shadow: 0 2px 12px rgba(0, 0, 0, .08); }
        .title { margin: 0 0 18px; color: #222; font-size: 40px; font-weight: 700; }
        .line { margin: 10px 0; color: #333; font-size: 34px; }
        .amount { color: #fa6400; font-size: 52px; font-weight: bold; }
        .panel { margin: 20px 0; padding: 18px; border: 1px dashed #1aad19; border-radius: 8px; background: #f6ffed; }
        .panel-title { color: #1aad19; font-weight: bold; font-size: 28px; margin-bottom: 10px; }
        .qr-placeholder { width: 190px; height: 190px; border: 2px solid #1aad19; color: #1aad19; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; }
        .btns { display: flex; gap: 12px; margin-top: 20px; }
        .btn { border: none; border-radius: 4px; padding: 12px 20px; font-size: 28px; cursor: pointer; }
        .btn-success { background: #1aad19; color: #fff; }
        .btn-cancel { background: #e5e5e5; color: #333; text-decoration: none; display: inline-flex; align-items: center; }
        .tip { color: #888; font-size: 25px; line-height: 1.8; margin-top: 16px; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="title">微信 - 支付网关（学习模拟）</h2>
    <div class="line">平台交易号：${tradeNo}</div>
    <div class="line">订单号：${order.orderId}</div>
    <div class="line">支付金额：<span class="amount">¥<fmt:formatNumber value="${order.totalPrice}" pattern="0.00"/></span></div>

    <div class="panel">
        <div class="panel-title">请使用微信扫码支付（演示）</div>
        <div class="qr-placeholder">微信二维码</div>
        <div style="color:#666; margin-top: 10px; font-size: 24px;">
            当前用于学习流程：跳转 -> 支付成功 -> 回写订单状态。
        </div>
    </div>

    <div class="btns">
        <form action="${pageContext.request.contextPath}/payment/return" method="post" style="margin: 0;">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="channel" value="wechat">
            <input type="hidden" name="tradeNo" value="${tradeNo}">
            <button type="submit" class="btn btn-success">确认支付成功（微信模拟）</button>
        </form>

        <a class="btn btn-cancel" href="${pageContext.request.contextPath}/order/list">取消并返回</a>
    </div>

    <div class="tip">
        真实接入时，这一页会被微信官方支付页或商户扫码页替代。<br>
        当前仅用于演示支付链路与订单状态更新。
    </div>
</div>
</body>
</html>

