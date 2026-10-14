package com.qf.pojo;

public class OrderItem {
    private Integer id;
    private Integer orderId;
    private Integer pid;
    private String pname;
    private Double price;
    private Integer quantity;

    public OrderItem() {
    }

    public OrderItem(Integer id, Integer orderId, Integer pid, String pname, Double price, Integer quantity) {
        this.id = id;
        this.orderId = orderId;
        this.pid = pid;
        this.pname = pname;
        this.price = price;
        this.quantity = quantity;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
