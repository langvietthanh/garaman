package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import model.Car8;
import model.Customer8;
import model.CustomerCar8;

public class CustomerCarDAO8 extends DAO {

    public CustomerCarDAO8() {
        super();
    }

    /** Lay danh sach xe lien ket voi khach hang c. @return mang rong neu khach chua co xe */
    public CustomerCar8[] getLinkedCarList(Customer8 c) {
        ArrayList<CustomerCar8> list = new ArrayList<>();
        String sql = "SELECT cc.id AS ccId, cc.registrationDate, x.id AS carId, x.licensePlate, x.brand, "
                + "x.manufacturingYear, x.color, x.vehicleType "
                + "FROM tblCustomerCar8 cc JOIN tblCar8 x ON x.id = cc.tblCar8id "
                + "WHERE cc.tblCustomer8id = ? ORDER BY cc.registrationDate";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, c.getId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Car8 car = new Car8();
                car.setId(rs.getInt("carId"));
                car.setLicensePlate(rs.getString("licensePlate"));
                car.setBrand(rs.getString("brand"));
                car.setManufacturingYear(rs.getInt("manufacturingYear"));
                car.setColor(rs.getString("color"));
                car.setVehicleType(rs.getString("vehicleType"));
                CustomerCar8 cc = new CustomerCar8();
                cc.setId(rs.getInt("ccId"));
                cc.setRegistrationDate(rs.getDate("registrationDate"));
                cc.setCar(car);
                list.add(cc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new CustomerCar8[0]);
    }

    /** Luu xe moi; id sinh tu dong gan lai vao car. */
    public boolean saveCar(Car8 car) {
        boolean kq = false;
        String sql = "INSERT INTO tblCar8 (licensePlate, brand, manufacturingYear, color, vehicleType) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, car.getLicensePlate());
            ps.setString(2, car.getBrand());
            ps.setInt(3, car.getManufacturingYear());
            ps.setString(4, car.getColor());
            ps.setString(5, car.getVehicleType());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                car.setId(rs.getInt(1));
                kq = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }

    /**
     * Lien ket xe cc.car voi khach hang c; id sinh tu dong gan lai vao cc.
     * Khach hang truyen vao rieng vi CustomerCar8 khong giu tham chieu Customer8 (Customer8.customerCars).
     */
    public boolean saveCustomerCar(CustomerCar8 cc, Customer8 c) {
        boolean kq = false;
        String sql = "INSERT INTO tblCustomerCar8 (registrationDate, tblCar8id, tblCustomer8id) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, new java.sql.Date(cc.getRegistrationDate().getTime()));
            ps.setInt(2, cc.getCar().getId());
            ps.setInt(3, c.getId());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                cc.setId(rs.getInt(1));
                kq = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return kq;
    }
}
