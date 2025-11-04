<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update <%= request.getAttribute("type") %> Service</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --primary: #4a69bd;
            --primary-dark: #3c6382;
            --secondary: #38ada9;
            --secondary-dark: #079992;
            --danger: #e74c3c;
            --success: #27ae60;
            --light: #f8f9fa;
            --dark: #2c3e50;
            --gray: #6c757d;
            --border: #dee2e6;
            --shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            --radius: 14px;
            --transition: all 0.3s ease;
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            color: var(--dark);
        }

        .container {
            width: 100%;
            max-width: 520px;
        }

        .update-card {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .card-header {
            background: var(--primary);
            color: white;
            padding: 20px 24px;
            text-align: center;
            font-size: 1.4rem;
            font-weight: 600;
        }

        .card-header i {
            margin-right: 10px;
            font-size: 1.3rem;
        }

        .card-body {
            padding: 30px 28px;
        }

        .error {
            background: #ffebee;
            color: var(--danger);
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            border-left: 4px solid var(--danger);
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
        }

        .error i {
            font-size: 1.1rem;
        }

        .form-grid {
            display: grid;
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-weight: 600;
            color: var(--dark);
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .form-group label i {
            color: var(--primary);
            width: 18px;
        }

        .form-group input {
            padding: 12px 14px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: 1rem;
            transition: var(--transition);
            background: #fdfdff;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(74, 105, 189, 0.15);
            background: white;
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        .btn {
            flex: 1;
            min-width: 120px;
            padding: 12px 16px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-save {
            background: var(--secondary);
            color: white;
        }

        .btn-save:hover {
            background: var(--secondary-dark);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(56, 173, 169, 0.3);
        }

        .btn-back {
            background: white;
            color: var(--primary);
            border: 1.5px solid var(--primary);
        }

        .btn-back:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        .no-data {
            text-align: center;
            padding: 30px;
            color: var(--gray);
            font-style: italic;
        }

        .no-data i {
            font-size: 2.5rem;
            color: #ddd;
            margin-bottom: 12px;
            display: block;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .container {
                padding: 10px;
            }
            .card-body {
                padding: 20px;
            }
            .btn-group {
                flex-direction: column;
            }
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="update-card">
        <div class="card-header">
            <%
                String type = (String) request.getAttribute("type");
                String icon = "";
                String title = "";
                if ("Hotel".equals(type)) { icon = "fa-hotel"; title = "Hotel"; }
                else if ("Flight".equals(type)) { icon = "fa-plane"; title = "Flight"; }
                else if ("Vehicle".equals(type)) { icon = "fa-car"; title = "Vehicle"; }
                else if ("Place".equals(type)) { icon = "fa-map-marker-alt"; title = "Place"; }
                else { icon = "fa-cogs"; title = "Service"; }
            %>
            <i class="fas <%= icon %>"></i>
            Update <%= title %> Service
        </div>

        <div class="card-body">
            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= error %>
                </div>
            <% } %>

            <%
                Map<String, Object> data = (Map<String, Object>) request.getAttribute("data");
                int id = (int) request.getAttribute("id");
            %>

            <% if (data == null || data.isEmpty()) { %>
                <div class="no-data">
                    <i class="fas fa-database"></i>
                    <p>Không tìm thấy dữ liệu dịch vụ.</p>
                </div>
                <div class="btn-group">
                    <a href="<%= request.getContextPath() %>/manager/service?action=list" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            <% } else { %>
                <form action="<%= request.getContextPath() %>/manager/service" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="type" value="<%= type %>">
                    <input type="hidden" name="id" value="<%= id %>">

                    <div class="form-grid">
                        <% if ("Hotel".equals(type)) { %>
                            <div class="form-group">
                                <label><i class="fas fa-hotel"></i> Tên khách sạn</label>
                                <input type="text" name="name" value="<%= data.get("name") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-coins"></i> Giá / đêm (₫)</label>
                                <input type="number" step="0.01" name="price" value="<%= data.get("price") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-bed"></i> Số phòng còn</label>
                                <input type="number" name="rooms" value="<%= data.get("rooms") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-star"></i> Đánh giá (rating)</label>
                                <input type="number" step="0.1" min="0" max="5" name="rating" value="<%= data.get("rating") %>" required>
                            </div>

                        <% } else if ("Flight".equals(type)) { %>
                            <div class="form-group">
                                <label><i class="fas fa-tag"></i> Mã chuyến bay</label>
                                <input type="text" name="flightNumber" value="<%= data.get("flightNumber") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-plane-departure"></i> Điểm đi</label>
                                <input type="text" name="departure" value="<%= data.get("departure") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-plane-arrival"></i> Điểm đến</label>
                                <input type="text" name="destination" value="<%= data.get("destination") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-coins"></i> Giá vé (₫)</label>
                                <input type="number" step="0.01" name="price" value="<%= data.get("price") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-ticket-alt"></i> Số vé còn</label>
                                <input type="number" name="tickets" value="<%= data.get("tickets") %>" required>
                            </div>

                        <% } else if ("Vehicle".equals(type)) { %>
                            <div class="form-group">
                                <label><i class="fas fa-car"></i> Tên xe</label>
                                <input type="text" name="modelName" value="<%= data.get("modelName") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-coins"></i> Giá thuê / ngày (₫)</label>
                                <input type="number" step="0.01" name="price" value="<%= data.get("price") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-check-circle"></i> Số lượng còn</label>
                                <input type="number" name="available" value="<%= data.get("available") %>" required>
                            </div>

                        <% } else if ("Place".equals(type)) { %>
                            <div class="form-group">
                                <label><i class="fas fa-map-marker-alt"></i> Tên địa điểm</label>
                                <input type="text" name="placeName" value="<%= data.get("placeName") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-coins"></i> Giá vé (₫)</label>
                                <input type="number" step="0.01" name="price" value="<%= data.get("price") %>" required>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-ticket-alt"></i> Còn bán vé</label>
                                <input type="text" name="hasTicket" value="<%= data.get("hasTicket") %>" required>
                            </div>
                        <% } %>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-save">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <a href="<%= request.getContextPath() %>/manager/service?action=list" class="btn btn-back">
                            <i class="fas fa-arrow-left"></i> Back
                        </a>
                    </div>
                </form>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>