package com.edu.bodybuddy.controller.user;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.edu.bodybuddy.domain.exr.ExrCategory;
import com.edu.bodybuddy.domain.exr.ExrNotice;
import com.edu.bodybuddy.domain.exr.ExrRoutine;
import com.edu.bodybuddy.model.exr.ExrCategoryService;
import com.edu.bodybuddy.model.exr.ExrNoticeService;
import com.edu.bodybuddy.model.exr.ExrRoutineService;

// 운동 카테고리 제어 컨트롤러
@Controller
@RequestMapping("/exr")
public class ExcerciseController {
	private Logger logger=LoggerFactory.getLogger(this.getClass());
	@Autowired
	private ExrNoticeService exrNoticeService;
	@Autowired
	private ExrCategoryService exrCategoryService;
	@Autowired
	private ExrRoutineService exrRoutineService;
	
	
	// 메인페이지
	@GetMapping("/notice")
	public ModelAndView getMain(HttpServletRequest request) {
		List<ExrNotice> exrNoticeList=exrNoticeService.selectAll();
		ModelAndView mv= new ModelAndView("exr/notice");
		mv.addObject("exrNoticeList", exrNoticeList);
		return mv;
	}

	
	// 상세페이지
	@GetMapping("/notice/{exr_notice_idx}")
	public ModelAndView getdetail(@PathVariable("exr_notice_idx") int exr_notice_idx, HttpServletRequest request) {
		logger.info("유저 페이지 작동");
		
		ExrNotice exrNotice=exrNoticeService.select(exr_notice_idx);
		List<ExrNotice> exrCategoryList=exrCategoryService.selectAll();
		
		ModelAndView mv= new ModelAndView("exr/notice_detail");
		mv.addObject("exrNotice", exrNotice);
		mv.addObject("exrCategoryList", exrCategoryList);
		return mv;
	}
	
	
	
	/*----------------------
	 	루틴 공유 게시판 영역
	 * ---------------------*/
	@GetMapping("/routine_list")
	public ModelAndView getList(HttpServletRequest request){
		ModelAndView mv= new ModelAndView("exr/routine_list");
		return mv;
	}
	
	// 글 등록 폼
	@GetMapping("/routine/registform")
	public ModelAndView getRegistForm(HttpServletRequest request){
		logger.info("등록폼");
		List<ExrCategory> exrCategoryList=exrCategoryService.selectAll();
		
		ModelAndView mv= new ModelAndView("exr/routine_registform");
		mv.addObject("exrCategoryList", exrCategoryList);
		return mv;
	}
	
	
	// 등록
	@PostMapping("/routine/regist")
	public ModelAndView regist(ExrRoutine exrRoutine, HttpServletRequest request){
		logger.info("넘어온 글 "+exrRoutine);
		
		exrRoutineService.insert(exrRoutine);
		
		ModelAndView mv= new ModelAndView("redirect:/exr/routine_list");
		return mv;
	}
	
	
	
	
	
}
