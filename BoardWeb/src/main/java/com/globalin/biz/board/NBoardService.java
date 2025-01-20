package com.globalin.biz.board;

import java.util.List;

public interface NBoardService {

	
	public void insertNBoard(NBoardVO vo);
	public void updateNBoard(NBoardVO vo);
	public void deleteNBoard(NBoardVO vo);
	public NBoardVO getNBoard(NBoardVO vo);
	public List<NBoardVO> getNBoardList(NBoardVO vo);
}
