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
import sm.data.MenuDTO;
import sm.data.MenuGroupDTO;
import sm.data.OracleConnection;

public class FoodCategoryUtil {
	
	public static class GroupViewData {
		public MenuGroupDTO group;
		public List<MenuDTO> menus = new ArrayList<>();
	}
	public static class MenuData
	{
		public List<MenuGroupDTO> groupDTOs;
		public List<MenuDTO> menuDTOs;	
		public List<GroupViewData> GetGroupViewDatas()
		{
			List<GroupViewData> viewDatas = new ArrayList<GroupViewData>();

			for (MenuGroupDTO groupdto : groupDTOs) {
				GroupViewData gvd = new GroupViewData();
				gvd.group = groupdto;
				
				for (MenuDTO menudto : menuDTOs) {
					if (menudto.getGroupNum() == groupdto.getNum()) {
						gvd.menus.add(menudto);
					}
				}
				viewDatas.add(gvd);
			}
			
			return viewDatas;
		}
	}
	public static MenuData menuDataParse(String menuData) {return menuDataParse(menuData, null);}
	public static MenuData menuDataParse(String menuData, Integer storeId)
	{
		MenuData result = new MenuData();
		result.groupDTOs = new ArrayList<MenuGroupDTO>();
		result.menuDTOs = new ArrayList<MenuDTO>();
		
		System.out.println(menuData);
		
		String RS = "\\|\\|\\|"; // 정규식 escape 주의
		String FS = ":::";
		for (String rec : menuData.split(RS)) {
		    String[] c = rec.split(FS, -1);
		
		    if ("G".equals(c[0])) {
		    	MenuGroupDTO menuGroup_dto = new MenuGroupDTO();	
		    	if(storeId!=null)menuGroup_dto.setStoreId(storeId);
		    	menuGroup_dto.setNum(Integer.parseInt(c[1]));
		    	menuGroup_dto.setOrderIdx(Integer.parseInt(c[2]));
		    	menuGroup_dto.setName(c[3]);
		    	
		    	result.groupDTOs.add(menuGroup_dto);
		
		    } else if ("M".equals(c[0])) {
		    	MenuDTO menu_dto = new MenuDTO();
		    	if(storeId!=null)menu_dto.setStoreId(storeId);
		    	menu_dto.setGroupNum(Integer.parseInt(c[1]));
		        menu_dto.setOrderIdx(Integer.parseInt(c[2]));
		        menu_dto.setId(Integer.parseInt(c[3]));
		        menu_dto.setName(c[4]);
		        menu_dto.setPrice(Integer.parseInt(c[5]));
		        menu_dto.setImage(c[6]);	
		        menu_dto.setMenu_desc(c[7]);			        
		        menu_dto.setCCategory_str(c[8]); 
		        menu_dto.setFCategory_str(c[9]) ;
		        menu_dto.setFoodItem_str(c[10]); 
		        
		        result.menuDTOs.add(menu_dto);
		    }
		}		
		return result;
	}
	public static String generateMenuDataString(List<MenuGroupDTO> groups , List<MenuDTO> menus )
	{
		String menuData = "";
		
		//generate menuData format; 
		//'M', groupId, mOrder, menuId, name, price, img, desc, culture, foodTypes, foodItem
		//G:::그룹번호:::정렬위치:::그룹명|||M:::소속그룹번호:::정렬위치:::메뉴아이디:::메뉴명:::가격:::이미지파일경로|||M:::소속그룹번호:::정렬위치:::메뉴아이디:::메뉴명:::가격:::이미지파일경로
		for(int i = 0; i < groups.size(); ++i)
		{
			MenuGroupDTO gdto = groups.get(i);
			if(i!=0)
			{
				menuData += "|||";
			}
		
			menuData += "G:::"+gdto.getNum()+":::"+gdto.getOrderIdx()+":::"+gdto.getName(); 
			
			for(int j = 0; j < menus.size(); ++j)
			{
				MenuDTO mdto = menus.get(j);
				if(mdto.getGroupNum() == gdto.getNum())	{
					menuData += "|||M:::"+mdto.getGroupNum()
							+":::"+mdto.getOrderIdx()
							+":::"+mdto.getId()
							+":::"+mdto.getName()
							+":::"+mdto.getPrice()
							+":::"+mdto.getImage()
							+":::"+mdto.getMenu_desc()
							+":::"+mdto.getCCategory_str()
							+":::"+mdto.getFCategory_str()
							+":::"+mdto.getFoodItem_str()
							;
				}
			}
		}
		return menuData;
	}
	
