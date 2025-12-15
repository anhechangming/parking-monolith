package com.parking.mapper;

import com.parking.entity.OwnerParking;
import org.apache.ibatis.annotations.*;

/**
 * 业主车位关联Mapper接口
 *
 * @author Parking System
 */
@Mapper
public interface OwnerParkingMapper {

    @Select("SELECT * FROM live_park WHERE user_id = #{userId} AND status = '1'")
    OwnerParking findByUserIdAndActive(@Param("userId") Long userId);

    @Select("SELECT COUNT(*) FROM live_park WHERE user_id = #{userId} AND status = '1'")
    int countByUserIdAndActive(@Param("userId") Long userId);

    @Insert("INSERT INTO live_park(user_id, park_id, car_number, bind_time, status) " +
            "VALUES(#{userId}, #{parkId}, #{carNumber}, #{bindTime}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
    int insert(OwnerParking ownerParking);

    @Update("UPDATE live_park SET status=#{status} WHERE id=#{id}")
    int update(OwnerParking ownerParking);
}
