# API测试指南

## 📦 测试工具包

本项目提供了3种测试方式：

1. **Postman测试集合** (`Postman测试集合.json`) - 推荐
2. **Shell脚本** (`test-api.sh`) - Linux/Mac用户
3. **批处理脚本** (`test-api.bat`) - Windows用户

---

## 🚀 方式1: 使用Postman测试（推荐）

### 步骤1: 导入集合

1. 打开Postman
2. 点击左上角 `Import`
3. 选择 `Postman测试集合.json` 文件
4. 导入成功后，会看到"停车管理系统API测试"集合

### 步骤2: 配置环境变量

集合已包含变量配置，默认值：
- `baseUrl`: http://localhost:8080/api
- `adminToken`: 空（登录后自动填充）
- `ownerToken`: 空（登录后自动填充）

### 步骤3: 开始测试

按照以下顺序测试：

#### 1️⃣ **认证接口测试**
```
1.1 管理员登录
    ✓ Token会自动保存到 adminToken 变量
    ✓ 后续管理员接口会自动使用此Token

1.2 业主登录
    ✓ Token会自动保存到 ownerToken 变量
    ✓ 后续业主接口会自动使用此Token
```

#### 2️⃣ **管理员-业主管理**
```
2.1 分页查询业主列表
2.2 查询所有业主
2.3 新增业主 (可选)
2.4 根据ID查询业主
2.5 更新业主信息 (可选)
```

#### 3️⃣ **管理员-车位管理**
```
3.1 分页查询车位列表
3.2 查询空闲车位
3.3 新增车位 (可选)
3.4 分配车位
3.5 业主退车位
```

#### 4️⃣ **管理员-停车费管理**
```
4.1 分页查询停车费
4.2 新增停车费 (可选)
4.3 查询指定业主的停车费
```

#### 5️⃣ **业主端接口**
```
5.1 查看我的车位
5.2 查看我的停车费记录
5.3 查看未缴费列表
5.4 缴纳停车费
```

### 步骤4: 查看测试结果

每个请求都包含自动化测试脚本：
- ✅ 状态码200验证
- ✅ 响应结构验证
- ✅ 自动保存Token

---

## 🐧 方式2: 使用Shell脚本测试（Linux/Mac）

### 前置条件

确保已安装 `curl` 和 `jq`（可选）：
```bash
# macOS
brew install curl jq

# Ubuntu/Debian
sudo apt-get install curl jq
```

### 使用步骤

```bash
# 1. 添加执行权限
chmod +x test-api.sh

# 2. 运行测试
./test-api.sh
```

### 脚本功能

- ✅ 自动测试所有GET接口
- ✅ 自动提取并保存Token
- ✅ 彩色输出测试结果
- ✅ 显示每个接口的响应

---

## 🪟 方式3: 使用批处理脚本测试（Windows）

### 前置条件

Windows 10及以上版本自带curl命令。

### 使用步骤

```batch
# 双击运行
test-api.bat
```

### 使用说明

1. 脚本会先测试管理员登录和业主登录
2. 请手动从响应中复制Token并粘贴
3. 后续测试会自动使用输入的Token

---

## 📊 完整测试流程示例

### 测试场景：管理员分配车位给业主

```
步骤1: 管理员登录
POST /api/auth/admin/login
参数: loginName=admin&password=admin123
预期: 返回Token

步骤2: 查询空闲车位
GET /api/admin/parkings/available
预期: 返回空闲车位列表

步骤3: 查询所有业主
GET /api/admin/owners/all
预期: 返回业主列表

步骤4: 分配车位
POST /api/admin/parkings/assign
参数: userId=1003&parkId=1003&carNumber=京C88888
预期: 分配成功

步骤5: 验证分配结果
GET /api/admin/parkings/1003
预期: status=1（已分配）
```

### 测试场景：业主查看和缴纳停车费

```
步骤1: 业主登录
POST /api/auth/owner/login
参数: loginName=owner001&password=admin123
预期: 返回Token

步骤2: 查看我的车位
GET /api/owner/my-parking?userId=1001
预期: 返回车位信息

步骤3: 查看未缴费列表
GET /api/owner/unpaid-fees?userId=1001
预期: 返回未缴费记录

步骤4: 缴纳停车费
POST /api/owner/pay-parking-fee
参数: parkFeeId=1&userId=1001
预期: 缴费成功

步骤5: 验证缴费结果
GET /api/owner/my-parking-fees?userId=1001
预期: 对应记录的payParkStatus=1
```

---

## 🔍 接口测试要点

### 1. Token使用

所有接口（除登录外）都需要在请求头中携带Token：

```
Authorization: Bearer {your_token_here}
```

### 2. 响应格式

所有接口返回统一格式：

```json
{
  "code": 200,        // 200成功，500失败
  "message": "操作成功",
  "data": {...}       // 具体数据
}
```

### 3. 分页参数

分页查询接口统一使用：
- `pageNum`: 页码（从1开始）
- `pageSize`: 每页数量

### 4. 状态值说明

**车位状态 (status)**
- `0`: 空闲
- `1`: 已分配

**停车费状态 (payParkStatus)**
- `0`: 未缴费
- `1`: 已缴费

**用户状态 (status)**
- `0`: 正常
- `1`: 停用

---

## 🐛 常见测试问题

### Q1: Token过期怎么办？
A: 重新调用登录接口获取新Token（默认有效期24小时）。

### Q2: 接口返回401？
A: 检查Token是否正确，是否在请求头中携带。

### Q3: 接口返回500？
A: 查看响应的message字段，通常会说明错误原因。

### Q4: 分配车位失败？
A: 检查：
- 车位是否已被分配（status=1）
- 业主是否已有车位
- 车位ID和业主ID是否存在

### Q5: Windows脚本中文乱码？
A: 脚本已包含 `chcp 65001` 命令设置UTF-8编码。

---

## 📝 测试检查清单

完整测试应包含以下场景：

### ✅ 认证功能
- [ ] 管理员登录成功
- [ ] 业主登录成功
- [ ] 错误密码登录失败
- [ ] 不存在的账号登录失败

### ✅ 业主管理
- [ ] 查询业主列表
- [ ] 新增业主
- [ ] 更新业主信息
- [ ] 查询单个业主
- [ ] 删除业主（可选）

### ✅ 车位管理
- [ ] 查询车位列表
- [ ] 查询空闲车位
- [ ] 新增车位
- [ ] 分配车位给业主
- [ ] 业主退车位
- [ ] 重复分配验证（应失败）

### ✅ 停车费管理
- [ ] 管理员录入停车费
- [ ] 查询停车费列表
- [ ] 业主查看停车费
- [ ] 业主缴纳停车费
- [ ] 重复缴纳验证（应失败）

---

## 🎯 性能测试（可选）

使用Apache Bench (ab) 进行简单压测：

```bash
# 测试登录接口
ab -n 1000 -c 10 -p login.json -T "application/x-www-form-urlencoded" \
   http://localhost:8080/api/auth/admin/login

# 测试查询接口（需要先获取Token）
ab -n 1000 -c 10 -H "Authorization: Bearer YOUR_TOKEN" \
   http://localhost:8080/api/admin/owners
```

---

## 📧 反馈

如果测试中发现问题，请记录：
1. 请求URL
2. 请求参数
3. 错误信息
4. 预期结果 vs 实际结果

---

**最后更新**: 2025-12-15
**测试工具版本**: Postman v10+, curl 7.x+
