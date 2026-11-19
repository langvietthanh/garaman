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

-- ===== Du lieu mau Module 2 (Nhan xe vao sua) - da dang de demo =====
-- Id 1-7 giu nguyen theo kich ban v.1 (nhan vien ban hang Lê Thị Hoa id=1, 3 khach trung ten 'Nguyễn Văn An' id 5-7).
INSERT INTO tblMember8 (id, username, password, fullName, phoneNumber, address) VALUES
 (1, 'sales01', '123456', 'Lê Thị Hoa', '0901000001', 'Thanh Xuân, Hà Nội'),
 (2, 'tech01', '123456', 'Phạm Văn Minh', '0901000002', 'Hoàng Mai, Hà Nội'),
 (3, 'tech02', '123456', 'Đỗ Quang Huy', '0901000003', 'Long Biên, Hà Nội'),
 (4, 'tech03', '123456', 'Vũ Đức Long', '0901000004', 'Hà Đông, Hà Nội'),
 (5, '0912345678', '0912345678', 'Nguyễn Văn An', '0912345678', 'Cầu Giấy, Hà Nội'),
 (6, '0988765432', '0988765432', 'Nguyễn Văn An', '0988765432', 'Đống Đa, Hà Nội'),
 (7, '0903112233', '0903112233', 'Nguyễn Văn An', '0903112233', 'Hà Đông, Hà Nội'),
 (8, 'tech04', '123456', 'Trần Văn Bình', '0901000008', 'Cầu Giấy, Hà Nội'),
 (9, 'tech05', '123456', 'Lê Quốc Dũng', '0901000009', 'Bắc Từ Liêm, Hà Nội'),
 (10, 'tech06', '123456', 'Ngô Thanh Tùng', '0901000010', 'Đống Đa, Hà Nội'),
 (11, 'tech07', '123456', 'Hoàng Minh Tuấn', '0901000011', 'Gia Lâm, Hà Nội'),
 (12, 'tech08', '123456', 'Bùi Văn Khánh', '0901000012', 'Nam Từ Liêm, Hà Nội'),
 (13, 'tech09', '123456', 'Đinh Công Thành', '0901000013', 'Tây Hồ, Hà Nội'),
 (14, 'tech10', '123456', 'Phan Văn Sơn', '0901000014', 'Ba Đình, Hà Nội'),
 (15, 'sales02', '123456', 'Nguyễn Thu Trang', '0901000015', 'Hai Bà Trưng, Hà Nội'),
 (16, 'kho01', '123456', 'Trịnh Văn Hải', '0901000016', 'Thanh Trì, Hà Nội'),
 (17, 'admin01', '123456', 'Đặng Thị Lan', '0901000017', 'Hoàn Kiếm, Hà Nội'),
 (20, '0912000020', '0912000020', 'Trần Thị Mai', '0912000020', 'Ba Đình, Hà Nội'),
 (21, '0983000021', '0983000021', 'Trần Thị Mai', '0983000021', 'Long Biên, Hà Nội'),
 (22, '0904000022', '0904000022', 'Lê Văn Hùng', '0904000022', 'Thanh Xuân, Hà Nội'),
 (23, '0935000023', '0935000023', 'Phạm Minh Tuấn', '0935000023', 'Hoàng Mai, Hà Nội'),
 (24, '0976000024', '0976000024', 'Hoàng Thị Thu Hà', '0976000024', 'Tây Hồ, Hà Nội'),
 (25, '0967000025', '0967000025', 'Vũ Đức Anh', '0967000025', 'Nam Từ Liêm, Hà Nội'),
 (26, '0918000026', '0918000026', 'Đặng Quốc Bảo', '0918000026', 'Gia Lâm, Hà Nội'),
 (27, '0889000027', '0889000027', 'Bùi Thị Ngọc Ánh', '0889000027', 'Hai Bà Trưng, Hà Nội'),
 (28, '0393000028', '0393000028', 'Đỗ Văn Cường', '0393000028', 'Đông Anh, Hà Nội'),
 (29, '0344000029', '0344000029', 'Ngô Thị Hồng Nhung', '0344000029', 'Thanh Trì, Hà Nội'),
 (30, '0355000030', '0355000030', 'Dương Văn Phúc', '0355000030', 'Bắc Từ Liêm, Hà Nội'),
 (31, '0866000031', '0866000031', 'Lý Thanh Hương', '0866000031', 'Hoàn Kiếm, Hà Nội'),
 (32, '0827000032', '0827000032', 'Trịnh Văn Quang', '0827000032', 'Sóc Sơn, Hà Nội'),
 (33, '0838000033', '0838000033', 'Mai Thị Lan', '0838000033', 'Từ Sơn, Bắc Ninh'),
 (34, '0949000034', '0949000034', 'Phan Anh Khoa', '0949000034', 'TP. Bắc Ninh, Bắc Ninh'),
 (35, '0910000035', '0910000035', 'Nguyễn Thị Hoa', '0910000035', 'Phúc Yên, Vĩnh Phúc'),
 (36, '0971000036', '0971000036', 'Nguyễn Hữu Thắng', '0971000036', 'TP. Hưng Yên, Hưng Yên'),
 (37, '0962000037', '0962000037', 'Cao Văn Lực', '0962000037', 'Hải An, Hải Phòng'),
 (38, '0913000038', '0913000038', 'Tạ Thị Minh Châu', '0913000038', 'Cầu Giấy, Hà Nội'),
 (39, '0384000039', '0384000039', 'Lâm Quốc Việt', '0384000039', 'Đống Đa, Hà Nội'),
 (40, '0705000040', '0705000040', 'Kiều Thị Yến', '0705000040', 'Thạch Thất, Hà Nội'),
 (41, '0776000041', '0776000041', 'Hồ Sỹ Nam', '0776000041', 'Thanh Xuân, Hà Nội'),
 (42, '0587000042', '0587000042', 'Lương Văn Tài', '0587000042', 'Hà Đông, Hà Nội'),
 (43, '0398000043', '0398000043', 'Chu Thị Thanh Tâm', '0398000043', 'Ba Đình, Hà Nội'),
 (44, '0919000044', '0919000044', 'Nguyễn Văn Bình', '0919000044', 'Long Biên, Hà Nội'),
 (45, '0984000045', '0984000045', 'Lê Thị Hồng', '0984000045', 'Hoàng Mai, Hà Nội'),
 (46, '0243000046', '0243000046', 'Công ty TNHH Minh Phát', '0243000046', 'Duy Tân, Cầu Giấy, Hà Nội');
