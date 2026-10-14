package com.qf.pojo;

public class Product {
    Integer pid;        // 商品ID
    String pname;       // 商品名称
    String pdesc;       // 商品描述
    Double price;       // 商品价格
    String pimage;      // 商品图片路径
    Integer category;   // 商品分类（1-热门产品，2-智能生活）

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

    public String getPdesc() {
        return pdesc;
    }

    public void setPdesc(String pdesc) {
        this.pdesc = pdesc;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getPimage() {
        return pimage;
    }

    public void setPimage(String pimage) {
        this.pimage = pimage;
    }

    public Integer getCategory() {
        return category;
    }

    public void setCategory(Integer category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "Product{" +
                "pid=" + pid +
                ", pname='" + pname + '\'' +
                ", pdesc='" + pdesc + '\'' +
                ", price=" + price +
                ", pimage='" + pimage + '\'' +
                ", category=" + category +
                '}';
    }
}
