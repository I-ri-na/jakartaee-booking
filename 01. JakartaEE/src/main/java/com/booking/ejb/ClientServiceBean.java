package com.booking.ejb;

import com.booking.entity.Client;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;

@Stateless
public class ClientServiceBean {

    @PersistenceContext(unitName = "bookingPU")
    private EntityManager em;

    public List<Client> getAllClients() {
        return em.createQuery("SELECT c FROM Client c ORDER BY c.id", Client.class)
                 .getResultList();
    }

    public Client getClientById(Integer id) {
        return em.find(Client.class, id);
    }

    public Client saveClient(Client client) {
        if (client.getId() == null) {
            em.persist(client);
        } else {
            client = em.merge(client);
        }
        em.flush(); // чтобы нарушение UNIQUE (телефон/email) проявилось сразу
        return client;
    }

    public void deleteClient(Integer id) {
        Client client = em.find(Client.class, id);
        if (client != null) {
            // Сначала удаляем бронирования клиента, затем самого клиента
            em.createQuery("DELETE FROM Booking b WHERE b.client.id = :id")
              .setParameter("id", id)
              .executeUpdate();
            em.remove(client);
        }
    }
}
