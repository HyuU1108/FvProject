package com.globalin.login;

import com.globalin.biz.user.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    @GetMapping("/save")
    public String saveForm() {
        return "save";
    }

    @PostMapping("/save")
    public String save(@ModelAttribute UserVO userVO) {
        int saveResult = memberService.saveUser(userVO);
        if (saveResult > 0) {
            return "login";
        } else {
            return "save";
        }
    }

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String login(@ModelAttribute UserVO userVO, HttpSession session) {
        boolean loginResult = memberService.loginUser(userVO);
        if (loginResult) {
            session.setAttribute("loginId", userVO.getId());  // getID() -> getId() 수정
            return "main";
        } else {
            return "login";
        }
    }

    @GetMapping("/list")  // 경로 충돌 방지
    public String findAll(Model model) {
        List<UserVO> userList = memberService.findAllUsers();
        model.addAttribute("userList", userList);
        return "list";
    }

    @GetMapping("/detail")  // 경로 충돌 방지
    public String findById(@RequestParam("id") Long id, Model model) {
        UserVO userVO = memberService.findUserById(id);
        model.addAttribute("user", userVO);
        return "detail";
    }

    @GetMapping("/delete")
    public String delete(@RequestParam("id") Long id) {
        memberService.deleteUser(id);
        return "redirect:/member/list";  // 경로 수정
    }

    @GetMapping("/update")
    public String updateForm(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        UserVO userVO = memberService.findUserById(Long.parseLong(loginId));  // String -> Long 변환
        model.addAttribute("user", userVO);
        return "update";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute UserVO userVO) {
        boolean result = memberService.updateUser(userVO);
        if (result) {
            return "redirect:/member/detail?id=" + userVO.getId();  // 경로 수정
        } else {
            return "login.do";
        }
    }

    @PostMapping("/id-check")
    public @ResponseBody String idCheck(@RequestParam("uId") String uId) {
        System.out.println("uId = " + uId);
        String checkResult = memberService.uIdCheck(uId);
        return checkResult;
    }
}
