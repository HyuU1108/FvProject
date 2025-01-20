package com.globalin.view.board;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.globalin.biz.board.BoardService;
import com.globalin.biz.board.BoardVO;
import com.globalin.biz.board.SBoardService;
import com.globalin.biz.board.SBoardVO;
import com.globalin.biz.board.impl.BoardDAO;

@Controller
@SessionAttributes("sboard")
public class SBoardController {
	
	@Autowired
	private SBoardService sboardService;
	
	// 검색 조건 목록 설정
	@ModelAttribute("conditionMap")
	public Map<String, String> searchConditionMap(){
		Map<String, String> conditionMap = new HashMap<String, String>();
		
		conditionMap.put("제목", "SBSUBJECT");
		conditionMap.put("내용", "SBCONTENT");
		
		return conditionMap;
	}

	// 글 등록
	@RequestMapping(value = "/insertSBoard.do")
	public String insertSBoard(SBoardVO vo) throws IOException {
		System.out.println("글 등록 처리");
		
		//파일 업로드 처리
		MultipartFile uploadFile = vo.getUploadFile();
		
		if (!uploadFile.isEmpty()) {
			String fileName = uploadFile.getOriginalFilename();
			uploadFile.transferTo(new File("C:/ora/"+fileName));
		}
		
		sboardService.insertSBoard(vo);

	    return  "getSBoardList.do";
	}
	
	// 글 수정
	@RequestMapping("/updateSBoard.do")
	public String updateSBoard(@ModelAttribute("sboard") SBoardVO vo) {
		
		System.out.println("글 수정 처리");
		System.out.println("번  호 : " + vo.getSbNum());
		System.out.println("제  목 : " + vo.getSbSubject());
		System.out.println("작성자 : " + vo.getENick());
		System.out.println("내  용 : " + vo.getSbContent());
		System.out.println("등록일 : " + vo.getSbRegDate());
		System.out.println("조회수 : " + vo.getSbRdCnt());
		
		sboardService.updateSBoard(vo);
		// 3. 화면 네비게이션
		return "getSBoardList.do";
	}
	
	// 글 삭제
	@RequestMapping("/deleteSBoard.do")
	public String deleteSBoard(SBoardVO vo) {
		
		System.out.println("글 삭제 처리");
		sboardService.deleteSBoard(vo);
		//  화면 네비게이션
	    return "getSBoardList.do";
	}
	
	// 글 상세
	@RequestMapping("/getSBoard.do")
	public String getSBoard(SBoardVO vo,
		 Model model) {
		
		System.out.println("글 상세 조회 처리");
		
		model.addAttribute("sboard", sboardService.getSBoard(vo));
		return "getSBoard.jsp";
	}
	
	// 글 목록(원본)
	
	@RequestMapping("/getSBoardList.do")
	public String getSBoardList(SBoardVO vo,
		Model model) {
		System.out.println("글 목록 검색 처리");
		// Null Check
		if (vo.getSearchCondition() == null) {vo.setSearchCondition("TITLE");}
		if (vo.getSearchKeyword() == null) {vo.setSearchKeyword("");}
		
		model.addAttribute("SboardList", sboardService.getSBoardList(vo));
		return "getSBoardList.jsp";//  view 정보 저장
	}
	

}
