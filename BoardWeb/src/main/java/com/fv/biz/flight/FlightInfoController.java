package com.fv.biz.flight;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class FlightInfoController {

    @Autowired
    private FlightInfoService flightInfoService;

    // 필요에 따라 웹 요청 처리 메서드 추가
}