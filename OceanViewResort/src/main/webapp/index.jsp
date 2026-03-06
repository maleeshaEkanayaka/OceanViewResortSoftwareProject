<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
   <%
    if (session.getAttribute("username") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    Cookie[] cookies = request.getCookies();
    String cUser = null;
    String cPass = null;

    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("c_user")) cUser = c.getValue();
            if (c.getName().equals("c_pass")) cPass = c.getValue();
        }
    }

    if (cUser != null && cPass != null) {

    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ocean View Resort</title>
  <style>
    @charset "UTF-8";
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Open Sans", sans-serif;
    }

    body {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      width: 100%;
      padding: 0 10px;
      position: relative;
      background: #000;
      overflow: hidden;
    }

    body::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: url("bg.webp") no-repeat center center;
      background-size: cover;
      filter: brightness(0.5);
      z-index: -1;
    }

    .wrapper {
      width: 90%;
      max-width: 400px;
      border-radius: 8px;
      padding: clamp(20px, 5vw, 30px);
      text-align: center;
      border: 1px solid rgba(255, 255, 255, 0.5);
      backdrop-filter: blur(60px);
      -webkit-backdrop-filter: blur(60px);
      position: relative;
      z-index: 1;
      background: rgba(255, 255, 255, 0.05);
    }

    .logo {
      width: 50%;
      max-width: 200px;
      margin: 0 auto 10px auto;
    }

    h1 {
      font-family: 'Playfair Display', serif;
      font-size: clamp(1.5rem, 5vw, 3rem);
      margin-bottom: 20px;
      color: #f2e9e4;
    }

    form {
      display: flex;
      flex-direction: column;
    }

    .input-field {
      position: relative;
      border-bottom: 2px solid #ccc;
      margin: 15px 0;
    }

    .input-field label {
      position: absolute;
      top: 50%;
      left: 40px; 
      transform: translateY(-50%);
      color: #f8f9fa;
      font-size: 16px;
      pointer-events: none;
      transition: 0.15s ease;
    }

    .input-field input {
      width: 100%;
      height: 40px;
      background: transparent;
      border: none;
      outline: none;
      font-size: 16px;
      color: #fff;
      padding-left: 40px; 
      padding-right: 40px; 
    }

    .input-field input:focus ~ label,
    .input-field input:valid ~ label {
      font-size: 0.8rem;
      top: 10px;
      transform: translateY(-120%);
    }

    /* Icons inside input fields */
    .input-field svg.icon {
      position: absolute;
      left: 0;
      top: 50%;
      transform: translateY(-50%);
      width: 24px;
      height: 24px;
      fill: #f8f9fa;
    }

    .toggle-password {
      position: absolute;
      right: 0;
      top: 50%;
      transform: translateY(-50%);
      width: 24px;
      height: 24px;
      cursor: pointer;
      fill: #f8f9fa;
      transition: fill 0.3s;
    }

    .toggle-password:hover {
      fill: #f2e9e4;
    }

    button {
      background: #f2e9e4;
      color: #4a4e69;
      font-weight: 600;
      border: none;
      padding: 12px 20px;
      cursor: pointer;
      border-radius: 3px;
      font-size: 18px;
      border: 2px solid transparent;
      transition: 0.3s ease;
      margin-top: 20px;
    }

    button:hover {
      color: #fff;
      border-color: #fff;
      background: rgba(255, 255, 255, 0.15);
    }

    /* Responsive adjustments */
    @media (max-width: 500px) {
      .wrapper {
        padding: 15px 10px;
      }
      .input-field input {
        font-size: 14px;
        height: 35px;
      }
      .input-field label {
        font-size: 14px;
      }
      button {
        font-size: 14px;
        padding: 10px 15px;
      }
      h1 {
        font-size: clamp(1.2rem, 6vw, 2rem);
      }
      .logo {
        width: 60%;
        max-width: 150px;
      }
      .input-field svg.icon,
      .toggle-password {
        width: 20px;
        height: 20px;
      }
    }
    
    .remember-me {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 10px 0;
  color: #f8f9fa;
  font-size: 14px;
}
.remember-me input {
  cursor: pointer;
  accent-color: #f2e9e4;
}
  </style>
</head>


<body>
  <div class="wrapper">

    <img src="logo.png" alt="Ocean View Resort Logo" class="logo">

    <h1>OCEAN VIEW RESORT</h1>

    <form action="login" method="post">

      <div class="input-field">
        <input type="text" name="username" required>
        <label>Enter your username</label>

        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <path d="M12 12c2.7 0 4.9-2.2 4.9-4.9S14.7 2.2 12 2.2 7.1 4.4 7.1 7.1 9.3 12 12 12zm0 2.2c-3.3 0-9.8 1.7-9.8 5v2.7h19.6v-2.7c0-3.3-6.5-5-9.8-5z"/>
        </svg>
      </div>


      <div class="input-field">
        <input type="password" name="password" id="password" required>
        <label>Enter your password</label>

        <svg class="icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
    <path d="M12 2a5 5 0 0 0-5 5v3H6c-1.1 0-2 .9-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V12c0-1.1-.9-2-2-2h-1V7a5 5 0 0 0-5-5zm-3 5a3 3 0 0 1 6 0v3H9V7zm3 9a2 2 0 1 1 0-4 2 2 0 0 1 0 4z"/>
  </svg>

        <svg class="toggle-password" id="togglePassword" onclick="togglePassword()" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
          <path id="eyeIcon" d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5C21.27 7.61 17 4.5 12 4.5zm0 12a4.5 4.5 0 110-9 4.5 4.5 0 010 9zm0-7.5a3 3 0 100 6 3 3 0 000-6z"/>
        </svg>
      </div>
      
      <div class="remember-me">
    <input type="checkbox" name="rememberMe" id="rememberMe">
    <label for="rememberMe">Remember Me</label>
</div>

      <button type="submit">Log In</button>
    </form>
  </div>

  <script>
    function togglePassword() {
      const passwordInput = document.getElementById('password');
      const eyeIcon = document.getElementById('eyeIcon');
      if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        eyeIcon.setAttribute('d', 'M12 5c-7 0-11 7-11 7s2 3 5 5l-2 2 1 1 2-2c2 2 5 3 8 3s6-1 8-3l2 2 1-1-2-2c3-2 5-5 5-5s-4-7-11-7zm0 11a4 4 0 110-8 4 4 0 010 8z');
      } else {
        passwordInput.type = 'password';
        eyeIcon.setAttribute('d', 'M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5C21.27 7.61 17 4.5 12 4.5zm0 12a4.5 4.5 0 110-9 4.5 4.5 0 010 9zm0-7.5a3 3 0 100 6 3 3 0 000-6z');
      }
    }
  </script>
  
  <%
    if ("invalid".equals(request.getParameter("error"))) {
%>
<script>
    alert("Invalid username or password!");
</script>
<%
    }
%>
</body>
</html>