INSERT INTO tblEmployee8 (id, position, workStatus) VALUES
 (1, 'Bán hàng', 'Đang làm việc'),
 (2, 'Kỹ thuật', 'Đang làm việc'),
 (3, 'Kỹ thuật', 'Đang làm việc'),
 (4, 'Kỹ thuật', 'Đang làm việc'),
 (8, 'Kỹ thuật', 'Đang làm việc'),
 (9, 'Kỹ thuật', 'Đang làm việc'),
 (10, 'Kỹ thuật', 'Đang làm việc'),
 (11, 'Kỹ thuật', 'Đang làm việc'),
 (12, 'Kỹ thuật', 'Đang làm việc'),
 (13, 'Kỹ thuật', 'Đang làm việc'),
 (14, 'Kỹ thuật', 'Đang làm việc'),
 (15, 'Bán hàng', 'Đang làm việc'),
 (16, 'Kho', 'Đang làm việc'),
 (17, 'Quản lý', 'Đang làm việc');
INSERT INTO tblTechnician8 (id, specialty) VALUES
 (2, 'Động cơ'),
 (3, 'Điện - điều hòa'),
 (4, 'Gầm - phanh'),
 (8, 'Máy - gầm'),
 (9, 'Điện - điều hòa'),
 (10, 'Thân vỏ - sơn'),
 (11, 'Lốp - cân chỉnh'),
 (12, 'Chẩn đoán điện tử'),
 (13, 'Hộp số'),
 (14, 'Động cơ');
