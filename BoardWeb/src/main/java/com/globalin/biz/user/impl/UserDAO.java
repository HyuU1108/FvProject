package com.globalin.biz.user.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.springframework.stereotype.Repository;

import com.globalin.biz.common.JDBCUtil;
import com.globalin.biz.user.UserVO;

@Repository("userDAO")
public class UserDAO {

	//Jdbc 관련 변수 선언
	private Connection con = null;
	private PreparedStatement stmt = null;
	private ResultSet rs = null;
	
	// sql 명령어
	private final String USER_GET = 
	"select * from users where id=? and password=?";
	
	//crud 기능의 메소드 구현
	// 회원등록
	public UserVO getUser(UserVO vo) {
		
		UserVO user = null;
		try {
			System.out.println("===> JDBC로 getUser() 기능 처리 ....");
			con = JDBCUtil.getConnection();
			stmt = con.prepareStatement(USER_GET);
			stmt.setString(1, vo.getId());
			stmt.setString(2, vo.getPassword());
			
			rs = stmt.executeQuery();
			
			if(rs.next()) {
				user = new UserVO();
				user.setId(rs.getString("id"));
				user.setPassword(rs.getString("password"));
				user.setName(rs.getString("name"));
				user.setRole(rs.getString("role"));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			JDBCUtil.close(rs, stmt, con);
		}
		return user;
	}
}
