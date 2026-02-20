package sm.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/*
 * 작성자 : 김용진
 * 내용 : 가게를 등록 하기 위한 DAO
 */

public class StoreDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	// 
	public int InsertStore(StoreDTO dto) {
		int resultStoreId = -1;
	
		try {
			conn = OracleConnection.getConnection();
			String sql = "insert into store (Id, name, phone, address, geoCode, status, created_at) values(store_seq.nextval, ?, ?, ?,?, 0, sysdate)";
			 pstmt = conn.prepareStatement(sql, new String[] { "ID" }); 
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPhone());
			pstmt.setString(3, dto.getAddress());
			pstmt.setString(4, dto.getGeoCode());

			boolean insertresult = pstmt.executeUpdate() > 0;
			
			if(insertresult)
			{
				rs = pstmt.getGeneratedKeys();
				if (rs.next()) {
					resultStoreId = rs.getInt(1);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return resultStoreId;
	}	
	public StoreDTO GetStoreInfo(int id) {
		StoreDTO result = null;		
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from store where id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {	
				result = new StoreDTO();		
				result.setId(rs.getInt("id"));
				result.setName(rs.getString("name"));
				result.setPhone(rs.getString("phone"));
				result.setAddress(rs.getString("address"));
				result.setStatus(rs.getInt("status"));
				result.setCreated_at(rs.getTimestamp("created_at"));
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return result;
	}
	
	public List<StoreDTO> GetAllStores() {
		List<StoreDTO> result = new ArrayList<StoreDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from store";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				StoreDTO dto = new StoreDTO();				
				dto.setId(rs.getInt("id"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setStatus(rs.getInt("status"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
				result.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return result;
	}
	
	public List<StoreDTO> GetStoresByName(String searchName) {
		List<StoreDTO> result = new ArrayList<StoreDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from store where name like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%" + searchName + "%");
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				StoreDTO dto = new StoreDTO();				
				dto.setId(rs.getInt("id"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setStatus(rs.getInt("status"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
				result.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return result;
	}
	
	public List<StoreDTO> GetUnregistedStores() {
		List<StoreDTO> result = new ArrayList<StoreDTO>();
		try {
			conn = OracleConnection.getConnection();
			String sql = "select * from store where status = 0";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				StoreDTO dto = new StoreDTO();				
				dto.setId(rs.getInt("id"));
				dto.setName(rs.getString("name"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setStatus(rs.getInt("status"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
				result.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		
		return result;
	}
	
	public boolean updateStoreInfo(StoreDTO dto) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			
			String sql = "update store set name = ?, phone = ?, address = ? WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPhone());
			pstmt.setString(3, dto.getAddress());
			pstmt.setInt(4, dto.getId());
			
			result = pstmt.executeUpdate() > 0;

		} catch (Exception e) {
			result = false;
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}
	
	public boolean updateStoreStatus(int id, int status) {
		boolean result = true;

		try {
			conn = OracleConnection.getConnection();
			
			String sql = "update store set status = ? WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, status);
			pstmt.setInt(2, id);
			
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
	public List<String> deleteStore(int storeId) {
		List<String> result = new ArrayList<String>();
		try {
			conn = OracleConnection.getConnection();			

			String sql = "delete from store  WHERE id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, storeId);

			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			OracleConnection.closeAll(conn, pstmt, rs);
		}
		return result;
	}	

}