INSERT INTO tblCustomer8 (id) VALUES (5), (6), (7), (20), (21), (22), (23), (24), (25), (26), (27), (28), (29), (30), (31), (32), (33), (34), (35), (36), (37), (38), (39), (40), (41), (42), (43), (44), (45), (46);
INSERT INTO tblCar8 (id, licensePlate, brand, manufacturingYear, color, vehicleType) VALUES
 (1, '30A-999.88', 'Toyota', 2021, 'Trắng', 'Vios 1.5G'),
 (2, '29C-123.45', 'Hyundai', 2020, 'Đỏ', 'Accent 1.4 AT'),
 (3, '30G-456.78', 'Mazda', 2022, 'Xanh đậm', 'CX-5 2.0 Premium'),
 (4, '30K-246.80', 'Honda', 2023, 'Đen', 'City RS'),
 (5, '30E-135.79', 'Kia', 2019, 'Bạc', 'Cerato 1.6 AT'),
 (6, '30H-888.66', 'Toyota', 2022, 'Trắng ngọc trai', 'Corolla Cross 1.8V'),
 (7, '29A-777.21', 'Ford', 2021, 'Cam', 'Ranger Wildtrak 2.0'),
 (8, '30F-321.09', 'Mitsubishi', 2023, 'Trắng', 'Xpander AT Premium'),
 (9, '30L-112.34', 'VinFast', 2023, 'Xanh dương', 'VF 8 Plus'),
 (10, '29H-505.05', 'Hyundai', 2021, 'Xám', 'Tucson 2.0 Đặc biệt'),
 (11, '30A-202.20', 'Kia', 2018, 'Đỏ', 'Morning Si'),
 (12, '30G-678.12', 'Toyota', 2020, 'Đen', 'Fortuner 2.4 AT'),
 (13, '30K-909.90', 'Honda', 2021, 'Trắng', 'CR-V 1.5L'),
 (14, '30E-818.18', 'Mercedes-Benz', 2022, 'Đen', 'C 200 Avantgarde'),
 (15, '29D-414.14', 'Suzuki', 2020, 'Bạc', 'XL7 AT'),
 (16, '30H-363.63', 'Hyundai', 2019, 'Trắng', 'Grand i10 Sedan'),
 (17, '30F-727.27', 'Mazda', 2021, 'Đỏ pha lê', 'Mazda 3 Premium'),
 (18, '30L-585.58', 'Kia', 2022, 'Xanh rêu', 'Seltos 1.4 Turbo'),
 (19, '29C-919.19', 'Toyota', 2017, 'Bạc', 'Innova 2.0E'),
 (20, '99A-123.88', 'VinFast', 2021, 'Xám', 'Lux A2.0'),
 (21, '99A-246.68', 'Honda', 2020, 'Trắng', 'Civic 1.5 RS'),
 (22, '88A-369.36', 'Toyota', 2022, 'Đen', 'Camry 2.5Q'),
 (23, '89A-111.22', 'Ford', 2023, 'Trắng', 'Territory Titanium X'),
 (24, '15A-555.66', 'Hyundai', 2022, 'Đen', 'Santa Fe 2.2 Dầu'),
 (25, '15K-777.99', 'Kia', 2023, 'Trắng', 'Carnival 2.2D Signature'),
 (26, '30G-101.01', 'BMW', 2021, 'Xanh', '320i Sport Line'),
 (27, '30K-232.32', 'Mitsubishi', 2019, 'Trắng', 'Attrage CVT'),
 (28, '29H-646.46', 'VinFast', 2020, 'Đỏ', 'Fadil Plus'),
 (29, '30E-575.75', 'Toyota', 2023, 'Trắng', 'Veloz Cross Top'),
 (30, '30F-838.38', 'Mazda', 2020, 'Xám', 'CX-8 Luxury'),
 (31, '30A-474.74', 'Ford', 2022, 'Đen', 'Everest Titanium+'),
 (32, '30L-656.56', 'Honda', 2018, 'Bạc', 'Accord 1.5 Turbo'),
 (33, '30H-292.92', 'Hyundai', 2023, 'Trắng', 'Creta 1.5 Đặc biệt'),
 (34, '30G-868.68', 'Toyota', 2021, 'Đen', 'Hiace 3.0 (16 chỗ)'),
 (35, '30G-868.69', 'Toyota', 2021, 'Đen', 'Hiace 3.0 (16 chỗ)'),
 (36, '30K-123.98', 'Ford', 2022, 'Trắng', 'Transit Premium');
