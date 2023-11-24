-- Procedure to get customer reservation details

DELIMITER //

CREATE PROCEDURE GetCustomerReservationDetails(IN customerID INT)
BEGIN
    SELECT 
        c.first_name, 
        c.last_name, 
        h.name AS hotel_name, 
        h.address AS hotel_address, 
        rt.type_name AS room_type, 
        r.room_number, 
        res.checkin_date, 
        res.checkout_date
    FROM 
        customer c
    left JOIN reservation res ON c.customer_id = res.customer_id
    JOIN reservationDetails rd ON res.reservation_id = rd.reservation_id
    JOIN room r ON rd.room_id = r.room_id
    JOIN roomType rt ON r.room_type_id = rt.room_type_id
    JOIN hotel h ON r.hotel_id = h.hotel_id
    WHERE 
        c.customer_id = customerID;
END //

DELIMITER ;
select * from customer;
CALL GetCustomerReservationDetails(1001);

-- Procedure to get employees, their roles and salaries

DELIMITER //

CREATE PROCEDURE GetEmployeeRolesAndSalaries()
BEGIN
    SELECT 
        e.name AS employee_name, 
        e.role, 
        e.salary, 
        h.name AS hotel_name
    FROM 
        employee e
    JOIN hotel h ON e.hotel_id = h.hotel_id;
END //

DELIMITER ;

CALL GetEmployeeRolesAndSalaries();


--   Procedure to add customer
DELIMITER //

CREATE PROCEDURE AddCustomer(
    IN _first_name VARCHAR(255),
    IN _last_name VARCHAR(255),
    IN _email VARCHAR(255),
    IN _phone VARCHAR(20),
    IN _DOB DATE
)
BEGIN
    IF EXISTS (SELECT 1 FROM customer WHERE email = _email) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A customer with this email already exists.';
    ELSE
        INSERT INTO customer (first_name, last_name, email, phone, DOB)
        VALUES (_first_name, _last_name, _email, _phone, _DOB);
    END IF;
END //

DELIMITER ;

CALL AddCustomer('Jo', 'Doe', 'jon.e@example.com', '123-456-7890', '1990-01-01');
-- Get Available room for given room Id

DELIMITER //

CREATE PROCEDURE GetAvailableRoom(
    IN in_hotel_id INT,
    IN in_room_type_id INT,
    IN in_checkin_date DATE,
    IN in_checkout_date DATE,
    OUT next_room_id INT
)
BEGIN
    SELECT MIN(ra.room_id) INTO next_room_id
    FROM roomAvailability ra
    WHERE ra.room_type_id = in_room_type_id
    AND ra.hotel_id = in_hotel_id
    AND ra.date BETWEEN in_checkin_date AND in_checkout_date
    AND ra.is_available = 1;

    IF next_room_id IS NULL THEN
        SET next_room_id = NULL;
    END IF;
END //

DELIMITER ;


-- Reserve Room assuming each extra guest costs same

DELIMITER //

CREATE PROCEDURE ReserveRoom(
    IN in_room_id INT,
    IN in_customer_id INT,
    IN in_checkin_date DATE,
    IN in_checkout_date DATE,
    IN in_guest_count INT,
    OUT out_reservation_id INT
)
BEGIN

    DECLARE is_room_available INT;
    DECLARE booking_hotel_id INT;

    SELECT COUNT(*) INTO is_room_available
    FROM roomAvailability ra
    WHERE ra.room_id = in_room_id
        AND ra.date BETWEEN in_checkin_date AND in_checkout_date
        AND ra.is_available = 1;
    SELECT hotel_id INTO booking_hotel_id FROM room WHERE room_id = in_room_id LIMIT 1;

    IF is_room_available >= DATEDIFF(in_checkin_date, in_checkout_date) + 1 THEN
        INSERT INTO reservation (customer_id, hotel_id, checkin_date, checkout_date, guest_count, total_price)
        VALUES (in_customer_id, booking_hotel_id, in_checkin_date, in_checkout_date, in_guest_count, CALCULATE_TOTAL_PRICE(in_checkin_date, in_checkout_date, in_room_id, in_guest_count));

        SET out_reservation_id = LAST_INSERT_ID();

        INSERT INTO reservationDetails (reservation_id, room_id, guest_count)
        VALUES (out_reservation_id, in_room_id, in_guest_count);
    ELSE
        SET out_reservation_id = NULL;
    END IF;
END //

DELIMITER ;

-- Book Room Procedure
DELIMITER //

CREATE PROCEDURE BookRoom(
    IN customer_id INT,
    IN guest_count INT,
    IN hotel_id INT,
    IN room_type_id INT,
    IN checkin_date DATE,
    IN checkout_date DATE
)
BEGIN
    DECLARE available_room_id INT;
    DECLARE reserved_room_id INT;

    CALL GetAvailableRoom(hotel_id, room_type_id, checkin_date, checkout_date, available_room_id);

    CALL ReserveRoom(available_room_id, customer_id, checkin_date, checkout_date, guest_count, reserved_room_id);
END //

DELIMITER ;


-- Procedure to fetch customer details using customer_id

DELIMITER //

CREATE PROCEDURE GetCustomerDetails(IN customerID INT)
BEGIN
    SELECT * FROM customer WHERE customer_id = customerID;
END //

DELIMITER ;

-- procedure to update customer details
DELIMITER //

CREATE PROCEDURE updateCustomerDetails(
    IN customerId INT,
    IN newPhoneNumber VARCHAR(15),
    IN newEmail VARCHAR(255)
)
BEGIN
    UPDATE customer
    SET phone = newPhoneNumber, email = newEmail
    WHERE customer_id = customerId;
END //

DELIMITER ;

CALL updateCustomerDetails(1001, '555-0301', 'marcopolo@gmail.com');




-- Procedure to update reservation details 
DELIMITER //

CREATE PROCEDURE updateReservationDetails(
    IN resId INT,
    IN newCheckInDate DATE,
    IN newCheckOutDate DATE,
    IN newGuestNumber INT,
    IN newActivityName VARCHAR(255),
    IN newRoomTypeName VARCHAR(255)
)
BEGIN
    DECLARE customerId INT;
    DECLARE newActivityId INT;
    DECLARE newRoomTypeId INT;

    SELECT customer_id INTO customerId FROM reservation WHERE reservation_id = resId;

    SELECT activity_id INTO newActivityId FROM activity WHERE name = newActivityName;

    SELECT room_type_id INTO newRoomTypeId FROM roomType WHERE type_name = newRoomTypeName;

    UPDATE reservation
    SET checkin_date = newCheckInDate, checkout_date = newCheckOutDate, guest_count = newGuestNumber
    WHERE reservation_id = resId;

    UPDATE reservationDetails
    SET room_id = (SELECT room_id FROM room WHERE room_type_id = newRoomTypeId LIMIT 1)
    WHERE reservation_id = resId;

    UPDATE activityBooking
    SET activity_id = newActivityId
    WHERE customer_id = customerId;
END //

DELIMITER ;
CALL updateReservationDetails(3001, '2024-01-01', '2024-01-05', 4, 'Wine Tasting', 'Deluxe');
