package com.globalin.biz.common;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;

@Service
@Aspect
public class AroundAdvice {
/*
	 @Pointcut("execution(* com.globalin.biz..*Impl.*(..))")
	 public void allPointcut() {}
*/	
	 @Around("PointcutCommon.allPointcut()")
	public Object aroundLog(ProceedingJoinPoint pjp) 
			throws Throwable {
		
		String method = pjp.getSignature().getName();
		
		StopWatch stopWatch = new StopWatch();
		stopWatch.start();
		
		Object obj = pjp.proceed();
		
		stopWatch.stop();
		
		System.out.println(method+"() 메소드 수행에 걸린 시간 :"
				+stopWatch.getTotalTimeMillis()+"(ms) 초");
		
		/*
		 * System.out.println("[BEFORE]: 비즈니스 메소드 수행 전 처리할 내용 ..");
		 * 
		 * System.out.println("[AFTER]: 비즈니스 메소드 수행 후 처리할 내용 ..");
		 */
		return obj;
	}
	
	
}
