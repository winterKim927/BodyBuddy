package com.edu.bodybuddy.model.exr;

import java.util.List;

import com.edu.bodybuddy.domain.exr.ExrNotice;

public interface ExrNoticeService {
	public List selectAll();
	public ExrNotice select(int exr_notice_idx);
	
	public void regist(ExrNotice exrNotice, String dir);		// db 등록 + 사진 파일 등록
	public void update(ExrNotice exrNotice);
	public void delete(int exr_notice_idx);	
}
