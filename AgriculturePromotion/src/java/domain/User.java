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
    private String fullname;
    private String gender;
    private String password; // Nếu bạn cần insert bằng insertUser()

    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt, String fullname, String gender) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.birthday = birthday;
        this.createdAt = createdAt;
        this.fullname = fullname;
        this.gender = gender;
    }

    // Nếu bạn cần constructor có password
    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt, String fullname, String gender, String password) {
        this(id, email, role, phone, address, birthday, createdAt, fullname, gender);
        this.password = password;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", birthday=" + birthday +
                ", createdAt=" + createdAt +
                ", fullname='" + fullname + '\'' +
                ", gender='" + gender + '\'' +
                ", password='" + (password != null ? "***" : null) + '\'' +
                '}';
    }
}
