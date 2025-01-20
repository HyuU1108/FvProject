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
import com.globalin.biz.board.NBoardService;
import com.globalin.biz.board.NBoardVO;
import com.globalin.biz.board.impl.BoardDAO;

@Controller
@SessionAttributes("nboard")
public class NBoardController {
	
	@Autowired
	private NBoardService nboardService;
	
	// 검색 조건 목록 설정
	@ModelAttribute("conditionMap")
	public Map<String, String> searchConditionMap(){
		Map<String, String> conditionMap = new HashMap<String, String>();
		
		conditionMap.put("제목", "FBTITLE");
		conditionMap.put("내용", "FBCONTENT");
		
		return conditionMap;
	}

	// 글 등록
	@RequestMapping(value = "/insertNBoard.do")
	public String insertNBoard(NBoardVO vo) throws IOException {
		System.out.println("글 등록 처리");
		
//		//파일 업로드 처리
//		MultipartFile uploadFile = vo.getUploadFile();
//		
//		if (!uploadFile.isEmpty()) {
//			String fileName = uploadFile.getOriginalFilename();
//			uploadFile.transferTo(new File("C:/ora/"+fileName));
//		}
		
		nboardService.insertNBoard(vo);

		// 3. 화면 네비게이션
	
	    return  "getNBoardList.do";
	}
	
	// 글 수정
	@RequestMapping("/updateNBoard.do")
	public String updateNBoard(@ModelAttribute("nboard") NBoardVO vo) {
		
		System.out.println("글 수정 처리");
		System.out.println("번  호 : " + vo.getbSeq());
		System.out.println("제  목 : " + vo.getFbTitle());
		System.out.println("작성자 : " + vo.geteNick());
		System.out.println("내  용 : " + vo.getFbContent());
		System.out.println("등록일 : " + vo.getFbWriteDay());
		System.out.println("조회수 : " + vo.getFbCnt());
		
		nboardService.updateNBoard(vo);
		// 3. 화면 네비게이션
		return "getNBoardList.do";
	}
	
	// 글 삭제
	@RequestMapping("/deleteNBoard.do")
	public String deleteNBoard(NBoardVO vo) {
		
		System.out.println("글 삭제 처리");
		nboardService.deleteNBoard(vo);
		//  화면 네비게이션
	    return "getNBoardList.do";
	}
	
	// 글 상세
	@RequestMapping("/getNBoard.do")
	public String getNBoard(NBoardVO vo,
		 Model model) {
		
		System.out.println("글 상세 조회 처리");
		
		model.addAttribute("nboard", nboardService.getNBoard(vo));
		return "getNBoard.jsp";
	}
	
	// 글 목록(원본)
	
	@RequestMapping("/getNBoardList.do")
	public String getNBoardList(NBoardVO vo,
		Model model) {
		System.out.println("글 목록 검색 처리");
		// Null Check
		if (vo.getSearchCondition() == null) {vo.setSearchCondition("TITLE");}
		if (vo.getSearchKeyword() == null) {vo.setSearchKeyword("");}
		
		model.addAttribute("nboardList", nboardService.getNBoardList(vo));
		return "getNBoardList.jsp";//  view 정보 저장
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
