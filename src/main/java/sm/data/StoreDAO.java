package sm.data;

import java.sql.*;

public class StoreDAO {
 // 코드 연결 하는 기능 
    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.219.198:1521:orcl",
            "Web1",
            "1234"
        );
    }
    
    // 게시글 등록 하는 기능 
	public int insertStore(StoreDTO dto) {
		String sql = "INSERT INTO store (store_name, phone, address) VALUES (?, ?, ?)";
		int storeId = -1;

		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, new String[] { "store_id" }))

		{
			System.out.println("insertStore() 시작");

			ps.setString(1, dto.getStoreName());
			ps.setString(2, dto.getPhone());
			ps.setString(3, dto.getAddress());

			int result = ps.executeUpdate();
			System.out.println("executeUpdate 결과 = " + result);

			ResultSet rs = ps.getGeneratedKeys();
			if (rs.next()) {
				storeId = rs.getInt(1);
				System.out.println("생성된 storeId = " + storeId);
			} else {
				System.out.println("storeId 생성 안 됨");
			}

		} catch (Exception e) {
			System.out.println("insertStore() 예외 발생");
			e.printStackTrace();
		}

		System.out.println("insertStore() 리턴 값 = " + storeId);
		return storeId;
	}
}