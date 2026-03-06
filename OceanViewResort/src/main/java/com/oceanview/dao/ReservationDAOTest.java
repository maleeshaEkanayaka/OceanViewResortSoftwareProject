package com.oceanview.dao;

import com.oceanview.model.Reservation;
import org.junit.jupiter.api.*;

import java.sql.Date;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ReservationDAOTest {

    private static ReservationDAO reservationDAO;
    private static Reservation testReservation;

    @BeforeAll
    static void setup() {
        reservationDAO = new ReservationDAO();

        testReservation = new Reservation();
        testReservation.setId(reservationDAO.getNextReservationId());
        testReservation.setGuestName("Test Guest");
        testReservation.setAddress("Colombo");
        testReservation.setEmail("testguest@email.com"); 
        testReservation.setContactNumber("0771234567");
        testReservation.setRoomNumber("001");
        testReservation.setRoomType("Standard");
        testReservation.setCheckIn(Date.valueOf("2026-03-01"));
        testReservation.setCheckOut(Date.valueOf("2026-03-05"));
        testReservation.setStatus("Checked-in");
    }

    @Test
    @Order(1)
    void testCreateReservation() {
        boolean result = reservationDAO.createReservation(testReservation);
        assertTrue(result, "Reservation should be created successfully");
    }

    @Test
    @Order(2)
    void testGetAllReservations() {
        List<Reservation> list = reservationDAO.getAllReservations();
        assertNotNull(list);
        assertFalse(list.isEmpty(), "Reservation list should not be empty");
    }

    @Test
    @Order(3)
    void testGetActiveReservationByRoom() {
        Reservation res = reservationDAO.getActiveReservationByRoom("001");
        assertNotNull(res, "Active reservation should be found");
        assertEquals("Test Guest", res.getGuestName());
    }

    @Test
    @Order(4)
    void testUpdateRoomStatus() {
    	boolean updated = reservationDAO.updateRoomStatus("001", "Maintenance");
        assertTrue(updated, "Room status should update successfully");
    }

    @Test
    @Order(5)
    void testSaveBillAndCheckout() {
        boolean result = reservationDAO.saveBillAndCheckout("001", "Test Guest", 5000.00);
        assertTrue(result, "Checkout and bill save should succeed");
    }

}