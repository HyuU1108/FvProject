package com.globalin.biz.board.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.globalin.biz.board.BoardService;
import com.globalin.biz.board.BoardVO;
import com.globalin.biz.board.NBoardService;
import com.globalin.biz.board.NBoardVO;
import com.globalin.biz.common.Log4jAdvice;
import com.globalin.biz.common.LogAdvice;

@Service("nboardService")
public class NBoardServiceImpl implements NBoardService {

	@Autowired
	//private BoardDAOSpring boardDAO;
	//private BoardDAOSpring2 boardDAO;
	//private BoardDAO boardDAO;
	//private Log4jAdvice log;
	private NBoardDAO nboardDAO;
	
	/*
	 * public BoardServiceImpl() { log = new Log4jAdvice(); }
	 */
	
	@Override
	public void insertNBoard(NBoardVO vo) {
		//log.printLogging();
		/*
		 * if(vo.getSeq() == 0) { throw new
		 * IllegalArgumentException("0번 글은 등록할 수 없습니다."); }
		 */
		//boardDAO.insertBoard(vo);// 100번 글 등록 성공
		nboardDAO.insertNBoard(vo);// Exception 발생
	}

	@Override
	public void updateNBoard(NBoardVO vo) {
		//log.printLogging();
		nboardDAO.updateNBoard(vo);
	}

	@Override
	public void deleteNBoard(NBoardVO vo) {
		//log.printLogging();   
		nboardDAO.deleteNBoard(vo);
	}

	@Override
	public NBoardVO getNBoard(NBoardVO vo) {
		//log.printLogging();
		return nboardDAO.getNBoard(vo);
	}

	@Override
	public List<NBoardVO> getNBoardList(NBoardVO vo) {
		//log.printLogging();
		return nboardDAO.getNBoardList(vo);
	}

}
