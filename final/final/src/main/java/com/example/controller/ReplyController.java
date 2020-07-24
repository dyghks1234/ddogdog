package com.example.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.domain.Criteria;
import com.example.domain.PageMaker;
import com.example.domain.ReplyVO;
import com.example.mapper.BoardMapper;
import com.example.mapper.ReplyMapper;
import com.example.service.ReplyService;

@Controller

public class ReplyController {

	@Autowired
	
	ReplyMapper mapper;
	
	@Autowired
	BoardMapper bMapper;
	
	@Autowired
	ReplyService service;
	
	
	@RequestMapping(value="/reply/list")
	@ResponseBody
	
	public HashMap<String,Object> list(int postingNo,Criteria cri){
		HashMap<String,Object> map=new HashMap<String,Object>();
		
		cri.setPerPageNum(3);
		PageMaker pm= new PageMaker();
		pm.setCri(cri);
		pm.setTotalCount(bMapper.replyCount(postingNo));
		
		map.put("pm", pm);
		map.put("list", mapper.list(postingNo,cri));
		map.put("count",bMapper.replyCount(postingNo));
		return map;
	}
	
	@RequestMapping(value="/reply/reply")
	public void reply() {
		
	}
	
	@RequestMapping(value="/reply/insert")
	@ResponseBody
	public void insert(ReplyVO vo){
		service.insert(vo);
	}
	
	@RequestMapping(value="/reply/delete")
	@ResponseBody
	public void delete(int commentNo){
		service.delete(commentNo);
	}
}
