CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(100) NOT NULL,
    gender NVARCHAR(10) CHECK (gender IN (N'Nam', N'Nữ', N'Khác')),
    birthday DATE,
    phone VARCHAR(10) CHECK (
        LEN(phone) = 10 AND phone NOT LIKE '%[^0-9]%'
    ),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address NVARCHAR(MAX),
    role VARCHAR(20) CHECK (role IN ('admin', 'farmer', 'customer')) NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);

ALTER TABLE users
MODIFY COLUMN password VARCHAR(255) NULL,
MODIFY COLUMN phone VARCHAR(20) NULL,
MODIFY COLUMN address VARCHAR(255) NULL,
MODIFY COLUMN birthday DATE NULL,
MODIFY COLUMN gender VARCHAR(10) NULL;

INSERT INTO users (fullname, gender, birthday, phone, email, password, address, role)
VALUES
(N'Nguyễn Văn Admin', N'Nam', '1990-01-01', '0123456789', 'admin@example.com', 'admin123', N'123 Đường Nguyễn Trãi, Hà Nội', 'admin'),

(N'Trần Văn Nông Dân', N'Nam', '1985-05-15', '0987654321', 'farmer@example.com', 'farmer123', N'Ấp Bình Long, Xã Hòa Phú, Huyện Củ Chi', 'farmer'),

(N'Lê Thị Khách Hàng', N'Nữ', '1995-12-25', '0112233445', 'customer@example.com', 'customer123', N'Số 5, Nguyễn Huệ, Quận 1, TP.HCM', 'customer');
