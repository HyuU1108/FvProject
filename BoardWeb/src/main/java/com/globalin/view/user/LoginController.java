package com.globalin.view.user;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.globalin.biz.user.UserVO;
import com.globalin.biz.user.impl.UserDAO;

@Controller
public class LoginController {

	@GetMapping("/login.do")
	public String loginView(@ModelAttribute("user") UserVO vo) {
		System.out.println("로그인 페이지로 이동...");
		vo.setId("test");
		vo.setPassword("test123");
		return "login.jsp";
	}

	@PostMapping("/login.do")
	public String login(UserVO vo, UserDAO userDAO, HttpSession session, Model model) {

		System.out.println("로그인 처리");

		if (vo.getId() == null || vo.getId().equals("")) {
			throw new IllegalArgumentException("아이디는 반드시 입력해야합니다");
		}

		UserVO user = userDAO.getUser(vo);
		if (user != null) {
			session.setAttribute("userName", user.getName());
			return "redirect:/getBoardList.do";
		} else {
			model.addAttribute("loginFail", "로그인에 실패했습니다. 다시 시도해주세요");
			return "login.jsp";
		}

	}

	/*
	 * private String getBoardViewName(String redirectUrl) { if
	 * (redirectUrl.equals("getSBoardList.do")) { return "getSBoardList.do"; } if
	 * (redirectUrl.equals("getNBoardList.do")) { return "getNBoardList.do"; }
	 * return "getBoardList.do"; }
	 */

	private String handleBoardAccess(HttpSession session, Model model, String redirectUrl) {
		String userName = (String) session.getAttribute("userName");
		if (userName == null) {
			return "redirect:/login.do";
		} else {
			model.addAttribute("userName", userName);
			if (redirectUrl == null || redirectUrl.isEmpty() || redirectUrl.equals("getBoardList.do")) {
				return "getBoardList.do";
			} else {
				return "redirect:" + redirectUrl;
			}
		}
	}

	@GetMapping(value = { "/fre.do", "/sug.do", "/not.do" })
	public String checkBoardLogin(HttpSession session, Model model,
			@RequestParam(required = false) String redirectUrl) {
		return handleBoardAccess(session, model, redirectUrl);
	}
	/*
	 * @RequestMapping("/logout.do") public String logout(HttpSession session) {
	 * session.invalidate(); return "redirect:/index.jsp"; }
	 */
}