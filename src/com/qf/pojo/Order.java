package com.qf.pojo;

import java.util.Date;
import java.util.List;

public class Order {
    private Integer orderId;
    private String userName;
    private Double totalPrice;
    private Date orderTime;
    private Integer status;
    private List<CartItem> items;

    public Order() {
    }

    public Order(Integer orderId, String userName, Double totalPrice, Date orderTime, Integer status) {
        this.orderId = orderId;
        this.userName = userName;
        this.totalPrice = totalPrice;
        this.orderTime = orderTime;
        this.status = status;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Date orderTime) {
        this.orderTime = orderTime;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }
}
