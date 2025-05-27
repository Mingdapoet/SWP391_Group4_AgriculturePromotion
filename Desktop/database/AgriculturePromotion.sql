create database AgriculturePromotion
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10) NULL CHECK (gender IN (N'Nam', N'Nữ', N'Khác')),
    birthday DATE NULL,
    phone VARCHAR(10) NULL CHECK (
        LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'
    ),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NULL,
    address NVARCHAR(MAX) NULL,
    role VARCHAR(20) CHECK (role IN ('admin', 'business', 'user', 'guest')) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    is_featured BIT DEFAULT 0,
    meta_description VARCHAR(255),
    meta_keywords VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE News (
    news_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    category VARCHAR(20) CHECK (category IN ('AGRICULTURE', 'EVENT', 'PROMOTION')) DEFAULT 'AGRICULTURE',
    meta_description VARCHAR(255),
    meta_keywords VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE CompanyInfo (
    info_id INT IDENTITY(1,1) PRIMARY KEY,
    section VARCHAR(20) CHECK (section IN ('ABOUT', 'CONTACT', 'WHY_CHOOSE_US')) NOT NULL,
    title VARCHAR(255),
    content TEXT,
    image_url VARCHAR(255),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE Reviews (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    productID INT,
    userName NVARCHAR(100) NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(255),
    reviewDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (productID) REFERENCES Products(product_id)
);

CREATE TABLE Provinces (
    provinceID INT IDENTITY(1,1) PRIMARY KEY,
    provinceName NVARCHAR(100) NOT NULL
);

CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(20) CHECK (type IN ('GENERAL', 'NEWS', 'UPDATE', 'EVENT')) DEFAULT 'GENERAL',
    status VARCHAR(20) CHECK (status IN ('ACTIVE', 'INACTIVE')) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE User_Notifications (
    user_notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    notification_id INT NOT NULL,
    is_read BIT DEFAULT 0,
    read_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (notification_id) REFERENCES Notifications(notification_id)
);