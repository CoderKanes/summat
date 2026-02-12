package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/*
 * 작성자 : 김용진
 * 내용 : 음식리뷰 포스트(Post) 등록, 수정, 삭제, 조회 및 목록 조회 기능을 담당하는 DAO 클래스
 */
public class PostDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	//post_seq.nextval을 받는 Method
	public int GetPostSeqNextVal() {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();

			String sql = "select post_seq.nextval from dual";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getInt(1);
			} else {
				throw new Exception();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	//post를 작성사항을 DB.post에 추가하는 Method
	public boolean insertPost(PostDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into post (postNum, user_id, title, content, thumbnailImage) values(post_seq.nextval,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getThumbnailImage());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	//기존에 작성된 post의 내용을 변경하는 Method
	public boolean updatePost(PostDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "update post set user_id=?, title=?, content=?, thumbnailImage=? where postNum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getThumbnailImage());
			pstmt.setInt(5, dto.getPostNum());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	//기존에 작성된 post의 내용을 삭제하는 Method
	public boolean deletePost(int postNum) {
		boolean result = true;
		try {
			conn = OracleConnection.getConnection();
			String sql = "delete from post where postNum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNum);

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	//검색 조건에 해당하는 Post들의 갯수를 반환하는 Method
	public int getPostListCount(PostQueryCondition condition) {
		int result = 0;

		try {
			conn = OracleConnection.getConnection();

			List<QueryParam> params = new ArrayList<>();

			String sql = " select count(*) from post where 1=1 ";
			sql = AppendSearchQuery(sql, condition, params);
			sql = AppendFilterQuery(sql, condition, params);
			sql = AppendOrderQuery(sql, condition, params);
		
			pstmt = conn.prepareStatement(sql);
			for (int i = 0; i < params.size(); i++) {
				QueryParam param = params.get(i);
				if (param.value == null) {
					pstmt.setNull(i + 1, param.type);
				} else {
					pstmt.setObject(i + 1, param.value, param.type);					
				}
			}
						
			rs = pstmt.executeQuery();

			if (rs.next()) {
				result = rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	//paging 범위와, 검색 조건에 해당하는 Post들의 List를 반환하는 Method
	public List<PostDTO> selectPostList(int start, int end, PostQueryCondition condition) {
		List<PostDTO> result = null;

		try {
			conn = OracleConnection.getConnection();

			List<QueryParam> params = new ArrayList<>();

			String baseSql = " select * from post where 1=1 ";
			baseSql = AppendSearchQuery(baseSql, condition, params);
			baseSql = AppendFilterQuery(baseSql, condition, params);
			baseSql = AppendOrderQuery(baseSql, condition, params);

			String rownumTable = "select a.*, rownum r from (" + baseSql + ") a ";
			String sql = start == end ? "select * from (" + rownumTable + ") "
					: "select * from (" + rownumTable + ") where r between ? and ?";
			if (start != end) {
				params.add(new QueryParam(start, Types.INTEGER));
				params.add(new QueryParam(end, Types.INTEGER));				
			}
			

			pstmt = conn.prepareStatement(sql);
			for (int i = 0; i < params.size(); i++) {
				QueryParam param = params.get(i);
				if (param.value == null) {
					pstmt.setNull(i + 1, param.type);
				} else {
					pstmt.setObject(i + 1, param.value, param.type);
				}
			}
						
			rs = pstmt.executeQuery();

			if (rs.next()) {
				result = new ArrayList<PostDTO>();
				do {
					PostDTO postDto = new PostDTO();
					postDto.setPostNum(rs.getInt("postNum"));
					postDto.setUser_id(rs.getString("user_id"));
					postDto.setTitle(rs.getString("title"));
					postDto.setContent(rs.getString("content"));
					postDto.setThumbnailImage(rs.getString("thumbnailImage"));
					postDto.setViewCount(rs.getInt("viewCount"));
					postDto.setLikeCount(rs.getInt("likeCount"));
					postDto.setCreated_at(rs.getTimestamp("created_at"));
					postDto.setUpdated_at(rs.getTimestamp("updated_at"));
					result.add(postDto);
				} while (rs.next());
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	//검색 관련 쿼리를 붙여주는 Method. selectPostList와 getPostListCount에서 사용된다.
	private String AppendSearchQuery(String baseSql, PostQueryCondition condition, List<QueryParam> params) {

		if (condition != null && condition.getKeyword() != null && !condition.getKeyword().isEmpty()) {
			PostQueryCondition.SearchType type = condition.getSearchType() == null ? PostQueryCondition.SearchType.ALL : condition.getSearchType();

			switch (type) {
			case TITLE:
				baseSql += " and title like ? ";
				params.add(new QueryParam("%" + condition.getKeyword() + "%", Types.VARCHAR));
				break;
			case CONTENT:
				baseSql += " and content like ? ";
				params.add(new QueryParam("%" + condition.getKeyword() + "%", Types.VARCHAR));
				break;
			case ALL:
				baseSql += " and (title like ? or content like ?) ";
				params.add(new QueryParam("%" + condition.getKeyword() + "%", Types.VARCHAR));
				params.add(new QueryParam("%" + condition.getKeyword() + "%", Types.VARCHAR));
				break;
			}
		}
		return baseSql;
	}
	
	//필터 관련 쿼리를 붙여주는 Method. selectPostList와 getPostListCount에서 사용된다.
	public String AppendFilterQuery(String baseSql, PostQueryCondition condition, List<QueryParam> params) {
		if(condition != null) {		
			if (condition.getMinViewCount() != null) {
				baseSql += " and viewCount >= ? ";
				params.add(new QueryParam(condition.getMinViewCount(), Types.INTEGER));
			}
	
			if (condition.getMinLikeCount() != null) {
				baseSql += " and likeCount >= ? ";
				params.add(new QueryParam(condition.getMinLikeCount(), Types.INTEGER));
			}
		}

		return baseSql;
	}

	//정렬 관련 쿼리를 붙여주는 Method. selectPostList와 getPostListCount에서 사용된다.
	public String AppendOrderQuery(String baseSql, PostQueryCondition condition, List<QueryParam> params) {
		if (condition != null) {
			PostQueryCondition.OrderType orderType = condition.getOrderType() == null ? PostQueryCondition.OrderType.LATEST : condition.getOrderType();

			switch (orderType) {
			case PostQueryCondition.OrderType.VIEW:
				baseSql += " order by viewCount desc ";
				break;
			case PostQueryCondition.OrderType.LIKE:
				baseSql += " order by likeCount desc ";
				break;
			default:
				baseSql += " order by created_at desc ";
			}
		}
		return baseSql;
	}

	//하나의 Post 데이터를 얻어오는 Method
	public PostDTO selectPost(int postNum) {
		PostDTO result = null;

		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from post where postNum=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNum);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				result = new PostDTO();
				result.setPostNum(rs.getInt("postNum"));
				result.setUser_id(rs.getString("user_id"));
				result.setTitle(rs.getString("title"));
				result.setContent(rs.getString("content"));
				result.setThumbnailImage(rs.getString("thumbnailImage"));
				result.setViewCount(rs.getInt("viewCount"));
				result.setLikeCount(rs.getInt("likeCount"));
				result.setCreated_at(rs.getTimestamp("created_at"));
				result.setUpdated_at(rs.getTimestamp("updated_at"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	//PreparedStatement에 사용될 Object타입 Param을 명시적타입으로 처리하기 위한 SubClass
	private static class QueryParam {
		Object value;
		int type; // java.sql.Types.INTEGER java.sql.Types.DOUBLE java.sql.Types.VARCHAR
					// java.sql.Types.TIMESTAMP

		QueryParam(Object value, int type) {
			this.value = value;
			this.type = type;
		}
	}
	
	
	//post에 댓글을 작성하는 Method
	public boolean insertComment(PostCommentDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into postComment (id, postNum, user_id, guestName, guestPassword, content, likeCount, dislikeCount, created_at, updated_at, replytarget) "
					+ "values(postComment_seq.nextval,?,?,?,?, ?,0,0,sysdate,sysdate,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getPostNum());
			pstmt.setString(2, dto.getUser_Id());
			pstmt.setString(3, dto.getGuestName());
			pstmt.setString(4, dto.getGuestPassword());
			pstmt.setString(5, dto.getContent());
			pstmt.setInt(6, dto.getReplyTarget());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	//post에 댓글을 작성하는 Method
		public List<PostCommentDTO> getPostComments(int postNum) {
			List<PostCommentDTO> result = new ArrayList<PostCommentDTO>();

			try {
				conn = OracleConnection.getConnection();
				String sql = "select * from postComment where postNum=? order by created_at desc";

				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, postNum);
				rs = pstmt.executeQuery();

				while (rs.next()) {
					PostCommentDTO dto = new PostCommentDTO();
					dto.setPostNum(rs.getInt("postNum"));				
					dto.setUser_Id(rs.getString("user_id"));
					dto.setGuestName(rs.getString("guestName")); 
					dto.setGuestPassword(rs.getString("guestPassword"));
					dto.setContent(rs.getString("content"));
					dto.setLikeCount(rs.getInt("likeCount"));
					dto.setDislikeCount(rs.getInt("dislikeCount"));
					dto.setCreated_at(rs.getTimestamp("created_at"));	
					dto.setUpdated_at(rs.getTimestamp("updated_at"));		
					dto.setReplyTarget(rs.getInt("replytarget"));
					
				
					result.add(dto);					
				}

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				OracleConnection.closeAll(conn, pstmt, rs);
			}
			return result;
		}
}