INSERT INTO tblCustomerCar8 (id, registrationDate, tblCar8id, tblCustomer8id) VALUES
 (1, '2024-01-15', 1, 5),
 (2, '2024-06-20', 2, 5),
 (3, '2023-03-02', 3, 44),
 (4, '2024-09-12', 4, 45),
 (5, '2022-11-05', 5, 20),
 (6, '2023-07-19', 6, 21),
 (7, '2022-04-27', 7, 22),
 (8, '2024-02-14', 8, 22),
 (9, '2024-05-30', 9, 23),
 (10, '2023-01-08', 10, 24),
 (11, '2021-08-16', 11, 25),
 (12, '2022-10-03', 12, 26),
 (13, '2023-06-21', 13, 26),
 (14, '2023-12-01', 14, 27),
 (15, '2022-02-18', 15, 28),
 (16, '2021-05-25', 16, 29),
 (17, '2022-09-09', 17, 30),
 (18, '2023-04-11', 18, 31),
 (19, '2020-12-20', 19, 32),
 (20, '2022-07-07', 20, 33),
 (21, '2021-10-30', 21, 34),
 (22, '2023-08-15', 22, 35),
 (23, '2024-03-03', 23, 36),
 (24, '2023-02-22', 24, 37),
 (25, '2024-01-29', 25, 37),
 (26, '2022-12-12', 26, 38),
 (27, '2021-03-17', 27, 39),
 (28, '2021-09-21', 28, 40),
 (29, '2024-04-04', 29, 41),
 (30, '2022-06-06', 30, 42),
 (31, '2023-09-27', 31, 43),
 (32, '2020-11-11', 32, 44),
 (33, '2024-07-01', 33, 45),
 (34, '2022-01-10', 34, 46),
 (35, '2022-01-10', 35, 46),
 (36, '2023-05-18', 36, 46);
INSERT INTO tblService8 (id, serviceName, description, listedPrice) VALUES
 (1, 'Thay dầu động cơ', 'Thay dầu, kiểm tra mức dầu và rò rỉ', 200000),
 (2, 'Bảo dưỡng định kỳ cấp nhỏ (5.000 km)', 'Kiểm tra tổng quát 20 hạng mục', 300000),
 (3, 'Bảo dưỡng định kỳ cấp lớn (40.000 km)', 'Kiểm tra 45 hạng mục, vệ sinh kim phun, bugi', 1500000),
 (4, 'Vệ sinh hệ thống điều hòa', 'Vệ sinh dàn lạnh, thay lọc gió điều hòa', 450000),
 (5, 'Nạp gas điều hòa', 'Hút chân không, nạp gas R134a', 350000),
 (6, 'Cân chỉnh thước lái', 'Căn chỉnh góc đặt bánh xe bằng máy 3D', 350000),
 (7, 'Đảo lốp và cân bằng động', 'Đảo vị trí 4 lốp, cân bằng động', 250000),
 (8, 'Thay má phanh', 'Công tháo lắp, vệ sinh cụm phanh', 300000),
 (9, 'Thay dầu phanh', 'Xả, thay dầu phanh DOT4', 250000),
 (10, 'Thay dầu hộp số tự động', 'Thay dầu ATF bằng máy', 400000),
 (11, 'Vệ sinh họng ga, kim phun', 'Vệ sinh bằng dung dịch chuyên dụng', 600000),
 (12, 'Kiểm tra, chẩn đoán lỗi bằng máy', 'Đọc và xóa lỗi OBD-II', 200000),
 (13, 'Thay ắc quy', 'Công kiểm tra và thay ắc quy', 100000),
 (14, 'Sơn dặm 1 vị trí', 'Sơn dặm vết xước nhỏ', 800000),
 (15, 'Đánh bóng, phủ ceramic', 'Đánh bóng 3 bước, phủ ceramic 9H', 4500000),
 (16, 'Rửa xe, hút bụi nội thất', 'Rửa bọt tuyết, hút bụi, lau nội thất', 150000),
 (17, 'Vệ sinh khoang máy', 'Vệ sinh và dưỡng khoang động cơ', 300000),
 (18, 'Thay lọc nhiên liệu', 'Công thay lọc xăng/dầu', 200000),
 (19, 'Kiểm tra hệ thống treo', 'Kiểm tra giảm xóc, rotuyn, cao su', 250000),
 (20, 'Thay nước làm mát', 'Xả và thay nước làm mát động cơ', 300000);
