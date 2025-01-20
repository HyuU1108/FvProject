package com.globalin.biz.board.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.globalin.biz.board.SBoardVO;
import com.globalin.biz.common.JDBCUtil;

@Repository("SboardDAO")
public class SBoardDAO {

	//JDBC관련 변수 선언
	private Connection con = null;
	private PreparedStatement stmt = null;
	private ResultSet rs = null;
	
	//SQL 명령어 정의
	private final String SBoard_INSERT=
			"INSERT INTO FV_SBOARD(SB_NUM,E_NICK,SB_SUBJECT,SB_CONTENT) VALUES((select nvl(max(seq),0)+1 from board),?,?,?)";
	private final String SBoard_UPDATE=
			"update FV_Sboard set SB_SUBJECT=?,SB_content=? where SB_NUM=?";
	private final String SBoard_DELETE="delete FV_Sboard where SB_NUM=?";
	private final String SBoard_GET="select * from FV_Sboard where SB_NUM=?";
	private final String SBoard_LIST="select * from FV_Sboard order by SB_NUM desc";
	
	//CRUD 기능을 메소드로 구현
	//글 등록 
	public void insertSBoard(SBoardVO vo) {
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(SBoard_INSERT);
			stmt.setString(1, vo.getSbSubject());
			stmt.setString(2, vo.getENick());
			stmt.setString(3, vo.getSbContent());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(stmt, con);
		}
	}
	
	//글 수정
	public void updateSBoard(SBoardVO vo) {
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(SBoard_UPDATE);
			stmt.setString(1, vo.getSbSubject());
			stmt.setString(2, vo.getSbContent());
			stmt.setInt(3, vo.getSbNum());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(stmt, con);
		}
	}
	
	//글 삭제
	public void deleteSBoard(SBoardVO vo) {
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(SBoard_DELETE);
			stmt.setInt(1, vo.getSbNum());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(stmt, con);
		}
	}
	
	//글 상세보기
	public SBoardVO getSBoard(SBoardVO vo) {
		SBoardVO board = null;
		
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(SBoard_GET);
			stmt.setInt(1, vo.getSbNum());
			rs = stmt.executeQuery();
			
			if(rs.next()) {
			
				board = new SBoardVO();
				board.setSbNum(rs.getInt("seq"));
				board.setSbSubject(rs.getString("title"));
				board.setENick(rs.getString("writer"));
				board.setSbContent(rs.getString("content"));
				board.setSbRegDate(rs.getDate("regdate"));
				board.setSbRdCnt(rs.getInt("cnt"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs, stmt, con);
		}
		return board;
	}
	
	//글 목록보기
	public List<SBoardVO> getSBoardList(SBoardVO vo){
		
		List<SBoardVO> boardList = new ArrayList<SBoardVO>();
		
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(SBoard_LIST);
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				
				SBoardVO board = new SBoardVO();
				board.setSbNum(rs.getInt("seq"));
				board.setSbSubject(rs.getString("title"));
				board.setENick(rs.getString("writer"));
				board.setSbContent(rs.getString("content"));
				board.setSbRegDate(rs.getDate("regdate"));
				board.setSbRdCnt(rs.getInt("cnt"));
				boardList.add(board);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs, stmt, con);
		}
		return boardList;
	}

}