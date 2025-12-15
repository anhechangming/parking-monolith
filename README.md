# 停车管理系统 - 简化单体版

## 📋 项目简介

这是一个简化的停车管理系统单体应用，专为作业和学习目的设计。系统保留了核心功能，删除了房屋管理、水电费等复杂模块。

### 核心功能

**管理员功能：**
- 登录/登出
- 业主管理（CRUD）
- 车位管理（CRUD）
- 车位分配与退位
- 停车费管理（录入、查询）

**业主功能：**
- 登录/登出
- 查看我的车位
- 查看停车费记录
- 在线缴纳停车费

## 🛠️ 技术栈

- **Java版本**: Java 21
- **后端框架**: Spring Boot 3.5.7
- **ORM框架**: MyBatis 3.0.4 (原生MyBatis)
- **数据库**: MySQL 8.0+
- **认证方案**: JWT (jjwt 0.12.6)
- **密码加密**: BCrypt
- **构建工具**: Maven

> **注意**: 本项目使用原生MyBatis而非MyBatis Plus，以确保与Spring Boot 3.5.7的完全兼容性。

## 📁 项目结构

```
parking-monolith/
├── src/main/java/com/parking/
│   ├── ParkingApplication.java    # 启动类
│   ├── common/                    # 通用类
│   │   ├── Result.java            # 统一返回结果
│   │   ├── JwtUtils.java          # JWT工具类
│   │   └── PageResult.java        # 分页结果类
│   ├── entity/                    # 实体类
│   │   ├── Admin.java             # 管理员
│   │   ├── Owner.java             # 业主
│   │   ├── ParkingSpace.java      # 车位
│   │   ├── OwnerParking.java      # 业主车位关联
│   │   └── ParkingFee.java        # 停车费
│   ├── mapper/                    # 数据访问层
│   │   ├── AdminMapper.java
│   │   ├── OwnerMapper.java
│   │   ├── ParkingSpaceMapper.java
│   │   ├── OwnerParkingMapper.java
│   │   └── ParkingFeeMapper.java
│   ├── service/                   # 业务逻辑层
│   │   ├── AuthService.java       # 认证服务
│   │   ├── OwnerService.java      # 业主服务
│   │   ├── ParkingService.java    # 车位服务
│   │   └── ParkingFeeService.java # 停车费服务
│   ├── controller/                # 控制器层
│   │   ├── AuthController.java    # 认证控制器
│   │   ├── AdminController.java   # 管理员控制器
│   │   └── OwnerController.java   # 业主控制器
│   └── config/                    # 配置类
│       ├── CorsConfig.java        # 跨域配置
│       └── GlobalExceptionHandler.java # 异常处理
└── src/main/resources/
    ├── application.yml            # 应用配置
    └── mapper/                    # MyBatis XML映射文件
        ├── OwnerMapper.xml
        ├── ParkingSpaceMapper.xml
        └── ParkingFeeMapper.xml
```

## 🗄️ 数据库设计

**6张核心表**：

1. **sys_user** - 系统管理员表
2. **live_user** - 业主表
3. **park_list** - 车位表
4. **live_park** - 业主车位关联表
5. **fee_park** - 停车费表
6. **sys_role** - 角色表（仅2条固定记录）

## 🚀 快速开始

### 前置要求

- **Java**: JDK 21 或更高版本
- **Maven**: 3.6+
- **MySQL**: 8.0+

### 1. 数据库准备

```bash
# 1. 创建数据库
mysql -u root -p
source parking-system.sql

# 2. 确认数据导入成功
USE parking_system;
SHOW TABLES;
```

### 2. 修改配置文件

编辑 `src/main/resources/application.yml`，修改数据库连接信息：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/parking_system?...
    username: root
    password: 你的密码
```

### 3. 启动项目

```bash
# 方式1: 使用Maven命令
cd parking-monolith
mvn spring-boot:run

# 方式2: IDEA中运行
# 右键 ParkingApplication.java -> Run

# 方式3: 打包后运行
mvn clean package
java -jar target/parking-monolith-1.0.0.jar
```

### 4. 验证启动

看到以下输出表示启动成功：

```
========================================
停车管理系统启动成功！
访问地址: http://localhost:8080/api
========================================
```

## 🔐 默认账号

### 管理员账号
- 账号：`admin`
- 密码：`admin123`

### 业主账号
- 账号：`owner001` / `owner002` / `owner003`
- 密码：`admin123`

## 📡 API接口文档

### 基础路径
```
http://localhost:8080/api
```

### 认证接口

#### 1. 管理员登录
```
POST /auth/admin/login
参数：loginName=admin&password=admin123

返回：
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzUxMiJ9...",
    "userId": 1,
    "username": "系统管理员",
    "roleType": "admin"
  }
}
```

#### 2. 业主登录
```
POST /auth/owner/login
参数：loginName=owner001&password=admin123

