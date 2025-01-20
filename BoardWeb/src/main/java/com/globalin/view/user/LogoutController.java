package com.globalin.view.user;


import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class LogoutController  {

	@RequestMapping("/logout.do")
	public String logout(HttpSession session) {
		
		System.out.println("로그아웃 처리");
		 // 브라우저와 연결된 세션 객체를 강제 종료함
		session.invalidate();
		return "login.jsp";
	}

}
