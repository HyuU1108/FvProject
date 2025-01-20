package com.globalin.biz.board;

import java.util.List;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

public class BoardServiceClient {

	public static void main(String[] args) {
		// 1. Spring 컨테이너 구동
		AbstractApplicationContext container =
				new GenericXmlApplicationContext(
						"applicationContext.xml");
		
		BoardService boardService 
		=(BoardService)container.getBean("boardService");
		
		// 글 등록 테스트
	     BoardVO vo = new BoardVO();
	     //vo.setSeq(100);
	     vo.setTitle("임시 제목");
		 vo.setWriter("홍길동");
		 vo.setContent("임시 내용 ...........");
		// boardService.insertBoard(vo);
		// 글 목록 기능 테스트
		 List<BoardVO> boardList = 
				 boardService.getBoardList(vo);
		 
		 for(BoardVO board : boardList) {
			 System.out.println("---> "+board.toString());
		 }
		
		container.close();
	}

}
