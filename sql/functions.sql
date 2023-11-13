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

    -- Calculate the base price for the room type
    SELECT price INTO total_price
    FROM room
    WHERE room_id = room_id_param;

    -- Calculate the total price based on the number of days staying
    SET total_price = total_price * (DATEDIFF(checkout_date_param, checkin_date_param) + 1);

    RETURN total_price;
END //
DELIMITER ;

