package test.template.command;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import framework.servlet.controller.handler.RedirectPageHandler;
import framework.servlet.controller.vo.PageMapperVO;

public class GetTemplatePageAction implements RedirectPageHandler {

	@Override
	public String getURL() {
		return "/page/template";
	}

	@Override
	public PageMapperVO doGet(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		return process(req, resp);
	}

	@Override
	public PageMapperVO doPost(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		return process(req, resp);
	}
	
	private PageMapperVO process(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		PageMapperVO pm = new PageMapperVO("/WEB-INF/view/template.jsp");
		return pm;
	}

}
