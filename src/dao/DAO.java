package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/** Lop DAO chung, giu ket noi CSDL dung chung (cai-dat.pdf 5.2.1, QD-04). */
public class DAO {
    public static Connection con;

    public DAO() {
        if (con == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/garaman?useUnicode=true&characterEncoding=UTF-8"
                    + "&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh";
            String dbClass = "com.mysql.cj.jdbc.Driver";
            try {
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "root"); // doi mat khau theo may
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
