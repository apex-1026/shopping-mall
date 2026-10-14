package com.qf.dao;

import com.qf.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;


public interface UserDao  {
    List<User> selectAll();
    /**
     * 根据用户名和密码查询用户(登录)
     *
     * @param userName 用户名
     * @param password 密码
     * @return 用户对象,如果不存在则返回null
     */
    User login(@Param("username") String userName, @Param("password") String password);

    /**
     * 注册新用户
     *
     * @param user 用户对象
     * @return 影响的行数
     */
    int register(User user);

    /**
     * 修改用户信息
     *
     * @param user 用户对象
     * @return 影响的行数
     */
    int updateUser(User user);

    /**
     * 删除用户
     *
     * @param uid 用户ID
     * @return 影响的行数
     */
    int deleteUser(String uid);

    /**
     * 根据用户名查询用户
     *
     * @param userName 用户名
     * @return 用户对象，如果不存在则返回null
     */
    User findByUserName(String userName);

    /**
     * 根据UID查询用户
     *
     * @param uid 用户ID
     * @return 用户对象，如果不存在则返回null
     */
    User findByUid(String uid);

}
