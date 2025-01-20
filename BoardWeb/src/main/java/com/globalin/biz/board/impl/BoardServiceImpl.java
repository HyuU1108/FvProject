package com.globalin.biz.board.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.globalin.biz.board.BoardService;
import com.globalin.biz.board.BoardVO;
import com.globalin.biz.common.Log4jAdvice;
import com.globalin.biz.common.LogAdvice;

@Service("boardService")
public class BoardServiceImpl implements BoardService {

	@Autowired
	//private BoardDAOSpring boardDAO;
	//private BoardDAOSpring2 boardDAO;
	//private BoardDAO boardDAO;
	//private Log4jAdvice log;
	private BoardDAOMybatis boardDAO;
	
	/*
	 * public BoardServiceImpl() { log = new Log4jAdvice(); }
	 */
	
	@Override
	public void insertBoard(BoardVO vo) {
		//log.printLogging();
		/*
		 * if(vo.getSeq() == 0) { throw new
		 * IllegalArgumentException("0번 글은 등록할 수 없습니다."); }
		 */
		//boardDAO.insertBoard(vo);// 100번 글 등록 성공
		boardDAO.insertBoard(vo);// Exception 발생
	}

	@Override
	public void updateBoard(BoardVO vo) {
		//log.printLogging();
		boardDAO.updateBoard(vo);
	}

	@Override
	public void deleteBoard(BoardVO vo) {
		//log.printLogging();   
		boardDAO.deleteBoard(vo);
	}

	@Override
	public BoardVO getBoard(BoardVO vo) {
		//log.printLogging();
		return boardDAO.getBoard(vo);
	}

	@Override
	public List<BoardVO> getBoardList(BoardVO vo) {
		//log.printLogging();
		return boardDAO.getBoardList(vo);
	}

}
