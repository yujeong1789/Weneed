package com.it.wanted.jobsearch.controller;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.it.wanted.matchup.model.MatchupMemService;
import com.it.wanted.member.model.MemberService;
import com.it.wanted.member.model.MemberVO;
import com.it.wanted.resume.model.ResumeService;
import com.it.wanted.resume.model.ResumeVO;

@Controller
@RequestMapping("/jobsearch")
public class jobsearchController {
	@Autowired ResumeService resumeService;
	@Autowired MatchupMemService matchupmemServece;
	@Autowired MemberService memberService;
	
	private static final Logger lOGGER =LoggerFactory.getLogger(jobsearchController.class);
	@RequestMapping("/jobsearchDetail.do")
	public void jobsearchDetail() {
		lOGGER.info("탐색 상세보기 화면보여주기");
	}
	
	@RequestMapping( value = "/apply.do", method = RequestMethod.GET)
	public String apply_get(@RequestParam (defaultValue = "0") int posNo, HttpSession session, Model model) {
		//1
		int memNo= (Integer) session.getAttribute("mem_no");
		String email= (String) session.getAttribute("email");
		lOGGER.info("지원하기 화면보여주기 파라미터 posNo={}",posNo);
		//2 회원정보, 이력서 리스트,매치업이력서번호,포지션번호 
		MemberVO memVo = memberService.selectMember(email);
		List<ResumeVO> resumeList = resumeService.selectResumeAll(memNo);
		int cnt=matchupmemServece.hasMcuResumeNo(memNo);
		int mcuResumeNo=0;
		if(cnt>0) {
			mcuResumeNo=matchupmemServece.selectmcuResumeNo(memNo);
		}
		//3
		model.addAttribute("memVo", memVo);
		model.addAttribute("resumeList", resumeList);
		model.addAttribute("mcuResumeNo", mcuResumeNo);
		model.addAttribute("posNo",posNo);
		//4
		return "jobsearch/apply";
	}
	
}
