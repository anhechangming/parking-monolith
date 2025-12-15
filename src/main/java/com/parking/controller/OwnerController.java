package com.parking.controller;

import com.parking.common.Result;
import com.parking.entity.OwnerParking;
import com.parking.entity.ParkingFee;
import com.parking.entity.ParkingSpace;
import com.parking.service.ParkingFeeService;
import com.parking.service.ParkingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 业主控制器
 *
 * @author Parking System
 */
@RestController
@RequestMapping("/owner")
public class OwnerController {

    @Autowired
    private ParkingService parkingService;

    @Autowired
    private ParkingFeeService parkingFeeService;

    // ==================== 车位信息 ====================

    /**
     * 查看我的车位信息
     *
     * @param userId 业主ID（从Token获取）
     * @return 车位信息
     */
    @GetMapping("/my-parking")
    public Result<Map<String, Object>> getMyParking(@RequestParam Long userId) {
        OwnerParking ownerParking = parkingService.getOwnerParking(userId);

        if (ownerParking == null) {
            return Result.success("暂无车位", null);
        }

        // 获取车位详细信息
        ParkingSpace parkingSpace = parkingService.getParkingById(ownerParking.getParkId());

        Map<String, Object> result = new HashMap<>();
        result.put("ownerParking", ownerParking);
        result.put("parkingSpace", parkingSpace);

        return Result.success(result);
    }

    // ==================== 停车费管理 ====================

    /**
     * 查看我的停车费记录
     *
     * @param userId 业主ID（从Token获取）
     * @return 停车费列表
     */
    @GetMapping("/my-parking-fees")
    public Result<List<ParkingFee>> getMyParkingFees(@RequestParam Long userId) {
        List<ParkingFee> fees = parkingFeeService.getOwnerParkingFees(userId);
        return Result.success(fees);
    }

    /**
     * 查看未缴费的停车费列表
     *
     * @param userId 业主ID（从Token获取）
     * @return 未缴费列表
     */
    @GetMapping("/unpaid-fees")
    public Result<List<ParkingFee>> getUnpaidFees(@RequestParam Long userId) {
        List<ParkingFee> fees = parkingFeeService.getUnpaidFees(userId);
        return Result.success(fees);
    }

    /**
     * 在线缴纳停车费
     *
     * @param parkFeeId 停车费ID
     * @param userId 业主ID（从Token获取）
     * @return 缴费结果
     */
    @PostMapping("/pay-parking-fee")
    public Result<Void> payParkingFee(@RequestParam Long parkFeeId,
                                       @RequestParam Long userId) {
        try {
            boolean success = parkingFeeService.payParkingFee(parkFeeId, userId);
            return success ? Result.success("缴费成功", null) : Result.error("缴费失败");
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }

    /**
     * 查看停车费详情
     *
     * @param parkFeeId 停车费ID
     * @return 停车费详情
     */
    @GetMapping("/parking-fees/{parkFeeId}")
    public Result<ParkingFee> getParkingFeeDetail(@PathVariable Long parkFeeId) {
        ParkingFee parkingFee = parkingFeeService.getParkingFeeById(parkFeeId);
        if (parkingFee == null) {
            return Result.error("停车费记录不存在");
        }
        return Result.success(parkingFee);
    }
}
