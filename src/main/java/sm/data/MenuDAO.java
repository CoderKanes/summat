package sm.data;
import java.sql.*;

public class MenuDAO {

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(
            "jdbc:oracle:thin:@192.168.219.198:1521:xe",
            "Web1",
            "1234"
        );
    }

    public void insertMenu(MenuDTO dto) {
        String sql =
            "INSERT INTO menu (store_id, menu_name, menu_info, menu_image) VALUES (?, ?, ?, ?)";

        try (
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, dto.getStoreId());
            ps.setString(2, dto.getMenuName());  
            ps.setString(3, dto.getMenuInfo());
            ps.setString(4, dto.getMenuImage());  
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