	public static String cCategoryIdToCategorySting(Integer cCategoryId) {
		String result = "";
		if (cCategoryId != null) {
			Map<Integer, String> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryMap();
			if(cultureMap.containsKey(cCategoryId))
			{
				result += cultureMap.get(cCategoryId);
			}			
		}
		return result;
	}

	public static String fCategoryIdToCategorySting(Integer fCategoryId) {
		String result = "";
		if (fCategoryId != null) {
			Map<Integer, String> typeMap = MenuCategoryDAO.getInstance().getFoodTypeMap();		
			if(typeMap.containsKey(fCategoryId))
			{
				result += typeMap.get(fCategoryId);
			}			
		}
		return result;
	}

	public static String fCategoryIdToCategorySting(List<Integer> fCategoryIds) {
		String result = "";
		Map<Integer, String> typeMap = MenuCategoryDAO.getInstance().getFoodTypeMap();		
		for (Integer fc_id : fCategoryIds ) {
			if (fc_id != null) {
				if(typeMap.containsKey(fc_id))
				{
					if(result.length()>0)
					{
						result+=",";
					}
					result += typeMap.get(fc_id);
				}			
			}
		}
		return result;
	}

	public static String foodItemIdToCategorySting(Integer foodItemId) {
		String result = "";
		if (foodItemId != null) {
			Map<Integer, String> foodItemMap = MenuCategoryDAO.getInstance().getFoodItemMap();		
			if(foodItemMap.containsKey(foodItemId))
			{
				result += foodItemMap.get(foodItemId);
			}			
		}
		return result;
	}
	
	public static Integer cCategoryStingToCategoryId(String cCategoryString) {
		Integer result = null;
		if (cCategoryString != null) {
			Map<String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryReverseMap();
			if(cultureMap.containsKey(cCategoryString))
			{
				result = cultureMap.get(cCategoryString);
			}			
		}
		return result;
	}

	public static Integer fCategoryStingToCategoryId(String fCategoryString) {
		Integer result = null;
		if (fCategoryString != null) {
			Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();		
			if(typeMap.containsKey(fCategoryString))
			{
				result = typeMap.get(fCategoryString);
			}			
		}
		return result;
	}

	public static List<Integer> fCategoryStingToCategoryIds(String fCategoryString) {
		List<Integer> result = new ArrayList<Integer>();
		Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();		
		
		for (String fc_str : fCategoryString.split(","))
		{
			if(typeMap.containsKey(fc_str))
			{
				result .add(typeMap.get(fc_str));
			}			
		}
		return result;
	}

	public static Integer foodItemStingToCategoryStingId(String foodItemString) {
		Integer result = null;
		if (foodItemString != null) {
			Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodItemReverseMap();		
			if(typeMap.containsKey(foodItemString))
			{
				result = typeMap.get(foodItemString);
			}			
		}
		return result;
	}
	
	public void loadCsv(String csvFile)
	{
		// DB에서 { "한식": 1, "일식": 2 ... } 형태의 Map을 미리 싹 긁어옵니다.
		Map<String, Integer> cultureMap = MenuCategoryDAO.getInstance().getCultureCategoryReverseMap();
		Map<String, Integer> typeMap = MenuCategoryDAO.getInstance().getFoodTypeReverseMap();
		
	
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
