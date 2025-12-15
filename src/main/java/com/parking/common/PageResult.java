package com.parking.common;

import lombok.Data;

import java.util.List;

/**
 * 分页结果类
 *
 * @author Parking System
 */
@Data
public class PageResult<T> {

    /**
     * 当前页码
     */
    private int current;

    /**
     * 每页大小
     */
    private int size;

    /**
     * 总记录数
     */
    private long total;

    /**
     * 数据列表
     */
    private List<T> records;

    /**
     * 总页数
     */
    private long pages;

    public PageResult(int current, int size, long total, List<T> records) {
        this.current = current;
        this.size = size;
        this.total = total;
        this.records = records;
        this.pages = (total + size - 1) / size; // 计算总页数
    }
}
