<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.DashboardOverview" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
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
                --dark: #2c3e50;
                --gray: #6c757d;
                --border: #dee2e6;
                --shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                --shadow-hover: 0 12px 30px rgba(0, 0, 0, 0.15);
                --radius: 16px;
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: var(--dark);
                padding: 20px 0;
            }

            .container {
                max-width: 1300px;
                margin: 0 auto;
                padding: 0 20px;
            }

            /* HEADER */
            header {
                text-align: center;
                margin: 30px 0 40px;
            }

            h2 {
                font-size: 2.4rem;
                font-weight: 700;
                color: white;
                text-shadow: 0 2px 10px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
            }

            h2 i {
                font-size: 2rem;
                color: #ffd700;
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
            }

            /* DASHBOARD CARDS */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 24px;
                margin-bottom: 50px;
            }

            .stat-card {
                background: white;
                border-radius: var(--radius);
                padding: 24px;
                text-align: center;
                box-shadow: var(--shadow);
                transition: var(--transition);
                cursor: pointer;
                position: relative;
                overflow: hidden;
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 5px;
                background: var(--primary);
                transform: scaleX(0);
                transform-origin: left;
                transition: var(--transition);
            }

            .stat-card:hover::before {
                transform: scaleX(1);
            }

            .stat-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--shadow-hover);
            }

            .stat-card .icon {
                width: 70px;
                height: 70px;
                margin: 0 auto 16px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.8rem;
                color: white;
                box-shadow: 0 6px 15px rgba(0,0,0,0.15);
            }

            .card-services .icon   {
                background: linear-gradient(135deg, #667eea, #764ba2);
            }
            .card-bookings .icon   {
                background: linear-gradient(135deg, #f093fb, #f5576c);
            }
            .card-payments .icon   {
                background: linear-gradient(135deg, #4facfe, #00f2fe);
            }
            .card-users .icon      {
                background: linear-gradient(135deg, #43e97b, #38f9d7);
            }
            .card-revenue .icon    {
                background: linear-gradient(135deg, #fa709a, #fee140);
            }

            .stat-card h3 {
                font-size: 1.1rem;
                color: var(--gray);
                margin-bottom: 8px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
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

            /* CHART SECTION */
            .chart-section {
                background: white;
                border-radius: var(--radius);
                padding: 30px;
                box-shadow: var(--shadow);
                margin-bottom: 40px;
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

            .chart-title i {
                color: var(--primary);
            }

            .chart-container {
                position: relative;
                height: 400px;
            }

            /* FOOTER */
            footer {
                text-align: center;
                padding: 30px 20px;
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.95rem;
                margin-top: 20px;
            }

            footer i {
                color: #ffd700;
                margin-right: 6px;
            }

            /* NO DATA */
            .no-data {
                text-align: center;
                padding: 80px 20px;
                color: white;
                font-size: 1.2rem;
            }

            .no-data i {
                font-size: 4rem;
                margin-bottom: 16px;
                opacity: 0.7;
                display: block;
            }

            /* RESPONSIVE */
            @media (max-width: 768px) {
                h2 {
                    font-size: 1.8rem;
                    flex-direction: column;
                    gap: 8px;
                }
                .stats-grid {
                    grid-template-columns: 1fr;
                }
                .chart-container {
                    height: 300px;
                }
                .chart-header {
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>

        <div class="container">

            <%
                DashboardOverview d = (DashboardOverview) request.getAttribute("dashboard");
                if (d == null) {
            %>
            <div class="no-data">
                <i class="fas fa-chart-line"></i>
                <p>No dashboard data available at the moment.</p>
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

            <!-- ===================== DASHBOARD CARDS ===================== -->
            <div class="stats-grid">

                <div class="stat-card card-services" onclick="location.href = '<%=request.getContextPath()%>/manager/service?action=list'">
                    <div class="icon">
                        <i class="fas fa-concierge-bell"></i>
                    </div>
                    <h3>Services</h3>
                    <p><%= d.getTotalServices() %></p>
                </div>

                <div class="stat-card card-bookings" onclick="location.href = '<%=request.getContextPath()%>/manager/booking'">
                    <div class="icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h3>Bookings</h3>
                    <p><%= d.getTotalBookings() %></p>
                </div>

                <div class="stat-card card-payments" onclick="location.href = '<%=request.getContextPath()%>/manager/payments'">
                    <div class="icon">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h3>Payments</h3>
                    <p><%= d.getTotalPayments() %></p>
                </div>
                
                      <div class="stat-card card-payments" onclick="location.href = '<%=request.getContextPath()%>/manager/report'">
                    <div class="icon">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h3>Report</h3>
                    <p><%= d.getTotalPayments() %></p>
                </div>

                <div class="stat-card card-users" onclick="location.href = '<%=request.getContextPath()%>/manager/user'">
                    <div class="icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3>Customer List</h3>
                    <p><%= d.getTotalUsers() %></p>
                </div>

                <div class="stat-card card-revenue">
                    <div class="icon">
                        <i class="fas fa-coins"></i>
                    </div>
                    <h3>Total Revenue</h3>
                    <p><%= String.format("%,.0f", d.getTotalRevenue()) %> <small>₫</small></p>
                </div>

            </div>

            <!-- ===================== MONTHLY REVENUE CHART ===================== -->
            <div class="chart-section">
                <div class="chart-header">
                    <div class="chart-title">
                        <i class="fas fa-chart-bar"></i>
                        Monthly Revenue Trend
                    </div>
                    <div style="color: var(--gray); font-size: 0.9rem;">
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
            <i class="fas fa-copyright"></i>
            Smart Travel Booking System <script>document.write(new Date().getFullYear())</script> — Manager Dashboard
        </footer>

        <script>
            // Chỉ chạy nếu có dữ liệu
            <%
                Map<String, Double> map = d != null ? d.getMonthlyRevenue() : null;
                if (map != null && !map.isEmpty()) {
            %>
            const ctx = document.getElementById('revenueChart').getContext('2d');

            const labels = [<%
                int i = 0;
                for (String k : map.keySet()) {
                    out.print("'" + k + "'");
                    if (i++ < map.size() - 1) out.print(",");
                }
            %>];

            const values = [<%
                i = 0;
                for (Double v : map.values()) {
                    out.print(v);
                    if (i++ < map.size() - 1) out.print(",");
                }
            %>];

            // Gradient cho biểu đồ
            const gradient = ctx.createLinearGradient(0, 0, 0, 400);
            gradient.addColorStop(0, 'rgba(74, 105, 189, 0.8)');
            gradient.addColorStop(1, 'rgba(74, 105, 189, 0.2)');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Monthly Revenue (₫)',
                            data: values,
                            backgroundColor: gradient,
                            borderColor: 'rgba(74, 105, 189, 1)',
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
                        legend: {
                            display: false
                        },
                        tooltip: {
                            callbacks: {
                                label: function (context) {
                                    let label = context.dataset.label || '';
                                    if (label)
                                        label += ': ';
                                    if (context.parsed.y !== null) {
                                        label += new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' ₫';
                                    }
                                    return label;
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: {display: false},
                            ticks: {color: '#555', font: {size: 12}}
                        },
                        y: {
                            beginAtZero: true,
                            grid: {color: 'rgba(0,0,0,0.05)'},
                            ticks: {
                                color: '#555',
                                callback: function (value) {
                                    return value >= 1000000 ? (value / 1000000) + 'M' : (value >= 1000 ? (value / 1000) + 'K' : value);
                                }
                            }
                        }
                    },
                    animation: {
                        duration: 1500,
                        easing: 'easeOutQuart'
                    }
                }
            });
            <%
                }
            %>
        </script>

    </body>
</html>