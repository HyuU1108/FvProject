package com.fv.biz.flight;

import java.util.List;

public interface FlightInfoDao {
    void save(FlightInfo flightInfo);
    FlightInfo findById(String id);
    List<FlightInfo> findAll();
    
    // selectFlightInfoById 추가
    FlightInfo selectFlightInfoById(String flightId); 

    // 필요에 따라 다른 메서드 추가
}