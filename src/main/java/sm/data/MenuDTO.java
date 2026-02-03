package sm.data;
public class MenuDTO {
    private int menuId;
    private int storeId;
    private String menuName;
    private String menuInfo;
    private String menuImage;
    private String regDate;

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }

    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }

    public String getMenuInfo() { return menuInfo; }
    public void setMenuInfo(String menuInfo) { this.menuInfo = menuInfo; }

    public String getMenuImage() { return menuImage; }
    public void setMenuImage(String menuImage) { this.menuImage = menuImage; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }
}
