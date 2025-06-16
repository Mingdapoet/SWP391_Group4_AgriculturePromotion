package domain;

import java.util.Date;

public class Product {

    private int id;
    private String name;
    private String description;
    private int stockQuantity;
    private String imageUrl;
    private int eventId;
    private Date createdAt;
    private Date updatedAt;
    private String origin;
    private String variety;
    private String farmingMethod;
    private String harvestTime;
    private String storage;
    private String healthBenefits;
    private String usageTips;

    public Product() {
    }

    public Product(int id, String name, String description, int stockQuantity, String imageUrl, int eventId, Date createdAt, Date updatedAt, String origin, String variety, String farmingMethod, String harvestTime, String storage, String healthBenefits, String usageTips) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
        this.eventId = eventId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.origin = origin;
        this.variety = variety;
        this.farmingMethod = farmingMethod;
        this.harvestTime = harvestTime;
        this.storage = storage;
        this.healthBenefits = healthBenefits;
        this.usageTips = usageTips;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getVariety() {
        return variety;
    }

    public void setVariety(String variety) {
        this.variety = variety;
    }

    public String getFarmingMethod() {
        return farmingMethod;
    }

    public void setFarmingMethod(String farmingMethod) {
        this.farmingMethod = farmingMethod;
    }

    public String getHarvestTime() {
        return harvestTime;
    }

    public void setHarvestTime(String harvestTime) {
        this.harvestTime = harvestTime;
    }

    public String getStorage() {
        return storage;
    }

    public void setStorage(String storage) {
        this.storage = storage;
    }

    public String getHealthBenefits() {
        return healthBenefits;
    }

    public void setHealthBenefits(String healthBenefits) {
        this.healthBenefits = healthBenefits;
    }

    public String getUsageTips() {
        return usageTips;
    }

    public void setUsageTips(String usageTips) {
        this.usageTips = usageTips;
    }
  
    
}
