package com.globalin.biz.board.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.globalin.biz.board.BoardVO;

@Repository
public class BoardDAOSpring2 {
	

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	// SQL 명령어들
	private final String BOARD_INSERT =
	"insert into board(seq, title, writer, content) "
	+ "values((select nvl(max(seq),0)+1 from board), ?,?,?)";
	
	private final String BOARD_UPDATE =
			"update board set title=?, content=? where seq=?";
	
	private final String BOARD_DELETE =
			"delete board where seq=?";
	
	private final String BOARD_GET =
			"select * from board where seq=?";
	
	private final String BOARD_LIST =
			"select * from board order by seq desc";
	
	private final String BOARD_LIST_T = 
			"select * from board where title like '%'||?||'%' order by seq desc";
	
	private final String BOARD_LIST_C = 
			"select * from board where content like '%'||?||'%' order by seq desc";
	
	// crud 기능의 메소드 구현
	// 글 등록
	public void insertBoard(BoardVO vo) {
		jdbcTemplate.update(BOARD_INSERT, 
				vo.getTitle(), vo.getWriter(), vo.getContent());
	}
	
	public void updateBoard(BoardVO vo) {
		jdbcTemplate.update(BOARD_UPDATE, 
				vo.getTitle(), vo.getContent(), vo.getSeq());
	}
	
	public void deleteBoard(BoardVO vo) {
		jdbcTemplate.update(BOARD_DELETE, vo.getSeq());
	}
	// 글 상세보기
	public BoardVO getBoard(BoardVO vo) {
		Object[] args = {vo.getSeq()};
		return jdbcTemplate.queryForObject(BOARD_GET, 
				args , new BoardRowMapper());
	}
	
	// 글목록 보기
	public List<BoardVO> getBoardList(BoardVO vo) {
		
		Object[] args = {vo.getSearchKeyword()};
		
		if (vo.getSearchCondition().equals("TITLE")) {
			return jdbcTemplate.query(
					BOARD_LIST_T,args , new BoardRowMapper()); 
		} else if (vo.getSearchCondition().equals("CONTENT")) {
			return jdbcTemplate.query(
					BOARD_LIST_C,args , new BoardRowMapper()); 
		}else {
			return jdbcTemplate.query(
					BOARD_LIST, new BoardRowMapper());
		}
	}
}
