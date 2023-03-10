package com.edu.bodybuddy.domain.diet;

import lombok.Data;

@Data
public class DietTipComments {
	private int diet_tip_idx;
	private int member_idx;
	
	private int diet_tip_comments_idx;
	private String content;
	private String writer;
	private String regdate;
	private int post;
	private int step;
	private int dept;
}
