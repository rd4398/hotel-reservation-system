DELIMITER //

CREATE TRIGGER UpdateRoomAvailabilityAfterReservation
AFTER INSERT ON reservationDetails
FOR EACH ROW
BEGIN
    DECLARE checkindate DATE;
    DECLARE checkoutdate DATE;

    SELECT checkin_date, checkout_date INTO checkindate, checkoutdate
    FROM reservation
    WHERE reservation_id = NEW.reservation_id;

    UPDATE roomAvailability
    SET is_available = 0
    WHERE room_id = NEW.room_id
        AND date BETWEEN checkindate AND checkoutdate;
END //

DELIMITER ;
