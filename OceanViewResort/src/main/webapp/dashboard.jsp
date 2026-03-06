<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ocean View Resort Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    /* RESET & BASE */
    * {margin:0; padding:0; box-sizing:border-box; font-family: 'Inter', sans-serif;}
    body, html {height:100%; width:100%; background:#f3f4f6; color: #1f2937;}

    /* LAYOUT */
    #dashboard { display:flex; height:100vh; overflow:hidden; }

    /* SIDEBAR */
    .sidebar {
        width:280px;
        background:#111827;
        color:#fff;
        display:flex;
        flex-direction:column;
        flex-shrink: 0;
    }
    .sidebar-header {
        padding: 30px 20px;
        text-align: center;
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }
    .sidebar-logo { width: 80px; margin-bottom: 10px; border-radius: 8px; opacity: 0.9; }
    .sidebar h2 { font-family: 'Playfair Display', serif; font-size: 1.5rem; letter-spacing: 0.5px; }
    .sidebar-sub { font-size: 0.75rem; text-transform: uppercase; color: #9ca3af; letter-spacing: 1.5px; margin-top: 5px; display: block; }

    .menu-item {
        display: flex; align-items: center; gap: 15px;
        padding: 16px 25px; color: #9ca3af; text-decoration: none;
        font-size: 0.95rem; font-weight: 500;
        border-left: 4px solid transparent;
        transition: all 0.2s;
    }
    .menu-item:hover { background: rgba(255,255,255,0.05); color: #fff; }
    .menu-item.active { background: #1f2937; border-left-color: #38bdf8; color: #fff; }
    .menu-item i { width: 20px; text-align: center; font-size: 1.1rem; }
    
    .sidebar-footer { margin-top: auto; padding: 20px; border-top: 1px solid rgba(255,255,255,0.1); }
    .menu-item.logout { color: #f87171; }
    .menu-item.logout:hover { background: rgba(239, 68, 68, 0.1); border-left-color: #ef4444; }

    /* MAIN CONTENT */
    .main-content { flex: 1; padding: 40px; overflow-y: auto; }
    .page-title { font-family: 'Playfair Display', serif; font-size: 2rem; color: #111827; margin-bottom: 30px; }

    /* SECTIONS */
    .section { display: none; animation: fadeIn 0.3s ease; }
    @keyframes fadeIn { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }

    /* DASHBOARD GRID */
    #rooms-grid-dashboard { 
        display: grid; 
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); 
        gap: 20px; 
    }

    /* ROOM CARD */
    .room-card {
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
        padding: 20px;
        position: relative;
        transition: all 0.3s ease;
        border: 1px solid #e5e7eb;
        border-left-width: 5px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 160px;
    }
    .room-card:hover { transform: translateY(-4px); box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); }
    
    /* Clickable room cards */
.room-card { cursor: pointer; }

/* Modal Styles */
.modal {
    display: none; 
    position: fixed; 
    z-index: 1000; 
    left: 0; top: 0; width: 100%; height: 100%; 
    background-color: rgba(0,0,0,0.5); 
    backdrop-filter: blur(4px);
}
.modal-content {
    background-color: #fff;
    margin: 10% auto;
    padding: 0;
    border-radius: 12px;
    width: 400px;
    box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
    overflow: hidden;
    animation: slideDown 0.3s ease;
}
@keyframes slideDown { from { transform: translateY(-50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

.modal-header { padding: 20px; background: #111827; color: white; display: flex; justify-content: space-between; align-items: center; }
.modal-body { padding: 25px; line-height: 1.6; }
.detail-row { display: flex; justify-content: space-between; margin-bottom: 10px; border-bottom: 1px solid #f3f4f6; padding-bottom: 5px; }
.detail-label { font-weight: 600; color: #6b7280; font-size: 0.85rem; }
.close-btn { cursor: pointer; font-size: 1.5rem; }

.modal-footer {
    padding: 20px;
    border-top: 1px solid #f3f4f6;
    display: flex;
    gap: 10px;
}
.btn-modal {
    flex: 1;
    padding: 10px;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    transition: 0.2s;
}
.btn-cancel-res { background: #fee2e2; color: #dc2626; }
.btn-cancel-res:hover { background: #fecaca; }
.btn-checkout-res { background: #0f172a; color: white; }
.btn-checkout-res:hover { background: #1e293b; }

    /* Room Type Colors */
    .type-Standard { border-left-color: #0ea5e9; } 
    .type-Deluxe { border-left-color: #8b5cf6; }  
    .type-Suite { border-left-color: #f59e0b; }  

    /* Card Typography */
    .room-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px; }
    .room-number { font-size: 1.5rem; font-weight: 700; color: #1f2937; line-height: 1; }
    .room-type-label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; color: #9ca3af; letter-spacing: 0.5px; }

    .room-icon { 
        font-size: 2.5rem; color: #e5e7eb; 
        align-self: center; margin: 15px 0; 
        transition: color 0.3s;
    }
    .room-card.is-reserved .room-icon { color: #fca5a5; }

    .room-footer { text-align: center; }
    
    /* Status Badges */
    .status-badge {
        display: inline-block; padding: 6px 14px;
        border-radius: 50px; font-size: 0.8rem; font-weight: 600;
        width: 100%;
    }
    .status-available { background: #ecfdf5; color: #059669; border: 1px solid #d1fae5; }
    .status-occupied { background: #fef2f2; color: #dc2626; border: 1px solid #fee2e2; }

    .guest-info { font-size: 0.9rem; font-weight: 600; color: #111827; margin-top: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

    /* FORMS */
    .card { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; max-width: 800px; margin: 0 auto; }
    .card-header { background: #f9fafb; padding: 20px; font-weight: 600; font-size: 1.1rem; border-bottom: 1px solid #e5e7eb; }
    .reservation-form { padding: 30px; }
    
    .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
    .form-group { display: flex; flex-direction: column; gap: 8px; }
    .form-group.full { grid-column: 1 / -1; }
    .form-group label { font-size: 0.85rem; font-weight: 600; color: #374151; }
    .form-group input, .form-group select { 
        padding: 12px; border: 1px solid #d1d5db; border-radius: 8px; 
        outline: none; transition: border 0.2s; font-size: 0.95rem;
    }
    .form-group input:focus, .form-group select:focus { border-color: #38bdf8; box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.1); }
    
    .btn-primary {
        background: #0f172a; color: #fff; border: none; padding: 14px 28px;
        border-radius: 8px; font-weight: 600; cursor: pointer; transition: background 0.2s;
        width: 100%; font-size: 1rem;
    }
    .btn-primary:hover { background: #1e293b; }
    
#res-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 8px; 
    margin-top: -8px;
}

#res-table thead th {
    background: #f9fafb;
    padding: 16px;
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    font-weight: 700;
    color: #6b7280;
    border: none;
}

#res-table tbody tr {
    background: #ffffff;
    transition: all 0.2s ease;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}

#res-table tbody tr:hover {
    transform: scale(1.005);
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    z-index: 10;
}

#res-table td {
    padding: 16px;
    vertical-align: middle;
    color: #4b5563;
    border-top: 1px solid #f3f4f6;
    border-bottom: 1px solid #f3f4f6;
}

#res-table td:first-child { border-left: 1px solid #f3f4f6; border-top-left-radius: 8px; border-bottom-left-radius: 8px; font-weight: 600; color: #111827; }
#res-table td:last-child { border-right: 1px solid #f3f4f6; border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

.res-status {
    padding: 4px 12px;
    border-radius: 50px;
    font-size: 0.75rem;
    font-weight: 700;
    display: inline-flex;
    align-items: center;
    gap: 5px;
}
.res-status::before {
    content: '';
    width: 6px;
    height: 6px;
    border-radius: 50%;
}

.status-checked-in { background: #ecfdf5; color: #065f46; }
.status-checked-in::before { background: #10b981; }

.status-checked-out { background: #f3f4f6; color: #374151; }
.status-checked-out::before { background: #9ca3af; }

.status-cancelled { background: #fef2f2; color: #991b1b; }
.status-cancelled::before { background: #ef4444; }

.filter-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    background: white;
    border-bottom: 1px solid #e5e7eb;
}

.search-wrapper {
    position: relative;
    width: 350px;
}

.search-wrapper i {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    color: #9ca3af;
}

.search-wrapper input {
    width: 100%;
    padding: 10px 10px 10px 35px;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    font-size: 0.9rem;
    transition: all 0.2s;
}

.search-wrapper input:focus {
    border-color: #38bdf8;
    outline: none;
    box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.1);
}


/* Billing Page Layout */
.billing-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    padding: 20px;
}

.bill-card {
    background: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.btn-action {
    width: 50px;  
}

.row-group { display: flex; gap: 15px; }
.bill-table { width: 100%; margin-bottom: 15px; border-collapse: collapse; }
.bill-table th { padding: 15px 0;text-align: left; color: #6b7280; font-size: 0.85rem; border-bottom: 1px solid #eee; }
.bill-table td { padding: 15px 0; border-bottom: 1px solid #f9fafb; }
.bill-table input { border: none; background: transparent; width: 100%; }

.add-charge-box { display: flex; gap: 5px; margin-bottom: 20px; }
.add-charge-box input { border: 1px solid #ddd; padding: 5px; border-radius: 4px; }
.add-charge-box button { background: #3b82f6; color: white; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; }

.totals-area { background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
.total-row { padding: 5px 0;display: flex; justify-content: space-between; margin-bottom: 5px; }
.grand-total { font-weight: bold; font-size: 1.2rem; color: #0f172a; border-top: 1px solid #ddd; padding-top: 10px; margin-top: 5px; }

.btn-print { width: 100%; background: #0f172a; color: white; padding: 12px; border: none; border-radius: 6px; font-size: 1rem; cursor: pointer; }
.btn-print:hover { background: #1e293b; }

.btn-remove { color: red; cursor: pointer; border: none; background: none; }


/* PRINT STYLE  */
@media print {
    body * { visibility: hidden; }
    #printable-invoice, #printable-invoice * { visibility: visible; }
    #printable-invoice {
        display: block !important;
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
    }
    
    .invoice-box {
        max-width: 800px;
        margin: auto;
        padding: 30px;
        border: 1px solid #eee;
        font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
        color: #555;
    }
    
    .ocean-title { color: #0284c7; margin-bottom: 5px; }
    .inv-header { text-align: center; margin-bottom: 40px; }
    .inv-details { display: flex; justify-content: space-between; margin-bottom: 40px; }
    
    .inv-table { width: 100%; line-height: inherit; text-align: left; border-collapse: collapse; }
    .inv-table td { padding: 5px; vertical-align: top; }
    .inv-table tr.heading td { background: #eee; border-bottom: 1px solid #ddd; font-weight: bold; }
    .inv-table tr.item td { border-bottom: 1px solid #eee; }
    .inv-table tr.total td { border-top: 2px solid #eee; font-weight: bold; text-align: right; }
    .inv-table tr.grand-total-row td { border-top: 2px solid #333; font-weight: bold; font-size: 1.2em; text-align: right; color: #0284c7; }
    .spacer-row td {
    height: 18px;   
    border: none !important;
}
    
    .inv-footer { margin-top: 50px; text-align: center; font-size: 0.8rem; }
    .signature-line { margin-top: 50px; border-top: 1px solid #333; width: 200px; margin-left: auto; margin-right: auto; padding-top: 5px; }
}
    
    
/* Help Section Styling */
.help-container {
    max-width: 1000px;
    margin: 20px 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #333;
}

.help-card {
    background: #fff;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    margin-bottom: 25px;
    border-left: 5px solid #1a233a; 
}

.help-section-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 25px;
}

.help-card h3, .help-card h4 {
    margin-top: 0;
    color: #1a233a;
    display: flex;
    align-items: center;
    gap: 10px;
}

.help-card p {
    line-height: 1.6;
    color: #555;
}

.help-card ol, .help-card ul {
    padding-left: 20px;
    line-height: 1.8;
}

.status-indicator {
    width: 40px;
    height: 6px;
    border-radius: 3px;
    margin-bottom: 15px;
}
.status-indicator.available { background-color: #2ecc71; }
.status-indicator.reserved { background-color: #e74c3c; }

.badge-available {
    background: #e8f8f0;
    color: #2ecc71;
    padding: 2px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.85em;
}

.badge-reserved {
    background: #fdeaea;
    color: #e74c3c;
    padding: 2px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.85em;
}

.support-footer {
    text-align: center;
    margin-top: 40px;
    padding: 20px;
    border-top: 1px solid #ddd;
    font-style: italic;
    color: #777;
}

@media (max-width: 768px) {
    .help-section-grid {
        grid-template-columns: 1fr;
    }
}   


#manage-users .page-title {
    font-family: 'Playfair Display', serif;
    font-size: 2rem;
    color: #111827;
    margin-bottom: 30px;
    text-align: left;
}

#manage-users .card {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    overflow: hidden;
    margin-bottom: 30px;
}

#manage-users .card-header {
    background: #f9fafb;
    padding: 20px;
    font-weight: 600;
    font-size: 1.1rem;
    border-bottom: 1px solid #e5e7eb;
}

#manage-users #user-form {
    padding: 30px 25px;
}

#manage-users .form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

#manage-users .form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

#manage-users .form-group.full { grid-column: 1 / -1; }

#manage-users label {
    font-size: 0.85rem;
    font-weight: 600;
    color: #374151;
}

#manage-users input,
#manage-users select {
    padding: 12px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 0.95rem;
    outline: none;
    transition: border 0.2s ease, box-shadow 0.2s ease;
}

#manage-users input:focus,
#manage-users select:focus {
    border-color: #38bdf8;
    box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.1);
}


#manage-users .btn-primary {
    width: 100%;
    background: #0f172a;
    color: #fff;
    border: none;
    padding: 14px 28px;
    border-radius: 8px;
    font-weight: 600;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s ease;
}

#manage-users .btn-primary:hover {
    background: #1e293b;
}


@media (max-width: 768px) {
    #manage-users .form-grid {
        grid-template-columns: 1fr;
    }
}
    
</style>
</head>

<body>

<div id="dashboard">

    <div class="sidebar">
        <div class="sidebar-header">
            <img src="logo.png" class="sidebar-logo" alt="Logo">
            <h2>Ocean View</h2>
            <span class="sidebar-sub">Resort Management</span>
        </div>

        <a class="menu-item active" onclick="showSection('dashboard-rooms', this)">
            <i class="fa-solid fa-gauge-high"></i><span>Dashboard</span>
        </a>
        <a class="menu-item" onclick="showSection('add-reservation', this)">
            <i class="fa-solid fa-plus-circle"></i><span>New Reservation</span>
        </a>
        <a class="menu-item" onclick="showSection('view-reservation', this)">
            <i class="fa-solid fa-list-check"></i><span>Reservations</span>
        </a>
        <a class="menu-item" onclick="showSection('calculate-bill', this)">
            <i class="fa-solid fa-calculator"></i><span>Billing</span>
        </a>
        <%
String role = (String) session.getAttribute("role");
if ("admin".equals(role)) {
%>

<a class="menu-item" onclick="showSection('manage-users', this)">
    <i class="fa-solid fa-users"></i><span>Manage Users</span>
</a>

<% } %>
        <a class="menu-item" onclick="showSection('help', this)">
            <i class="fa-regular fa-circle-question"></i><span>Help</span>
        </a>

        <div class="sidebar-footer">
            <a class="menu-item logout" onclick="logout()">
                <i class="fa-solid fa-arrow-right-from-bracket"></i><span>Log Out</span>
            </a>
        </div>
    </div>

    <div class="main-content">

        <div id="dashboard-rooms" class="section" style="display:block;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <h1 class="page-title" style="margin-bottom: 0;">Room Status</h1>
        
        <div class="filter-bar" style="display: flex; gap: 15px;">
        	<div class="form-group" style="flex-direction: row; align-items: center;">
    			<label style="margin-right: 10px; font-size: 0.8rem; color: #6b7280;">SEARCH</label>
    			<input type="text" id="search-room" onkeyup="filterRooms()" placeholder="Room ID" 
           			style="padding: 8px; border-radius: 6px; border: 1px solid #d1d5db; width: 100px;">
			</div>
            <div class="form-group" style="flex-direction: row; align-items: center;">
                <label style="margin-right: 10px; font-size: 0.8rem; color: #6b7280;">TYPE</label>
                <select id="filter-type" onchange="filterRooms()" style="padding: 8px; border-radius: 6px; border: 1px solid #d1d5db;">
                    <option value="All">All Types</option>
                    <option value="Standard">Standard</option>
                    <option value="Deluxe">Deluxe</option>
                    <option value="Suite">Suite</option>
                </select>
            </div>
            <div class="form-group" style="flex-direction: row; align-items: center;">
                <label style="margin-right: 10px; font-size: 0.8rem; color: #6b7280;">STATUS</label>
                <select id="filter-status" onchange="filterRooms()" style="padding: 8px; border-radius: 6px; border: 1px solid #d1d5db;">
                    <option value="All">All Status</option>
                    <option value="Available">Available</option>
                    <option value="Reserved">Reserved</option>
                </select>
                
                <a href="javascript:void(0)" onclick="resetFilters()" style="font-size: 0.75rem; color: #38bdf8; text-decoration: none;">Reset</a>
            </div>
        </div>
    </div>
    
    <div id="rooms-grid-dashboard"></div>
</div>

        <div id="add-reservation" class="section">
            <h1 class="page-title">New Reservation</h1>
            <div class="card">
                <div class="card-header">Guest & Room Details</div>
                <form id="reservation-form" method="post" class="reservation-form">
                    
                    <div class="form-group full" style="margin-bottom: 20px; background: #f0f9ff; padding: 15px; border-radius: 8px; border: 1px dashed #bae6fd;">
                        <label style="color:#0369a1;">Reservation ID</label>
                        <input type="text" id="reservationNumber" readonly style="background:transparent; border:none; font-weight:bold; font-size:1.1rem; color:#0c4a6e; padding:0;">
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Guest Name</label>
                            <input type="text" name="guest_name" placeholder="Full Name" required>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="contact_number" placeholder="+94 7X..." required>
                        </div>
                        <div class="form-group full">
                            <label>Address</label>
                            <input type="text" name="address" placeholder="Permanent Address" required>
                        </div>
                        <div class="form-group full">
    <label>Email</label>
    <input type="email" name="email" placeholder="example@gmail.com" >
</div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Room Type</label>
                            <select id="room-type" name="room_type" required>
                                <option value="">Select Type</option>
                                <option value="Standard">Standard</option>
                                <option value="Deluxe">Deluxe</option>
                                <option value="Suite">Suite</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Room Number</label>
                            <select id="room-number" name="room_number" disabled required>
                                <option value="">Select Room</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label>Check-in</label>
                            <input type="date" id="check_in" name="check_in" required>
                        </div>
                        <div class="form-group">
                            <label>Check-out</label>
                            <input type="date" id="check_out" name="check_out" required>
                        </div>
                    </div>

                    <button type="submit" id="btn-confirm-booking" class="btn-primary">Confirm Booking</button>
                </form>
            </div>
        </div>

        <div id="view-reservation" class="section">
    <h1 class="page-title">All Reservations</h1>
    <div class="card" style="max-width: 100%;">
        <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
            <span>Reservation History</span>
            <button onclick="loadAllReservations()" style="padding:5px 10px; font-size:0.8rem; cursor:pointer;">
                <i class="fa-solid fa-sync"></i> Refresh
            </button>
        </div>

        <div style="padding: 15px 20px; background: #f9fafb; border-bottom: 1px solid #e5e7eb; display: flex; gap: 10px; flex-wrap: wrap;">
            <input type="text" id="res-search-input" onkeyup="filterReservations()" 
                   placeholder="Search Guest Name, Room, or ID..." 
                   style="padding: 8px; border: 1px solid #d1d5db; border-radius: 4px; width: 250px;">
            
            <select id="res-filter-status" onchange="filterReservations()" 
                    style="padding: 8px; border: 1px solid #d1d5db; border-radius: 4px;">
                <option value="All">All Statuses</option>
                <option value="Checked-in">Checked-in</option>
                <option value="Checked-out">Checked-out</option>
                <option value="Cancelled">Cancelled</option>
            </select>
        </div>

        <div style="overflow-x: auto; padding: 20px;">
            <table id="res-table" style="width:100%; border-collapse: collapse; font-size:0.9rem;">
                <thead>
                    <tr style="text-align:left; border-bottom:2px solid #f3f4f6; color:#6b7280;">
                        <th style="padding:12px;">ID</th>
                        <th style="padding:12px;">Guest</th>
                        <th style="padding:12px;">Contact</th>
                        <th style="padding:12px;">Address</th>
                        <th style="padding:12px;">Room</th>
                        <th style="padding:12px;">Check-In</th>
                        <th style="padding:12px;">Check-Out</th>
                        <th style="padding:12px;">Status</th>
                    </tr>
                </thead>
                <tbody id="res-table-body"></tbody>
            </table>
        </div>
    </div>
</div>




        <div id="calculate-bill" class="section">
    <h1 class="page-title">Billing & Check-out</h1>
    
    <div class="billing-container" style="padding: 10px 0;">
        <div class="bill-card">
            <div class="card-header">Reservation Details</div>
            <div class="form-group" style="padding: 10px 0;">
                <label>Room Number</label>
                <div style="display:flex; gap:10px;">
                    <input type="text" id="billing-room-number" placeholder="000" onblur="fetchBillDetails()">
                    <button class="btn-action" onclick="fetchBillDetails()" ><i class="fa-solid fa-search"></i></button>
                </div>
            </div>
            <div class="form-group" style="padding: 10px 0;">
                <label>Guest Name</label>
                <input type="text" id="billing-guest">
            </div>
            <div class="row-group">
                <div class="form-group"style="padding: 10px 0;">
                    <label>Check In</label>
                    <input type="date" id="billing-checkin" onchange="calculateBill()">
                </div>
                <div class="form-group"style="padding: 10px 0;">
                    <label>Check Out</label>
                    <input type="date" id="billing-checkout" onchange="calculateBill()">
                </div>
            </div>
            <div class="form-group"style="padding: 10px 0;">
                <label>Room Type</label>
                <select id="billing-type" onchange="calculateBill()">
                    <option value="Standard">Standard (Rs. 3500)</option>
                    <option value="Deluxe">Deluxe (Rs. 7500)</option>
                    <option value="Suite">Suite (Rs. 10000)</option>
                </select>
            </div>
        </div>

        <div class="bill-card">
            <div class="card-header">Charges Breakdown</div>
            
            <table class="bill-table">
                <thead>
                    <tr>
                        <th>Description</th>
                        <th width="160">Amount</th>
                        <th width="20">Action</th>
                    </tr>
                </thead>
                <tbody id="bill-items-body">
                    <tr class="fixed-row">
                        <td>Room Charge (<span id="total-days">0</span> days)</td>
                        <td><input type="text" id="bill-room-total" readonly value="0"></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

            <div class="add-charge-box">
                <input type="text" id="new-item-desc" placeholder="Add Item (e.g. Dinner, Spa)">
                <input type="number" id="new-item-price" placeholder="Price">
                <button type="button" onclick="addBillItem()">+</button>
            </div>

            <div class="totals-area">
    <div class="total-row">
        <span>Subtotal:</span>
        <span id="bill-subtotal">Rs. 0</span>
    </div>
    <div class="total-row">
        <span>Service Charge (10%):</span>
        <span id="bill-service">Rs. 0</span>
    </div>
    <div class="total-row grand-total">
        <span>Grand Total:</span>
        <span id="bill-grand-total">Rs. 0</span>
    </div>
</div>

<button id="btn-confirm-pay" class="btn-print" style="background: #059669; margin-bottom: 10px;" onclick="confirmPayment()">
    <i class="fa-solid fa-check-circle"></i> Confirm Payment & Check-out
</button>

<button id="btn-print-bill" class="btn-print" style="display: none; background: #0f172a;" onclick="printInvoice()">
    <i class="fa-solid fa-print"></i> Print Official Receipt
</button>
        </div>
    </div>
</div>

<div id="printable-invoice" style="display:none;">
    <div class="invoice-box">
        <div class="inv-header">
            <h1 class="ocean-title">OCEAN VIEW RESORT</h1>
            <p>123 Beach Road, Galle, Sri Lanka</p>
            <p>Tel: +94 11 234 5678</p>
        </div>
        
        <div class="inv-details">
            <div>
                <strong>Billed To:</strong><br>
                <span id="inv-guest-name">Guest Name</span><br>
                Room: <span id="inv-room-num">000</span>
            </div>
            <div style="text-align:right;">
                <strong>Invoice #:</strong> <span id="inv-number">INV-001</span><br>
                <strong>Date:</strong> <span id="inv-date">2023-01-01</span>
            </div>
        </div>

        <table class="inv-table">
            <thead>
                <tr class="heading">
                    <td>Description</td>
                    <td style="text-align:right;">Price</td>
                </tr>
            </thead>
            <tbody id="inv-items-body">
                </tbody>
            <tfoot>
            	<tr class="spacer-row"><td colspan="2">&nbsp;</td></tr>
    			<tr class="spacer-row"><td colspan="2">&nbsp;</td></tr>
    			<tr class="spacer-row"><td colspan="2">&nbsp;</td></tr>
    			
                <tr class="total">
                    <td>Subtotal</td>
                    <td id="inv-subtotal">Rs. 0.00</td>
                </tr>
                <tr class="total">
                    <td>Service Charge (10%)</td>
                    <td id="inv-service">Rs. 0.00</td>
                </tr>
                <tr class="grand-total-row">
                    <td>Grand Total</td>
                    <td id="inv-total">Rs. 0.00</td>
                </tr>
            </tfoot>
        </table>

        <div class="inv-footer">
            <p>Thank you for staying with us!</p>
        </div>
    </div>
</div>



			<div id="manage-users" class="section">
    <h1 class="page-title">User Management</h1>

    <div class="card">
        <div class="card-header">Add New User</div>
        <form id="user-form">
            <div class="form-grid">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <select id="role" name="role" required>
                        <option value="">Select Role</option>
                        <option value="admin">Admin</option>
                        <option value="staff">Staff</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn-primary">Create User</button>
        </form>
    </div>

    <div class="card" style="margin-top: 2rem;">
        <div class="card-header">All Users</div>
        <div style="overflow-x: auto;">
            <table style="width: 100%; border-collapse: collapse; text-align: left;">
                <thead>
    <tr style="border-bottom: 2px solid #ddd;">
        <th style="padding: 10px; text-align: center;">ID</th>
        <th style="padding: 10px; text-align: center;">Username</th>
        <th style="padding: 10px; text-align: center;">Password</th> 
        <th style="padding: 10px; text-align: center;">Role</th>
        <th style="padding: 10px; text-align: center;">Action</th>
    </tr>
</thead>
                <tbody id="user-table-body">
                    </tbody>
            </table>
        </div>
    </div>
</div>


        <div id="help" class="section">
    <h1 class="page-title">System Help</h1>
    
    <div class="help-container">
        <div class="help-card">
            <h3><i class="fas fa-rocket"></i> Getting Started</h3>
            <p>Welcome to the Ocean View Management System. Use the sidebar to navigate between your daily tasks.</p>
        </div>

        <div class="help-section-grid">
            <div class="help-card">
                <div class="status-indicator available"></div>
                <h4>Handling Available Rooms</h4>
                <p>To create a new booking:</p>
                <ol>
                    <li>Go to the <strong>Dashboard</strong>.</li>
                    <li>Click on any room card marked as <span class="badge-available">Available</span>.</li>
                    <li>You will be redirected to the <strong>New Reservation</strong> form automatically.</li>
                    <li>Fill in the guest details and click "Confirm Booking".</li>
                </ol>
            </div>

            <div class="help-card">
                <div class="status-indicator reserved"></div>
                <h4>Managing Reserved Rooms</h4>
                <p>Clicking a <span class="badge-reserved">Reserved</span> room opens the management modal:</p>
                <ul>
                    <li><strong>Cancel:</strong> Use this if a guest voids their stay. The reservation and pending bill will be removed.</li>
                    <li><strong>Check-out:</strong> Click this when a guest is ready to leave. You will be redirected to the <strong>Billing Page</strong>.</li>
                </ul>
            </div>
        </div>

        <div class="help-card">
            <h4><i class="fas fa-file-invoice-dollar"></i> Billing & Checkout</h4>
            <p>Once on the Billing page, you can add additional services (Spa, Dinner, etc.) to the guest's bill. Ensure the <strong>Check-out date</strong> is correct to calculate the final room charge before clicking "Confirm Payment".</p>
        </div>
        
        <div class="support-footer">
            <p>Need technical assistance? Contact the system administrator at <strong>support@oceanview.com</strong></p>
        </div>
    </div>
</div>

    </div>
</div>

<div id="guestModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3 id="modalRoomTitle">Room Details</h3>
            <span class="close-btn" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body" id="modalBody">
            </div>
    </div>
</div>

<script>

//Define the context path once using a JSP expression
const contextPath = '<%= request.getContextPath() %>';

document.addEventListener("DOMContentLoaded", loadUsers);

// Handle Form Submission
document.getElementById('user-form').addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new URLSearchParams(new FormData(this));
    
    fetch(contextPath + '/user', {
        method: 'POST',
        body: formData,
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
    .then(response => response.text())
    .then(result => {
        const status = result.trim();
        if (status === 'success') {
            alert("User created successfully!");
            this.reset();
            loadUsers(); // Refresh the table
        } else if (status === 'exists') {
            alert("Username already exists!");
        } else {
            alert("Error: " + status);
        }
    })
    .catch(error => console.error("Error:", error));
});

// Fetch and Display Users
function loadUsers() {
    fetch(contextPath + '/user') 
        .then(response => {
            if (!response.ok) throw new Error("HTTP error " + response.status);
            return response.json();
        })
        .then(users => {
            const tbody = document.getElementById('user-table-body');
            tbody.innerHTML = '';
            
            users.forEach(user => {
                // Use '+' for concatenation to avoid JSP EL errors
                let row = '<tr style="border-bottom: 1px solid #eee;">' +
                    '<td style="padding: 10px; text-align: center;">' + user.id + '</td>' +
                    '<td style="padding: 10px; text-align: center;">' + user.username + '</td>' +
                    '<td style="padding: 10px; text-align: center;">' + user.password + '</td>' +
                    '<td style="padding: 10px; text-align: center;">' + user.role + '</td>' +
                    '<td style="padding: 10px; text-align: center;">' +
                        '<button onclick="deleteUser(' + user.id + ')" style="color: #dc3545; border: none; background: none; cursor: pointer;">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">' +
                              '<path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>' +
                            '</svg>' +
                        '</button>' +
                    '</td>' +
                '</tr>';
                tbody.innerHTML += row;
            });
        })
        .catch(error => console.error("Fetch error:", error));
}

// Delete User
function deleteUser(id) {
    if (confirm("Delete this user?")) {
        fetch(contextPath + '/user?id=' + id, { method: 'DELETE' }) 
            .then(response => response.text())
            .then(result => {
                if (result.trim() === 'success') {
                    loadUsers();
                } else {
                    alert("Delete failed: " + result);
                }
            })
            .catch(error => console.error("Delete error:", error));
    }
}

const checkInInput  = document.getElementById("check_in");
const checkOutInput = document.getElementById("check_out");

checkInInput.addEventListener("change", function () {
    if (!this.value) return;

    const minCheckout = this.value;

    checkOutInput.min = minCheckout;

    if (checkOutInput.value && checkOutInput.value < minCheckout) {
        checkOutInput.value = minCheckout;
    }
});

function showSection(id, el, isPopState = false) {
    document.querySelectorAll('.section').forEach(s => s.style.display = 'none');
    const targetSection = document.getElementById(id);
    if (targetSection) targetSection.style.display = 'block';

    document.querySelectorAll('.menu-item').forEach(m => m.classList.remove('active'));
    
    if (isPopState) {
        const activeMenu = document.querySelector(`[onclick*="${id}"]`);
        if (activeMenu) activeMenu.classList.add('active');
    } else {
        if (el) el.classList.add('active');
        history.pushState({ sectionId: id }, "", "#" + id);
    }

    if (id === 'dashboard-rooms') loadDashboardRooms();
    if (id === 'add-reservation') loadReservationNumber();
    if (id === 'view-reservation') loadAllReservations();
}




function loadDashboardRooms() {
    fetch(contextPath + '/reservation?action=dashboard&t=' + new Date().getTime())
        .then(res => {
            if (!res.ok) throw new Error('Network response was not ok');
            return res.json();
        })
        .then(data => {
            console.log("Data received:", data); 
            cachedRoomsData = data; 
            
            renderRooms(data);
        })
        .catch(err => console.error("Error loading dashboard:", err));
}





function renderRooms(data) {
    const grid = document.getElementById('rooms-grid-dashboard');
    grid.innerHTML = '';

    const typeFilter = document.getElementById('filter-type').value;
    const statusFilter = document.getElementById('filter-status').value;
    const searchQuery = document.getElementById('search-room').value.trim().toLowerCase();

    ["Standard", "Deluxe", "Suite"].forEach(type => {
        if (!Array.isArray(data[type])) return;

        if (typeFilter !== 'All' && typeFilter !== type) return;

        data[type].forEach(room => {
            const guestName = room.guest_name ? room.guest_name.trim() : "";
            const isReserved = room.guest_name && 
                               room.guest_name.trim() !== "" && 
                               room.room_status === "Checked-in";

            if (statusFilter !== 'All') {
                if (statusFilter === 'Reserved' && !isReserved) return;
                if (statusFilter === 'Available' && isReserved) return;
            }

            if (searchQuery !== "" && !room.room_number.includes(searchQuery)) {
                return;
            }

            const div = document.createElement('div');
            div.className = 'room-card type-' + type + (isReserved ? ' is-reserved' : '');
            
            div.onclick = function() {
                if (isReserved) {
                    showGuestDetails(room); 
                } else {
                    showSection('add-reservation', document.querySelector('[onclick*="add-reservation"]'));
                    autoSelectRoom(type, room.room_number);
                }
            };

            const iconClass = isReserved ? 'fa-user-check' : 'fa-bed';
            const statusHtml = isReserved 
                ? '<span class="status-badge status-occupied">Reserved</span> <div class="guest-info">' + guestName + '</div>'
                : '<span class="status-badge status-available">Available</span>';

            div.innerHTML = 
                '<div class="room-header">' +
                    '<span class="room-number">' + room.room_number + '</span>' +
                    '<span class="room-type-label">' + type + '</span>' +
                '</div>' +
                '<i class="fa-solid ' + iconClass + ' room-icon"></i>' +
                '<div class="room-footer">' + statusHtml + '</div>';

            grid.appendChild(div);
        });
    });

    if(grid.innerHTML === '') {
        grid.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #9ca3af;">No rooms match your search.</div>';
    }
}

function filterRooms() {
    if (cachedRoomsData) {
        renderRooms(cachedRoomsData);
    } else {
        loadDashboardRooms();
    }
}

function resetFilters() {
    document.getElementById('search-room').value = '';
    document.getElementById('filter-type').value = 'All';
    document.getElementById('filter-status').value = 'All';
    filterRooms();
}





function showGuestDetails(room) {
    console.log("Room Object Received:", room);
    
    const modal = document.getElementById('guestModal');
    const body = document.getElementById('modalBody');
    document.getElementById('modalRoomTitle').innerText = 'Room ' + room.room_number;

    const val = (v) => (v && v !== "null" && v.trim() !== "") ? v : 'N/A';
    const dateVal = (v) => (v && v !== "null" && v.trim() !== "") ? v : '----';

    body.innerHTML = 
        '<div class="detail-row"><span class="detail-label">Guest Name:</span> <span>' + val(room.guest_name) + '</span></div>' +
        '<div class="detail-row"><span class="detail-label">Contact:</span> <span>' + val(room.contact_number) + '</span></div>' +
        '<div class="detail-row"><span class="detail-label">Address:</span> <span>' + val(room.address) + '</span></div>' +
        
        '<div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:15px; background:#f9fafb; padding:10px; border-radius:8px; border: 1px solid #e5e7eb;">' +
            '<div><span class="detail-label" style="display:block; font-size:0.7rem; color:#6b7280;">CHECK-IN</span><span style="font-weight:600; font-size:0.9rem;">' + dateVal(room.check_in) + '</span></div>' +
            '<div><span class="detail-label" style="display:block; font-size:0.7rem; color:#6b7280;">CHECK-OUT</span><span style="font-weight:600; font-size:0.9rem;">' + dateVal(room.check_out) + '</span></div>' +
        '</div>' +

        '<div class="detail-row" style="margin-top:15px; border:none; display:flex; align-items:center; gap:8px;">' +
            '<span class="detail-label">Status:</span>' +
            '<span style="background:#dcfce7; color:#15803d; padding:2px 10px; border-radius:12px; font-size:0.8rem; font-weight:700;">Checked In</span>' +
        '</div>' +

        '<div class="modal-footer" style="display:flex; gap:10px; margin-top:20px; padding-top:15px; border-top:1px solid #eee;">' +
            '<button class="btn-modal btn-cancel-res" onclick="updateRoomStatus(\'' + room.room_number + '\', \'Cancelled\')">Cancel</button>' +
            '<button class="btn-modal btn-checkout-res" onclick="proceedToCheckout(\'' + room.room_number + '\')">Check-out</button>' +
        '</div>';
    
    modal.style.display = "block";
}


function updateRoomStatus(roomNum, status) {
    if(!confirm("Are you sure you want to cancel this reservation?")) return;

    fetch(contextPath + '/reservation?action=updateStatus&room_number=' + roomNum + '&status=' + status)
        .then(res => res.text())
        .then(data => {
            if(data.trim() === 'success') {
                alert("Reservation " + status);
                closeModal();
                loadDashboardRooms(); 
            } else {
                alert("Failed to update status");
            }
        });
}


function proceedToCheckout(roomNum) {

    if (!confirm("Are you sure you want to proceed to check-out for Room " + roomNum + "?")) {
        return;
    }

    const billingMenu = document.querySelector('[onclick*="calculate-bill"]');
    showSection('calculate-bill', billingMenu);
    
    const billingRoomInput = document.getElementById('billing-room-number'); 
    if (billingRoomInput) {
        billingRoomInput.value = roomNum;
        fetchBillDetails(); 
    }
    closeModal();
}

function closeModal() {
    document.getElementById('guestModal').style.display = "none";
}

window.onclick = function(event) {
    let modal = document.getElementById('guestModal');
    if (event.target == modal) closeModal();
}




function autoSelectRoom(type, roomNum) {
    const typeSelect = document.getElementById('room-type');
    const roomSelect = document.getElementById('room-number');
    
    typeSelect.value = type;
    
    fetch(contextPath + '/reservation?action=availableRooms&type=' + type)
        .then(res => res.json())
        .then(data => {
            roomSelect.innerHTML = '<option value="">Select Room Number</option>';
            
            data.forEach(r => {
                let o = document.createElement('option');
                o.value = r; 
                o.text = r;
                roomSelect.appendChild(o);
            });

            roomSelect.value = roomNum; 
            roomSelect.disabled = false;
            roomSelect.style.opacity = "1";
        });
}




function loadReservationNumber(){
    fetch(contextPath + '/reservation?action=nextId')
        .then(res=>res.text())
        .then(id=>document.getElementById('reservationNumber').value=id);
}


let cachedReservationList = [];

function loadAllReservations() {
    const tbody = document.getElementById('res-table-body');
    if (!tbody) return;

    tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:20px;">Loading...</td></tr>';

    fetch(contextPath + '/reservation?action=allReservations&t=' + new Date().getTime())
        .then(res => res.json())
        .then(data => {
            cachedReservationList = data || [];

            document.getElementById('res-search-input').value = '';
            document.getElementById('res-filter-status').value = 'All';

            renderReservationTable(cachedReservationList);
        })
        .catch(err => {
            console.error("Fetch error:", err);
            tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:20px; color:red;">Error loading data.</td></tr>';
        });
}

function filterReservations() {
    const searchQuery = document.getElementById('res-search-input').value.toLowerCase().trim();
    const statusFilter = document.getElementById('res-filter-status').value;

    const filteredData = cachedReservationList.filter(row => {
        const matchesStatus = (statusFilter === 'All') || (row.status === statusFilter);

        const guest = (row.guest || '').toLowerCase();
        const id = String(row.id).toLowerCase();
        const room = String(row.room).toLowerCase();
        
        const matchesSearch = guest.includes(searchQuery) || 
                              id.includes(searchQuery) || 
                              room.includes(searchQuery);

        return matchesStatus && matchesSearch;
    });

    renderReservationTable(filteredData);
}

function renderReservationTable(data) {
    const tbody = document.getElementById('res-table-body');
    tbody.innerHTML = '';

    if (!data || data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:20px; color:#6b7280;">No matching reservations found.</td></tr>';
        return;
    }

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.style.borderBottom = "1px solid #f3f4f6";

        let statusStyle = "color: #6b7280; font-weight:bold;";
        if(row.status === 'Checked-in') statusStyle = "color: #059669; font-weight:bold;";
        else if(row.status === 'Cancelled') statusStyle = "color: #dc2626; font-weight:bold;";
        else if(row.status === 'Checked-out') statusStyle = "color: #3b82f6; font-weight:bold;";

        let html = '<td style="padding:12px;">#' + row.id + '</td>';
        html += '<td style="padding:12px; font-weight:600;">' + row.guest + '</td>';
        html += '<td style="padding:12px;">' + row.contact + '</td>'; 
        html += '<td style="padding:12px; font-size:0.8rem; color:#6b7280; max-width:150px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">' + row.address + '</td>'; 
        html += '<td style="padding:12px;"><span style="background:#f3f4f6; padding:2px 8px; border-radius:4px;">' + row.room + '</span></td>';
        html += '<td style="padding:12px;">' + row.in + '</td>';
        html += '<td style="padding:12px;">' + row.out + '</td>';
        html += '<td style="padding:12px;"><span style="' + statusStyle + '">' + row.status + '</span></td>';
        
        tr.innerHTML = html;
        tbody.appendChild(tr);
    });
}



document.getElementById('room-type').addEventListener('change', function(){
    const roomSelect = document.getElementById('room-number');
    roomSelect.disabled = true;
    roomSelect.style.opacity = "0.6";

    fetch(contextPath + '/reservation?action=availableRooms&type=' + this.value)
        .then(res=>res.json())
        .then(data=>{
            roomSelect.innerHTML='<option value="">Select Room Number</option>';
            data.forEach(r=>{
                let o=document.createElement('option');
                o.value=r; 
                o.text=r;
                roomSelect.appendChild(o);
            });
            roomSelect.disabled = false;
            roomSelect.style.opacity = "1";
        });
});



document.getElementById('reservation-form').addEventListener('submit', function(e){
	e.preventDefault();
    
	const checkIn  = new Date(document.getElementById("check_in").value);
    const checkOut = new Date(document.getElementById("check_out").value);
    const submitBtn = document.getElementById("btn-confirm-booking");

    if (checkOut < checkIn) {
        alert("Check-out date cannot be before check-in date.");
        return false;
    }

    document.getElementById('room-number').disabled = false;
    
    submitBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Processing...';
    submitBtn.disabled = true;


    fetch(contextPath + '/reservation', { method:'POST', body:new FormData(this) })
        .then(res=>res.text())
        .then(r=>{
            if(r === 'success'){
                alert('Reservation saved successfully!');
                this.reset();
                document.getElementById('room-number').disabled = true; 
                showSection('dashboard-rooms', document.querySelectorAll('.menu-item')[0]);
            } else {
                alert('Error saving reservation');
            }
            submitBtn.innerText = "Confirm Booking";
            submitBtn.disabled = false;
        });
});



//Room Prices 
const ROOM_PRICES = {
    'Standard': 3500,
    'Deluxe': 7500,
    'Suite': 10000
};

let extraCharges = [];

function fetchBillDetails() {
    const roomNum = document.getElementById('billing-room-number').value;
    if(!roomNum) return;

    fetch(contextPath + '/reservation?action=getBillDetails&room_number=' + roomNum)
        .then(res => res.json())
        .then(data => {
            if(data.guest_name) {
                document.getElementById('billing-guest').value = data.guest_name;
                document.getElementById('billing-type').value = data.room_type;
                document.getElementById('billing-checkin').value = data.check_in;
                
                let checkoutDate = data.check_out;
                if(!checkoutDate || checkoutDate === 'null') {
                    checkoutDate = new Date().toISOString().split('T')[0];
                }
                document.getElementById('billing-checkout').value = checkoutDate;
                
                extraCharges = [];
                renderExtraCharges();
                calculateBill();
            } else {
                alert("No active checked-in reservation found for this room.");
            }
        });
}


function calculateBill() {
    const type = document.getElementById('billing-type').value;
    const checkIn = new Date(document.getElementById('billing-checkin').value);
    const checkOut = new Date(document.getElementById('billing-checkout').value);

    let diffTime = Math.abs(checkOut - checkIn);
    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
    if(isNaN(diffDays) || diffDays < 1) diffDays = 1; 
    if(isNaN(diffDays)) diffDays = 0; 

    document.getElementById('total-days').innerText = diffDays;

    const pricePerDay = ROOM_PRICES[type] || 0;
    const roomTotal = pricePerDay * diffDays;

    const totalField = document.getElementById('bill-room-total');

    totalField.value = 'Rs. ' + roomTotal.toFixed(2);

    totalField.style.border = "none";
    totalField.style.background = "transparent";
    totalField.style.fontSize = "inherit"; 
    totalField.style.fontFamily = "inherit";
    totalField.style.padding = "0";
    totalField.style.textAlign = "left"; 
    totalField.style.width = "100%";

    updateGrandTotal();
}


function addBillItem() {
    const desc = document.getElementById('new-item-desc').value;
    const priceInput = document.getElementById('new-item-price').value;
    const price = parseFloat(priceInput);

    if (desc.trim() === "" || isNaN(price)) {
        alert("Please enter a valid description and price");
        return;
    }

    extraCharges.push({ desc: desc, price: price });
    
    document.getElementById('new-item-desc').value = '';
    document.getElementById('new-item-price').value = '';
    
    renderExtraCharges();
    updateGrandTotal();
}


function renderExtraCharges() {
    const tbody = document.getElementById('bill-items-body');

    const fixedRow = tbody.querySelector('.fixed-row');

    tbody.innerHTML = '';

    if (fixedRow) {
        tbody.appendChild(fixedRow);
    }

    extraCharges.forEach((item, index) => {
        const tr = document.createElement('tr');
        tr.className = "item-row"; 

        tr.innerHTML = `
            <td style="padding: 15px 0; border-bottom: 1px solid #f9fafb;">
                \${item.desc}
            </td>
            <td style="text-align: left; padding: 15px 0; border-bottom: 1px solid #f9fafb;">
                Rs. \${parseFloat(item.price).toFixed(2)}
            </td>
            <td style="text-align: center; padding: 15px 0; border-bottom: 1px solid #f9fafb;">
                <button class="btn-remove" onclick="removeCharge(\${index})">
                    <i class="fa-solid fa-trash"></i>
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}


function removeCharge(index) {
    extraCharges.splice(index, 1);
    renderExtraCharges();
    updateGrandTotal();
}


function updateGrandTotal() {

    const rawRoomTotal = document.getElementById('bill-room-total').value;
    const cleanRoomTotal = rawRoomTotal.replace('Rs. ', '').trim();
    const roomTotal = parseFloat(cleanRoomTotal) || 0;

    let extrasTotal = 0;
    extraCharges.forEach(item => extrasTotal += item.price);

    const subtotal = roomTotal + extrasTotal;
    const serviceCharge = subtotal * 0.10; 
    const grandTotal = subtotal + serviceCharge;

    document.getElementById('bill-subtotal').innerText = 'Rs. ' + subtotal.toFixed(2);
    document.getElementById('bill-service').innerText = 'Rs. ' + serviceCharge.toFixed(2);
    document.getElementById('bill-grand-total').innerText = 'Rs. ' + grandTotal.toFixed(2);
}

function printInvoice() {
    document.getElementById('inv-guest-name').innerText = document.getElementById('billing-guest').value;
    document.getElementById('inv-room-num').innerText = document.getElementById('billing-room-number').value;
    document.getElementById('inv-date').innerText = new Date().toLocaleDateString();
    document.getElementById('inv-number').innerText = 'INV-' + Math.floor(Math.random() * 10000);

    const tbody = document.getElementById('inv-items-body');
    tbody.innerHTML = '';

    const days = document.getElementById('total-days').innerText;
    const rawRoomTotal = document.getElementById('bill-room-total').value;
    const roomTotal = parseFloat(rawRoomTotal.replace('Rs. ', '').trim()) || 0;

    let html = `
        <tr class="item">
            <td>Room Charge (\${days} Days)</td>
            <td style="text-align:right;">Rs. \${roomTotal.toFixed(2)}</td>
        </tr>
    `;

    extraCharges.forEach(item => {
        html += `
            <tr class="item">
                <td>\${item.desc}</td>
                <td style="text-align:right;">Rs. \${item.price.toFixed(2)}</td>
            </tr>
        `;
    });

    tbody.innerHTML = html;
    
    document.getElementById('inv-subtotal').innerText = document.getElementById('bill-subtotal').innerText;
    document.getElementById('inv-service').innerText = document.getElementById('bill-service').innerText;
    document.getElementById('inv-total').innerText = document.getElementById('bill-grand-total').innerText;
    
    const originalTitle = document.title;
    document.title = "Ocean View Resort Management System";

    window.print();
    
    document.title = originalTitle;
}



const originalProceedToCheckout = proceedToCheckout;
proceedToCheckout = function(roomNum) {
    if (!confirm("Are you sure you want to proceed to check-out for Room " + roomNum + "?")) return;
    
    showSection('calculate-bill', document.querySelector('[onclick*="calculate-bill"]'));
    const input = document.getElementById('billing-room-number');
    if(input) {
        input.value = roomNum;
        setTimeout(fetchBillDetails, 100);
    }
    closeModal();
}


function confirmPayment() {
    const roomNum = document.getElementById('billing-room-number').value;
    const guest = document.getElementById('billing-guest').value;
    const totalRaw = document.getElementById('bill-grand-total').innerText;
    const total = totalRaw.replace('Rs. ', '');
    const payBtn = document.getElementById('btn-confirm-pay');

    if(!roomNum || !guest) {
        alert("No active billing data found.");
        return;
    }

    const message = "Confirm payment of " + totalRaw + " for Room " + roomNum + "";
    
    if(!confirm(message)) return;

    payBtn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Processing...';
    payBtn.disabled = true;

    fetch(contextPath + '/reservation?action=saveBill&room_number=' + roomNum + '&total_amount=' + total + '&guest_name=' + encodeURIComponent(guest))
        .then(res => res.text())
        .then(data => {
            if(data.trim() === 'success') {
                payBtn.style.display = 'none';
                
                const printBtn = document.getElementById('btn-print-bill');
                printBtn.style.display = 'block';
                printBtn.innerHTML = '<i class="fa-solid fa-print"></i> Payment Confirmed - Print Bill';

                document.querySelectorAll('.billing-container input, .billing-container select, .add-charge-box button').forEach(el => {
                    el.disabled = true;
                });
            } else {
                payBtn.innerText = "Confirm Payment";
                payBtn.disabled = false;
                alert("Error saving payment. Please try again.");
            }
        })
        .catch(err => {
            payBtn.innerText = "Confirm Payment";
            payBtn.disabled = false;
            console.error(err);
        });
}




function logout(){
    if(confirm("Are you sure you want to logout?")){
        location.href = 'logout'; 
    }
}

window.onpopstate = function(event) {
    if (event.state && event.state.sectionId) {
        showSection(event.state.sectionId, null, true);
    } else {
        showSection('dashboard-rooms', null, true);
    }
};

window.onload = () => {
    const hash = window.location.hash.replace('#', '');
    if (hash && document.getElementById(hash)) {
        showSection(hash, null);
    } else {
        showSection('dashboard-rooms', document.querySelectorAll('.menu-item')[0]);
    }
};
</script>

</body>
</html>