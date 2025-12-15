package com.parking.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 车位实体类
 *
 * @author Parking System
 */
@Data
public class ParkingSpace implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 车位ID
     */
    private Long parkId;

    /**
     * 车位名称
     */
    private String parkName;

    /**
     * 车位编号
     */
    private String parkNum;

    /**
     * 车位类型（地下车位/地上车位/路边车位）
     */
    private String parkType;

    /**
     * 状态（0空闲 1已分配）
     */
    private String status;

    /**
     * 备注
     */
    private String remark;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;
}
