package com.globalin.login;

import com.globalin.biz.user.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberService {

    private final MemberRepository memberRepository; 

    @Autowired
    public MemberService(MemberRepository memberRepository) { 
        this.memberRepository = memberRepository;
    }

    // 회원 저장
    public int saveUser(UserVO userVO) { // 메서드 이름을 saveUser로 변경
        return memberRepository.save(userVO); 
    }

    // 로그인 처리
    public boolean loginUser(UserVO userVO) { // 메서드 이름을 loginUser로 변경
        UserVO loginUser = memberRepository.login(userVO); 
        return loginUser != null; // 로그인 성공 여부 반환
    }

    // 모든 사용자 조회
    public List<UserVO> findAllUsers() { // 메서드 이름을 findAllUsers로 변경
        return memberRepository.findAll(); 
    }

    // ID로 사용자 조회
    public UserVO findUserById(Long id) { // 메서드 이름을 findUserById로 변경
        return memberRepository.findById(id); 
    }

    // 사용자 삭제
    public void deleteUser(Long id) { // 메서드 이름을 deleteUser로 변경
        memberRepository.delete(id); 
    }

    // 사용자 아이디로 조회
    public UserVO findUserByUId(String uId) { // 메서드 이름을 findUserByUId로 변경
        return memberRepository.findByUId(uId); 
    }

    // 사용자 정보 수정
    public boolean updateUser(UserVO userVO) { // 메서드 이름을 updateUser로 변경
        int result = memberRepository.update(userVO); 
        return result > 0; // 업데이트 성공 여부 반환
    }

    // 아이디 중복 체크
    public String uIdCheck(String uId) { // 메서드 이름을 uIdCheck로 변경
        UserVO userVO = memberRepository.findByUId(uId); 
        return userVO == null ? "ok" : "no"; // 아이디가 없다면 "ok", 있으면 "no"
    }
}
