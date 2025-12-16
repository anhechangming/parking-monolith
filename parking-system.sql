-- =====================================================
-- 停车管理系统 - 简化版数据库脚本
-- 创建时间: 2025-12-15
-- 说明: 核心6张表，删除房屋管理、水电费等模块
-- =====================================================

CREATE DATABASE IF NOT EXISTS `parking_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `parking_system`;

-- =====================================================
-- 1. 系统管理员表 (sys_user)
-- =====================================================
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `login_name` varchar(30) NOT NULL COMMENT '登录账号',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `username` varchar(30) DEFAULT '' COMMENT '用户昵称',
  `phone` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_login_name` (`login_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='系统管理员表';

-- 初始化管理员账号：admin / admin123
INSERT INTO `sys_user` VALUES
(1, 'admin', '$2a$10$6j28Ej1OaWvpKeA08Y.v8O0.cMQUnq0VyaaCU4DtlKmCGsca4y2yG', '系统管理员', '13800138000', '0', '0', NOW(), NOW());

-- =====================================================
-- 2. 业主表 (live_user)
-- =====================================================
DROP TABLE IF EXISTS `live_user`;
CREATE TABLE `live_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '业主ID',
  `login_name` varchar(30) NOT NULL COMMENT '登录账号',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `username` varchar(30) DEFAULT '' COMMENT '业主姓名',
  `phone` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '性别（0男 1女 2未知）',
  `id_card` varchar(18) DEFAULT '' COMMENT '身份证号',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uk_login_name` (`login_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COMMENT='业主表';

-- 初始化测试业主数据
INSERT INTO `live_user` VALUES
(1001, 'owner001', '$2a$10$6j28Ej1OaWvpKeA08Y.v8O0.cMQUnq0VyaaCU4DtlKmCGsca4y2yG', '张三', '13900139000', '0', '110101199001011234', '0', NOW(), NOW()),
(1002, 'owner002', '$2a$10$6j28Ej1OaWvpKeA08Y.v8O0.cMQUnq0VyaaCU4DtlKmCGsca4y2yG', '李四', '13900139001', '1', '110101199002021234', '0', NOW(), NOW()),
(1003, 'owner003', '$2a$10$6j28Ej1OaWvpKeA08Y.v8O0.cMQUnq0VyaaCU4DtlKmCGsca4y2yG', '王五', '13900139002', '0', '110101199003031234', '0', NOW(), NOW());

-- =====================================================
-- 3. 车位表 (park_list)
-- =====================================================
DROP TABLE IF EXISTS `park_list`;
CREATE TABLE `park_list` (
  `park_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '车位ID',
  `park_name` varchar(50) DEFAULT '' COMMENT '车位名称',
  `park_num` varchar(20) NOT NULL COMMENT '车位编号',
  `park_type` varchar(20) DEFAULT '地下车位' COMMENT '车位类型（地下车位/地上车位/路边车位）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0空闲 1已分配）',
  `remark` varchar(200) DEFAULT '' COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`park_id`),
  UNIQUE KEY `uk_park_num` (`park_num`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COMMENT='车位表';

-- 初始化车位数据
INSERT INTO `park_list` VALUES
(1001, 'A区车位', 'A-001', '地下车位', '0', 'A区地下一层', NOW(), NOW()),
(1002, 'A区车位', 'A-002', '地下车位', '0', 'A区地下一层', NOW(), NOW()),
(1003, 'A区车位', 'A-003', '地下车位', '0', 'A区地下一层', NOW(), NOW()),
(1004, 'B区车位', 'B-001', '地下车位', '0', 'B区地下一层', NOW(), NOW()),
(1005, 'B区车位', 'B-002', '地下车位', '0', 'B区地下一层', NOW(), NOW()),
(1006, 'C区车位', 'C-001', '地上车位', '0', 'C区地面停车场', NOW(), NOW()),
(1007, 'C区车位', 'C-002', '地上车位', '0', 'C区地面停车场', NOW(), NOW()),
(1008, 'D区车位', 'D-001', '路边车位', '0', 'D区路边停车', NOW(), NOW());

-- =====================================================
-- 4. 业主车位关联表 (live_park)
-- =====================================================
DROP TABLE IF EXISTS `live_park`;
CREATE TABLE `live_park` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint(20) NOT NULL COMMENT '业主ID',
  `park_id` bigint(20) NOT NULL COMMENT '车位ID',
  `car_number` varchar(20) DEFAULT '' COMMENT '车牌号',
  `bind_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '分配时间',
  `status` char(1) DEFAULT '1' COMMENT '状态（0已退位 1使用中）',
  `remark` varchar(200) DEFAULT '' COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_park_id` (`park_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='业主车位关联表';

-- 初始化关联数据（示例）
INSERT INTO `live_park` VALUES
(1, 1001, 1001, '京A12345', NOW(), '1', '张三的车位', NOW(), NOW()),
(2, 1002, 1004, '京B67890', NOW(), '1', '李四的车位', NOW(), NOW());

-- 更新车位状态为已分配
UPDATE `park_list` SET `status` = '1' WHERE `park_id` IN (1001, 1004);

-- =====================================================
-- 5. 停车费表 (fee_park)
-- =====================================================
DROP TABLE IF EXISTS `fee_park`;
CREATE TABLE `fee_park` (
  `park_fee_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '停车费ID',
  `user_id` bigint(20) NOT NULL COMMENT '业主ID',
  `park_id` bigint(20) NOT NULL COMMENT '车位ID',
  `pay_park_month` varchar(10) NOT NULL COMMENT '缴费月份（格式：2025-01）',
  `pay_park_money` decimal(10,2) DEFAULT '0.00' COMMENT '缴费金额',
  `pay_park_status` char(1) DEFAULT '0' COMMENT '缴费状态（0未缴 1已缴）',
  `pay_park_time` datetime DEFAULT NULL COMMENT '缴费时间',
  `remark` varchar(200) DEFAULT '' COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`park_fee_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_park_id` (`park_id`),
  KEY `idx_pay_month` (`pay_park_month`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='停车费表';

-- 初始化停车费数据
INSERT INTO `fee_park` VALUES
(1, 1001, 1001, '2025-12', 300.00, '0', NULL, '2025年12月停车费', NOW(), NOW()),
(2, 1002, 1004, '2025-12', 300.00, '1', NOW(), '2025年12月停车费', NOW(), NOW()),
(3, 1001, 1001, '2025-11', 300.00, '1', '2025-11-05 10:30:00', '2025年11月停车费', NOW(), NOW()),
(4, 1002, 1004, '2025-11', 300.00, '1', '2025-11-03 14:20:00', '2025年11月停车费', NOW(), NOW());

-- =====================================================
-- 6. 角色表 (sys_role) - 简化为固定2个角色
-- =====================================================
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `status` char(1) DEFAULT '0' COMMENT '角色状态（0正常 1停用）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 初始化角色数据
INSERT INTO `sys_role` VALUES
(1, '系统管理员', 'ROLE_ADMIN', '0', NOW(), NOW()),
(2, '业主', 'ROLE_OWNER', '0', NOW(), NOW());

-- =====================================================
-- 数据库脚本执行完成
-- =====================================================
-- 默认密码说明：
-- 所有账号的默认密码都是：admin123
-- 加密后的密码为：$2a$10$6j28Ej1OaWvpKeA08Y.v8O0.cMQUnq0VyaaCU4DtlKmCGsca4y2yG
--
-- 默认账号：
-- 管理员：admin / admin123
-- 业主1：owner001 / admin123
-- 业主2：owner002 / admin123
-- 业主3：owner003 / admin123
-- =====================================================
