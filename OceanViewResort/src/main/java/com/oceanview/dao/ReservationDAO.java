package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public int getNextReservationId() {
        int next = 1;
        String sql = "SELECT reservation_id FROM reservations ORDER BY reservation_id";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            List<Integer> ids = new ArrayList<>();
            while (rs.next()) ids.add(rs.getInt(1));

            for (int i = 1; i <= ids.size(); i++) {
                if (!ids.contains(i)) return i;
            }
            if (!ids.isEmpty()) next = ids.get(ids.size() - 1) + 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return next;
    }

    public List<Reservation> getReservedRoomsWithGuest(String type) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT room_number, guest_name, address, contact_number, check_in, check_out, room_status " +
                     "FROM reservations WHERE room_type=? AND room_status = 'Checked-in' " +
                     "AND CURRENT_DATE BETWEEN check_in AND check_out";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reservation res = new Reservation();
                res.setRoomNumber(rs.getString("room_number"));
                res.setGuestName(rs.getString("guest_name"));
                res.setAddress(rs.getString("address"));
                res.setContactNumber(rs.getString("contact_number"));
                res.setCheckIn(rs.getDate("check_in"));
                res.setCheckOut(rs.getDate("check_out"));
                res.setStatus(rs.getString("room_status"));
                list.add(res);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateRoomStatus(String roomNum, String newStatus) {
        String sql = "UPDATE reservations SET room_status = ? WHERE room_number = ? AND room_status = 'Checked-in'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, roomNum);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY reservation_id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Reservation res = new Reservation();
                res.setId(rs.getInt("reservation_id"));
                res.setGuestName(rs.getString("guest_name"));
                res.setContactNumber(rs.getString("contact_number"));
                res.setAddress(rs.getString("address"));
                res.setRoomNumber(rs.getString("room_number"));
                res.setRoomType(rs.getString("room_type"));
                res.setCheckIn(rs.getDate("check_in"));
                res.setCheckOut(rs.getDate("check_out"));
                res.setStatus(rs.getString("room_status"));
                list.add(res);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Reservation getActiveReservationByRoom(String roomNum) {
        String sql = "SELECT * FROM reservations WHERE room_number = ? AND room_status = 'Checked-in'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, roomNum);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reservation res = new Reservation();
                res.setGuestName(rs.getString("guest_name"));
                res.setRoomType(rs.getString("room_type"));
                res.setCheckIn(rs.getDate("check_in"));
                res.setCheckOut(rs.getDate("check_out"));
                res.setEmail(rs.getString("email"));
                
                return res;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean saveBillAndCheckout(String roomNum, String guest, double total) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String billSql = "INSERT INTO bills (room_number, guest_name, total_amount) VALUES (?, ?, ?)";
            try (PreparedStatement ps1 = con.prepareStatement(billSql)) {
                ps1.setString(1, roomNum);
                ps1.setString(2, guest);
                ps1.setDouble(3, total);
                ps1.executeUpdate();
            }

            String resSql = "UPDATE reservations SET room_status = 'Checked-out' WHERE room_number = ? AND room_status = 'Checked-in'";
            try (PreparedStatement ps2 = con.prepareStatement(resSql)) {
                ps2.setString(1, roomNum);
                ps2.executeUpdate();
            }

            con.commit();
            return true;
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch (SQLException ex) {}
        }
    }

    public boolean createReservation(Reservation res) {

        if (res.getGuestName() == null || res.getGuestName().isEmpty()) {
            return false;
        }

        String sql = "INSERT INTO reservations (reservation_id, guest_name, address, email, contact_number, " +
                "room_number, room_type, check_in, check_out, room_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

        	ps.setInt(1, res.getId());
            ps.setString(2, res.getGuestName());
            ps.setString(3, res.getAddress());
            ps.setString(4, res.getEmail());
            ps.setString(5, res.getContactNumber()); 
            ps.setString(6, res.getRoomNumber());   
            ps.setString(7, res.getRoomType());     
            ps.setDate(8, res.getCheckIn());        
            ps.setDate(9, res.getCheckOut());        
            ps.setString(10, res.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}