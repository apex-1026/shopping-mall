package com.qf.pojo;

public class CartItem {
    private Integer pid;
    private String pname;
    private String pimage;
    private Double price;
    private Integer quantity;

    public CartItem() {
    }

    public CartItem(Integer pid, String pname, String pimage, Double price, Integer quantity) {
        this.pid = pid;
        this.pname = pname;
        this.pimage = pimage;
        this.price = price;
        this.quantity = quantity;
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

    public String getPimage() {
        return pimage;
    }

    public void setPimage(String pimage) {
        this.pimage = pimage;
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

    public Double getTotalPrice() {
        return price * quantity;
    }
}
