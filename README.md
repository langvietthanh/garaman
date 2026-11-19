# GaraMan – Module 1: Đặt lịch hẹn trực tuyến (Phiên 5)

## Chạy
1. MySQL 8 (`localhost:3306`, user `root`): chạy `garaman.sql` (tạo CSDL `garaman` + dữ liệu mẫu 14 ngày tính từ ngày mai, Chủ nhật nghỉ, sẵn 1 lịch hẹn 08:30 ngày làm việc đầu tiên).
2. Sửa mật khẩu MySQL trong `src/dao/DAO.java` (đang để `root`).
3. Eclipse → Dynamic Web Project `GaraMan`, source folder `src`, content directory `WebContent`.
4. Chép `mysql-connector-j-8.x.jar` vào `WebContent/WEB-INF/lib/`.
5. Chạy trên Tomcat 9 hoặc 10 → mở `http://localhost:8080/GaraMan/` (vào `view/customer/uiMainMenu8.jsp`). Nhân viên bán hàng: đăng nhập tại `http://localhost:8080/GaraMan/view/auth/uiLogin8.jsp` (tài khoản mẫu `sales01` / `123456`).

Lưu ý: máy chạy MySQL và Tomcat cùng múi giờ Việt Nam (URL kết nối dùng `serverTimezone=Asia/Ho_Chi_Minh`).

## Cấu trúc (khớp package diagram: view → dao → model)
```
src/
  dao/      DAO + các lớp xxxDAO8          (gói dao)
  model/    các lớp thực thể xxx8          (gói model)
WebContent/
  view/                                    (gói view, chia theo tác nhân)
    auth/        Đăng nhập nhân viên: uiLogin8 → doLogin8 (EmployeeDAO8.checkLogin) → sales/uiMainSales8
    customer/    Module 1 – Đặt lịch hẹn trực tuyến: uiMainMenu8 → uiDateSelection8 → uiTimeSlotSelection8 → uiCustomerInfo8 → uiBookingConfirmation8 → doSaveBooking8
    sales/       Module 2 – Nhận xe vào sửa: uiMainSales8 → uiCustomerSearch8 (→ uiAddNewCustomer8) → uiCarSelection8 (→ uiAddNewCar8) → uiRequestForm8 ⇄ uiServiceSelection8 / uiPartSelection8 / uiTechnicianAssignment8 → doSaveRequestForm8 → uiCarReceipt8; receiveCar8.jspf = hàm dùng chung
    statistic/   thống kê – quản lý (chưa cài đặt)
    warehouse/   kho (chưa cài đặt)
    technician/  kỹ thuật (chưa cài đặt)
  css/garaman8.css   giao diện dùng chung module 2
  WEB-INF/web.xml, WEB-INF/lib/mysql-connector-j-8.0.33.jar
garaman.sql          tạo CSDL + dữ liệu mẫu
```

Module 1 – Đối tượng truyền giữa các trang qua `session`: `selectedDate`, `timeSlots` (`Appointment8[]`, khung đã đặt có id > 0), `selectedTimeSlot`, `appointment`.
