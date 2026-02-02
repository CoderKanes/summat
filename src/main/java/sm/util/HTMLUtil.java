package sm.util;

public class HTMLUtil {

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
}