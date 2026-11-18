-- GaraMan (De 27) - CSDL cho Module 1: Dat lich hen truc tuyen + Module 2: Nhan xe vao sua
-- Theo Hinh 4.2 + tu dien CSDL modul Dat lich hen (pha_thiet_ke_full); Module 2 theo db.svg, tru:
--  * khoa ngoai phieu nhan xe <-> phieu yeu cau dat o tblCarReceipt8.tblRequestForm8id (khop CarReceipt8.requestForm);
--  * bo cac cot status/serviceStatus khong co trong design-class-diagram-2.

CREATE DATABASE IF NOT EXISTS garaman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
SET NAMES utf8mb4;
USE garaman;

DROP TABLE IF EXISTS tblCarReceipt8;
DROP TABLE IF EXISTS tblAssignmentDetail8;
DROP TABLE IF EXISTS tblPartDetail8;
DROP TABLE IF EXISTS tblServiceDetail8;
DROP TABLE IF EXISTS tblRequestForm8;
DROP TABLE IF EXISTS tblPartDiscountDetail8;
DROP TABLE IF EXISTS tblServiceDiscountDetail8;
DROP TABLE IF EXISTS tblDiscountCondition8;
DROP TABLE IF EXISTS tblDiscount8;
DROP TABLE IF EXISTS tblImportedPart8;
DROP TABLE IF EXISTS tblImportInvoice8;
DROP TABLE IF EXISTS tblSupplier8;
DROP TABLE IF EXISTS tblPartVariant8;
DROP TABLE IF EXISTS tblSparePart8;
DROP TABLE IF EXISTS tblService8;
DROP TABLE IF EXISTS tblCustomerCar8;
DROP TABLE IF EXISTS tblCar8;
DROP TABLE IF EXISTS tblTechnician8;
DROP TABLE IF EXISTS tblEmployee8;
DROP TABLE IF EXISTS tblAppointment8;
DROP TABLE IF EXISTS tblBookingContact8;
DROP TABLE IF EXISTS tblWorkSchedule8;
DROP TABLE IF EXISTS tblCustomer8;
DROP TABLE IF EXISTS tblMember8;

