package sm.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import sm.data.MenuCategoryDAO;
import sm.data.OracleConnection;

public class FoodCategoryUtil {
	public void loadCsv(String csvFile)
	{
		// DB에서 { "한식": 1, "일식": 2 ... } 형태의 Map을 미리 싹 긁어옵니다.
		Map<String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryMap();
		Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodTypeMap();
		
	
		Connection conn = OracleConnection.getConnection();
	    try (BufferedReader br = Files.newBufferedReader(Paths.get(csvFile), StandardCharsets.UTF_8)){
			conn.setAutoCommit(false);	

			List<int[]> cultureBatch = new ArrayList<>();
			List<int[]> typeBatch = new ArrayList<>();
			String line = "";
			while ((line = br.readLine()) != null) {
				String[] data = line.split(",");
				if(data.length == 0) continue; // 빈 줄 방어
				int foodId = MenuCategoryDAO.getInstance().insertFoodItem(conn, data[0]); // 음식 먼저 넣고 ID 획득

				for (int i = 1; i < data.length; i++) {
					String catName = data[i].trim(); 
					if (cultureMap.containsKey(catName)) {
						cultureBatch.add(new int[] { foodId, cultureMap.get(catName) });
					} else if (typeMap.containsKey(catName)) {
						typeBatch.add(new int[] { foodId, typeMap.get(catName) });
					}
				}
			}

			// 루프가 끝나면 한꺼번에 배치 실행
			MenuCategoryDAO.getInstance().insertCultureBatch(conn, cultureBatch);
			MenuCategoryDAO.getInstance().insertTypeBatch(conn, typeBatch);
				
			conn.commit();
			
		} catch (Exception e) { 
			if (conn != null){
				try { conn.rollback();}	catch (SQLException e1) {e1.printStackTrace();} 
			}
			e.printStackTrace();
		} finally {	
			try { if(conn != null) conn.setAutoCommit(true); } catch (SQLException e) {}
			OracleConnection.closeAll(conn, null, null);
		}
		
	}
}
