package com.globalin.login;

import com.globalin.biz.user.UserVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MemberRepository {

    @Autowired
    private SqlSessionTemplate sql;

    public int save(UserVO userVO) {
        System.out.println("userVO = " + userVO);
        return sql.insert("Member.save", userVO);
    }

    public UserVO login(UserVO userVO) {
        return sql.selectOne("Member.login", userVO);
    }

    public List<UserVO> findAll() {
        return sql.selectList("Member.findAll");
    }

    public UserVO findById(Long id) {
        return sql.selectOne("Member.findById", id);
    }

    public void delete(Long id) {
        sql.delete("Member.delete", id);
    }

    public UserVO findByUId(String uId) {
        return sql.selectOne("Member.findByUId", uId);
    }

    public int update(UserVO userVO) {
        return sql.update("Member.update", userVO);
    }
}