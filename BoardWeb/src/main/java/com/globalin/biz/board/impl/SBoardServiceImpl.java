package com.globalin.biz.board.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.globalin.biz.board.BoardService;
import com.globalin.biz.board.BoardVO;
import com.globalin.biz.board.SBoardService;
import com.globalin.biz.board.SBoardVO;
import com.globalin.biz.common.Log4jAdvice;
import com.globalin.biz.common.LogAdvice;

@Service("sboardService")
public class SBoardServiceImpl implements SBoardService {

	@Autowired
	//private BoardDAOSpring boardDAO;
	//private BoardDAOSpring2 boardDAO;
	//private BoardDAO boardDAO;
	//private Log4jAdvice log;
	private SBoardDAO SboardDAO;
	
	/*
	 * public BoardServiceImpl() { log = new Log4jAdvice(); }
	 */
	
	@Override
	public void insertSBoard(SBoardVO vo) {
		//log.printLogging();
		/*
		 * if(vo.getSeq() == 0) { throw new
		 * IllegalArgumentException("0번 글은 등록할 수 없습니다."); }
		 */
		//boardDAO.insertBoard(vo);// 100번 글 등록 성공
		SboardDAO.insertSBoard(vo);// Exception 발생
	}

	@Override
	public void updateSBoard(SBoardVO vo) {
		//log.printLogging();
		SboardDAO.updateSBoard(vo);
	}

	@Override
	public void deleteSBoard(SBoardVO vo) {
		//log.printLogging();   
		SboardDAO.deleteSBoard(vo);
	}

	@Override
	public SBoardVO getSBoard(SBoardVO vo) {
		//log.printLogging();
		return SboardDAO.getSBoard(vo);
	}

	@Override
	public List<SBoardVO> getSBoardList(SBoardVO vo) {
		//log.printLogging();
		return SboardDAO.getSBoardList(vo);
	}

}
