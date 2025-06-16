package domain;

public class Appeal {

    private int id;
    private String fullname;
    private String email;
    private String reason;
    private String status;

    public Appeal() {
    }

    public Appeal(String fullname, String email, String reason) {
        this.fullname = fullname;
        this.email = email;
        this.reason = reason;
    }

    public Appeal(int id, String fullname, String email, String reason, String status) {
        this.id = id;
        this.fullname = fullname;
        this.email = email;
        this.reason = reason;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
  
} 