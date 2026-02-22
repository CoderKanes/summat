package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/*
 * 작성자 : 김용진
 * 내용 : 음식리뷰 포스트(Post) 등록, 수정, 삭제, 조회 및 목록 조회 기능을 담당하는 DAO 클래스
 */
public class PostDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// post_seq.nextval을 받는 Method
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

	// post를 작성사항을 DB.post에 추가하는 Method
	public boolean insertPost(PostDTO dto) {return insertPost(dto, null, null);}
	public boolean insertPost(PostDTO dto, String storeId, String[] menus) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			conn.setAutoCommit(false);
			
			// 1. 기본 포스트 저장
			String sql = "insert into post (postNum, user_id, title, content, thumbnailImage) values(post_seq.nextval,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUser_id());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getThumbnailImage());
			pstmt.executeUpdate();
			pstmt.close();
			// 2. 가게 연결 (storeId가 있을 경우만)
	        if (storeId != null && !storeId.isEmpty()) {
	            String sqlStore = "insert into postTargetStore (postNum, targetStoreId) "
	                            + "values(post_seq.currval, ?)";
	            pstmt = conn.prepareStatement(sqlStore);
	            pstmt.setInt(1, Integer.parseInt(storeId));
	            pstmt.executeUpdate();
	            pstmt.close();
	        }
	        // 3. 메뉴 연결 (menus 배열이 있을 경우만)
	        if (menus != null && menus.length > 0) {
	            // 주의: postTargetMenu 테이블의 PK가 postNum 단독이면 루프 시 에러 발생 가능
	            String sqlMenu = "insert into postTargetMenu (postNum, targetMenuId) "
	                           + "values(post_seq.currval, ?)";
	            pstmt = conn.prepareStatement(sqlMenu);
	            for (String menuId : menus) {
	                pstmt.setInt(1, Integer.parseInt(menuId));
	                pstmt.executeUpdate(); 
	            }
	        }
	        conn.commit(); // 모든 작업 성공 시 커밋
	        result = true;

		} catch (Exception e) {
			result = false;
			try { if(conn != null) conn.rollback(); } catch(Exception ex) {} // 실패 시 롤백
			e.printStackTrace();
		} finally {
			try {conn.setAutoCommit(true);	} catch (SQLException e) {}
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	// 기존에 작성된 post의 내용을 변경하는 Method
	public boolean updatePost(PostDTO dto) {return updatePost(dto, null, null);}
	public boolean updatePost(PostDTO dto, String storeId, String[] menus) {
		boolean result = false;

	    try {
	        conn = OracleConnection.getConnection();
	        conn.setAutoCommit(false); // 트랜잭션 시작

	        // 1. 기본 포스트 내용 수정
	        String sql = "update post set title=?, content=?, thumbnailImage=? where postNum=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getTitle());
	        pstmt.setString(2, dto.getContent());
	        pstmt.setString(3, dto.getThumbnailImage());
	        pstmt.setInt(4, dto.getPostNum());
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 2. 가게 연결 정보 갱신 (Delete -> Insert)
	        // 기존 연결 삭제
	        String sqlDelStore = "delete from postTargetStore where postNum=?";
	        pstmt = conn.prepareStatement(sqlDelStore);
	        pstmt.setInt(1, dto.getPostNum());
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 새로운 가게 연결 (값이 있을 때만)
	        if (storeId != null && !storeId.isEmpty()) {
	            String sqlInsStore = "insert into postTargetStore (postNum, targetStoreId) values(?, ?)";
	            pstmt = conn.prepareStatement(sqlInsStore);
	            pstmt.setInt(1, dto.getPostNum());
	            pstmt.setInt(2, Integer.parseInt(storeId));
	            pstmt.executeUpdate();
	            pstmt.close();
	        }

	        // 3. 메뉴 연결 정보 갱신 (Delete -> Insert)
	        // 기존 연결 삭제
	        String sqlDelMenu = "delete from postTargetMenu where postNum=?";
	        pstmt = conn.prepareStatement(sqlDelMenu);
	        pstmt.setInt(1, dto.getPostNum());
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 새로운 메뉴들 연결 (배열이 있을 때만)
	        if (menus != null && menus.length > 0) {
	            String sqlInsMenu = "insert into postTargetMenu (postNum, targetMenuId) values(?, ?)";
	            pstmt = conn.prepareStatement(sqlInsMenu);
	            for (String menuId : menus) {
	                if (menuId != null && !menuId.isEmpty()) {
	                    pstmt.setInt(1, dto.getPostNum());
	                    pstmt.setInt(2, Integer.parseInt(menuId));
	                    pstmt.executeUpdate();
	                }
	            }
	        }

	        conn.commit(); // 모든 작업 성공 시 확정
	        result = true;

	    } catch (Exception e) {
	        try { if(conn != null) conn.rollback(); } catch(Exception ex) {} // 실패 시 되돌리기
	        e.printStackTrace();
	    } finally {
	        try { if(conn != null) conn.setAutoCommit(true); } catch (Exception e) {}
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return result;
	}

	// 기존에 작성된 post의 내용을 삭제하는 Method
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

	// 검색 조건에 해당하는 Post들의 갯수를 반환하는 Method
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

	// paging 범위와, 검색 조건에 해당하는 Post들의 List를 반환하는 Method
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

	// 검색 관련 쿼리를 붙여주는 Method. selectPostList와 getPostListCount에서 사용된다.
	private String AppendSearchQuery(String baseSql, PostQueryCondition condition, List<QueryParam> params) {

		if (condition != null && condition.getKeyword() != null && !condition.getKeyword().isEmpty()) {
			PostQueryCondition.SearchType type = condition.getSearchType() == null ? PostQueryCondition.SearchType.ALL
					: condition.getSearchType();

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

	// 필터 관련 쿼리를 붙여주는 Method. selectPostList와 getPostListCount에서 사용된다.
	public String AppendFilterQuery(String baseSql, PostQueryCondition condition, List<QueryParam> params) {
		if (condition != null) {
			if (condition.getMinViewCount() != null) {
				baseSql += " and viewCount >= ? ";
				params.add(new QueryParam(condition.getMinViewCount(), Types.INTEGER));
			}

			if (condition.getMinLikeCount() != null) {
				baseSql += " and likeCount >= ? ";
				params.add(new QueryParam(condition.getMinLikeCount(), Types.INTEGER));
			}
			
			if (condition.getByMenuId() != null) {
	            // 해당 postNum을 가진 데이터가 postTargetMenu 테이블에 존재하는지 확인
	            baseSql += " and exists (select 1 from postTargetMenu ptm "
	                    + " where ptm.postNum = post.postNum and ptm.targetMenuId = ?) ";
	            params.add(new QueryParam(condition.getByMenuId(), Types.INTEGER));
	        }
			
			if (condition.getByStoreId() != null) {
	            // 해당 postNum을 가진 데이터가 postTargetStroe 테이블에 존재하는지 확인
	            baseSql += " and exists (select 1 from postTargetStroe ptm "
	                    + " where ptm.postNum = post.postNum and ptm.targetStoreId = ?) ";
	            params.add(new QueryParam(condition.getByStoreId(), Types.INTEGER));
	        }
			
			// 작성자 등급 필터 (List 버전)
	        List<PostQueryCondition.UserRole> roles = condition.getUserRoleFilters();
	        if (roles != null && !roles.isEmpty()) {
	            
	            // 1. IN 절에 들어갈 물음표(?)들 생성 (예: ?, ?, ?)
	            String placeholders = roles.stream()
	                                       .map(role -> "?")
	                                       .collect(Collectors.joining(", "));
	            
	            baseSql += " and exists (select 1 from users u where u.user_id = post.user_id "
	                    + " and u.user_type IN (" + placeholders + ")) ";
	            
	            // 2. 파라미터 리스트에 실제 enum 값(문자열) 추가
	            for (PostQueryCondition.UserRole role : roles) {
	                params.add(new QueryParam(role.name(), Types.VARCHAR));
	            }
	        }
		}

		return baseSql;
	}

	// 정렬 관련 쿼리를 붙여주는 Method. selectPostList와 getPostListCount에서 사용된다.
	public String AppendOrderQuery(String baseSql, PostQueryCondition condition, List<QueryParam> params) {
		if (condition != null) {
			PostQueryCondition.OrderType orderType = condition.getOrderType() == null
					? PostQueryCondition.OrderType.LATEST
					: condition.getOrderType();

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

	// 하나의 Post 데이터를 얻어오는 Method
	public PostDTO selectPost(int postNum) {return selectPost(postNum, false);}
	public PostDTO selectPost(int postNum, boolean bAddViewCount) {
		PostDTO result = null;

		try {
			conn = OracleConnection.getConnection();
			
			if (bAddViewCount) {
	            String updateSql = "update post set viewCount = viewCount + 1 where postNum = ?";
	            pstmt = conn.prepareStatement(updateSql);
	            pstmt.setInt(1, postNum);
	            pstmt.executeUpdate();
	            pstmt.close(); 
	        }			
			
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

	// PreparedStatement에 사용될 Object타입 Param을 명시적타입으로 처리하기 위한 SubClass
	private static class QueryParam {
		Object value;
		int type; // java.sql.Types.INTEGER java.sql.Types.DOUBLE java.sql.Types.VARCHAR
					// java.sql.Types.TIMESTAMP

		QueryParam(Object value, int type) {
			this.value = value;
			this.type = type;
		}
	}

	// post에 댓글을 작성하는 Method
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

	// (대댓글을 제외한) post에 해당하는 댓글을 가져오는 Method
	public List<PostCommentDTO> getPostComments(int postNum) {
		List<PostCommentDTO> result = new ArrayList<PostCommentDTO>();

		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from postComment where postNum=? and replytarget = 0 OR replytarget IS NULL order by created_at desc";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNum);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				PostCommentDTO dto = new PostCommentDTO();
				dto.setId(rs.getInt("id"));
				dto.setPostNum(rs.getInt("postNum"));
				dto.setUser_Id(rs.getString("user_id"));
				dto.setGuestName(rs.getString("guestName"));
				dto.setGuestPassword(rs.getString("guestPassword"));
				dto.setContent(rs.getString("content"));
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
	
	// (대댓글을 포함) post에 해당하는 댓글의 개수를 가져오는 Method
	public int getPostCommentCount(int postNum) {
		int result = 0;

		try {
			conn = OracleConnection.getConnection();
			String sql = "select Count(*) from postComment where postNum=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNum);
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

	// id로 댓글을 가져오는 Method
	public PostCommentDTO getPostComment(int postCommentId) {
		PostCommentDTO result = null;

		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from postComment where id = ?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				result = new PostCommentDTO();
				result.setId(rs.getInt("id"));
				result.setPostNum(rs.getInt("postNum"));
				result.setUser_Id(rs.getString("user_id"));
				result.setGuestName(rs.getString("guestName"));
				result.setGuestPassword(rs.getString("guestPassword"));
				result.setContent(rs.getString("content"));
				result.setCreated_at(rs.getTimestamp("created_at"));
				result.setUpdated_at(rs.getTimestamp("updated_at"));
				result.setReplyTarget(rs.getInt("replytarget"));

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	// id에 해당하는 post댓글 삭제 
	public boolean deletePostComment(int postCommentId) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "delete from postComment where id=?";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	// id에 해당하는 post댓글 수정 
	public boolean updatePostComment(int postCommentId, String newContent) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "update postComment set content=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, newContent);
			pstmt.setInt(2, postCommentId);
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	public List<PostCommentDTO> getSubPostComments(int postNum, int commentId) {
		List<PostCommentDTO> result = new ArrayList<PostCommentDTO>();

		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from postComment where postNum=? and REPLYTARGET=? order by created_at desc";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postNum);
			pstmt.setInt(2, commentId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				PostCommentDTO dto = new PostCommentDTO();
				dto.setId(rs.getInt("id"));
				dto.setPostNum(rs.getInt("postNum"));
				dto.setUser_Id(rs.getString("user_id"));
				dto.setGuestName(rs.getString("guestName"));
				dto.setGuestPassword(rs.getString("guestPassword"));
				dto.setContent(rs.getString("content"));
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
	
	// id에 해당하는 post댓글 의 좋아요 상태 추가
	public boolean insertCommentLike(int postCommentId, String user_id, int likeType) {
		boolean result = true;
		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into postComment_like (COMMENT_ID, USER_ID, LIKE_TYPE, CREATED_AT) values(?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
			pstmt.setString(2, user_id);
			pstmt.setInt(3, likeType);
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	// commentid에 userid가 남긴 해당하는 좋아요 상태 select; 
	public int getLikeType(int postCommentId, String user_id) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select LIKE_TYPE from postComment_like where COMMENT_ID=? and USER_ID=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
			pstmt.setString(2, user_id);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				result = rs.getInt("LIKE_TYPE");
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	// commentid에 userid가 남긴 해당하는 좋아요 상태 select; 
	public int GetTotalLike(int postCommentId) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select Count(*) from postComment_like where COMMENT_ID=? and LIKE_TYPE=1 ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
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
	
	// commentid에 userid가 남긴 해당하는 싫어요 상태 select; 
	public int GetTotalDislike(int postCommentId) {
		int result = 0;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select Count(*) from postComment_like where COMMENT_ID=? and LIKE_TYPE=-1 ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
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
	// id에 해당하는 post댓글 의 좋아요 상태 수정 
	public boolean updateCommentLike(int postCommentId, String user_id, int likeType) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "update postComment_like set LIKE_TYPE=? where COMMENT_ID=? and USER_ID=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, likeType);
			pstmt.setInt(2, postCommentId);
			pstmt.setString(3, user_id);
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	// id에 해당하는 post댓글 의 좋아요 상태 수정
	public boolean deleteCommentLike(int postCommentId, String user_id) {
		boolean result = true;
		try {
			conn = OracleConnection.getConnection();
			String sql = "delete from postComment_like where COMMENT_ID=? and USER_ID=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, postCommentId);
			pstmt.setString(2, user_id);
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	// 게시글에 연결된 가게 ID 가져오기
	public Integer getStoreIdByPost(int postNum) {
		Integer storeId = null;
	    String sql = "SELECT targetStoreId FROM postTargetStore WHERE postNum = ?";
	    
	    try {
	        conn = OracleConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, postNum);
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            storeId = rs.getInt("targetStoreId");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return storeId;
	}

	// 게시글에 연결된 메뉴 ID 리스트 가져오기
	public List<Integer> getMenusByPost(int postNum) {
	    List<Integer> menus = new ArrayList<>();
	    String sql = "SELECT targetMenuId FROM postTargetMenu WHERE postNum = ?";
	    
	    try {
	        conn = OracleConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, postNum);
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            menus.add(rs.getInt("targetMenuId"));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return menus;
	}
	
	public int updateLikeCount(int postNum, String userId) {
	    int result = 0; // 0: 실패, 1: 성공, -1: 이미 추천함
	    try {
	        conn = OracleConnection.getConnection();
	        
	        // 1. 중복 추천 확인 (이미 이 유저가 이 글을 추천했는지)
	        String sqlCheck = "select count(*) from POST_LIKE where POST_ID=? and USER_ID=?";
	        pstmt = conn.prepareStatement(sqlCheck);
	        pstmt.setInt(1, postNum);
	        pstmt.setString(2, userId);
	        rs = pstmt.executeQuery();
	        
	        if (rs.next() && rs.getInt(1) > 0) {
	            return -1; // 이미 추천함
	        }
	        pstmt.close();

	        // 2. 추천 기록 저장
	        String sqlInsert = "insert into POST_LIKE (POST_ID, USER_ID) values (?, ?)";
	        pstmt = conn.prepareStatement(sqlInsert);
	        pstmt.setInt(1, postNum);
	        pstmt.setString(2, userId);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 3. 실제 포스트 테이블의 likeCount 증가
	        String sqlUpdate = "update post set likeCount = likeCount + 1 where postNum = ?";
	        pstmt = conn.prepareStatement(sqlUpdate);
	        pstmt.setInt(1, postNum);
	        pstmt.executeUpdate();
	        
	        result = 1; // 최종 성공
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return result;
	}
	
	// 특정 게시글의 총 추천수(좋아요 수) 가져오기
	public int getLikeCount(int postNum) {
	    int count = 0;
	    String sql = "SELECT COUNT(*) FROM POST_LIKE WHERE POST_ID = ?";
	    
	    try {
	        conn = OracleConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, postNum);
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            // COUNT(*)의 결과는 첫 번째 컬럼에 숫자로 담깁니다.
	            count = rs.getInt(1); 
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        OracleConnection.closeAll(conn, pstmt, rs);
	    }
	    return count;
	}
}
