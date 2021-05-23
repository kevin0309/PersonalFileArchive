package member.join.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import framework.servlet.controller.handler.RedirectPageHandler;
import framework.servlet.controller.vo.PageMapperVO;

public class GetJoinPageAction implements RedirectPageHandler {
	
	private final String VIEW_URL = "/WEB-INF/view/member/login.jsp";

	@Override
	public String getURL() {
		return "/page/member/login";
	}

	@Override
	public PageMapperVO doGet(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		return new PageMapperVO(VIEW_URL);
	}

	@Override
	public PageMapperVO doPost(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		return new PageMapperVO(VIEW_URL);
	}

}
