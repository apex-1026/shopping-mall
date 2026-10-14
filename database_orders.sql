-- 创建订单表
CREATE TABLE IF NOT EXISTS `orders` (
  `orderid` INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `totalprice` DOUBLE NOT NULL COMMENT '订单总价',
  `ordertime` DATETIME NOT NULL COMMENT '下单时间',
  `status` INT NOT NULL DEFAULT 1 COMMENT '订单状态：1-待付款，2-已付款，3-已发货，4-已完成，5-已取消'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单表';

-- 创建订单明细表（保存下单时商品快照，便于订单展示图片）
CREATE TABLE IF NOT EXISTS `order_items` (
  `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
  `orderid` INT NOT NULL COMMENT '订单ID',
  `pid` INT NOT NULL COMMENT '商品ID',
  `pname` VARCHAR(100) NOT NULL COMMENT '商品名称快照',
  `pimage` VARCHAR(255) DEFAULT NULL COMMENT '商品图片快照',
  `price` DOUBLE NOT NULL COMMENT '成交单价快照',
  `quantity` INT NOT NULL COMMENT '购买数量',
  INDEX `idx_orderid` (`orderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单明细表';

-- 插入测试数据（可选）
INSERT INTO `orders` (`username`, `totalprice`, `ordertime`, `status`) VALUES
('admin', 2999.00, NOW(), 4),
('admin', 1599.00, NOW(), 2);