CREATE TABLE tblMember8 (
    id          INT(10)      NOT NULL AUTO_INCREMENT,
    username    VARCHAR(255) NOT NULL,
    password    VARCHAR(255) NOT NULL,
    fullName    VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(10)  NULL,
    address     VARCHAR(255) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Ke thua tblMember8: dung chung khoa
CREATE TABLE tblCustomer8 (
    id INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES tblMember8(id)
) ENGINE=InnoDB;

-- Ngay co ban ghi = ngay hoat dong; khong co ban ghi = ngay nghi (QD-10). Khong co cot status.
CREATE TABLE tblWorkSchedule8 (
    id        INT(10) NOT NULL,
    workDate  DATE    NOT NULL,
    openTime  TIME    NOT NULL,
    closeTime TIME    NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblBookingContact8 (
    id          INT(10)     NOT NULL AUTO_INCREMENT,
    fullName    VARCHAR(50) NOT NULL,
    phoneNumber VARCHAR(10) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- status: 'Chờ xác nhận' | 'Đã tiếp nhận' (QD-02, bang trang thai sau Hinh 4.2)
CREATE TABLE tblAppointment8 (
    id                   INT(10)      NOT NULL AUTO_INCREMENT,
    appointmentTime      TIMESTAMP    NOT NULL,
    status               VARCHAR(255) NOT NULL,
    tblCustomer8id       INT(10)      NULL,
    tblWorkSchedule8id   INT(10)      NOT NULL,
    tblBookingContact8id INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblCustomer8id)       REFERENCES tblCustomer8(id),
    FOREIGN KEY (tblWorkSchedule8id)   REFERENCES tblWorkSchedule8(id),
    FOREIGN KEY (tblBookingContact8id) REFERENCES tblBookingContact8(id)
) ENGINE=InnoDB;

-- ===== Module 2: Nhan xe vao sua =====
-- Ke thua tblMember8: dung chung khoa. position: 'Quản lý' | 'Bán hàng' | 'Kho' | 'Kỹ thuật'
CREATE TABLE tblEmployee8 (
    id         INT(10)      NOT NULL,
    position   VARCHAR(255) NOT NULL,
    workStatus VARCHAR(255) NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES tblMember8(id)
) ENGINE=InnoDB;

-- Ke thua tblEmployee8
CREATE TABLE tblTechnician8 (
    id        INT(10)      NOT NULL,
    specialty VARCHAR(255) NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES tblEmployee8(id)
) ENGINE=InnoDB;

CREATE TABLE tblCar8 (
    id                INT(10)      NOT NULL AUTO_INCREMENT,
    licensePlate      VARCHAR(255) NOT NULL UNIQUE,
    brand             VARCHAR(255) NOT NULL,
    manufacturingYear INT(10)      NULL,
    color             VARCHAR(255) NULL,
    vehicleType       VARCHAR(255) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblCustomerCar8 (
    id               INT(10) NOT NULL AUTO_INCREMENT,
    registrationDate DATE    NOT NULL,
    tblCar8id        INT(10) NOT NULL,
    tblCustomer8id   INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblCar8id)      REFERENCES tblCar8(id),
    FOREIGN KEY (tblCustomer8id) REFERENCES tblCustomer8(id)
) ENGINE=InnoDB;

CREATE TABLE tblService8 (
    id          INT(10)      NOT NULL AUTO_INCREMENT,
    serviceName VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL,
    listedPrice FLOAT        NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblSparePart8 (
    id          INT(10)      NOT NULL AUTO_INCREMENT,
    partName    VARCHAR(255) NOT NULL,
    description VARCHAR(255) NULL,
    unit        VARCHAR(255) NOT NULL,
    discount    FLOAT        NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblPartVariant8 (
    id              INT(10)      NOT NULL AUTO_INCREMENT,
    brand           VARCHAR(255) NOT NULL,
    markupRate      FLOAT        NOT NULL,
    discount        FLOAT        NOT NULL DEFAULT 0,
    stockQuantity   INT(10)      NOT NULL DEFAULT 0,
    tblSparePart8id INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblSparePart8id) REFERENCES tblSparePart8(id)
) ENGINE=InnoDB;

-- Nhap hang: chi dung de tinh don gia niem yet phu tung = gia nhap gan nhat * (1 + markupRate)
CREATE TABLE tblSupplier8 (
    id           INT(10)      NOT NULL AUTO_INCREMENT,
    supplierName VARCHAR(255) NOT NULL,
    address      VARCHAR(255) NULL,
    phoneNumber  VARCHAR(255) NULL,
    email        VARCHAR(255) NULL,
    description  VARCHAR(255) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblImportInvoice8 (
    id             INT(10) NOT NULL AUTO_INCREMENT,
    importDate     DATE    NOT NULL,
    totalAmount    FLOAT   NOT NULL,
    tblSupplier8id INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblSupplier8id) REFERENCES tblSupplier8(id)
) ENGINE=InnoDB;

CREATE TABLE tblImportedPart8 (
    id                  INT(10) NOT NULL AUTO_INCREMENT,
    importQuantity      INT(10) NOT NULL,
    importPrice         FLOAT   NOT NULL,
    totalPrice          FLOAT   NOT NULL,
    tblImportInvoice8id INT(10) NOT NULL,
    tblPartVariant8id   INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblImportInvoice8id) REFERENCES tblImportInvoice8(id),
    FOREIGN KEY (tblPartVariant8id)   REFERENCES tblPartVariant8(id)
) ENGINE=InnoDB;

-- discountType: 'Phần trăm' | 'Số tiền'
CREATE TABLE tblDiscount8 (
    id                  INT(10)      NOT NULL AUTO_INCREMENT,
    discountName        VARCHAR(255) NOT NULL,
    discountType        VARCHAR(255) NOT NULL,
    discountValue       FLOAT        NOT NULL,
    applicableScope     VARCHAR(255) NULL,
    maxDiscountAmount   FLOAT        NULL,
    minApplicableAmount FLOAT        NULL,
    startTime           DATE         NOT NULL,
    endTime             DATE         NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE tblDiscountCondition8 (
    id             INT(10)      NOT NULL AUTO_INCREMENT,
    description    VARCHAR(255) NULL,
    conditionType  VARCHAR(255) NOT NULL,
    operator       VARCHAR(255) NOT NULL,
    targetValue    FLOAT        NOT NULL,
    tblDiscount8id INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblDiscount8id) REFERENCES tblDiscount8(id)
) ENGINE=InnoDB;

CREATE TABLE tblServiceDiscountDetail8 (
    id             INT(10) NOT NULL AUTO_INCREMENT,
    tblDiscount8id INT(10) NOT NULL,
    tblService8id  INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblDiscount8id) REFERENCES tblDiscount8(id),
    FOREIGN KEY (tblService8id)  REFERENCES tblService8(id)
) ENGINE=InnoDB;

CREATE TABLE tblPartDiscountDetail8 (
    id                INT(10) NOT NULL AUTO_INCREMENT,
    tblDiscount8id    INT(10) NOT NULL,
    tblPartVariant8id INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblDiscount8id)    REFERENCES tblDiscount8(id),
    FOREIGN KEY (tblPartVariant8id) REFERENCES tblPartVariant8(id)
) ENGINE=InnoDB;

