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
			String sql = "insert into menu (Id, storeId, groupNum, orderIdx, name, menu_desc, price, image) values(menu_seq.nextval, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getStoreId());
			pstmt.setInt(2, dto.getGroupNum());
			pstmt.setInt(3, dto.getOrderIdx());
			pstmt.setString(4, dto.getName());
			pstmt.setString(5, dto.getMenu_desc());
			pstmt.setInt(6, dto.getPrice());
			pstmt.setString(7, dto.getImage());

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
			
			while(rs.next()) {
				MenuGroupDTO dto = new MenuGroupDTO();				
				dto.setStoreId(rs.getInt("storeId"));
				dto.setNum(rs.getInt("num"));
				dto.setOrderIdx(rs.getInt("orderIdx"));
				dto.setName(rs.getString("name"));
				
				result.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
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
			
			while(rs.next()) {
				MenuDTO dto = new MenuDTO();				
				
				dto.setId(rs.getInt("Id"));
				dto.setStoreId(rs.getInt("storeId"));
				dto.setGroupNum(rs.getInt("groupNum"));
			    dto.setOrderIdx(rs.getInt("OrderIdx"));
			    dto.setName(rs.getString("name"));
			    dto.setMenu_desc(rs.getString("menu_desc"));
			    dto.setPrice(rs.getInt("price"));
			    dto.setImage(rs.getString("image"));
				
				result.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
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
			
			String sql = "update menu set groupNum = ?, orderIdx = ?, name = ? , menu_desc = ? , price = ? , image = ? WHERE storeId = ? and Id = ?";
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
