-- Script to test GetAvailableRoom and ReserveRoom procedures

-- Step 1: Get available room
CALL GetAvailableRoom(101, 1, '2023-12-01', '2023-12-02', @available_room_id);

-- Display available room ID
SELECT 'Available Room ID:', @available_room_id AS 'Room ID';

-- Step 2: Reserve the room
CALL ReserveRoom(@available_room_id, 1001, '2023-12-01', '2023-12-02', 2, @reserved_room_id);

-- Display reserved room ID
SELECT 'Reserved Room ID:', @reserved_room_id AS 'Room ID';

-- Display reservation and reservationDetails
SELECT * FROM reservation;
SELECT * FROM reservationDetails;
SELECT * FROM roomAvailability

-- Use Total Bill Function:
SELECT CALCULATE_TOTAL_BILL(1001, '2023-11-15', '2023-11-20') AS total_bill;

-- Use Increment Salary Function
SELECT INCREMENT_SALARY(5001)

-- Testing Booking room using wrapper (use dates 2023-12-01 to 2023-12-03 only because roomAvailability only has dates for those add more to book other dates)
CALL BookRoom(1002, 2, 101, 1, '2023-12-01','2023-12-02')
