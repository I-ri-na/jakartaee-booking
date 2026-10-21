<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.booking.entity.Client" %>
<%!
    /** Экранирование HTML, чтобы пользовательский ввод не ломал страницу */
    private static String h(Object value) {
        if (value == null) return "";
        String s = String.valueOf(value);
        StringBuilder sb = new StringBuilder(s.length());
        for (char c : s.toCharArray()) {
            switch (c) {
                case '<': sb.append("&lt;"); break;
                case '>': sb.append("&gt;"); break;
                case '&': sb.append("&amp;"); break;
                case '"': sb.append("&quot;"); break;
                case '\'': sb.append("&#39;"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }
%>
<%
    String ctx = request.getContextPath();
    List<Client> clients = (List<Client>) request.getAttribute("clients");
%>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Система бронирования</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">
</head>
<body class="bg-light">

<div class="container my-4">
    <h1 class="mb-4">Система бронирования</h1>

    <!-- ===================== Клиенты ===================== -->
    <div class="row">
        <div class="col-lg-3">
            <div class="card mb-4">
                <div class="card-header">Добавить клиента</div>
                <div class="card-body">
                    <form method="post" action="<%= ctx %>/">
                        <input type="hidden" name="action" value="addClient">
                        <div class="mb-3">
                            <label class="form-label">Имя</label>
                            <input type="text" name="name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Телефон</label>
                            <input type="text" name="phone" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Добавить клиента</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-9">
            <div class="card mb-4">
                <div class="card-header">Клиенты</div>
                <div class="card-body p-0">
                    <div class="table-responsive mb-0">
                        <table class="table table-striped table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Имя</th>
                                <th>Телефон</th>
                                <th>Email</th>
                                <th>Действия</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if (clients != null && !clients.isEmpty()) {
                                    for (Client c : clients) {
                                        String formId = "client-" + c.getId();
                            %>
                            <tr>
                                <td><%= c.getId() %></td>
                                <td><input form="<%= formId %>" type="text" name="name"
                                           class="form-control form-control-sm" value="<%= h(c.getName()) %>" required></td>
                                <td><input form="<%= formId %>" type="text" name="phone"
                                           class="form-control form-control-sm" value="<%= h(c.getPhone()) %>" required></td>
                                <td><input form="<%= formId %>" type="email" name="email"
                                           class="form-control form-control-sm" value="<%= h(c.getEmail()) %>" required></td>
                                <td class="text-nowrap">
                                    <form id="<%= formId %>" method="post" action="<%= ctx %>/" class="d-inline">
                                        <input type="hidden" name="action" value="editClient">
                                        <input type="hidden" name="id" value="<%= c.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-primary">Изменить</button>
                                    </form>
                                    <form method="post" action="<%= ctx %>/" class="d-inline"
                                          onsubmit="return confirm('Удалить клиента и все его бронирования?');">
                                        <input type="hidden" name="action" value="deleteClient">
                                        <input type="hidden" name="id" value="<%= c.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-outline-danger">Удалить</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" class="text-center text-muted">Клиентов пока нет</td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>
