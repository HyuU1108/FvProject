package com.globalin.biz.common;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Service;

@Service
@Aspect
public class LogAdvice {
	  /*
	  @Pointcut("execution(* com.globalin.biz..*Impl.*(..))")
	  public void allPointcut() {}
	  @Pointcut("execution(* com.globalin.biz..*Impl.get*(..))")
	  public void getPointcut() {}
	*/
	  @Before("PointcutCommon.allPointcut()")
      public void printLog() {
    	  System.out.println("[l]  ....");
      }
}
