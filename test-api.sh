#!/bin/bash

# ============================================
# 停车管理系统 - API接口测试脚本
# 使用curl命令测试所有接口
# ============================================

# 配置
BASE_URL="http://localhost:8080/api"
ADMIN_TOKEN=""
OWNER_TOKEN=""

# 颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印分隔线
print_separator() {
    echo "=================================================="
}

# 打印测试标题
print_title() {
    echo -e "${YELLOW}$1${NC}"
    print_separator
}

# 打印成功信息
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# 打印错误信息
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# 测试接口
test_api() {
    local method=$1
    local url=$2
    local data=$3
    local token=$4
    local description=$5

    echo ""
    echo "测试: $description"
    echo "URL: $method $url"

    if [ -z "$token" ]; then
        if [ "$method" == "GET" ]; then
            response=$(curl -s -X $method "$url")
        else
            response=$(curl -s -X $method "$url" \
                -H "Content-Type: application/json" \
                -d "$data")
        fi
    else
        if [ "$method" == "GET" ]; then
            response=$(curl -s -X $method "$url" \
                -H "Authorization: Bearer $token")
        else
            response=$(curl -s -X $method "$url" \
                -H "Authorization: Bearer $token" \
                -H "Content-Type: application/json" \
                -d "$data")
        fi
    fi

    echo "响应: $response"

    # 检查响应是否包含 "code":200
    if echo "$response" | grep -q '"code":200'; then
        print_success "测试通过"
        return 0
    else
        print_error "测试失败"
        return 1
    fi
}

# ============================================
# 开始测试
# ============================================

print_title "停车管理系统 API 测试开始"
echo "基础URL: $BASE_URL"
echo ""

# ============================================
# 1. 认证接口测试
# ============================================
print_title "1. 认证接口测试"

# 1.1 管理员登录
echo ""
echo "1.1 管理员登录"
response=$(curl -s -X POST "${BASE_URL}/auth/admin/login?loginName=admin&password=admin123")
echo "响应: $response"

if echo "$response" | grep -q '"code":200'; then
    ADMIN_TOKEN=$(echo $response | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    print_success "管理员登录成功"
    echo "Token: $ADMIN_TOKEN"
else
    print_error "管理员登录失败"
    exit 1
fi

# 1.2 业主登录
echo ""
echo "1.2 业主登录"
response=$(curl -s -X POST "${BASE_URL}/auth/owner/login?loginName=owner001&password=admin123")
echo "响应: $response"

if echo "$response" | grep -q '"code":200'; then
    OWNER_TOKEN=$(echo $response | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    print_success "业主登录成功"
    echo "Token: $OWNER_TOKEN"
else
    print_error "业主登录失败"
fi

# ============================================
# 2. 管理员-业主管理
# ============================================
print_title "2. 管理员-业主管理接口测试"

# 2.1 分页查询业主列表
test_api "GET" "${BASE_URL}/admin/owners?pageNum=1&pageSize=10" "" "$ADMIN_TOKEN" "分页查询业主列表"

# 2.2 查询所有业主
test_api "GET" "${BASE_URL}/admin/owners/all" "" "$ADMIN_TOKEN" "查询所有业主"

# 2.3 根据ID查询业主
test_api "GET" "${BASE_URL}/admin/owners/1001" "" "$ADMIN_TOKEN" "根据ID查询业主"

# ============================================
# 3. 管理员-车位管理
# ============================================
print_title "3. 管理员-车位管理接口测试"

# 3.1 分页查询车位列表
test_api "GET" "${BASE_URL}/admin/parkings?pageNum=1&pageSize=10" "" "$ADMIN_TOKEN" "分页查询车位列表"

# 3.2 查询空闲车位
test_api "GET" "${BASE_URL}/admin/parkings/available" "" "$ADMIN_TOKEN" "查询空闲车位"

# 3.3 根据ID查询车位
test_api "GET" "${BASE_URL}/admin/parkings/1001" "" "$ADMIN_TOKEN" "根据ID查询车位"

# ============================================
# 4. 管理员-停车费管理
# ============================================
print_title "4. 管理员-停车费管理接口测试"

# 4.1 分页查询停车费
test_api "GET" "${BASE_URL}/admin/parking-fees?pageNum=1&pageSize=10" "" "$ADMIN_TOKEN" "分页查询停车费"

# 4.2 查询指定业主的停车费
test_api "GET" "${BASE_URL}/admin/parking-fees?userId=1001" "" "$ADMIN_TOKEN" "查询指定业主的停车费"

# ============================================
# 5. 业主端接口
# ============================================
print_title "5. 业主端接口测试"

# 5.1 查看我的车位
test_api "GET" "${BASE_URL}/owner/my-parking?userId=1001" "" "$OWNER_TOKEN" "查看我的车位"

# 5.2 查看我的停车费记录
test_api "GET" "${BASE_URL}/owner/my-parking-fees?userId=1001" "" "$OWNER_TOKEN" "查看我的停车费记录"

# 5.3 查看未缴费列表
test_api "GET" "${BASE_URL}/owner/unpaid-fees?userId=1001" "" "$OWNER_TOKEN" "查看未缴费列表"

# ============================================
# 测试总结
# ============================================
print_separator
print_title "测试完成"
echo ""
echo "所有基础接口测试完成！"
echo ""
echo "管理员Token: $ADMIN_TOKEN"
echo "业主Token: $OWNER_TOKEN"
echo ""
print_separator
