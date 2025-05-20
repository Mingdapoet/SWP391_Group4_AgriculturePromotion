package domain;

import java.sql.Date;
import java.sql.Timestamp;

public class User {
    private int id;
    private String email;
    private String role;
    private String phone;
    private String address;
    private Date birthday;
    private Timestamp createdAt;

    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.birthday = birthday;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public String getEmail() { return email; }
    public String getRole() { return role; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public Date getBirthday() { return birthday; }
    public Timestamp getCreatedAt() { return createdAt; }
}