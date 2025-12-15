package com.parking;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * BCrypt密码测试工具
 */
public class BCryptPasswordTest {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        String plainPassword = "admin123";
        String hashedPasswordFromDB = "$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU.o1xhKj0a";

        // 测试1：验证数据库中的密码是否匹配 admin123
        boolean matches = encoder.matches(plainPassword, hashedPasswordFromDB);
        System.out.println("数据库密码是否匹配 'admin123': " + matches);

        // 测试2：生成新的密码哈希（如果需要重置）
        String newHash = encoder.encode(plainPassword);
        System.out.println("\n新生成的 'admin123' 密码哈希: " + newHash);
        System.out.println("新哈希验证结果: " + encoder.matches(plainPassword, newHash));

        // 测试3：显示当前使用的加密信息
        System.out.println("\nBCrypt配置信息:");
        System.out.println("- BCrypt版本: BCryptPasswordEncoder");
        System.out.println("- 原始密码: " + plainPassword);
        System.out.println("- 数据库哈希: " + hashedPasswordFromDB);
    }
}
