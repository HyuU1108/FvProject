package com.fv.biz.flight;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;

public class FlightInfoDaoImpl implements FlightInfoDao {
    
	@Autowired
    private SqlSessionTemplate sqlSession;

    @Override
    public void save(FlightInfo flightInfo) {
        sqlSession.insert("FlightInfoMapper.insertFlightInfo", flightInfo);
    }

    @Override
    public FlightInfo findById(String id) {
        return sqlSession.selectOne("FlightInfoMapper.selectFlightInfoById", id);
    }

    @Override
    public List<FlightInfo> findAll() {
        return sqlSession.selectList("FlightInfoMapper.selectAllFlightInfo");
    }
    
    @Override
    public FlightInfo selectFlightInfoById(String flightId) {
        return sqlSession.selectOne("FlightInfoMapper.selectFlightInfoById", flightId);
    }

}
