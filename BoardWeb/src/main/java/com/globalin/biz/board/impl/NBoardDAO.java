package com.globalin.biz.board.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.globalin.biz.board.NBoardVO;
import com.globalin.biz.common.JDBCUtil;

@Repository("NboardDAO")
public class NBoardDAO {

	//JDBC관련 변수 선언
	private Connection con = null;
	private PreparedStatement stmt = null;
	private ResultSet rs = null;
	
	//SQL 명령어 정의
	private final String NBoard_INSERT=
			"INSERT INTO FV_NBOARD(B_SEQ,FB_TITLE,E_NICK,FB_CONTENT) VALUES((select nvl(max(b_seq),0)+1 from fv_nboard),?,?,?)";
	private final String NBoard_UPDATE=
			"update fv_nboard set fb_title=?,fb_content=? where b_seq=?";
	private final String NBoard_DELETE="delete fv_nboard where b_seq=?";
	private final String NBoard_GET="select * from fv_nboard where b_seq=?";
	private final String NBoard_LIST="select * from fv_nboard order by b_seq desc";
	
	//CRUD 기능을 메소드로 구현
	//글 등록 
	public void insertNBoard(NBoardVO vo) {
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(NBoard_INSERT);
			stmt.setString(1, vo.getFbTitle());
			stmt.setString(2, vo.geteNick());
			stmt.setString(3, vo.getFbContent());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(stmt, con);
		}
	}
	
	//글 수정
	public void updateNBoard(NBoardVO vo) {
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(NBoard_UPDATE);
			stmt.setString(1, vo.getFbTitle());
			stmt.setString(2, vo.getFbContent());
			stmt.setInt(3, vo.getbSeq());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(stmt, con);
		}
	}
	
	//글 삭제
	public void deleteNBoard(NBoardVO vo) {
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(NBoard_DELETE);
			stmt.setInt(1, vo.getbSeq());
			stmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(stmt, con);
		}
	}
	
	//글 상세보기
	public NBoardVO getNBoard(NBoardVO vo) {
		NBoardVO board = null;
		
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(NBoard_GET);
			stmt.setInt(1, vo.getbSeq());
			rs = stmt.executeQuery();
			
			if(rs.next()) {
			
				board = new NBoardVO();
				board.setbSeq(rs.getInt("bseq"));
				board.setFbTitle(rs.getString("fbTitle"));
				board.seteNick(rs.getString("eNick"));
				board.setFbContent(rs.getString("fbcontent"));
				board.setFbWriteDay(rs.getDate("regdate"));
				board.setFbCnt(rs.getInt("fbcnt"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs, stmt, con);
		}
		return board;
	}
	
	//글 목록보기
	public List<NBoardVO> getNBoardList(NBoardVO vo){
		
		List<NBoardVO> boardList = new ArrayList<NBoardVO>();
		
		try {
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(NBoard_LIST);
			rs = stmt.executeQuery();
			
			while(rs.next()) {
				
				NBoardVO board = new NBoardVO();
				board.setbSeq(rs.getInt("seq"));
				board.setFbTitle(rs.getString("title"));
				board.seteNick(rs.getString("writer"));
				board.setFbContent(rs.getString("content"));
				board.setFbWriteDay(rs.getDate("regdate"));
				board.setFbCnt(rs.getInt("cnt"));
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