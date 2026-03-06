package com.oceanview.model;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

public class UserTest {

    @Test
    public void testUserCreationAndGetters() {
        User user = new User(1, "johndoe", "pass123", "Receptionist");

        Assertions.assertEquals(1, user.getId(), "User ID should match");
        Assertions.assertEquals("johndoe", user.getUsername(), "Username should match");
        Assertions.assertEquals("pass123", user.getPassword(), "Password should match");
        Assertions.assertEquals("Receptionist", user.getRole(), "Role should match");
    }

    @Test
    public void testUserSetters() {
        User user = new User();
        
        user.setUsername("admin");
        user.setRole("Manager");

        Assertions.assertEquals("admin", user.getUsername());
        Assertions.assertEquals("Manager", user.getRole());
    }
}