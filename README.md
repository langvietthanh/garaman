# GaraMan – Module 1: Đặt lịch hẹn trực tuyến (Phiên 5)

## Chạy
1. MySQL 8 (`localhost:3306`, user `root`): chạy `garaman.sql` (tạo CSDL `garaman` + dữ liệu mẫu 14 ngày tính từ ngày mai, Chủ nhật nghỉ, sẵn 1 lịch hẹn 08:30 ngày làm việc đầu tiên).
2. Sửa mật khẩu MySQL trong `src/dao/DAO.java` (đang để `123456`).
3. Eclipse → Dynamic Web Project `GaraMan`, source folder `src`, content directory `WebContent`.
4. Chép `mysql-connector-j-8.x.jar` vào `WebContent/WEB-INF/lib/`.
5. Chạy trên Tomcat 9 hoặc 10 → mở `http://localhost:8080/GaraMan/` (vào `view/uiMainMenu8.jsp`).

Lưu ý: máy chạy MySQL và Tomcat cùng múi giờ Việt Nam (URL kết nối dùng `serverTimezone=Asia/Ho_Chi_Minh`).

## Cấu trúc (theo Hình 4.5)
- `src/model`: `WorkSchedule8`, `Appointment8`, `BookingContact8`
- `src/dao`: `DAO`, `WorkScheduleDAO8`, `AppointmentDAO8`, `BookingContactDAO8`
- `WebContent/view`: `uiMainMenu8.jsp` → `uiDateSelection8.jsp` → `uiTimeSlotSelection8.jsp` → `uiCustomerInfo8.jsp` → `uiBookingConfirmation8.jsp` → `doSaveBooking8.jsp` → về `uiBookingConfirmation8.jsp` hiện thông báo.

Đối tượng truyền giữa các trang qua `session`: `selectedDate`, `timeSlots`, `selectedTimeSlot`, `appointment`.
