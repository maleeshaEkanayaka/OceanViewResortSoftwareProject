package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import com.oceanview.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe");

        User user = userDAO.authenticateUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            new Thread(() -> EmailUtil.sendLoginAlert(user.getUsername(), user.getRole())).start();

            
            if ("on".equals(remember)) {
                Cookie uCookie = new Cookie("c_user", username);
                Cookie pCookie = new Cookie("c_pass", password); 
                
                uCookie.setPath("/"); 
                pCookie.setPath("/");

                uCookie.setMaxAge(60 * 60 * 24 * 30); 
                pCookie.setMaxAge(60 * 60 * 24 * 30);
                
                response.addCookie(uCookie);
                response.addCookie(pCookie);
            }

            response.sendRedirect("dashboard.jsp");

        } else {
            response.sendRedirect("index.jsp?error=invalid");
        }
    }
}