package com.globalin.biz.board;

import java.util.List;

public interface SBoardService {

	public void insertSBoard(SBoardVO vo);
	public void updateSBoard(SBoardVO vo);
	public void deleteSBoard(SBoardVO vo);
	public SBoardVO getSBoard(SBoardVO vo);
	public List<SBoardVO> getSBoardList(SBoardVO vo);
	
	
	
	
	
}
