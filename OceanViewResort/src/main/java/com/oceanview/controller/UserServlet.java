package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Simple Validation
        if (username == null || password == null || role == null || username.isBlank()) {
            response.getWriter().write("error: missing parameters");
            return;
        }

        if (userDAO.isUserExists(username)) {
            response.getWriter().write("exists");
            return;
        }

        User newUser = new User(0, username, password, role);
        boolean success = userDAO.addUser(newUser);
        response.getWriter().write(success ? "success" : "error: insert failed");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<User> users = userDAO.getAllUsers();
        
        // Manual JSON building (as in your original code)
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < users.size(); i++) {
            User u = users.get(i);
            json.append("{")
                .append("\"id\":").append(u.getId()).append(",")
                .append("\"username\":\"").append(u.getUsername()).append("\",")
                .append("\"password\":\"").append(u.getPassword()).append("\",")
                .append("\"role\":\"").append(u.getRole()).append("\"")
                .append("}");
            if (i < users.size() - 1) json.append(",");
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/plain");
        String idStr = request.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);
            boolean success = userDAO.deleteUser(id);
            response.getWriter().write(success ? "success" : "error: user not found");
        } catch (NumberFormatException e) {
            response.getWriter().write("error: invalid id format");
        }
    }
}