<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo Doanh thu hàng tháng</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
   
        * {
            box-sizing: border-box;
        }

        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --bg-light: #f6f8fb;
            --card-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            --border-color: #e9ecef;
        }

        body {
            font-family: "Inter", "Segoe UI", sans-serif;
            background: var(--bg-light); 
            padding: 30px;
        }
        
        .report-card {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 30px;
        }

        h2 { 
            text-align: center; 
            color: #2c3e50; 
            margin-bottom: 30px; 
            font-weight: 700;
            font-size: 28px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--border-color);
        }

    
        .chart-container {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 30px;
        }

        canvas { 
            display: block; 
            margin: 0 auto; 
            max-width: 100%; 
            height: 400px; 
        }

      
        table {
            width: 100%; 
            border-collapse: separate; 
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 8px; 
            overflow: hidden; 
            font-size: 15px;
        }

        thead {
            background: var(--primary-color);
        }

        th {
            background: var(--primary-color); 
            color: #fff;
            padding: 12px 10px; 
            text-align: center;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        td {
            border-bottom: 1px solid var(--border-color); 
            padding: 12px 10px; 
            text-align: center;
        }

        tbody tr:nth-child(even) { 
            background: #fcfcfc;
        }
        tbody tr:hover {
            background: #f0f5ff;
        }

       
        td b {
            font-weight: 700;
            color: #d9534f; 
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="report-card">
        <h2><i class="fa-solid fa-chart-line"></i> Báo cáo Doanh thu hàng tháng</h2>
        
        <div class="chart-container">
            <canvas id="revenueChart"></canvas>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Tháng</th>
                    <th style="color: var(--success-color);">Doanh thu CONFIRMED (VND)</th>
                    <th style="color: var(--warning-color);">Doanh thu PENDING (VND)</th>
                    <th>Tổng doanh thu (VND)</th>
                    <th>Số booking CONFIRMED</th>
                    <th>Số booking PENDING</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="r" items="${reportData}">
                    <tr>
                        <td>${r.month}</td>
                        <td><fmt:formatNumber value="${r.confirmedRevenue}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/></td>
                        <td><fmt:formatNumber value="${r.pendingRevenue}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/></td>
                        <td><b><fmt:formatNumber value="${r.totalRevenue}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/></b></td>
                        <td>${r.confirmedCount}</td>
                        <td>${r.pendingCount}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        // Lấy dữ liệu từ JSP
        const labels = [<c:forEach var="r" items="${reportData}">"${r.month}",</c:forEach>];
        const confirmedRevenue = [<c:forEach var="r" items="${reportData}">${r.confirmedRevenue},</c:forEach>];
        const pendingRevenue = [<c:forEach var="r" items="${reportData}">${r.pendingRevenue},</c:forEach>];

        new Chart(document.getElementById('revenueChart'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    { 
                        label: 'Doanh thu Đã xác nhận (VND)', 
                        data: confirmedRevenue, 
                        backgroundColor: '#28a745', 
                        borderRadius: 4
                    },
                    { 
                        label: 'Doanh thu Chờ xử lý (VND)', 
                        data: pendingRevenue, 
                        backgroundColor: '#ffc107', 
                        borderRadius: 4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false, 
                plugins: {
                    title: {
                        display: true,
                        text: 'Doanh thu so sánh giữa Đã xác nhận và Chờ xử lý',
                        font: { size: 16, weight: '600' }
                    },
                    legend: {
                        position: 'bottom',
                    }
                },
                scales: {
                    y: { 
                        beginAtZero: true, 
                        title: {
                            display: true,
                            text: 'Doanh thu (VND)'
                        },
                        ticks: { 
                            callback: function(value) {
                                return value.toLocaleString('vi-VN') + ' ₫'; 
                            } 
                        } 
                    }
                }
            }
        });
    </script>
</body>
</html>