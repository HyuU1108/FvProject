package com.globalin.biz.board;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class SBoardVO {
    private int sbNum;         // 게시글 번호
    private String eNick;      // 작성자
    private String sbSubject;  // 제목
    private String sbContent;  // 내용
    private Integer sbRef;     // 원본 게시글 번호 (null 허용)
    private Integer sbStep;    // 답글 단계 (null 허용)
    private Integer sbDepth;   // 답글 깊이 (null 허용)
    private int sbRdCnt;       // 조회수
    private String sbDeleteYn; // 삭제 여부
    private Date sbRegDate;    // 작성일자
    private Date sbUpdateDay;  // 수정일자
    private String searchCondition;
	private String searchKeyword;
	private MultipartFile uploadFile;
	
	
    public String geteNick() {
		return eNick;
	}

	public void seteNick(String eNick) {
		this.eNick = eNick;
	}

	public String getSearchCondition() {
		return searchCondition;
	}

	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

	public MultipartFile getUploadFile() {
		return uploadFile;
	}

	public void setUploadFile(MultipartFile uploadFile) {
		this.uploadFile = uploadFile;
	}

	// Getters and Setters
    public int getSbNum() {
        return sbNum;
    }

    public void setSbNum(int sbNum) {
        this.sbNum = sbNum;
    }

    public String getENick() {
        return eNick;
    }

    public void setENick(String eNick) {
        this.eNick = eNick;
    }

    public String getSbSubject() {
        return sbSubject;
    }

    public void setSbSubject(String sbSubject) {
        this.sbSubject = sbSubject;
    }

    public String getSbContent() {
        return sbContent;
    }

    public void setSbContent(String sbContent) {
        this.sbContent = sbContent;
    }

    public Integer getSbRef() {
        return sbRef;
    }

    public void setSbRef(Integer sbRef) {
        this.sbRef = sbRef;
    }

    public Integer getSbStep() {
        return sbStep;
    }

    public void setSbStep(Integer sbStep) {
        this.sbStep = sbStep;
    }

    public Integer getSbDepth() {
        return sbDepth;
    }

    public void setSbDepth(Integer sbDepth) {
        this.sbDepth = sbDepth;
    }

    public int getSbRdCnt() {
        return sbRdCnt;
    }

    public void setSbRdCnt(int sbRdCnt) {
        this.sbRdCnt = sbRdCnt;
    }

    public String getSbDeleteYn() {
        return sbDeleteYn;
    }

    public void setSbDeleteYn(String sbDeleteYn) {
        this.sbDeleteYn = sbDeleteYn;
    }

    public Date getSbRegDate() {
        return sbRegDate;
    }

    public void setSbRegDate(Date sbRegDate) {
        this.sbRegDate = sbRegDate;
    }

    public Date getSbUpdateDay() {
        return sbUpdateDay;
    }

    public void setSbUpdateDay(Date sbUpdateDay) {
        this.sbUpdateDay = sbUpdateDay;
    }

    @Override
    public String toString() {
        return "SBoardVO{" +
                "sbNum=" + sbNum +
                ", eNick='" + eNick + '\'' +
                ", sbSubject='" + sbSubject + '\'' +
                ", sbContent='" + sbContent + '\'' +
                ", sbRef=" + sbRef +
                ", sbStep=" + sbStep +
                ", sbDepth=" + sbDepth +
                ", sbRdCnt=" + sbRdCnt +
                ", sbDeleteYn='" + sbDeleteYn + '\'' +
                ", sbRegDate=" + sbRegDate +
                ", sbUpdateDay=" + sbUpdateDay +
                '}';
    }

	
}
