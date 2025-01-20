package com.fv.biz.flight;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FlightInfoService {

    @Autowired
    private FlightInfoDao flightInfoDao;

    public void saveFlightInfo(FlightInfo flightInfo) {
        flightInfoDao.save(flightInfo);
    }

    public FlightInfo getFlightInfo(String flightId) {
        return flightInfoDao.selectFlightInfoById(flightId);
    }
}