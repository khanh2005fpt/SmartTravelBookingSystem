<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.DashboardOverview" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #4a69bd;
            --primary-dark: #3c6382;
            --secondary: #38ada9;
            --success: #27ae60;
            --warning: #f39c12;
            --danger: #e74c3c;
            --light: #f8f9fa;
            --dark: #222222;
            --gray: #666666;
            --border: #e0e0e0;
            --shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            --shadow-hover: 0 12px 30px rgba(0, 0, 0, 0.12);
            --radius: 16px;
            --transition: all 0.3s ease;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
            min-height: 100vh;
            color: var(--dark);
            padding: 20px 0;
        }

        .container { max-width: 1350px; margin: 0 auto; padding: 0 20px; }

        /* HEADER */
        header {
            text-align: center;
            margin: 30px 0 50px;
            padding-bottom: 20px;
            border-bottom: 3px solid var(--primary);
        }
        h2 {
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--dark);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        h2 i {
            font-size: 2rem;
            color: var(--primary);
        }

        /* STATS GRID */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 50px;
        }

        .stat-card {
            background: white;
            border-radius: var(--radius);
            padding: 26px;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 5px;
            background: var(--primary);
            transform: scaleX(0);
            transform-origin: left;
            transition: var(--transition);
        }

        .stat-card:hover::before { transform: scaleX(1); }
        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
        }

        .stat-card .icon {
            width: 72px; height: 72px;
            margin: 0 auto 16px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            color: white;
            box-shadow: 0 6px 16px rgba(0,0,0,0.15);
        }

        .card-services .icon   { background: linear-gradient(135deg, #667eea, #764ba2); }
        .card-bookings .icon   { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .card-payments .icon   { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .card-reports .icon    { background: linear-gradient(135deg, #fa709a, #fee140); }
        .card-users .icon      { background: linear-gradient(135deg, #43e97b, #38f9d7); }
        .card-revenue .icon    { background: linear-gradient(135deg, #ff9a9e, #fad0c4); }

        .stat-card h3 {
            font-size: 1.05rem;
            color: var(--gray);
            margin-bottom: 10px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .stat-card p {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }

        .stat-card p small {
            font-size: 0.9rem;
            color: var(--secondary);
            font-weight: 500;
        }

        .growth {
            position: absolute;
            top: 12px; right: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 12px;
            color: white;
        }
        .growth.positive { background: var(--success); }
        .growth.negative { background: var(--danger); }

        /* CHART SECTION */
        .chart-section {
            background: white;
            border-radius: var(--radius);
            padding: 30px;
            box-shadow: var(--shadow);
            margin-bottom: 40px;
            border: 1px solid var(--border);
        }

        .chart-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .chart-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .chart-title i { color: var(--primary); }

        .chart-info {
            color: var(--gray);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .chart-container {
            position: relative;
            height: 400px;
        }

        /* NO DATA */
        .no-data {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray);
            font-size: 1.2rem;
        }
        .no-data i {
            font-size: 4rem;
            margin-bottom: 16px;
            color: #ddd;
            display: block;
        }

        /* FOOTER */
        footer {
            text-align: center;
            padding: 30px 20px;
            color: var(--gray);
            font-size: 0.95rem;
            margin-top: 40px;
            border-top: 1px solid var(--border);
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            h2 { font-size: 1.9rem; flex-direction: column; gap: 8px; }
            .stats-grid { grid-template-columns: 1fr; }
            .chart-container { height: 300px; }
        }
    </style>
</head>
<body>
    <!-- Include Sidebar -->
    <%@ include file="/views/staff/sidebar.jsp" %>
    <div class="container">
        <%
            DashboardOverview d = (DashboardOverview) request.getAttribute("dashboard");
            if (d == null) {
        %>
        <div class="no-data">
            <i class="fas fa-chart-line"></i>
            <p>No dashboard data available.</p>
        </div>
        <%
            } else {
        %>
        <header>
            <h2>
                <i class="fas fa-tachometer-alt"></i>
                Manager Dashboard
            </h2>
        </header>

        <!-- DASHBOARD CARDS -->
        <div class="stats-grid">
            <div class="stat-card card-services" onclick="location.href='<%=request.getContextPath()%>/manager/service?action=list'">
                <div class="icon"><i class="fas fa-concierge-bell"></i></div>
                <h3>Services</h3>
                <p><%= d.getTotalServices() %></p>
            </div>

            <div class="stat-card card-bookings" onclick="location.href='<%=request.getContextPath()%>/manager/booking'">
                <div class="icon"><i class="fas fa-calendar-check"></i></div>
                <h3>Bookings</h3>
                <p><%= d.getTotalBookings() %></p>
            </div>

           

            <div class="stat-card card-reports" onclick="location.href='<%=request.getContextPath()%>/manager/report'">
                <div class="icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <h3>Reports</h3>
                <p><%= d.getTotalPayments() %></p>
                <span class="growth positive">+12%</span>
            </div>

            <div class="stat-card card-users" onclick="location.href='<%=request.getContextPath()%>/manager/user'">
                <div class="icon"><i class="fas fa-users"></i></div>
                <h3>Customers</h3>
                <p><%= d.getTotalUsers() %></p>
            </div>
            
             <div class="stat-card card-users" onclick="location.href='<%=request.getContextPath()%>/manager/tour-approval'">
                <div class="icon"><i class="fas fa-users"></i></div>
                <h3>Tour</h3>
                
            </div>

            <div class="stat-card card-revenue">
                <div class="icon"><i class="fas fa-coins"></i></div>
                <h3>Total Revenue</h3>
                <p><%= String.format("%,.0f", d.getTotalRevenue()) %> <small>₫</small></p>
                <span class="growth positive">+8.5%</span>
            </div>
        </div>

        <!-- CHART -->
        <div class="chart-section">
            <div class="chart-header">
                <div class="chart-title">
                    <i class="fas fa-chart-bar"></i>
                    Monthly Revenue Trend
                </div>
                <div class="chart-info">
                    <i class="fas fa-info-circle"></i> In VND (₫)
                </div>
            </div>
            <div class="chart-container">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <footer>
        Smart Travel Booking System <script>document.write(new Date().getFullYear())</script> — Manager Dashboard
    </footer>

    <script>
        <%
            Map<String, Double> map = d != null ? d.getMonthlyRevenue() : null;
            if (map != null && !map.isEmpty()) {
        %>
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const labels = [<%= String.join(",", map.keySet().stream().map(k -> "'" + k + "'").toList()) %>];
        const values = [<%= map.values().stream().map(Object::toString).collect(java.util.stream.Collectors.joining(",")) %>];

        const gradient = ctx.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(74, 105, 189, 0.8)');
        gradient.addColorStop(1, 'rgba(74, 105, 189, 0.1)');

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Monthly Revenue (₫)',
                    data: values,
                    backgroundColor: gradient,
                    borderColor: '#4a69bd',
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false,
                    barThickness: 30,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        titleColor: '#fff',
                        bodyColor: '#fff',
                        cornerRadius: 8,
                        displayColors: false,
                        callbacks: {
                            label: ctx => 'Revenue: ' + new Intl.NumberFormat('vi-VN').format(ctx.parsed.y) + ' ₫'
                        }
                    }
                },
                scales: {
                    x: { grid: { display: false }, ticks: { color: '#555' } },
                    y: {
                        beginAtZero: true,
                        grid: { color: 'rgba(0,0,0,0.05)' },
                        ticks: {
                            color: '#555',
                            callback: value => value >= 1000000 ? (value/1000000)+'M' : (value >= 1000 ? (value/1000)+'K' : value)
                        }
                    }
                },
                animation: { duration: 1500, easing: 'easeOutQuart' }
            }
        });
        <%
            }
        %>
    </script>
</body>
</html>