INSERT INTO tblSparePart8 (id, partName, description, unit, discount) VALUES
 (1, 'Dầu động cơ 5W-30', 'Can 4 lít, tổng hợp toàn phần', 'Can', 0),
 (2, 'Lọc dầu động cơ', 'Lọc nhớt cho xe con', 'Cái', 0),
 (3, 'Lọc gió động cơ', 'Lọc không khí nạp', 'Cái', 0),
 (4, 'Lọc gió điều hòa', 'Lọc than hoạt tính', 'Cái', 0),
 (5, 'Má phanh trước', 'Bộ má phanh 2 bánh trước', 'Bộ', 0),
 (6, 'Má phanh sau', 'Bộ má phanh 2 bánh sau', 'Bộ', 0),
 (7, 'Dầu phanh DOT4', 'Chai 1 lít', 'Chai', 0),
 (8, 'Ắc quy 12V 60Ah', 'Ắc quy khô miễn bảo dưỡng', 'Bình', 0),
 (9, 'Bugi', 'Bugi đánh lửa', 'Cái', 0),
 (10, 'Gạt mưa', 'Cặp gạt mưa trước', 'Cặp', 0),
 (11, 'Nước làm mát', 'Can 4 lít, pha sẵn', 'Can', 0),
 (12, 'Dầu hộp số tự động ATF', 'Chai 1 lít', 'Chai', 0),
 (13, 'Lốp xe 205/55R16', 'Lốp không săm', 'Chiếc', 0),
 (14, 'Gas điều hòa R134a', 'Bình 13,6 kg', 'Kg', 0),
 (15, 'Bóng đèn pha LED H4', 'Cặp bóng 6000K', 'Cặp', 0);
INSERT INTO tblPartVariant8 (id, brand, markupRate, discount, stockQuantity, tblSparePart8id) VALUES
 (1, 'Castrol EDGE', 0.2, 0, 30, 1),
 (2, 'Mobil 1', 0.2, 0, 18, 1),
 (3, 'Shell Helix Ultra', 0.18, 0, 0, 1),
 (4, 'Toyota Genuine', 0.25, 0, 20, 2),
 (5, 'Bosch', 0.3, 0, 15, 2),
 (6, 'Denso', 0.25, 0, 3, 2),
 (7, 'Bosch', 0.3, 0, 25, 3),
 (8, 'Sakura', 0.3, 0, 12, 3),
 (9, 'Denso', 0.3, 0, 22, 4),
 (10, 'Bosch', 0.3, 0, 10, 4),
 (11, 'Akebono', 0.25, 0, 0, 5),
 (12, 'Bosch', 0.25, 0, 8, 5),
 (13, 'Toyota Genuine', 0.2, 0, 5, 5),
 (14, 'Akebono', 0.25, 0, 6, 6),
 (15, 'Brembo', 0.25, 0, 4, 6),
 (16, 'Bosch', 0.3, 0, 30, 7),
 (17, 'Castrol', 0.3, 0, 14, 7),
 (18, 'GS', 0.15, 0, 7, 8),
 (19, 'Varta', 0.15, 0, 4, 8),
 (20, 'Rocket', 0.15, 0, 2, 8),
 (21, 'Denso Iridium', 0.25, 0, 40, 9),
 (22, 'NGK Laser Iridium', 0.25, 0, 0, 9),
 (23, 'Bosch Aerotwin', 0.3, 0, 16, 10),
 (24, 'Denso', 0.3, 0, 9, 10),
 (25, 'Toyota Super Long Life', 0.25, 0, 12, 11),
 (26, 'Prestone', 0.25, 0, 10, 11),
 (27, 'Toyota ATF WS', 0.2, 0, 24, 12),
 (28, 'Castrol Transmax', 0.2, 0, 1, 12),
 (29, 'Michelin Primacy 4', 0.15, 0, 8, 13),
 (30, 'Bridgestone Turanza', 0.15, 0, 12, 13),
 (31, 'Kumho Ecsta', 0.15, 0, 6, 13),
 (32, 'Honeywell', 0.4, 0, 20, 14),
 (33, 'Philips Ultinon', 0.3, 0, 6, 15),
 (34, 'Osram LEDriving', 0.3, 0, 0, 15);
