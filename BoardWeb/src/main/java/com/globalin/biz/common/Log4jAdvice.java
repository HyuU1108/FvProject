package com.globalin.biz.common;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Service;

@Service
@Aspect
public class Log4jAdvice {
	
	@Before("PointcutCommon.allPointcut()")
	public void printLogging() {
		System.out.println("[Log4j] ...");
	}
}
