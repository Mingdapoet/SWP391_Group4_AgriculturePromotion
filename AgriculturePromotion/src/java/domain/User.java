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
    private String fullname; // Added
    private String gender;   // Added

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
}