package com.globalin.biz.user;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

public class UserServiceClient {

	public static void main(String[] args) {
		
		//1. Spring 컨테이너 구동
		AbstractApplicationContext container =
			new	GenericXmlApplicationContext("applicationContext.xml");
		
		// 2. Spring 컨테이너로부터 UserServiceImpl 객체 요청함(Lookup)
		UserService userService =
				(UserService)container.getBean("userService");
		
		// 3. 로그인 테스트
		UserVO vo = new UserVO();
		vo.setId("test");
		vo.setPassword("test123");
		
		UserVO user = userService.getUser(vo);
		
		if(user != null) {
			System.out.println(user.getName()+"님 무쟈게 환영하는 바입니다.");
		}else {
			System.out.println("로그인 실패 !!! ");
		}
		
		// 4. Spring 컨테이너 종료
		container.close();
		
		

	}

}
