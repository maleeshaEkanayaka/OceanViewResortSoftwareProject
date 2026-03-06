package com.oceanview.model;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;
import java.sql.Date;

public class ReservationTest {

    @Test
    public void testReservationModelGettersSetters() {

        Reservation res = new Reservation();

        // Set values
        res.setId(50);
        res.setGuestName("John Smith");
        res.setAddress("Colombo");
        res.setEmail("john@email.com");
        res.setContactNumber("0771234567");
        res.setRoomNumber("001");
        res.setRoomType("Standard");
        res.setCheckIn(Date.valueOf("2026-04-10"));
        res.setCheckOut(Date.valueOf("2026-04-15"));
        res.setStatus("Checked-in");

        // Assertions
        assertEquals(50, res.getId());
        assertEquals("John Smith", res.getGuestName());
        assertEquals("Colombo", res.getAddress());
        assertEquals("john@email.com", res.getEmail());
        assertEquals("0771234567", res.getContactNumber());
        assertEquals("001", res.getRoomNumber());
        assertEquals("Standard", res.getRoomType());
        assertEquals(Date.valueOf("2026-04-10"), res.getCheckIn());
        assertEquals(Date.valueOf("2026-04-15"), res.getCheckOut());
        assertEquals("Checked-in", res.getStatus());
    }
}