返回：同上，roleType为"owner"
```

### 管理员接口（需要Token）

#### 业主管理
```
GET  /admin/owners?pageNum=1&pageSize=10&keyword=张三  # 分页查询
GET  /admin/owners/all                                 # 查询所有
GET  /admin/owners/{userId}                            # 根据ID查询
POST /admin/owners                                     # 新增
PUT  /admin/owners/{userId}                            # 更新
DELETE /admin/owners/{userId}                          # 删除
```

#### 车位管理
```
GET  /admin/parkings?pageNum=1&pageSize=10&status=0    # 分页查询
GET  /admin/parkings/available                         # 查询空闲车位
GET  /admin/parkings/{parkId}                          # 根据ID查询
POST /admin/parkings                                   # 新增
PUT  /admin/parkings/{parkId}                          # 更新
DELETE /admin/parkings/{parkId}                        # 删除
POST /admin/parkings/assign?userId=1001&parkId=1001&carNumber=京A12345  # 分配车位
POST /admin/parkings/return?userId=1001                # 退位
```

#### 停车费管理
```
GET  /admin/parking-fees?pageNum=1&pageSize=10         # 分页查询
GET  /admin/parking-fees/{parkFeeId}                   # 根据ID查询
POST /admin/parking-fees                               # 新增
PUT  /admin/parking-fees/{parkFeeId}                   # 更新
DELETE /admin/parking-fees/{parkFeeId}                 # 删除
```

### 业主接口（需要Token）

```
GET  /owner/my-parking?userId=1001                     # 查看我的车位
GET  /owner/my-parking-fees?userId=1001                # 查看停车费记录
GET  /owner/unpaid-fees?userId=1001                    # 查看未缴费
POST /owner/pay-parking-fee?parkFeeId=1&userId=1001    # 缴费
GET  /owner/parking-fees/{parkFeeId}                   # 查看详情
```

### 请求头说明

除登录接口外，其他接口需要在请求头中携带Token：

```
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...
```

## 🧪 测试建议

### 使用Postman测试

1. **导入环境变量**
   ```
   BASE_URL: http://localhost:8080/api
   TOKEN: (登录后获取)
   ```

2. **测试流程**
   ```
   步骤1: 管理员登录 -> 获取Token
   步骤2: 创建业主
   步骤3: 创建车位
   步骤4: 分配车位给业主
   步骤5: 录入停车费
   步骤6: 业主登录 -> 获取Token
   步骤7: 查看车位信息
   步骤8: 缴纳停车费
   ```

## 📊 数据库ER图

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│  sys_user   │         │  live_user   │         │  park_list  │
│  (管理员)   │         │   (业主)     │         │   (车位)    │
└─────────────┘         └──────────────┘         └─────────────┘
                                │                        │
                                │                        │
                                └────────┬───────────────┘
                                         │
                                   ┌─────┴──────┐
                                   │ live_park  │
                                   │ (关联表)   │
                                   └─────┬──────┘
                                         │
                                   ┌─────┴──────┐
                                   │  fee_park  │
                                   │ (停车费)   │
                                   └────────────┘
```

## 🎯 下一步计划

当前版本是单体应用。后续可以进行微服务拆分：

1. **auth-service** (认证服务) - 端口8081
2. **parking-service** (停车服务) - 端口8082
3. **gateway-service** (网关服务) - 端口8080

详见：`微服务拆分架构文档.md`

## ⚠️ 注意事项

1. 本项目为简化版本，仅供学习和作业使用
2. 密码使用BCrypt加密，已有一定安全性
3. 所有接口返回统一格式的Result对象

## 📝 常见问题

### Q1: 启动失败，提示"Unsupported class file major version"？
A: 检查是否安装了Java 21。运行 `java -version` 确认版本。

### Q2: 启动失败，提示数据库连接错误？
A: 检查MySQL是否启动，数据库名、用户名、密码是否正确。

### Q3: 接口返回401或403？
A: 检查Token是否正确，是否在请求头中携带。

### Q4: 如何添加新的业主？
A: 使用管理员Token，调用 `POST /admin/owners` 接口。

### Q5: 如何重置密码？
A: 默认密码都是 `admin123`，可以在数据库中直接使用BCrypt加密后的字符串。

### Q6: MyBatis相关问题？
A: 本项目使用原生MyBatis。如遇到Mapper映射问题，检查`application.yml`中的`mybatis.mapper-locations`配置。

### Q7: 为什么使用MyBatis而不是MyBatis Plus？
A: Spring Boot 3.5.7与MyBatis Plus 3.5.x存在兼容性问题。使用原生MyBatis 3.0.4可确保完全兼容。

## 📧 联系方式

如有问题，请联系项目负责人。

---

**项目创建时间**: 2025-12-15
**版本**: v1.0.0（单体）
