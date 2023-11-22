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
    -- Check if the email already exists in the database
    IF EXISTS (SELECT 1 FROM customer WHERE email = _email) THEN
        -- If the email exists, we do not insert the new customer and raise an error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A customer with this email already exists.';
    ELSE
        -- If the email does not exist, insert the new customer
        INSERT INTO customer (first_name, last_name, email, phone, DOB)
        VALUES (_first_name, _last_name, _email, _phone, _DOB);
    END IF;
END //

DELIMITER ;

CALL AddCustomer('Jo', 'Doe', 'jon.e@example.com', '123-456-7890', '1990-01-01');

-- Get Available room for given room Id

DELIMITER //

CREATE PROCEDURE GetAvailableRoom(IN hotel_id INT, IN room_type_id INT, IN checkin_date DATE, IN checkout_date DATE, OUT next_room_id INT)
BEGIN
    -- Check if there is an entry in roomAvailability for the given room type and date range
    SELECT MIN(ra.room_id) INTO next_room_id
    FROM roomAvailability ra
    WHERE ra.room_type_id = room_type_id
    AND ra.hotel_id = hotel_id
    AND ra.date BETWEEN checkin_date AND checkout_date
    AND ra.is_available = 1;

    -- If no available room found, set next_room_id to NULL
    IF next_room_id IS NULL THEN
        SET next_room_id = NULL;
    END IF;
END //

DELIMITER ;


-- Reserve Room assuming each extra guest costs same

DELIMITER //

CREATE PROCEDURE ReserveRoom(
    IN room_id INT,
    IN customer_id INT,
    IN checkin_date DATE,
    IN checkout_date DATE,
    IN guest_count INT,
    OUT reservation_id INT
)
BEGIN
    -- Check if the room is available for the given date range
    DECLARE is_room_available INT;

    SELECT COUNT(*) INTO is_room_available
    FROM roomAvailability ra
    WHERE ra.room_id = room_id
        AND ra.date BETWEEN checkin_date AND checkout_date
        AND ra.is_available = 1;

    -- If the room is available, proceed with the reservation
    IF is_room_available > 0 THEN
        -- Insert reservation details
        INSERT INTO reservation (customer_id, checkin_date, checkout_date, guest_count, total_price)
        VALUES (customer_id, checkin_date, checkout_date, guest_count, CALCULATE_TOTAL_PRICE(checkin_date,checkout_date,room_id, guest_count));

        -- Get the last inserted reservation_id
        SET reservation_id = LAST_INSERT_ID();

        -- Insert reservation details for the room
        INSERT INTO reservationDetails (reservation_id, room_id, guest_count)
        VALUES (reservation_id, room_id, guest_count);
        
    ELSE
        -- Room is not available, set reservation_id to NULL
        SET reservation_id = NULL;
    END IF;
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

    -- Find the customer ID associated with the reservation
    SELECT customer_id INTO customerId FROM reservation WHERE reservation_id = resId;

    -- Get the activity_id based on the activity name
    SELECT activity_id INTO newActivityId FROM activity WHERE name = newActivityName;

    -- Get the room_type_id based on the room type name
    SELECT room_type_id INTO newRoomTypeId FROM roomType WHERE type_name = newRoomTypeName;

    -- Update the reservation table
    UPDATE reservation
    SET checkin_date = newCheckInDate, checkout_date = newCheckOutDate, guest_count = newGuestNumber
    WHERE reservation_id = resId;

    -- Update the reservationDetails table
    UPDATE reservationDetails
    SET room_id = (SELECT room_id FROM room WHERE room_type_id = newRoomTypeId LIMIT 1)
    WHERE reservation_id = resId;

    -- Update the activityBooking table based on the customer ID and reservation dates
    UPDATE activityBooking
    SET activity_id = newActivityId
    WHERE customer_id = customerId;
END //

DELIMITER ;
CALL updateReservationDetails(3001, '2024-01-01', '2024-01-05', 4, 'Wine Tasting', 'Deluxe');