-- processingStatus: 'Nháp' | 'Đang xử lý'
CREATE TABLE tblRequestForm8 (
    id                INT(10)      NOT NULL AUTO_INCREMENT,
    processingStatus  VARCHAR(255) NOT NULL,
    estimatedTotal    FLOAT        NOT NULL,
    createdAt         DATETIME     NOT NULL,
    notes             VARCHAR(255) NULL,
    totalDiscount     FLOAT        NOT NULL,
    totalListedAmount FLOAT        NOT NULL,
    tblEmployee8id    INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblEmployee8id) REFERENCES tblEmployee8(id)
) ENGINE=InnoDB;

CREATE TABLE tblServiceDetail8 (
    id                INT(10)      NOT NULL AUTO_INCREMENT,
    quantity          INT(10)      NOT NULL,
    discountAmount    FLOAT        NOT NULL,
    finalPrice        FLOAT        NOT NULL,
    totalPrice        FLOAT        NOT NULL,
    discountNote      VARCHAR(255) NULL,
    tblRequestForm8id INT(10)      NOT NULL,
    tblService8id     INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblRequestForm8id) REFERENCES tblRequestForm8(id),
    FOREIGN KEY (tblService8id)     REFERENCES tblService8(id)
) ENGINE=InnoDB;

CREATE TABLE tblPartDetail8 (
    id                INT(10)      NOT NULL AUTO_INCREMENT,
    quantity          INT(10)      NOT NULL,
    discountAmount    FLOAT        NOT NULL,
    finalPrice        FLOAT        NOT NULL,
    totalPrice        FLOAT        NOT NULL,
    discountNote      VARCHAR(255) NULL,
    tblRequestForm8id INT(10)      NOT NULL,
    tblPartVariant8id INT(10)      NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblRequestForm8id) REFERENCES tblRequestForm8(id),
    FOREIGN KEY (tblPartVariant8id) REFERENCES tblPartVariant8(id)
) ENGINE=InnoDB;

CREATE TABLE tblAssignmentDetail8 (
    id                INT(10) NOT NULL AUTO_INCREMENT,
    tblRequestForm8id INT(10) NOT NULL,
    tblTechnician8id  INT(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tblRequestForm8id) REFERENCES tblRequestForm8(id),
    FOREIGN KEY (tblTechnician8id)  REFERENCES tblTechnician8(id)
) ENGINE=InnoDB;

CREATE TABLE tblCarReceipt8 (
    id                 INT(10)      NOT NULL AUTO_INCREMENT,
    actualCreationTime DATETIME     NOT NULL,
    actualReceiptTime  DATETIME     NOT NULL,
    notes              VARCHAR(255) NULL,
    tblCustomerCar8id  INT(10)      NOT NULL,
    tblRequestForm8id  INT(10)      NOT NULL UNIQUE,
    PRIMARY KEY (id),
    FOREIGN KEY (tblCustomerCar8id) REFERENCES tblCustomerCar8(id),
    FOREIGN KEY (tblRequestForm8id) REFERENCES tblRequestForm8(id)
) ENGINE=InnoDB;

