package com.globalin.biz.board;

import java.util.Date;

public class NBoardVO {

	 	private int bSeq;              // 게시글 번호
	    private String eNick;          // 작성자
	    private String fbTitle;        // 제목
	    private String fbContent;      // 내용
	    private int fbCnt;             // 조회수
	    private String fbDeleteYn;     // 삭제 여부
	    private Date fbWriteDay;       // 작성일자
	    private Date fbUpdateDay;
	    private String searchCondition;
		private String searchKeyword;
		
		
	    
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
		public int getbSeq() {
			return bSeq;
		}
		public void setbSeq(int bSeq) {
			this.bSeq = bSeq;
		}
		public String geteNick() {
			return eNick;
		}
		public void seteNick(String eNick) {
			this.eNick = eNick;
		}
		public String getFbTitle() {
			return fbTitle;
		}
		public void setFbTitle(String fbTitle) {
			this.fbTitle = fbTitle;
		}
		public String getFbContent() {
			return fbContent;
		}
		public void setFbContent(String fbContent) {
			this.fbContent = fbContent;
		}
		public int getFbCnt() {
			return fbCnt;
		}
		public void setFbCnt(int fbCnt) {
			this.fbCnt = fbCnt;
		}
		public String getFbDeleteYn() {
			return fbDeleteYn;
		}
		public void setFbDeleteYn(String fbDeleteYn) {
			this.fbDeleteYn = fbDeleteYn;
		}
		public Date getFbWriteDay() {
			return fbWriteDay;
		}
		public void setFbWriteDay(Date fbWriteDay) {
			this.fbWriteDay = fbWriteDay;
		}
		public Date getFbUpdateDay() {
			return fbUpdateDay;
		}
		public void setFbUpdateDay(Date fbUpdateDay) {
			this.fbUpdateDay = fbUpdateDay;
		}  
	    
		// toString() for debugging and logging
	    @Override
	    public String toString() {
	        return "NBoardVO{" +
	                "bSeq=" + bSeq +
	                ", eNick='" + eNick + '\'' +
	                ", fbTitle='" + fbTitle + '\'' +
	                ", fbContent='" + fbContent + '\'' +
	                ", fbCnt=" + fbCnt +
	                ", fbDeleteYn='" + fbDeleteYn + '\'' +
	                ", fbWriteDay=" + fbWriteDay +
	                ", fbUpdateDay=" + fbUpdateDay +
	                '}';
	    }
	    
	    
}
