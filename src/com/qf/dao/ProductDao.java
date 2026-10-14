package com.qf.dao;

import com.qf.pojo.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ProductDao {
    /**
     * 查询所有商品
     * @return 商品列表
     */
    List<Product> selectAll();

    /**
     * 根据分类查询商品
     * @param category 分类（1-热门产品，2-智能生活）
     * @return 商品列表
     */
    List<Product> selectByCategory(Integer category);

    /**
     * 根据商品ID查询商品
     * @return 商品对象
     */
    Product selectByPid(int i);

    /**
     * 根据关键词搜索商品
     * @param keyword 搜索关键词
     * @return 商品列表
     */
    List<Product> selectByKeyword(String keyword);

    /**
     * 查询所有不同的分类
     * @return 分类列表
     */
    List<Integer> selectAllCategories();

    /**
     * 分页查询所有商品
     * @param offset 偏移量
     * @param limit 每页数量
     * @return 商品列表
     */
    List<Product> selectAllWithPagination(@Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 分页查询指定分类的商品
     * @param category 分类
     * @param offset 偏移量
     * @param limit 每页数量
     * @return 商品列表
     */
    List<Product> selectByCategoryWithPagination(@Param("category") Integer category, @Param("offset") Integer offset, @Param("limit") Integer limit);

    /**
     * 查询商品总数
     * @return 商品总数
     */
    int countAll();

    /**
     * 查询指定分类的商品总数
     * @param category 分类
     * @return 商品总数
     */
    int countByCategory(Integer category);

    void insertProduct(Product product);

    void updateProduct(Product product);

    void deleteProduct(int pid);
}