-- ===== Du lieu mau =====
-- Lich lam viec 14 ngay tinh tu ngay mai, 08:00 - 17:00; Chu nhat nghi (xoa ban ghi).
INSERT INTO tblWorkSchedule8 (id, workDate, openTime, closeTime) VALUES
 (1,  CURDATE() + INTERVAL 1 DAY,  '08:00:00', '17:00:00'),
 (2,  CURDATE() + INTERVAL 2 DAY,  '08:00:00', '17:00:00'),
 (3,  CURDATE() + INTERVAL 3 DAY,  '08:00:00', '17:00:00'),
 (4,  CURDATE() + INTERVAL 4 DAY,  '08:00:00', '17:00:00'),
 (5,  CURDATE() + INTERVAL 5 DAY,  '08:00:00', '17:00:00'),
 (6,  CURDATE() + INTERVAL 6 DAY,  '08:00:00', '17:00:00'),
 (7,  CURDATE() + INTERVAL 7 DAY,  '08:00:00', '17:00:00'),
 (8,  CURDATE() + INTERVAL 8 DAY,  '08:00:00', '17:00:00'),
 (9,  CURDATE() + INTERVAL 9 DAY,  '08:00:00', '17:00:00'),
 (10, CURDATE() + INTERVAL 10 DAY, '08:00:00', '17:00:00'),
 (11, CURDATE() + INTERVAL 11 DAY, '08:00:00', '17:00:00'),
 (12, CURDATE() + INTERVAL 12 DAY, '08:00:00', '17:00:00'),
 (13, CURDATE() + INTERVAL 13 DAY, '08:00:00', '17:00:00'),
 (14, CURDATE() + INTERVAL 14 DAY, '08:00:00', '17:00:00');
DELETE FROM tblWorkSchedule8 WHERE DAYOFWEEK(workDate) = 1;

-- Mot lich hen co san de thay khung gio "Da co khach dat"
INSERT INTO tblBookingContact8 (fullName, phoneNumber) VALUES ('Trần Thị B', '0988765432');
INSERT INTO tblAppointment8 (appointmentTime, status, tblCustomer8id, tblWorkSchedule8id, tblBookingContact8id)
SELECT TIMESTAMP(w.workDate, '08:30:00'), 'Chờ xác nhận', NULL, w.id, LAST_INSERT_ID()
FROM tblWorkSchedule8 w ORDER BY w.workDate LIMIT 1;

-- ===== Du lieu mau Module 2 (theo kich ban v.1 "Nhan xe vao sua") =====
INSERT INTO tblMember8 (id, username, password, fullName, phoneNumber, address) VALUES
 (1, 'sales01', '123456', 'Lê Thị Hoa',     '0901000001', 'Hà Nội'),
 (2, 'tech01',  '123456', 'Phạm Văn Minh',  '0901000002', 'Hà Nội'),
 (3, 'tech02',  '123456', 'Đỗ Quang Huy',   '0901000003', 'Hà Nội'),
 (4, 'tech03',  '123456', 'Vũ Đức Long',    '0901000004', 'Hà Nội'),
 (5, '0912345678', '0912345678', 'Nguyễn Văn An', '0912345678', 'Cầu Giấy, Hà Nội'),
 (6, '0988765432', '0988765432', 'Nguyễn Văn An', '0988765432', 'Đống Đa, Hà Nội'),
 (7, '0903112233', '0903112233', 'Nguyễn Văn An', '0903112233', 'Hà Đông, Hà Nội');
INSERT INTO tblEmployee8 (id, position, workStatus) VALUES
 (1, 'Bán hàng', 'Đang làm việc'), (2, 'Kỹ thuật', 'Đang làm việc'),
 (3, 'Kỹ thuật', 'Đang làm việc'), (4, 'Kỹ thuật', 'Đang làm việc');
