package com.oceanview.dao;

import com.oceanview.model.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class UserDAOTest {

    private UserDAO userDAO;

    @BeforeEach
    public void setUp() {
        userDAO = new UserDAO();
    }

    @Test
    public void testAuthenticateUser_InvalidCredentials_ReturnsNull() {
        User result = userDAO.authenticateUser("fakeUser999", "wrongPassword");

        Assertions.assertNull(result, "Authentication should fail and return null for invalid credentials.");
    }

    @Test
    public void testIsUserExists_EmptyUsername_ReturnsFalse() {
        boolean exists = userDAO.isUserExists("");

        Assertions.assertFalse(exists, "Empty username should not exist in the database.");
    }
}