package sm.util;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/*
 * 작성자 : 김용진
 * 내용 : HTML 문자열을 가공·변환하기 위한 공통 유틸리티 클래스
 */
public class HTMLUtil {
	// HTML형식 문자열에서 <태그>들을 떼어내고 PlainText를 반환한다.
    public static String htmlContentToPlainText(String htmlContent, boolean keepLineBreaks) {
        if (htmlContent == null || htmlContent.isEmpty()) {
            return "";
        }
        // 줄바꿈 태그를 줄바꿈 적용할지, 공백처리할지
        if (keepLineBreaks) {            
            htmlContent = htmlContent.replaceAll("(?i)<br\\s*/?>", "\n");
            htmlContent = htmlContent.replaceAll("(?i)</div>", "\n");
            htmlContent = htmlContent.replaceAll("(?i)</p>", "\n");
        } else {          
            htmlContent = htmlContent.replaceAll("(?i)<br\\s*/?>|</div>|</p>", " ");
        }

        // HTML 태그 제거
        htmlContent = htmlContent.replaceAll("<[^>]*>", "");

        // HTML 공백 및 특수문자
        htmlContent = htmlContent.replace("&nbsp;", " ")
                         .replace("&lt;", "<")
                         .replace("&gt;", ">")
                         .replace("&amp;", "&")
                         .replace("&quot;", "\"")
                         .replace("&apos;", "'");
        // 연속공백
        if (keepLineBreaks) {
            htmlContent = htmlContent.replaceAll("[ \t]+", " ");           
            htmlContent = htmlContent.replaceAll("\n{3,}", "\n\n"); // 3개 이상 줄바꿈을 2개로)
        } else {
            htmlContent = htmlContent.replaceAll("\\s+", " ");
        }
        return htmlContent.trim();
    } 
    

	public static List<String> extractAllImgSrc(String html) {
		List<String> result = new ArrayList<>();

		String regex = "<img[^>]+src\\s*=\\s*\"([^\"]+)\"";
		Pattern pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
		Matcher matcher = pattern.matcher(html);

		while (matcher.find()) {
			result.add(matcher.group(1));
		}

		return result;
	}

}