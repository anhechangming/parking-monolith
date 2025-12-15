package com.parking.mapper;

import com.parking.entity.Admin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 系统管理员Mapper接口
 *
 * @author Parking System
 */
@Mapper
public interface AdminMapper {

    @Select("SELECT * FROM sys_user WHERE login_name = #{loginName}")
    Admin findByLoginName(@Param("loginName") String loginName);
}
