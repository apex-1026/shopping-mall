package com.qf.test;

import com.qf.dao.UserDao;
import com.qf.pojo.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class Test {
        public static void main(String[] args) {
        // 读取mybatis.xml配置文件
        InputStream inputStream = null;
        SqlSession sqlSession = null;
        try {
            inputStream = Resources.getResourceAsStream("mybatis.xml");
            // 由SqlSessionFactoryBuilder和mybatis.xml配置文件获取SqlSessionFactory工厂
            SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
            // 由sqlSessionFactory打开连接获取SqlSession连接数据库 相当于Connection
            sqlSession = sqlSessionFactory.openSession();
            // 由SqlSession获取映射器接口UserDao
            UserDao userDao = sqlSession.getMapper(UserDao.class);
            // 映射器接口调用方法，执行指定的SQL语句
            List<User> list = userDao.selectAll();
            for (User user : list) {
                System.out.println(user);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


}
