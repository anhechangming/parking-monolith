package com.parking.mapper;

import com.parking.entity.ParkingSpace;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 车位Mapper接口
 *
 * @author Parking System
 */
@Mapper
public interface ParkingSpaceMapper {

    @Select("SELECT * FROM park_list WHERE park_id = #{parkId}")
    ParkingSpace findById(@Param("parkId") Long parkId);

    @Select("SELECT * FROM park_list WHERE status = '0' ORDER BY park_num ASC")
    List<ParkingSpace> findAvailable();

    @Select("SELECT COUNT(*) FROM park_list WHERE park_num = #{parkNum}")
    int countByParkNum(@Param("parkNum") String parkNum);

    @Insert("INSERT INTO park_list(park_num, park_name, status) " +
            "VALUES(#{parkNum}, #{parkName}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "parkId", keyColumn = "park_id")
    int insert(ParkingSpace parkingSpace);

    @Update("UPDATE park_list SET park_num=#{parkNum}, park_name=#{parkName}, " +
            "status=#{status} WHERE park_id=#{parkId}")
    int update(ParkingSpace parkingSpace);

    @Delete("DELETE FROM park_list WHERE park_id = #{parkId}")
    int deleteById(@Param("parkId") Long parkId);

    // 分页查询方法（复杂查询，在XML中实现）
    List<ParkingSpace> findByPage(@Param("offset") int offset,
                                   @Param("limit") int limit,
                                   @Param("keyword") String keyword,
                                   @Param("status") String status);

    int countByKeyword(@Param("keyword") String keyword,
                       @Param("status") String status);
}
