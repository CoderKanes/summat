package sm.setting;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

/*
 * 작성자 : 김용진
 * 내용 : EncodingFilter. UTF-8로 처리.
 */
@WebFilter("/*")
public class EncodingFilter implements Filter{

	private String encoding="UTF-8";
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		//Filter.super.init(filterConfig);
		String enc = filterConfig.getInitParameter("encoding");
		if(enc != null) {
			encoding = enc;
		}
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest)request;
		String method = req.getMethod();
		if(method.equalsIgnoreCase("POST")) {
			req.setCharacterEncoding(encoding);
		}		
		chain.doFilter(request, response);		
	}	
}