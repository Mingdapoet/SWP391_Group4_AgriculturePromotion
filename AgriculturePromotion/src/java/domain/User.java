package domain;

import java.sql.Date;
import java.sql.Timestamp;

public class User {

    private int id;
    private String avatar;
    private String email;
    private String role;
    private String phone;
    private String address;
    private Date birthday;
    private Timestamp createdAt;
    private String fullName; // Added
    private String gender;   // Added
    private String password;
    private String picture;
    private boolean locked;          //Added
    private Timestamp lastLogin;

    public User() {
    }

    public boolean isLocked() {
        return locked;
    }

    public void setLocked(boolean locked) {
        this.locked = locked;
    }

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }

    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt, String fullName, String gender, boolean locked, Timestamp lastLogin) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.birthday = birthday;
        this.createdAt = createdAt;
        this.fullName = fullName;
        this.gender = gender;
        this.locked = locked;
        this.lastLogin = lastLogin;
    }

    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt, String fullName, String gender, String password) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.birthday = birthday;
        this.createdAt = createdAt;
        this.fullName = fullName;
        this.gender = gender;
        this.password = password;
    }

    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt, String fullName, String gender) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.birthday = birthday;
        this.createdAt = createdAt;
        this.fullName = fullName;
        this.gender = gender;
    }

    public User(int id, String email, String role, String phone, String address, Date birthday, Timestamp createdAt, String fullName, String gender, String password, String picture) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.phone = phone;
        this.address = address;
        this.birthday = birthday;
        this.createdAt = createdAt;
        this.fullName = fullName;
        this.gender = gender;
        this.password = password;
        this.picture = picture;
    }

    // Getters and setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

}
