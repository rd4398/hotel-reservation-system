DELIMITER //
CREATE FUNCTION CALCULATE_TOTAL_PRICE(
    checkin_date_param DATE, 
    checkout_date_param DATE, 
    room_id_param INT, 
    guest_count_param INT
) 
RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
    DECLARE total_price DECIMAL(10, 2);

    SELECT price INTO total_price
    FROM room
    WHERE room_id = room_id_param;

    SET total_price = total_price * (DATEDIFF(checkout_date_param, checkin_date_param) + 1);

    RETURN total_price;
END //
DELIMITER ;

DELIMITER //

CREATE FUNCTION CALCULATE_TOTAL_BILL(
    in_customer_id INT,
    in_checkin_date DATE,
    in_checkout_date DATE
) RETURNS DECIMAL(10, 2) READS SQL DATA
BEGIN
    DECLARE total_reservation_amount DECIMAL(10, 2);
    DECLARE total_activity_amount DECIMAL(10, 2);
    DECLARE total_bill DECIMAL(10, 2);

    SELECT total_price
    INTO total_reservation_amount
    FROM reservation
    WHERE customer_id = in_customer_id
      AND checkin_date = in_checkin_date
      AND checkout_date = in_checkout_date;

    SELECT COALESCE(SUM(a.price), 0)
    INTO total_activity_amount
    FROM activityBooking ab
    JOIN activity a ON ab.activity_id = a.activity_id
    WHERE ab.customer_id = in_customer_id
      AND ab.date >= in_checkin_date
      AND ab.date <= in_checkout_date;

    SET total_bill = total_reservation_amount + total_activity_amount;

    RETURN total_bill;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION INCREMENT_SALARY(
    in_employee_id INT 
) RETURNS DECIMAL(10, 2) READS SQL DATA
BEGIN
    SET @original_salary := (SELECT salary FROM employee WHERE employee_id = in_employee_id);

    IF @original_salary IS NOT NULL THEN
        -- 10% increment
        SET @new_salary := @original_salary * 1.10;

        UPDATE employee
        SET salary = @new_salary
        WHERE employee_id = in_employee_id;

        RETURN @new_salary; 
    ELSE
        RETURN NULL; 
    END IF;
END //

DELIMITER ;
