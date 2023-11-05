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

