<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Log</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f5f6fa;
            margin: 0;
        }

        /* Chừa chỗ cho header và sidebar */
        .main-content {
            margin-left: 260px; /* bằng chiều rộng sidebar */
            margin-top: 90px;   /* chừa header */
            padding: 30px 40px;
        }

        h1 {
            color: #5a2fc2;
            margin-bottom: 25px;
            font-weight: 700;
            text-align: center;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

        h1::before {
            content: "🧾";
            font-size: 26px;
        }

        .container {
            background: white;
            padding: 35px 40px;
            border-radius: 18px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 600px;
            margin: 0 auto;
            transition: all 0.3s ease;
        }

        .container:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }

        .field {
            margin-bottom: 18px;
            font-size: 16px;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            padding-bottom: 8px;
        }

        .label {
            font-weight: 600;
            color: #5a2fc2;
        }

        .value {
            color: #2d3436;
            font-weight: 500;
            max-width: 320px;
            text-align: right;
        }

        /* Method hiển thị như badge */
        .method-badge {
            padding: 5px 12px;
            border-radius: 8px;
            color: #fff;
            font-weight: 600;
            display: inline-block;
        }

        .GET { background: #27ae60; }
        .POST { background: #5a2fc2; }
        .PUT { background: #f39c12; }
        .DELETE { background: #c0392b; }

        a.back {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            background: #5a2fc2;
            color: white;
            font-weight: 600;
            padding: 10px 25px;
            border-radius: 8px;
            transition: background 0.2s ease;
            text-align: center;
        }

        a.back:hover {
            background: #45229e;
        }

        .back-wrapper {
            text-align: center;
        }

        /* Responsive fix */
        @media (max-width: 900px) {
            .main-content {
                margin-left: 0;
                margin-top: 120px;
                padding: 20px;
            }

            .container {
                width: 100%;
                padding: 25px 20px;
            }

            .field {
                flex-direction: column;
                align-items: flex-start;
            }

            .value {
                text-align: left;
                margin-top: 5px;
            }
        }
    </style>
</head>
<body>

    <%@ include file="../user/header.jsp" %>
    <%@ include file="../user/sidebar.jsp" %>

    <div class="main-content">
        <h1>Chi tiết Log #${log.logId}</h1>

        <div class="container">
            <div class="field">
                <span class="label">Người dùng:</span>
                <span class="value">${log.username}</span>
            </div>
            <div class="field">
                <span class="label">Hành động:</span>
                <span class="value">${log.action}</span>
            </div>
            <div class="field">
                <span class="label">Phương thức:</span>
                <span class="value">
                    <span class="method-badge ${log.method}">${log.method}</span>
                </span>
            </div>
            <div class="field">
                <span class="label">Thời gian:</span>
                <span class="value">${log.timestamp}</span>
            </div>

            <div class="back-wrapper">
                <a class="back" href="logs">← Quay lại danh sách</a>
            </div>
        </div>
    </div>

    <%@ include file="../user/footer.jsp" %>
</body>
</html>
