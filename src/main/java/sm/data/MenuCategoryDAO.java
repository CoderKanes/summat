package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class MenuCategoryDAO {
	//싱글톤 
	private static class Holder { private static final MenuCategoryDAO instance = new MenuCategoryDAO(); }	
	public static MenuCategoryDAO getInstance() { return Holder.instance; }	
	private MenuCategoryDAO() {}
	//end
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
		
	public Map<String, Integer> getCultureCategoryMap() {
		Map<String, Integer> result = new LinkedHashMap<String, Integer>();
		try {
			conn = OracleConnection.getConnection();
			
			String sql = "select * from CULTURE_CATEGORY ORDER BY id";
			pstmt = conn.prepareStatement(sql);			
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				result.put(rs.getString("name"), rs.getInt("id"));
			}	

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	public Map<String, Integer> getFoodTypeMap() {
		Map<String, Integer> result = new LinkedHashMap<String, Integer>();
		try {
			conn = OracleConnection.getConnection();
			
			String sql = "select * from FOODTYPE_CATEGORY ORDER BY id";
			pstmt = conn.prepareStatement(sql);			
			rs = pstmt.executeQuery();
			while(rs.next())
			{
				result.put(rs.getString("name"), rs.getInt("id"));
			}	

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	public List<FoodCategory> getFoodCategoryInfos() {
		List<FoodCategory> result = new ArrayList<FoodCategory>();
		try {
			conn = OracleConnection.getConnection();
			
			String sql = 
					"SELECT f.name AS food_name, "
					+ "LISTAGG(c.name, ',') WITHIN GROUP (ORDER BY c.name) AS cultures, "
					+ "LISTAGG(t.name, ',') WITHIN GROUP (ORDER BY t.name) AS types "					
					+ "FROM FOOD_ITEM f "
					+ "LEFT JOIN FOOD_CULTURE_MAP fcm ON f.id = fcm.food_id "
					+ "LEFT JOIN CULTURE_CATEGORY c ON fcm.culture_id = c.id "
					+ "LEFT JOIN FOOD_TYPE_MAP ftm ON f.id = ftm.food_id "
					+ "LEFT JOIN FOODTYPE_CATEGORY t ON ftm.type_id = t.id "
					+ "GROUP BY f.id, f.name";
			pstmt = conn.prepareStatement(sql);			
			rs = pstmt.executeQuery();
			while (rs.next()) {
			    String name = rs.getString("food_name");
			    String cultures = rs.getString("cultures"); // 예: "양식,일식"
			    String types = rs.getString("types");       // 예: "고기,튀김"

			    // 생성자에서 쉼표로 쪼개어 List<String>에 담는 로직
			    FoodCategory food = new FoodCategory(name, cultures, types);
			    result.add(food);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	public int insertFoodItem(Connection connection, String name) throws SQLException {
		int result = 0;
		try {
			connection = OracleConnection.getConnection();
			
			String sql = "INSERT INTO FOOD_ITEM (id, name) VALUES (food_seq.NEXTVAL, ?)";
			String[] generatedColumns = {"ID"}; 
		    pstmt = connection.prepareStatement(sql, generatedColumns);
		    pstmt.setString(1, name);
		    pstmt.executeUpdate();
		    
		    rs = pstmt.getGeneratedKeys();
	        if (rs.next()) {
	        	result = rs.getInt(1);
	        }		
		} finally {
			OracleConnection.closeAll(null, pstmt, rs); //Connection은 상위 콜스택에서 닫음.
		}
		return result;
	}
	
	public void insertCultureBatch(Connection connection, List<int[]> mappingList) throws SQLException {
	    try {
	        String sql = "INSERT INTO FOOD_CULTURE_MAP (food_id, culture_id) VALUES (?, ?)";
	        pstmt = connection.prepareStatement(sql);

	        for (int[] map : mappingList) {
	            pstmt.setInt(1, map[0]); // foodId
	            pstmt.setInt(2, map[1]); // cultureId
	            pstmt.addBatch();        // Batch에 담기
	        }
	        pstmt.executeBatch();        // Batch 실행
	    }
	    finally {
	    	OracleConnection.closeAll(null, pstmt, rs); //Connection은 상위 콜스택에서 닫음.
	    }
	}
	
	public void insertTypeBatch(Connection connection, List<int[]> mappingList) throws SQLException {
	    try {	   
	        String sql = "INSERT INTO FOOD_TYPE_MAP (food_id, type_id) VALUES (?, ?)";
	        pstmt = connection.prepareStatement(sql);

	        for (int[] map : mappingList) {
	            pstmt.setInt(1, map[0]); // foodId
	            pstmt.setInt(2, map[1]); // type_id
	            pstmt.addBatch();        // Batch에 담기
	        }
	        pstmt.executeBatch();        // 한꺼번에 실행
	    } finally {
	    	OracleConnection.closeAll(null, pstmt, rs); //Connection은 상위 콜스택에서 닫음.
	    }
	}	
}
