package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.util.EmailUtil;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.*;

@WebServlet("/reservation")
@MultipartConfig
public class ReservationServlet extends HttpServlet {

    private ReservationDAO dao;

    @Override
    public void init() {
        dao = new ReservationDAO();
        System.out.println("✅ ReservationServlet loaded");
    }

    private String normalizeRoom(String room) {
        try {
            int n = Integer.parseInt(room.trim());
            return String.format("%03d", n);
        } catch (Exception e) {
            return room;
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ").trim();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        String action = req.getParameter("action");

        try {
            if ("nextId".equals(action)) {
                out.print(dao.getNextReservationId());
            } 
            else if ("availableRooms".equals(action)) {
                String type = req.getParameter("type");
                List<Reservation> used = dao.getReservedRoomsWithGuest(type);
                Set<String> usedSet = new HashSet<>();
                for (Reservation r : used) usedSet.add(normalizeRoom(r.getRoomNumber()));

                List<String> all = new ArrayList<>();
                int start = 1, end = 1;
                if ("Standard".equals(type)) { start = 1; end = 12; }
                else if ("Deluxe".equals(type)) { start = 13; end = 17; }
                else if ("Suite".equals(type)) { start = 18; end = 20; }

                for (int i = start; i <= end; i++) {
                    String rn = String.format("%03d", i);
                    if (!usedSet.contains(rn)) all.add(rn);
                }
                out.print("[\"" + String.join("\",\"", all) + "\"]");
            } 
            else if ("dashboard".equals(action)) {
                String[][] roomConfig = { {"Standard", "1", "12"}, {"Deluxe", "13", "17"}, {"Suite", "18", "20"} };
                StringBuilder json = new StringBuilder("{");

                for (int r = 0; r < roomConfig.length; r++) {
                    String type = roomConfig[r][0];
                    int start = Integer.parseInt(roomConfig[r][1]);
                    int end = Integer.parseInt(roomConfig[r][2]);

                    List<Reservation> reservedList = dao.getReservedRoomsWithGuest(type);
                    Map<String, Reservation> reservedMap = new HashMap<>();
                    if (reservedList != null) {
                        for (Reservation res : reservedList) reservedMap.put(normalizeRoom(res.getRoomNumber()), res);
                    }

                    if (r > 0) json.append(",");
                    json.append("\"").append(type).append("\":[");

                    for (int i = start; i <= end; i++) {
                        String rn = String.format("%03d", i);
                        Reservation details = reservedMap.get(rn);

                        json.append("{")
                            .append("\"room_number\":\"").append(rn).append("\",")
                            .append("\"guest_name\":\"").append(details != null ? escape(details.getGuestName()) : "").append("\",")
                            .append("\"address\":\"").append(details != null ? escape(details.getAddress()) : "").append("\",")
                            .append("\"contact_number\":\"").append(details != null ? escape(details.getContactNumber()) : "").append("\",")
                            .append("\"check_in\":\"").append(details != null ? details.getCheckIn().toString() : "").append("\",")
                            .append("\"check_out\":\"").append(details != null ? details.getCheckOut().toString() : "").append("\",")
                            .append("\"room_status\":\"").append(details != null ? escape(details.getStatus()) : "Available").append("\"")
                            .append("}");

                        if (i < end) json.append(",");
                    }
                    json.append("]");
                }
                json.append("}");
                out.print(json.toString());
            } 
            else if ("updateStatus".equals(action)) {
                String roomNum = normalizeRoom(req.getParameter("room_number"));
                String newStatus = req.getParameter("status");
                boolean success = dao.updateRoomStatus(roomNum, newStatus);
                out.print(success ? "success" : "error");
            } 
            else if ("allReservations".equals(action)) {
                List<Reservation> list = dao.getAllReservations();
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < list.size(); i++) {
                    Reservation res = list.get(i);
                    if (i > 0) json.append(",");
                    json.append("{")
                        .append("\"id\":\"").append(res.getId()).append("\",")
                        .append("\"guest\":\"").append(escape(res.getGuestName())).append("\",")
                        .append("\"contact\":\"").append(escape(res.getContactNumber())).append("\",")
                        .append("\"address\":\"").append(escape(res.getAddress())).append("\",")
                        .append("\"room\":\"").append(escape(res.getRoomNumber())).append("\",")
                        .append("\"type\":\"").append(escape(res.getRoomType())).append("\",")
                        .append("\"in\":\"").append(res.getCheckIn()).append("\",")
                        .append("\"out\":\"").append(res.getCheckOut()).append("\",")
                        .append("\"status\":\"").append(escape(res.getStatus())).append("\"")
                        .append("}");
                }
                json.append("]");
                out.print(json.toString());
            } 
            else if ("getBillDetails".equals(action)) {
                String roomNum = normalizeRoom(req.getParameter("room_number"));
                Reservation res = dao.getActiveReservationByRoom(roomNum);
                if (res != null) {
                    out.print("{\"guest_name\":\"" + escape(res.getGuestName()) + "\",\"room_type\":\"" + escape(res.getRoomType()) + 
                              "\",\"check_in\":\"" + res.getCheckIn() + "\",\"check_out\":\"" + res.getCheckOut() + "\"}");
                } else {
                    out.print("{}");
                }
            } 
            else if ("saveBill".equals(action)) {
                String roomNum = normalizeRoom(req.getParameter("room_number"));
                double total = Double.parseDouble(req.getParameter("total_amount"));
                String guest = req.getParameter("guest_name");
                
                Reservation res = dao.getActiveReservationByRoom(roomNum);
                
                boolean success = dao.saveBillAndCheckout(roomNum, guest, total);
                
                if (success && res != null && res.getEmail() != null && !res.getEmail().isEmpty()) {
                	new Thread(() -> {
                	    EmailUtil.sendCheckoutEmail(guest, res.getEmail(), roomNum, total);
                	}).start();
                }
                
                out.print(success ? "success" : "error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain");

        String guestName = req.getParameter("guest_name");
        String contactNumber = req.getParameter("contact_number");
        String address = req.getParameter("address");
        String email = req.getParameter("email"); 
        String roomType = req.getParameter("room_type");
        String roomNumber = normalizeRoom(req.getParameter("room_number"));
        Date checkIn = Date.valueOf(req.getParameter("check_in"));
        Date checkOut = Date.valueOf(req.getParameter("check_out"));


        if (checkOut.before(checkIn)) {
            resp.getWriter().write("invalid_date");
            return;
        }

        Reservation res = new Reservation();
        res.setId(dao.getNextReservationId());
        res.setGuestName(guestName);
        res.setAddress(address);
        res.setEmail(email); 
        res.setContactNumber(contactNumber);
        res.setRoomNumber(roomNumber);
        res.setRoomType(roomType);
        res.setCheckIn(checkIn);
        res.setCheckOut(checkOut);
        res.setStatus("Checked-in");

        boolean success = dao.createReservation(res);
        
        if (success) {
            new Thread(() -> {
                EmailUtil.sendReservationEmail(
                    guestName,
                    email,
                    roomNumber,
                    roomType,
                    checkIn.toString(),
                    checkOut.toString()
                );
            }).start();
        }
        
        resp.getWriter().write(success ? "success" : "error");
    }
}