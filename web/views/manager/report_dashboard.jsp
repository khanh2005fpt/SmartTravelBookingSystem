<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Report Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #6c63ff;
            --primary-hover: #5848d6;
            --accent: #a79eff;
            --bg: #f5f4ff;
            --card: #ffffff;
            --text: #2d3748;
            --text-light: #718096;
            --border: #e2e8f0;
            --shadow: 0 6px 20px rgba(108, 99, 255, 0.15);
            --radius: 16px;
            --transition: all 0.3s ease;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.6;
            padding: 30px;
        }

        .container { max-width: 1200px; margin: 0 auto; }

        h1 {
            text-align: center;
            color:  #00ACD4;
            margin-bottom: 30px;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 24px;
            margin-bottom: 30px;
        }

        .card {
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 24px;
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(108, 99, 255, 0.25);
        }

        .card h2 {
            color:  #007CB9;
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            border-left: 4px solid #00ACD4;
            padding-left: 12px;
        }

        canvas { width: 100% !important; height: 300px !important; }

        .table-container { margin-top: 16px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background: #00ACD4;; color: white; padding: 12px 14px; text-align: left; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 12px 14px; border-bottom: 1px solid var(--border); color: var(--text); }
        tr:hover { background-color: #f8f6ff; }
        .price { font-weight: 600; color: var(--text); }
        .empty-state { text-align: center; padding: 30px 20px; color: var(--text-light); font-style: italic; }

        /* NÚT BACK TO DASHBOARD */
        .back-to-dashboard {
            text-align: center;
            margin-top: 20px;
        }

        .back-to-dashboard a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #718096;
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 12px;
            font-weight: 500;
            font-size: 14px;
            transition: var(--transition);
            box-shadow: 0 4px 12px rgba(113, 128, 150, 0.2);
        }

        .back-to-dashboard a:hover {
            background: #4a5568;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(113, 128, 150, 0.3);
        }

        @media (max-width: 768px) {
            .dashboard { grid-template-columns: 1fr; }
            h1 { font-size: 1.6rem; }
            .card { padding: 20px; }
            canvas { height: 250px !important; }
        }
    </style>
</head>


<body>
 <!-- Include Sidebar -->
    <%@ include file="/views/staff/sidebar.jsp" %>
<div class="container">

    <h1>Manager Report Dashboard</h1>
 
    <div class="dashboard">

        <!-- Monthly Revenue -->
        <div class="card">
            <h2>Monthly Revenue (₫)</h2>
            <canvas id="revenueChart"></canvas>
        </div>

        <!-- Monthly Bookings -->
        <div class="card">
            <h2>Monthly Bookings</h2>
            <canvas id="bookingChart"></canvas>
        </div>

        <!-- Service Performance -->
        <div class="card">
            <h2>Service Performance</h2>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Dịch vụ</th>
                            <th>Số lượt đặt</th>
                            <th>Doanh thu (₫)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Map<String,Object>> list = (List<Map<String,Object>>) request.getAttribute("servicePerformance");
                            if (list != null && !list.isEmpty()) {
                                for (Map<String,Object> row : list) {
                        %>
                        <tr>
                            <td><%= row.get("serviceName") == null ? "N/A" : row.get("serviceName") %></td>
                            <td><%= row.get("totalBookings") %></td>
                            <td class="price"><%= String.format("%,.0f", row.get("totalRevenue")) %></td>
                        </tr>
                        <% 
                                }
                            } else { 
                        %>
                        <tr>
                            <td colspan="3" class="empty-state">Không có dữ liệu</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</div>

<!-- Chart.js Scripts -->
<script>
    const revDataMap = <%= new org.json.JSONObject(
        request.getAttribute("monthlyRevenue") != null 
            ? (Map) request.getAttribute("monthlyRevenue") 
            : new HashMap<>()
    ) %>;

    const bookDataMap = <%= new org.json.JSONObject(
        request.getAttribute("monthlyBookings") != null 
            ? (Map) request.getAttribute("monthlyBookings") 
            : new HashMap<>()
    ) %>;

    const revLabels = Object.keys(revDataMap);
    const revData = Object.values(revDataMap);
    const bookLabels = Object.keys(bookDataMap);
    const bookData = Object.values(bookDataMap);

    new Chart(document.getElementById('revenueChart'), {
        type: 'bar',
        data: {
            labels: revLabels,
            datasets: [{
                label: 'Doanh thu',
                data: revData,
                backgroundColor: 'rgba(108, 99, 255, 0.8)',
                borderColor: '#6c63ff',
                borderWidth: 1,
                borderRadius: 8,
                borderSkipped: false,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return 'Doanh thu: ' + context.parsed.y.toLocaleString() + ' ₫';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString() + ' ₫';
                        },
                        color: '#555'
                    },
                    grid: { color: '#eee' }
                },
                x: { ticks: { color: '#555' }, grid: { display: false } }
            }
        }
    });

    new Chart(document.getElementById('bookingChart'), {
        type: 'line',
        data: {
            labels: bookLabels,
            datasets: [{
                label: 'Số lượt đặt',
                data: bookData,
                borderColor: '#6c63ff',
                backgroundColor: 'rgba(108, 99, 255, 0.1)',
                tension: 0.4,
                fill: true,
                pointRadius: 5,
                pointBackgroundColor: '#6c63ff',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointHoverRadius: 7,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return 'Đặt chỗ: ' + context.parsed.y;
                        }
                    }
                }
            },
            scales: {
                y: { beginAtZero: true, ticks: { color: '#555' }, grid: { color: '#eee' } },
                x: { ticks: { color: '#555' }, grid: { display: false } }
            }
        }
    });
</script>

</body>
</html>