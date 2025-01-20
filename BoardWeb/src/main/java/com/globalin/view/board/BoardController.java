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
import com.globalin.biz.board.impl.BoardDAO;

@Controller
@SessionAttributes("board")
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	
	// 검색 조건 목록 설정
	@ModelAttribute("conditionMap")
	public Map<String, String> searchConditionMap(){
		Map<String, String> conditionMap = new HashMap<String, String>();
		
		conditionMap.put("제목", "TITLE");
		conditionMap.put("내용", "CONTENT");
		
		return conditionMap;
	}

	// 글 등록
	@RequestMapping(value = "/insertBoard.do")
	public String insertBoard(BoardVO vo) throws IOException {
		System.out.println("글 등록 처리");
		
		//파일 업로드 처리
		MultipartFile uploadFile = vo.getUploadFile();
		
		if (!uploadFile.isEmpty()) {
			String fileName = uploadFile.getOriginalFilename();
			uploadFile.transferTo(new File("C:/ora/"+fileName));
		}
		
		boardService.insertBoard(vo);

		// 3. 화면 네비게이션
	
	    return  "getBoardList.do";
	}
	
	// 글 수정
	@RequestMapping("/updateBoard.do")
	public String updateBoard(@ModelAttribute("board") BoardVO vo) {
		
		System.out.println("글 수정 처리");
		System.out.println("번  호 : " + vo.getSeq());
		System.out.println("제  목 : " + vo.getTitle());
		System.out.println("작성자 : " + vo.getWriter());
		System.out.println("내  용 : " + vo.getContent());
		System.out.println("등록일 : " + vo.getRegDate());
		System.out.println("조회수 : " + vo.getCnt());
		
		boardService.updateBoard(vo);
		// 3. 화면 네비게이션
		return "getBoardList.do";
	}
	
	// 글 삭제
	@RequestMapping("/deleteBoard.do")
	public String deleteBoard(BoardVO vo) {
		
		System.out.println("글 삭제 처리");
		boardService.deleteBoard(vo);
		//  화면 네비게이션
	    return "getBoardList.do";
	}
	
	// 글 상세
	@RequestMapping("/getBoard.do")
	public String getBoard(BoardVO vo,
		 Model model) {
		
		System.out.println("글 상세 조회 처리");
		
		model.addAttribute("board", boardService.getBoard(vo));
		return "getBoard.jsp";
	}
	
	// 글 목록(원본)
	
	@RequestMapping("/getBoardList.do")
	public String getBoardList(BoardVO vo,
		Model model) {
		System.out.println("글 목록 검색 처리");
		// Null Check
		if (vo.getSearchCondition() == null) {vo.setSearchCondition("TITLE");}
		if (vo.getSearchKeyword() == null) {vo.setSearchKeyword("");}
		
		model.addAttribute("boardList", boardService.getBoardList(vo));
		return "getBoardList.jsp";//  view 정보 저장
	}
	
	/*
	// 글 목록
	@RequestMapping("/getBoardList.do")
	public String getBoardList(
			// value : 전달될 파라미터 이름
			// defaultValue : 전달될 파라미터 정보가 없을 때 설정할 기본값
			// required : 파라미터의 생략 여부 옵션
			@RequestParam(value = "searchCondition", defaultValue = "TITLE", required = false) String condition,
			@RequestParam(value = "searchKeyword", defaultValue = "", required = false) String keyword,
			BoardDAO boardDAO, Model model
			) {
		
		System.out.println("글 목록 검색 처리");
		System.out.println("검색 조건 : " + condition);
		System.out.println("검색 단어 : " + keyword);
		//model.addAttribute("boardList", boardDAO.getBoardList(vo));
		return "getBoardList.jsp";//  view 정보 저장
	}
	*/
}