INSERT INTO tblSupplier8 (id, supplierName, address, phoneNumber, email, description) VALUES
 (1, 'Công ty CP Phụ tùng Ô tô Hà Nội', 'Long Biên, Hà Nội', '0243000001', 'kinhdoanh@phutunghn.vn', 'Phụ tùng chính hãng Toyota, Honda'),
 (2, 'Công ty TNHH Bosch Việt Nam - Đại lý Miền Bắc', 'Hoàng Mai, Hà Nội', '0243000002', 'sales@bosch-dl.vn', 'Lọc, má phanh, gạt mưa, dầu phanh'),
 (3, 'Công ty TNHH Dầu nhớt Thịnh Phát', 'Gia Lâm, Hà Nội', '0243000003', 'order@thinhphatoil.vn', 'Dầu nhớt, nước làm mát'),
 (4, 'Công ty CP Lốp xe Thăng Long', 'Đông Anh, Hà Nội', '0243000004', 'lop@thanglongtyre.vn', 'Lốp, ắc quy');
INSERT INTO tblImportInvoice8 (id, importDate, totalAmount, tblSupplier8id) VALUES
 (1, CURDATE() - INTERVAL 40 DAY, 73170000, 1),
 (2, CURDATE() - INTERVAL 35 DAY, 46424000, 2),
 (3, CURDATE() - INTERVAL 25 DAY, 30206000, 3),
 (4, CURDATE() - INTERVAL 20 DAY, 157594000, 4),
 (5, CURDATE() - INTERVAL 8 DAY, 61833000, 1),
 (6, CURDATE() - INTERVAL 6 DAY, 34710000, 2),
 (7, CURDATE() - INTERVAL 5 DAY, 23400000, 3),
 (8, CURDATE() - INTERVAL 4 DAY, 125100000, 4);
