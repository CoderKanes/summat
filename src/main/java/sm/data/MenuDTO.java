package sm.data;

import java.util.List;

public class MenuDTO {
    private int Id;
    private int storeId;
    private int groupNum;
    private int orderIdx;
    private String name;
    private String menu_desc;
    private int price;
    private String image;
    private String cCategory_str;
    private String fCategory_str;
    private String foodItem_str;
    //without DB field
    private String storeName; 
    private int storeStatus;
    private Double storeDistance;

	

	public int getId() {
		return Id;
	}
	public void setId(int id) {
		Id = id;
	}
	public int getStoreId() {
		return storeId;
	}
	public void setStoreId(int storeId) {
		this.storeId = storeId;
	}
	public int getGroupNum() {
		return groupNum;
	}
	public void setGroupNum(int groupNum) {
		this.groupNum = groupNum;
	}
	public int getOrderIdx() {
		return orderIdx;
	}
	public void setOrderIdx(int orderIdx) {
		this.orderIdx = orderIdx;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMenu_desc() {
		return menu_desc;
	}
	public void setMenu_desc(String desc) {
		this.menu_desc = desc;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getCCategory_str() {
		return cCategory_str;
	}
	public void setCCategory_str(String cCategory_str) {
		this.cCategory_str = cCategory_str;
	}
	public String getFCategory_str() {
		return fCategory_str;
	}
	public void setFCategory_str(String fCategory_str) {
		this.fCategory_str = fCategory_str;
	}
	public String getFoodItem_str() {
		return foodItem_str;
	}
	public void setFoodItem_str(String foodItem_str) {
		this.foodItem_str = foodItem_str;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public int getStoreStatus() {
		return storeStatus;
	}
	public void setStoreStatus(int storeStatus) {
		this.storeStatus = storeStatus;
	}
	public Double getStoreDistance() {
		return storeDistance;
	}
	public void setStoreDistance(Double storeDistance) {
		this.storeDistance = storeDistance;
	}
}
