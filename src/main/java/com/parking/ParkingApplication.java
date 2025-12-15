package com.parking;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 停车管理系统 - 启动类
 *
 * @author Parking System
 * @date 2025-12-15
 */
@SpringBootApplication
@MapperScan("com.parking.mapper")
public class ParkingApplication {


    public static void main(String[] args) {
        SpringApplication.run(ParkingApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("停车管理系统启动成功！");
        System.out.println("访问地址: http://localhost:8080/api");
        System.out.println("========================================\n");
    }
}
