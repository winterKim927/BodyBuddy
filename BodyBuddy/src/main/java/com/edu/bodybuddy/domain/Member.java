package com.edu.bodybuddy.domain;

import lombok.Data;

@Data
public class Member {
	private int member_idx;
	private String name;
	private String id;
	private String pass;
	private String email;
	private String phone;
	private String regdate;
	private int point;
}