package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/*
 * 작성자 : 김용진
 * 내용 : 가게 메뉴를 저장/수정하기 위한 DAO
 */

public class MenuDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	//
	public boolean InsertMenuGroup(MenuGroupDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into menuGroup (storeId, num, orderIdx, name) values(?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getStoreId());
			pstmt.setInt(2, dto.getNum());
			pstmt.setInt(3, dto.getOrderIdx());
			pstmt.setString(4, dto.getName());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	public boolean InsertMenu(MenuDTO dto) {
		boolean result = true;
		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into menu (Id, storeId, groupNum, orderIdx, name, menu_desc, price, image, CCATEGORY_STR,FCATEGORY_STR, FOODITEM_STR ) values(menu_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getStoreId());
			pstmt.setInt(2, dto.getGroupNum());
			pstmt.setInt(3, dto.getOrderIdx());
			pstmt.setString(4, dto.getName());
			pstmt.setString(5, dto.getMenu_desc());
			pstmt.setInt(6, dto.getPrice());
			pstmt.setString(7, dto.getImage());
			pstmt.setString(8, dto.getCCategory_str());
			pstmt.setString(9, dto.getFCategory_str());
			pstmt.setString(10, dto.getFoodItem_str());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	public List<MenuGroupDTO> getMenuGroups(int storeId) {
		List<MenuGroupDTO> result = new ArrayList<MenuGroupDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from menuGroup where storeId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, storeId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				MenuGroupDTO dto = new MenuGroupDTO();
				dto.setStoreId(rs.getInt("storeId"));
				dto.setNum(rs.getInt("num"));
				dto.setOrderIdx(rs.getInt("orderIdx"));
				dto.setName(rs.getString("name"));

				result.add(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}

		return result;
	}

	public List<MenuDTO> getFoodInfos() {
		List<MenuDTO> result = new ArrayList<MenuDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from menu";
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				MenuDTO dto = new MenuDTO();

				dto.setId(rs.getInt("Id"));
				dto.setStoreId(rs.getInt("storeId"));
				dto.setGroupNum(rs.getInt("groupNum"));
				dto.setOrderIdx(rs.getInt("OrderIdx"));
				dto.setName(rs.getString("name"));
				dto.setMenu_desc(rs.getString("menu_desc"));
				dto.setPrice(rs.getInt("price"));
				dto.setImage(rs.getString("image"));
				dto.setCCategory_str(rs.getString("CCATEGORY_STR"));
				dto.setFCategory_str(rs.getString("FCATEGORY_STR"));
				dto.setFoodItem_str(rs.getString("FOODITEM_STR"));
				result.add(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}

		return result;
	}

	public MenuDTO getFoodInfo(int menuid) {
		MenuDTO result = null;
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from menu where id=? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, menuid);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				result = new MenuDTO();

				result.setId(rs.getInt("Id"));
				result.setStoreId(rs.getInt("storeId"));
				result.setGroupNum(rs.getInt("groupNum"));
				result.setOrderIdx(rs.getInt("OrderIdx"));
				result.setName(rs.getString("name"));
				result.setMenu_desc(rs.getString("menu_desc"));
				result.setPrice(rs.getInt("price"));
				result.setImage(rs.getString("image"));
				result.setCCategory_str(rs.getString("CCATEGORY_STR"));
				result.setFCategory_str(rs.getString("FCATEGORY_STR"));
				result.setFoodItem_str(rs.getString("FOODITEM_STR"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}

		return result;
	}

	public List<MenuDTO> getFoodInfosWithStore() {
		List<MenuDTO> result = new ArrayList<MenuDTO>();
		// JOIN을 통해 가게 이름(store_name)까지 한 번에 가져옵니다.
		String sql = "SELECT m.*, s.name AS store_name, s.status AS store_status " + "FROM menu m "
				+ "JOIN store s ON m.storeId = s.id";
		// 승인된 가게만 가져올 경우 추가 +" WHERE s.status = 1";

		try {
			conn = OracleConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				MenuDTO dto = new MenuDTO();
				dto.setId(rs.getInt("id"));
				dto.setStoreId(rs.getInt("storeId"));
				dto.setName(rs.getString("name"));
				dto.setPrice(rs.getInt("price"));
				dto.setImage(rs.getString("image"));
				dto.setCCategory_str(rs.getString("CCATEGORY_STR"));
				dto.setFCategory_str(rs.getString("FCATEGORY_STR"));
				dto.setFoodItem_str(rs.getString("FOODITEM_STR"));
				// JOIN으로 가져온 가게 정보
				dto.setStoreName(rs.getString("store_name"));
				dto.setStoreStatus(rs.getInt("store_status"));

				result.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	public List<MenuDTO> getFoodInfosFiltered(String search, String ccategory, String fcategory, String fooditem,
			Integer minPrice, Integer maxPrice, Float myLat, Float myLon) {
		System.out.println("" + search +"-"+
				ccategory +"-"+fcategory +"-"+fooditem +"-"+
				minPrice +"-"+maxPrice +"-"+myLat +"-"+myLon
				);
		// --- 설정 변수 ---
		double distanceLimit = 5.0; // 5km 이내
		int rowLimit = 50; // 최대 50건
		// ----------------

		List<MenuDTO> result = new ArrayList<>();
		StringBuilder sql = new StringBuilder();
		String pi = "3.14159265358979323846";

		// 1. 최외곽: ROWNUM을 적용하여 개수 제한
		sql.append("SELECT * FROM ( ");
		// 2. 중간: 거리 정렬 및 필터 적용
		sql.append("  SELECT * FROM ( ");
		sql.append("    SELECT m.*, s.name AS store_name, s.status AS store_status ");

		if (myLat != null && myLon != null) {
			sql.append(", (6371 * acos(least(1, greatest(-1, ");
			sql.append("    cos(? * " + pi	+ " / 180) * cos(TO_NUMBER(SUBSTR(s.geoCode, 1, INSTR(s.geoCode, ',') - 1)) * " + pi + " / 180) ");
			sql.append("    * cos((TO_NUMBER(SUBSTR(s.geoCode, INSTR(s.geoCode, ',') + 1)) * " + pi + " / 180) - (? * "	+ pi + " / 180)) ");
			sql.append("    + sin(? * " + pi + " / 180) * sin(TO_NUMBER(SUBSTR(s.geoCode, 1, INSTR(s.geoCode, ',') - 1)) * " + pi + " / 180) ");
			sql.append("  )))) AS distance ");
		} else {
			sql.append(", 0 AS distance ");
		}

		sql.append("    FROM menu m JOIN store s ON m.storeId = s.id WHERE 1=1 ");

		if (myLat != null && myLon != null) {
			sql.append("    AND s.geoCode IS NOT NULL AND s.geoCode LIKE '%,%' ");
		}

		// 검색/카테고리 필터
		if (search != null && !search.trim().isEmpty()) {
			sql.append(
					"    AND (m.name LIKE ? OR s.name LIKE ? OR m.CCATEGORY_STR LIKE ? OR m.FCATEGORY_STR LIKE ? OR m.FOODITEM_STR LIKE ?) ");
		} else {
			if (ccategory != null && !ccategory.trim().isEmpty())
				sql.append("    AND m.CCATEGORY_STR = ? ");
			if (fcategory != null && !fcategory.trim().isEmpty())
				sql.append("    AND m.FCATEGORY_STR LIKE ? ");
			if (fooditem != null && !fooditem.trim().isEmpty())
				sql.append("    AND m.FOODITEM_STR = ? ");
		}

		if (minPrice != null && maxPrice != null && minPrice <= maxPrice) {
			sql.append("    AND m.price >= ? AND m.price <= ? ");
		}

		sql.append("  ) t WHERE 1=1 ");

		// 거리 제한 필터 및 정렬
		if (myLat != null && myLon != null) {
			sql.append("  AND distance <= ? ORDER BY distance ASC ");
		} else {
			sql.append("  ORDER BY id DESC ");
		}

		// 최외곽 닫기 및 ROWNUM 조건
		sql.append(") WHERE ROWNUM <= ? ");

		try (Connection conn = OracleConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			int idx = 1;

			// 1. 위도/경도 파라미터 (Select절)
			if (myLat != null && myLon != null) {
				pstmt.setFloat(idx++, myLat);
				pstmt.setFloat(idx++, myLon);
				pstmt.setFloat(idx++, myLat);
			}

			// 2. 검색어/카테고리 바인딩
			if (search != null && !search.trim().isEmpty()) {
				String pattern = "%" + search + "%";
				for (int i = 0; i < 5; i++)
					pstmt.setString(idx++, pattern);
			} else {
				if (ccategory != null && !ccategory.trim().isEmpty())
					pstmt.setString(idx++, ccategory);
				if (fcategory != null && !fcategory.trim().isEmpty())
					pstmt.setString(idx++, "%" + fcategory + "%");
				if (fooditem != null && !fooditem.trim().isEmpty())
					pstmt.setString(idx++, fooditem);
			}

			// 3. 가격 바인딩
			if (minPrice != null && maxPrice != null && minPrice <= maxPrice) {
				pstmt.setInt(idx++, minPrice);
				pstmt.setInt(idx++, maxPrice);
			}

			// 4. 거리 제한 바인딩
			if (myLat != null && myLon != null) {
				pstmt.setDouble(idx++, distanceLimit);
			}

			// 5. ROWNUM 개수 제한 바인딩
			pstmt.setInt(idx++, rowLimit);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					MenuDTO dto = new MenuDTO();
					dto.setId(rs.getInt("id"));
					dto.setStoreId(rs.getInt("storeId"));
					dto.setName(rs.getString("name"));
					dto.setPrice(rs.getInt("price"));
					dto.setCCategory_str(rs.getString("CCATEGORY_STR"));
					dto.setFCategory_str(rs.getString("FCATEGORY_STR"));
					dto.setFoodItem_str(rs.getString("FOODITEM_STR"));
					dto.setStoreName(rs.getString("store_name"));
					dto.setStoreStatus(rs.getInt("store_status"));

					if (myLat != null && myLon != null) {
						dto.setStoreDistance(rs.getDouble("distance"));
					}
					result.add(dto);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public List<MenuDTO> getMenus(int storeId) {
		List<MenuDTO> result = new ArrayList<MenuDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from menu where storeId = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, storeId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				MenuDTO dto = new MenuDTO();

				dto.setId(rs.getInt("Id"));
				dto.setStoreId(rs.getInt("storeId"));
				dto.setGroupNum(rs.getInt("groupNum"));
				dto.setOrderIdx(rs.getInt("OrderIdx"));
				dto.setName(rs.getString("name"));
				dto.setMenu_desc(rs.getString("menu_desc"));
				dto.setPrice(rs.getInt("price"));
				dto.setImage(rs.getString("image"));
				dto.setCCategory_str(rs.getString("CCATEGORY_STR"));
				dto.setFCategory_str(rs.getString("FCATEGORY_STR"));
				dto.setFoodItem_str(rs.getString("FOODITEM_STR"));
				result.add(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}

		return result;
	}

	public boolean updateMenuGroup(MenuGroupDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();

			String sql = "update menuGroup set orderIdx = ?, name = ? WHERE storeId = ? and num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getOrderIdx());
			pstmt.setString(2, dto.getName());
			pstmt.setInt(3, dto.getStoreId());
			pstmt.setInt(4, dto.getNum());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	public boolean updateMenu(MenuDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();

			String sql = "update menu set groupNum = ?, orderIdx = ?, name = ? , menu_desc = ? , price = ? , image = ? ,"
					+ "WHERE storeId = ? and Id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getGroupNum());
			pstmt.setInt(2, dto.getOrderIdx());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getMenu_desc());
			pstmt.setInt(5, dto.getPrice());
			pstmt.setString(6, dto.getImage());
			pstmt.setInt(7, dto.getStoreId());
			pstmt.setInt(8, dto.getId());

			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	//
	public List<String> deleteMenuGroup(int storeId, int groupNum) {
		List<String> result = new ArrayList<String>();
		try {
			conn = OracleConnection.getConnection();

			String sql = "delete from menuGroup  WHERE storeId = ? and num = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, storeId);
			pstmt.setInt(2, groupNum);

			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

	public List<String> deleteMenu(int storeId, int menuId) {
		List<String> result = new ArrayList<String>();
		try {
			conn = OracleConnection.getConnection();

			String sql = "delete from menu  WHERE storeId = ? and id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, storeId);
			pstmt.setInt(2, menuId);

			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}

}