INSERT INTO tblTechnician8 (id, specialty) VALUES (2, 'Động cơ'), (3, 'Điện - điều hòa'), (4, 'Gầm - phanh');
INSERT INTO tblCustomer8 (id) VALUES (5), (6), (7);

INSERT INTO tblCar8 (id, licensePlate, brand, manufacturingYear, color, vehicleType) VALUES
 (1, '30A-999.88', 'Toyota',  2021, 'Trắng', 'Vios 1.5G'),
 (2, '29C-123.45', 'Hyundai', 2020, 'Đỏ',    'Accent AT');
INSERT INTO tblCustomerCar8 (registrationDate, tblCar8id, tblCustomer8id) VALUES
 ('2024-01-15', 1, 5), ('2024-06-20', 2, 5);

INSERT INTO tblService8 (id, serviceName, description, listedPrice) VALUES
 (1, 'Thay dầu động cơ',         'Thay dầu và kiểm tra mức dầu',  200000),
 (2, 'Bảo dưỡng định kỳ',        'Kiểm tra tổng quát 20 hạng mục', 300000),
 (3, 'Vệ sinh hệ thống điều hòa', 'Vệ sinh dàn lạnh, thay lọc gió', 450000),
 (4, 'Cân chỉnh thước lái',      'Căn chỉnh góc đặt bánh xe',      350000);

INSERT INTO tblSparePart8 (id, partName, description, unit, discount) VALUES
 (1, 'Lọc dầu động cơ', 'Lọc dầu cho xe con',  'Cái', 0),
 (2, 'Má phanh trước',  'Bộ má phanh 2 bánh',  'Bộ',  0),
 (3, 'Dầu động cơ 5W-30', 'Can 4 lít',         'Can', 0);
INSERT INTO tblPartVariant8 (id, brand, markupRate, discount, stockQuantity, tblSparePart8id) VALUES
 (1, 'Toyota Genuine', 0.25, 0, 20, 1),
 (2, 'Bosch',          0.30, 0, 15, 1),
 (3, 'Akebono',        0.25, 0, 0,  2),
 (4, 'Castrol',        0.20, 0, 30, 3);

INSERT INTO tblSupplier8 (id, supplierName, address, phoneNumber, email, description) VALUES
 (1, 'Công ty Phụ tùng Hà Nội', 'Long Biên, Hà Nội', '0243000000', 'ncc@example.com', NULL);
INSERT INTO tblImportInvoice8 (id, importDate, totalAmount, tblSupplier8id) VALUES (1, CURDATE() - INTERVAL 10 DAY, 9960000, 1);
INSERT INTO tblImportedPart8 (importQuantity, importPrice, totalPrice, tblImportInvoice8id, tblPartVariant8id) VALUES
 (20, 120000, 2400000, 1, 1), (15, 100000, 1500000, 1, 2), (6, 400000, 2400000, 1, 3), (30, 122000, 3660000, 1, 4);

-- Giam gia dang hieu luc: dich vu 2 giam 10%, phu tung bien the 4 giam 20.000d khi mua tu 2 can
INSERT INTO tblDiscount8 (id, discountName, discountType, discountValue, applicableScope, maxDiscountAmount, minApplicableAmount, startTime, endTime) VALUES
 (1, 'Ưu đãi bảo dưỡng tháng này', 'Phần trăm', 10,    'Dịch vụ',  50000, 0, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 25 DAY),
 (2, 'Giảm giá dầu Castrol',       'Số tiền',   20000, 'Phụ tùng', 20000, 0, CURDATE() - INTERVAL 5 DAY, CURDATE() + INTERVAL 25 DAY);
INSERT INTO tblDiscountCondition8 (description, conditionType, operator, targetValue, tblDiscount8id) VALUES
 ('Mua từ 2 can trở lên', 'Số lượng', '>=', 2, 2);
INSERT INTO tblServiceDiscountDetail8 (tblDiscount8id, tblService8id) VALUES (1, 2);
INSERT INTO tblPartDiscountDetail8 (tblDiscount8id, tblPartVariant8id) VALUES (2, 4);
