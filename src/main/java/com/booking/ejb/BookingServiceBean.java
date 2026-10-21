package com.booking.ejb;

import com.booking.entity.Booking;
import com.booking.entity.BookingStatus;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class BookingServiceBean {

    @PersistenceContext(unitName = "bookingPU")
    private EntityManager em;

    public List<Booking> getAllBookings() {
        return em.createQuery(
                "SELECT b FROM Booking b LEFT JOIN FETCH b.client ORDER BY b.id DESC",
                Booking.class
        ).getResultList();
    }

    public Booking getBookingById(Integer id) {
        return em.find(Booking.class, id);
    }

    public Booking saveBooking(Booking booking) {
        if (booking.getCheckIn() == null || booking.getCheckOut() == null
                || !booking.getCheckOut().isAfter(booking.getCheckIn())) {
            throw new IllegalArgumentException("Дата выезда должна быть позже даты заезда");
        }
        if (booking.getId() == null) {
            booking.setBookedAt(LocalDateTime.now());
            booking.setStatus(BookingStatus.created);
            em.persist(booking);
            return booking;
        } else {
            return em.merge(booking);
        }
    }

    public void deleteBooking(Integer id) {
        Booking booking = em.find(Booking.class, id);
        if (booking != null) {
            em.remove(booking);
        }
    }
}
