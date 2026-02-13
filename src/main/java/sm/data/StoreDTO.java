package sm.data;

import java.sql.Timestamp;

public class StoreDTO {
    private int Id;
    private String name;
    private String phone;
    private String address;
    private String geoCode;

	private int status;
	private Timestamp created_at;

   
	public int getId() { return Id; }
    public void setId(int Id) { this.Id = Id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getGeoCode() {return geoCode;	}
	public void setGeoCode(String geoCode) {this.geoCode = geoCode;	}
	
    public int getStatus() { return status; }    
	public void setStatus(int status) {	this.status = status; }
	
	public Timestamp getCreated_at() {	return created_at;	}
	public void setCreated_at(Timestamp created_at) {this.created_at = created_at;	}
    

}
