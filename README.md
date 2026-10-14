# 购物商城系统（Shopping Mall）

一个基于 **Servlet + JSP + MyBatis + MySQL** 的 Java Web 商城项目，覆盖用户注册登录、商品浏览/搜索、购物车、下单、后台管理，并接入**支付宝沙箱支付**流程，适合作为 Java Web / 后端入门到进阶的学习与求职演示项目。

## 技术栈

| 分类 | 技术 |
|------|------|
| 语言 | Java 8 |
| Web 层 | Servlet 4.0、JSP、JSTL、EL |
| 持久层 | MyBatis 3.4.5（注解 + XML Mapper） |
| 数据库 | MySQL 5.x |
| 构建 / 部署 | Maven、Tomcat |
| 支付 | 支付宝沙箱（RSA2 签名）、微信模拟收银台 |
| 其他 | fastjson / gson、原生 HTML + CSS |

## 功能特性

**前台（用户端）**
- 用户注册 / 登录 / 退出，支持头像上传
- 商品列表、详情、分类浏览、关键词搜索、分页
- 购物车（Session 存储）：加购、修改数量、删除、结算
- 下单：订单主表 + 明细快照，手动事务保证数据一致
- 我的订单：分页查看、待付款转已付款

**后台（管理端）**
- 用户管理：列表、修改、删除
- 商品管理：增删改查、分页
- 订单管理：分页 + 按状态筛选 + 状态流转校验
- 数据统计：今日订单数、今日/累计销售额

**支付**
- 支付宝沙箱：RSA2 签名 → 表单跳转 → 同步回跳 + 异步通知验签（幂等）
- 微信支付：学习版模拟收银台页

## 权限与安全设计

- `user.role` 区分普通用户（1）/ 管理员（2）
- 管理员访问前台订单时自动跳转后台入口
- 订单操作做**归属校验**（普通用户只能操作自己的订单）
- 订单状态 `1→2→3→4` 递进流转，非法跳转拒绝更新
- SQL 使用 MyBatis `#{}` 预编译，防注入

## 项目结构

```
shopping-mall-project-master
├── src/com/qf/
│   ├── Servlet/    # 控制层：30+ 个 Servlet（路由 + 业务编排）
│   ├── dao/        # DAO 接口（MyBatis Mapper 接口）
│   ├── mapper/     # MyBatis XML 映射文件
│   ├── pojo/       # 实体类：User / Product / Order / OrderItem / CartItem
│   └── Utils/      # 工具类：MyBatisUtil / 支付 / 文件上传 / 日志
├── web/
│   ├── admin/      # 后台 JSP 页面
│   ├── *.jsp       # 前台页面
│   └── WEB-INF/    # web.xml、依赖 jar
├── src/mybatis.xml # MyBatis 全局配置
└── pom.xml         # Maven 配置
```

## 快速开始

### 环境要求

- JDK 1.8+
- Maven 3.x
- MySQL 5.x
- Tomcat 8.5 / 9

### 1. 初始化数据库

新建数据库 `mybatis04`，依次执行下面的建表语句，再执行仓库里的 `database_orders.sql`：

```sql
CREATE DATABASE IF NOT EXISTS mybatis04 DEFAULT CHARACTER SET utf8;
USE mybatis04;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
  `uid`      VARCHAR(32) PRIMARY KEY COMMENT '用户ID(UUID)',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(50) NOT NULL COMMENT '密码',
  `role`     INT NOT NULL DEFAULT 1 COMMENT '1-普通用户 2-管理员',
  `avatar`   VARCHAR(255) DEFAULT NULL COMMENT '头像文件名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

-- 商品表
CREATE TABLE IF NOT EXISTS `product` (
  `pid`      INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品ID',
  `pname`    VARCHAR(100) NOT NULL COMMENT '商品名称',
  `pdesc`    TEXT COMMENT '商品描述',
  `price`    DOUBLE NOT NULL COMMENT '价格',
  `pimage`   VARCHAR(255) DEFAULT NULL COMMENT '图片路径',
  `category` INT DEFAULT 1 COMMENT '分类'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品表';

-- 默认管理员账号（用户名 admin / 密码 admin123）
INSERT INTO `user` (`uid`, `username`, `password`, `role`) VALUES
(UUID(), 'admin', 'admin123', 2);
```

订单表（`orders`、`order_items`）直接执行仓库里的 `database_orders.sql` 即可。

### 2. 修改数据库连接

编辑 `src/mybatis.xml`，改成你的 MySQL 账号密码：

```xml
<property name="url"      value="jdbc:mysql://localhost:3306/mybatis04?useSSL=false&amp;characterEncoding=utf-8"/>
<property name="username" value="root"/>
<property name="password" value="root"/>
```

### 3. 部署运行

- 用 IDEA 导入 Maven 项目，配置 Tomcat，启动后访问 `http://localhost:8080/Mybatis04`
- 或执行 `mvn clean package` 打 war 包，放到 Tomcat 的 `webapps/` 目录

## 支付说明

- 支付配置在 `src/payment.properties`（默认 `payment.mode=mock` 走模拟流程）
- 支付宝沙箱需填入自己的 `appId`、应用私钥、支付宝公钥，参考 `payment.properties.example`
- **注意**：真实密钥请勿提交到公开仓库，仓库已通过 `.gitignore` 排除 `src/payment.properties`

## 待优化方向

- 金额字段改用 `DECIMAL` + `BigDecimal`
- 下单时事务内扣减库存
- 用 `Filter` 统一登录拦截
- 升级为 Spring Boot + MyBatis 版本

## 许可证

本项目仅用于学习与求职演示。
