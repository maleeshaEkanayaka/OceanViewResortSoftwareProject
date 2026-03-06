package com.oceanview.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        String[] cookieNames = {"c_user", "c_pass"};
        for (String name : cookieNames) {
            Cookie cookie = new Cookie(name, "");
            cookie.setValue(null);
            cookie.setPath(request.getContextPath()); 
            cookie.setMaxAge(0);
            response.addCookie(cookie);

            Cookie cookieRoot = new Cookie(name, "");
            cookieRoot.setPath("/");
            cookieRoot.setMaxAge(0);
            response.addCookie(cookieRoot);
        }

        response.sendRedirect("index.jsp");
    }
}