-- 为 user 表添加头像字段
ALTER TABLE user ADD COLUMN avatar VARCHAR(255) DEFAULT NULL COMMENT '用户头像文件名';
