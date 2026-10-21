package com.booking.web;

import com.booking.ejb.ClientServiceBean;
import com.booking.entity.Client;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Контроллер (слой представления). JSP лежит в WEB-INF, поэтому открыть её
 * напрямую нельзя — все запросы идут через этот сервлет.
 */
@WebServlet("/")
public class MainServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/views/index.jsp";

    @EJB
    private ClientServiceBean clientService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        req.setAttribute("clients", clientService.getAllClients());
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("addClient".equals(action)) {
            Client client = new Client();
            fillClient(client, req);
            clientService.saveClient(client);

        } else if ("editClient".equals(action)) {
            Client existing = clientService.getClientById(intParam(req, "id"));
            if (existing != null) {
                fillClient(existing, req);
                clientService.saveClient(existing);
            }

        } else if ("deleteClient".equals(action)) {
            clientService.deleteClient(intParam(req, "id"));
        }

        resp.sendRedirect(req.getContextPath() + "/");
    }

    private static void fillClient(Client client, HttpServletRequest req) {
        client.setName(required(req, "name"));
        client.setPhone(required(req, "phone"));
        client.setEmail(required(req, "email"));
    }

    private static Integer intParam(HttpServletRequest req, String name) {
        return Integer.valueOf(required(req, name));
    }

    private static String required(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Не заполнено поле: " + name);
        }
        return value.trim();
    }
}
