package sm.data;

import java.util.List;


/*
 * 작성자 : 김용진
 * 내용 : PostDAO에서 검색,필터,정렬 관련 Param으로 사용하기 위한 DataType Class
 */
public class PostQueryCondition {
	public enum SearchType {
	    ALL,
	    TITLE,
	    CONTENT
	}

	public enum OrderType {
	    LATEST,
	    VIEW,
	    LIKE
	}
	
    // 검색
    private SearchType searchType = null; // ALL, TITLE, CONTENT
    private String keyword = null;

    // 필터
    private Integer minViewCount = null;
    private Integer minLikeCount = null;
    //private List<String> tags = null;

    // 정렬
    private OrderType orderType = null; // LATEST, VIEW, LIKE

    public SearchType getSearchType() { return searchType; }
    public void setSearchType(SearchType searchType) { this.searchType = searchType; }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public Integer getMinViewCount() { return minViewCount; }
    public void setMinViewCount(Integer minViewCount) { this.minViewCount = minViewCount; }

    public Integer getMinLikeCount() { return minLikeCount; }
    public void setMinLikeCount(Integer minLikeCount) { this.minLikeCount = minLikeCount; }

    //public List<String> getTags() { return tags; }
    //public void setTags(List<String> tags) { this.tags = tags; }

    public OrderType getOrderType() { return orderType; }
    public void setOrderType(OrderType orderType) { this.orderType = orderType; }
    
    

    
}