INSERT INTO tblImportedPart8 (importQuantity, importPrice, totalPrice, tblImportInvoice8id, tblPartVariant8id) VALUES
 (18, 91000, 1638000, 1, 4),
 (22, 81000, 1782000, 1, 6),
 (12, 104000, 1248000, 1, 8),
 (14, 152000, 2128000, 1, 9),
 (22, 712000, 15664000, 1, 13),
 (16, 162000, 2592000, 1, 17),
 (10, 171000, 1710000, 1, 21),
 (12, 209000, 2508000, 1, 22),
 (16, 209000, 3344000, 1, 24),
 (18, 142000, 2556000, 1, 32),
 (20, 855000, 17100000, 1, 33),
 (22, 950000, 20900000, 1, 34),
 (20, 76000, 1520000, 2, 5),
 (10, 142000, 1420000, 2, 7),
 (16, 133000, 2128000, 2, 10),
 (18, 608000, 10944000, 2, 11),
 (20, 494000, 9880000, 2, 12),
 (10, 456000, 4560000, 2, 14),
 (12, 855000, 10260000, 2, 15),
 (14, 142000, 1988000, 2, 16),
 (14, 266000, 3724000, 2, 23),
 (12, 380000, 4560000, 3, 1),
 (14, 428000, 5992000, 3, 2),
 (16, 361000, 5776000, 3, 3),
 (18, 209000, 3762000, 3, 25),
 (20, 171000, 3420000, 3, 26),
 (22, 218000, 4796000, 3, 27),
 (10, 190000, 1900000, 3, 28),
 (18, 1425000, 25650000, 4, 18),
 (20, 1805000, 36100000, 4, 19),
 (22, 1282000, 28204000, 4, 20),
 (12, 1995000, 23940000, 4, 29),
 (14, 1710000, 23940000, 4, 30),
 (16, 1235000, 19760000, 4, 31),
 (18, 96000, 1728000, 5, 4),
 (9, 85000, 765000, 5, 6),
 (15, 110000, 1650000, 5, 8),
 (18, 160000, 2880000, 5, 9),
 (15, 750000, 11250000, 5, 13),
 (12, 170000, 2040000, 5, 17),
 (9, 180000, 1620000, 5, 21),
 (12, 220000, 2640000, 5, 22),
 (18, 220000, 3960000, 5, 24),
 (12, 150000, 1800000, 5, 32),
 (15, 900000, 13500000, 5, 33),
 (18, 1000000, 18000000, 5, 34),
 (6, 80000, 480000, 6, 5),
 (12, 150000, 1800000, 6, 7),
 (6, 140000, 840000, 6, 10),
 (9, 640000, 5760000, 6, 11),
 (12, 520000, 6240000, 6, 12),
 (18, 480000, 8640000, 6, 14),
 (6, 900000, 5400000, 6, 15),
 (9, 150000, 1350000, 6, 16),
 (15, 280000, 4200000, 6, 23),
 (9, 400000, 3600000, 7, 1),
 (12, 450000, 5400000, 7, 2),
 (15, 380000, 5700000, 7, 3),
 (6, 220000, 1320000, 7, 25),
 (9, 180000, 1620000, 7, 26),
 (12, 230000, 2760000, 7, 27),
 (15, 200000, 3000000, 7, 28),
 (15, 1500000, 22500000, 8, 18),
 (18, 1900000, 34200000, 8, 19),
 (6, 1350000, 8100000, 8, 20),
 (18, 2100000, 37800000, 8, 29),
 (6, 1800000, 10800000, 8, 30),
 (9, 1300000, 11700000, 8, 31);
-- Khuyen mai: 6 dang hieu luc (phan tram / so tien, co tran, co muc toi thieu, co dieu kien), 1 da het han, 1 chua bat dau
INSERT INTO tblDiscount8 (id, discountName, discountType, discountValue, applicableScope, maxDiscountAmount, minApplicableAmount, startTime, endTime) VALUES
 (1, 'Ưu đãi bảo dưỡng tháng này',      'Phần trăm', 10,     'Dịch vụ',  50000,  0,       CURDATE() - INTERVAL 5 DAY,  CURDATE() + INTERVAL 25 DAY),
 (2, 'Giảm giá dầu nhớt Castrol',        'Số tiền',   20000,  'Phụ tùng', 20000,  0,       CURDATE() - INTERVAL 5 DAY,  CURDATE() + INTERVAL 25 DAY),
 (3, 'Chăm sóc điều hòa mùa hè',         'Phần trăm', 15,     'Dịch vụ',  100000, 300000,  CURDATE() - INTERVAL 10 DAY, CURDATE() + INTERVAL 50 DAY),
 (4, 'Giảm 100.000đ gói làm đẹp xe',     'Số tiền',   100000, 'Dịch vụ',  100000, 1000000, CURDATE() - INTERVAL 3 DAY,  CURDATE() + INTERVAL 30 DAY),
 (5, 'Mua 4 lốp giảm 5%',                'Phần trăm', 5,      'Phụ tùng', 500000, 0,       CURDATE() - INTERVAL 15 DAY, CURDATE() + INTERVAL 15 DAY),
 (6, 'Ắc quy chính hãng giảm 8%',        'Phần trăm', 8,      'Phụ tùng', 200000, 0,       CURDATE() - INTERVAL 2 DAY,  CURDATE() + INTERVAL 40 DAY),
 (7, 'Khuyến mãi Tết (đã hết hạn)',      'Phần trăm', 20,     'Dịch vụ',  300000, 0,       CURDATE() - INTERVAL 60 DAY, CURDATE() - INTERVAL 30 DAY),
 (8, 'Black Friday (sắp diễn ra)',       'Phần trăm', 25,     'Phụ tùng', 300000, 0,       CURDATE() + INTERVAL 10 DAY, CURDATE() + INTERVAL 13 DAY);
