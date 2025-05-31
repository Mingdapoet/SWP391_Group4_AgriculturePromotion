/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package domain;

import java.util.Date;

/**
 *
 * @author trvie
 */
public class BusinessRegistration {

    private int id;
    private int userId;
    private String companyName;
    private String taxCode;
    private String companyEmail;
    private String companyPhone;
    private String headOffice;
    private String businessType;
    private String customType;
    private String repFullName;
    private String repPosition;
    private String repPhone;
    private String repEmail;
    private String legalDocument;
    private String fileName;
    private String filePath;
    private String status;
    private Date submittedAt;
    private String rejectReason;

    public BusinessRegistration(int id, int userId, String companyName, String taxCode, String companyEmail, String companyPhone, String headOffice, String businessType, String customType, String repFullName, String repPosition, String repPhone, String repEmail, String legalDocument, String fileName, String filePath, String status, Date submittedAt, String rejectReason) {
        this.id = id;
        this.userId = userId;
        this.companyName = companyName;
        this.taxCode = taxCode;
        this.companyEmail = companyEmail;
        this.companyPhone = companyPhone;
        this.headOffice = headOffice;
        this.businessType = businessType;
        this.customType = customType;
        this.repFullName = repFullName;
        this.repPosition = repPosition;
        this.repPhone = repPhone;
        this.repEmail = repEmail;
        this.legalDocument = legalDocument;
        this.fileName = fileName;
        this.filePath = filePath;
        this.status = status;
        this.submittedAt = submittedAt;
        this.rejectReason = rejectReason;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public BusinessRegistration() {
    }

    public BusinessRegistration(int id, int userId, String companyName, String taxCode, String companyEmail, String companyPhone, String headOffice, String businessType, String customType, String repFullName, String repPosition, String repPhone, String repEmail, String legalDocument, String fileName, String filePath, String status, Date submittedAt) {
        this.id = id;
        this.userId = userId;
        this.companyName = companyName;
        this.taxCode = taxCode;
        this.companyEmail = companyEmail;
        this.companyPhone = companyPhone;
        this.headOffice = headOffice;
        this.businessType = businessType;
        this.customType = customType;
        this.repFullName = repFullName;
        this.repPosition = repPosition;
        this.repPhone = repPhone;
        this.repEmail = repEmail;
        this.legalDocument = legalDocument;
        this.fileName = fileName;
        this.filePath = filePath;
        this.status = status;
        this.submittedAt = submittedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public String getCompanyEmail() {
        return companyEmail;
    }

    public void setCompanyEmail(String companyEmail) {
        this.companyEmail = companyEmail;
    }

    public String getCompanyPhone() {
        return companyPhone;
    }

    public void setCompanyPhone(String companyPhone) {
        this.companyPhone = companyPhone;
    }

    public String getHeadOffice() {
        return headOffice;
    }

    public void setHeadOffice(String headOffice) {
        this.headOffice = headOffice;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getCustomType() {
        return customType;
    }

    public void setCustomType(String customType) {
        this.customType = customType;
    }

    public String getRepFullName() {
        return repFullName;
    }

    public void setRepFullName(String repFullName) {
        this.repFullName = repFullName;
    }

    public String getRepPosition() {
        return repPosition;
    }

    public void setRepPosition(String repPosition) {
        this.repPosition = repPosition;
    }

    public String getRepPhone() {
        return repPhone;
    }

    public void setRepPhone(String repPhone) {
        this.repPhone = repPhone;
    }

    public String getRepEmail() {
        return repEmail;
    }

    public void setRepEmail(String repEmail) {
        this.repEmail = repEmail;
    }

    public String getLegalDocument() {
        return legalDocument;
    }

    public void setLegalDocument(String legalDocument) {
        this.legalDocument = legalDocument;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Date submittedAt) {
        this.submittedAt = submittedAt;
    }

}
