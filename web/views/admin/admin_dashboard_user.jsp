<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - User Statistics</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f5f6fa;
            margin: 0;
        }

        .main-content {
            padding: 40px;
            margin-left: 260px; 
        }

        h1 {
            color: #00ACD4;
            margin-bottom: 30px;
            font-weight: 700;
        }

        /* === 3 CARD THỐNG KÊ === */
        .dashboard {
            display: flex;
            justify-content: space-between;
            gap: 25px;
            flex-wrap: wrap;
        }

        .card {
            background: white;
            border-radius: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 25px;
            flex: 1;
            min-width: 250px;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.15);
        }

        .icon {
            font-size: 30px;
            color: #00ACD4;
            margin-bottom: 10px;
        }

        .title {
            font-weight: 600;
            color: #00ACD4;
            font-size: 18px;
            margin-bottom: 8px;
        }

        .count {
            font-size: 42px;
            font-weight: bold;
            color:#00ACD4;
        }

        /* === BIỂU ĐỒ === */
        .chart-section {
            margin-top: 60px;
            background: white;
            padding: 30px;
            border-radius: 18px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            align-items: flex-start;
            gap: 40px;
        }

        canvas {
            max-width: 350px;
            max-height: 350px;
        }

        h2 {
            color: #00ACD4;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <!-- Include Sidebar -->
    <%@ include file="/views/staff/sidebar.jsp" %>


    <div class="main-content">
        <h1>📊 Thống kê người dùng</h1>

        <!-- 3 CARD -->
        <div class="dashboard">
            <div class="card">
                <div class="icon">👥</div>
                <div class="title">Tổng số người dùng</div>
                <div class="count">${totalUsers}</div>
            </div>

            <div class="card">
                <div class="icon">✅</div>
                <div class="title">Người dùng ACTIVE</div>
                <div class="count">${activeUsers}</div>
            </div>

            <div class="card">
                <div class="icon">🔒</div>
                <div class="title">Người dùng LOCKED</div>
                <div class="count">${lockedUsers}</div>
            </div>
        </div>

        <!-- BIỂU ĐỒ -->
        <div class="chart-section">
            <!-- 1️⃣ Biểu đồ đường -->
            <div>
                <h2>📈 Tổng số người dùng theo thời gian</h2>
                <canvas id="userGrowth"></canvas>
            </div>

            <!-- 2️⃣ Biểu đồ tròn -->
            <div>
                <h2>🥧 Tỉ lệ ACTIVE vs LOCKED</h2>
                <canvas id="statusPie"></canvas>
            </div>

            <!-- 3️⃣ Biểu đồ cột -->
            <div>
                <h2>📊 Phân bố tổng thể</h2>
                <canvas id="totalBar"></canvas>
            </div>
        </div>
    </div>



    <!-- SCRIPT BIỂU ĐỒ -->
<script>
    const active = ${activeUsers};
    const locked = ${lockedUsers};
    const total = ${totalUsers};

    // 1. Biểu đồ đường - Tổng người dùng theo thời gian
    const ctxGrowth = document.getElementById('userGrowth');
    new Chart(ctxGrowth, {
        type: 'line',
        data: {
            labels: ['Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10'],
            datasets: [{
                label: 'Tổng người dùng',
                data: [2, 3, 4, 5, total],
                borderColor: '#00ACD4',                    //  → xanh ngọc
                backgroundColor: 'rgba(0, 172, 212, 0.2)', //  → xanh mờ
                tension: 0.3,
                fill: true,
                pointRadius: 5,
                pointHoverRadius: 8,
                pointBackgroundColor: '#00ACD4',
                pointBorderColor: '#0077b6'
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1 }
                }
            },
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: '#2d3436', font: { size: 14 } }
                }
            }
        }
    });

    // 2. Biểu đồ tròn - ACTIVE vs LOCKED
    const ctxPie = document.getElementById('statusPie');
    new Chart(ctxPie, {
        type: 'pie',
        data: {
            labels: ['Active', 'Locked'],
            datasets: [{
                data: [active, locked],
                backgroundColor: ['#00ACD4', '#c0392b'],  
                hoverOffset: 10
            }]
        },
        options: {
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { color: '#2d3436', font: { size: 14 } }
                }
            }
        }
    });

    // 3. Biểu đồ cột - Tổng thể
    const ctxBar = document.getElementById('totalBar');
    new Chart(ctxBar, {
        type: 'bar',
        data: {
            labels: ['Tổng', 'Active', 'Locked'],
            datasets: [{
                label: 'Số lượng người dùng',
                data: [total, active, locked],
                backgroundColor: ['#00ACD4', '#27ae60', '#c0392b']  // 
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
    });
</script>
</body>
</html>