INSERT INTO tblDiscountCondition8 (description, conditionType, operator, targetValue, tblDiscount8id) VALUES
 ('Mua từ 2 can trở lên', 'Số lượng', '>=', 2, 2),
 ('Thành tiền từ 300.000đ', 'Tổng tiền', '>=', 300000, 3),
 ('Mua từ 4 chiếc trở lên', 'Số lượng', '>=', 4, 5);
INSERT INTO tblServiceDiscountDetail8 (tblDiscount8id, tblService8id) VALUES (1, 2), (1, 3), (3, 4), (3, 5), (4, 14), (4, 15), (7, 1), (7, 6);
INSERT INTO tblPartDiscountDetail8 (tblDiscount8id, tblPartVariant8id) VALUES (2, 1), (2, 17), (5, 29), (5, 30), (5, 31), (6, 18), (6, 19), (8, 21), (8, 23);
-- Phieu dang xu ly: KTV 8, 9, 10, 2 dang ban -> danh sach phan cong chi hien 6/10 KTV ranh
INSERT INTO tblRequestForm8 (id, processingStatus, estimatedTotal, createdAt, notes, totalDiscount, totalListedAmount, tblEmployee8id) VALUES
 (1, 'Đang xử lý', 3195000, NOW() - INTERVAL 1 DAY - INTERVAL 1 HOUR, NULL, 0, 3195000, 1),
 (2, 'Đang xử lý', 4740000, NOW() - INTERVAL 0 DAY - INTERVAL 2 HOUR, NULL, 0, 4740000, 15),
 (3, 'Đang xử lý', 1584000, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, NULL, 0, 1584000, 1);
INSERT INTO tblServiceDetail8 (quantity, discountAmount, finalPrice, totalPrice, discountNote, tblRequestForm8id, tblService8id) VALUES
 (1, 0, 1500000, 1500000, NULL, 1, 3),
 (1, 0, 600000, 600000, NULL, 1, 11),
 (1, 0, 350000, 350000, NULL, 2, 6),
 (1, 0, 250000, 250000, NULL, 2, 7),
 (1, 0, 200000, 200000, NULL, 3, 12),
 (1, 0, 200000, 200000, NULL, 3, 1);
INSERT INTO tblPartDetail8 (quantity, discountAmount, finalPrice, totalPrice, discountNote, tblRequestForm8id, tblPartVariant8id) VALUES
 (1, 0, 195000, 195000, NULL, 1, 7),
 (4, 0, 900000, 900000, NULL, 1, 21),
 (2, 0, 4140000, 4140000, NULL, 2, 30),
 (2, 0, 1080000, 1080000, NULL, 3, 2),
 (1, 0, 104000, 104000, NULL, 3, 5);
INSERT INTO tblAssignmentDetail8 (tblRequestForm8id, tblTechnician8id) VALUES  (1, 8), (2, 9), (2, 10), (3, 2);
INSERT INTO tblCarReceipt8 (actualCreationTime, actualReceiptTime, notes, tblCustomerCar8id, tblRequestForm8id) VALUES
 (NOW() - INTERVAL 1 DAY - INTERVAL 1 HOUR, NOW() - INTERVAL 1 DAY - INTERVAL 1 HOUR, 'Xước nhẹ cửa sau bên lái; xăng 1/4 bình', 6, 1),
 (NOW() - INTERVAL 0 DAY - INTERVAL 2 HOUR, NOW() - INTERVAL 0 DAY - INTERVAL 2 HOUR, 'Khách để lại 01 ô, 01 sạc điện thoại', 12, 2),
 (NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, NOW() - INTERVAL 2 DAY - INTERVAL 3 HOUR, 'Đèn báo lỗi động cơ sáng; mức dầu thấp', 24, 3);
