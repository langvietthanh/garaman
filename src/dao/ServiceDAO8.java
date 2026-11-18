package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.Service8;

public class ServiceDAO8 extends DAO {

    public ServiceDAO8() {
        super();
    }

    /** Lay toan bo danh muc dich vu (tim theo ten loc tren giao dien). */
    public Service8[] getServices() {
        ArrayList<Service8> list = new ArrayList<>();
        String sql = "SELECT id, serviceName, description, listedPrice FROM tblService8 ORDER BY id";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Service8 s = new Service8();
                s.setId(rs.getInt("id"));
                s.setServiceName(rs.getString("serviceName"));
                s.setDescription(rs.getString("description"));
                s.setListedPrice(rs.getFloat("listedPrice"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list.toArray(new Service8[0]);
    }
}
