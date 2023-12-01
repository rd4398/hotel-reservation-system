CREATE DATABASE IF NOT EXISTS hotel;

USE hotel;
-- Customer Table
CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    DOB DATE NOT NULL
);

-- Hotel Table
CREATE TABLE hotel (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    rating INT
);

-- RoomType Table
CREATE TABLE roomType (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(255) NOT NULL,
    description TEXT
);

-- Room Table

CREATE TABLE room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number INT NOT NULL,
    room_type_id INT,
    hotel_id INT,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id),
    FOREIGN KEY (room_type_id) REFERENCES roomType(room_type_id)
);



-- Reservation Table
CREATE TABLE reservation (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    hotel_id INT,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    guest_count INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- ReservationDetails Table
CREATE TABLE reservationDetails (
    reservation_id INT,
    room_id INT,
    guest_count INT DEFAULT 1,
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (reservation_id,room_id)
);
-- Activity Table
CREATE TABLE activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    type VARCHAR(255)
);

-- ActivityBooking Table
CREATE TABLE activityBooking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    activity_id INT,
    customer_id INT,
    date DATE NOT NULL,
    FOREIGN KEY (activity_id) REFERENCES activity(activity_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Employee Table
CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    hotel_id INT,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Payment Table
CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    type VARCHAR(50),
    date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Review Table
CREATE TABLE review (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    hotel_id INT,
    rating INT NOT NULL,
    comment TEXT,
    source VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotel(hotel_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- RoomAvailability Table
CREATE TABLE roomAvailability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    room_id INT,
    hotel_id INT,
    room_type_id INT,
    is_available BOOLEAN NOT NULL,
    date DATE NOT NULL,
    cleaning_status VARCHAR(50),
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE ON UPDATE CASCADE
);



INSERT INTO customer (customer_id, first_name, last_name, email, phone, DOB) VALUES
(1001, 'Aarav', 'Kumar', 'aarav.kumar@gmail.com', '555-0201', '1985-01-15'),
(1002, 'Vivaan', 'Mehta', 'vivaan.mehta@gmail.com', '555-0202', '1990-07-19'),
(1003, 'Aditi', 'Sharma', 'aditi.sharma@gmail.com', '555-0203', '1982-02-23'),
(1004, 'Saanvi', 'Singh', 'saanvi.singh@gmail.com', '555-0204', '1975-05-30'),
(1005, 'Arjun', 'Patel', 'arjun.patel@gmail.com', '555-0205', '1991-08-12'),
(1006, 'Pari', 'Gupta', 'pari.gupta@gmail.com', '555-0206', '1988-12-06'),
(1007, 'Ishaan', 'Dhawan', 'ishaan.dhawan@gmail.com', '555-0207', '1979-09-17'),
(1008, 'Ananya', 'Bose', 'ananya.bose@gmail.com', '555-0208', '1995-03-22'),
(1009, 'Aryan', 'Chatterjee', 'aryan.chatterjee@gmail.com', '555-0209', '1983-11-11'),
(1010, 'Diya', 'Jain', 'diya.jain@gmail.com', '555-0210', '1974-04-05'),
(1011, 'Vihaan', 'Srivastava', 'vihaan.srivastava@gmail.com', '555-0211', '1992-10-20'),
(1012, 'Riya', 'Mukherjee', 'riya.mukherjee@gmail.com', '555-0212', '1987-06-18'),
(1013, 'Siddharth', 'Nair', 'siddharth.nair@gmail.com', '555-0213', '1980-01-25'),
(1014, 'Aanya', 'Pillai', 'aanya.pillai@gmail.com', '555-0214', '1993-07-07'),
(1015, 'Kabir', 'Malhotra', 'kabir.malhotra@gmail.com', '555-0215', '1986-03-15');

INSERT INTO hotel (hotel_id, name, address, rating) VALUES
(101, 'The Golden Gate Hotel', '100 Bridge Plaza, San Francisco, CA', 5),
(102, 'The Capitol Suites', '200 Senate Ave, Washington, DC', 4),
(103, 'The Lakefront Residency', '300 Lakeside Dr, Chicago, IL', 4),
(104, 'The Alamo Inn', '400 Mission Rd, San Antonio, TX', 3),
(105, 'The Oceanfront Villa', '500 Beachside Blvd, Miami Beach, FL', 5),
(106, 'The Mountain Peak Lodge', '600 Highland Dr, Aspen, CO', 4),
(107, 'The City Center Hotel', '700 Downtown Ln, Las Vegas, NV', 5),
(108, 'The Riverside Mansion', '800 River St, New Orleans, LA', 4),
(109, 'The Beacon Hill Bed & Breakfast', '900 Cobblestone Way, Boston, MA', 4),
(110, 'The Starlight Motel', '1010 Sunset Blvd, Los Angeles, CA', 3);

INSERT INTO roomType (room_type_id, type_name, description) VALUES
(1, 'Standard', 'A standard room with all the basic amenities.'),
(2, 'Deluxe', 'A deluxe room with extra space and a comfortable work area.'),
(3, 'Suite', 'A suite with separate living and sleeping areas for added privacy.'),
(4, 'Family', 'A family-sized room with additional beds and space for comfort.'),
(5, 'Presidential Suite', 'The most luxurious room with premium amenities and services.'),
(6, 'Junior Suite', 'A comfortable suite perfect for shorter stays.'),
(7, 'Executive', 'An executive room with a focus on comfort for business travelers.'),
(8, 'Economy', 'An economical option without compromising on the essentials.'),
(9, 'Superior', 'A superior room with enhanced room amenities and decor.'),
(10, 'Penthouse', 'The pinnacle of luxury, offering expansive space and exclusive amenities.');

-- Inserting sample data into the `room` table
INSERT INTO room (room_id, room_number, room_type_id, hotel_id, price) VALUES
(300, 101, 1, 101, 100.00),
(301, 102, 2, 101, 150.00),
(302, 103, 1, 101, 100.00),
(303, 104, 3, 101, 200.00),
(304, 105, 2, 101, 150.00),
(305, 201, 1, 102, 90.00),
(306, 202, 2, 102, 140.00),
(307, 203, 3, 102, 220.00),
(308, 204, 1, 102, 90.00),
(309, 205, 2, 102, 140.00);


INSERT INTO activity (activity_id, name, description, price, type) VALUES
(4001, 'Spa Day', 'A full day of pampering with massages and treatments.', 120.00, 'Wellness'),
(4002, 'City Tour', 'Guided tour around the city’s historic landmarks.', 60.00, 'Excursion'),
(4003, 'Wine Tasting', 'Sampling of local and international wines.', 50.00, 'Dining'),
(4004, 'Cooking Class', 'Learn to cook local cuisine with our expert chefs.', 70.00, 'Education'),
(4005, 'Yoga Session', 'Morning yoga to rejuvenate body and mind.', 30.00, 'Wellness'),
(4006, 'Golf Round', 'Access to the nearby country club’s golf course.', 90.00, 'Sport'),
(4007, 'Snorkeling Trip', 'Explore the underwater world with a guided snorkeling tour.', 80.00, 'Adventure'),
(4008, 'Horseback Riding', 'Enjoy a ride through scenic trails on horseback.', 75.00, 'Sport'),
(4009, 'Live Concert', 'Evening entertainment featuring live music.', 40.00, 'Entertainment'),
(4010, 'Dinner Cruise', 'A romantic evening cruise with dinner on the deck.', 100.00, 'Dining');


INSERT INTO activityBooking (activity_id, customer_id, date) VALUES
(4001, 1001, '2023-11-15'),
(4002, 1002, '2023-11-16'),
(4003, 1003, '2023-11-17'),
(4003, 1001, '2023-11-16'),
(4003, 1004, '2023-11-19'),
(4004, 1004, '2023-11-18'),
(4005, 1005, '2023-11-19'),
(4008, 1003, '2023-11-22'),
(4009, 1004, '2023-11-23'),
(4010, 1005, '2023-11-24');


INSERT INTO employee (employee_id, name, role, DOB, salary, hotel_id) VALUES
(5001, 'John Doe', 'Receptionist', '1985-01-10', 28000.00, 101),
(5002, 'Jane Smith', 'Housekeeper', '1980-02-15', 24000.00, 101),
(5003, 'Bob Brown', 'Chef', '1975-03-20', 35000.00, 101),
(5004, 'Alice Johnson', 'Manager', '1988-04-25', 40000.00, 101),
(5005, 'Steve Davis', 'Maintenance', '1990-05-01', 30000.00, 102),
(5006, 'Mary Wilson', 'Concierge', '1987-06-05', 32000.00, 102),
(5007, 'Chris Martinez', 'Bartender', '1982-07-10', 25000.00, 102),
(5008, 'Patricia Garcia', 'Event Coordinator', '1993-08-15', 36000.00, 102),
(5009, 'Michael Lee', 'Valet', '1986-09-20', 22000.00, 101),
(5010, 'Linda Thompson', 'Spa Therapist', '1984-10-25', 33000.00, 101);



INSERT INTO payment (amount, type, date) VALUES
(200.00, 'Credit Card', '2023-01-15'),
(450.00, 'Debit Card', '2023-01-16'),
(300.00, 'Cash', '2023-01-17'),
(750.00, 'Credit Card', '2023-01-18'),
(500.00, 'Credit Card', '2023-01-19'),
(650.00, 'Debit Card', '2023-01-20'),
(350.00, 'Cash', '2023-01-21'),
(900.00, 'Credit Card', '2023-01-22'),
(250.00, 'Debit Card', '2023-01-23'),
(100.00, 'Cash', '2023-01-24');

INSERT INTO review (review_id, customer_id, hotel_id, rating, comment, source) VALUES
(1, 1001, 101, 5, 'Outstanding service and beautiful location!', 'Online'),
(2, 1002, 101, 4, 'Very comfortable rooms and friendly staff.', 'Online'),
(3, 1003, 102, 3, 'Decent place but the food service was slow.', 'In-person'),
(4, 1004, 102, 4, 'Great amenities, but the rooms were a bit pricey.', 'Online'),
(5, 1005, 103, 5, 'Perfect stay. The staff went above and beyond!', 'Online'),
(6, 1006, 103, 2, 'The room was not as clean as expected.', 'In-person'),
(7, 1007, 104, 3, 'Average experience, nothing exceptional.', 'Online'),
(8, 1008, 104, 4, 'Good for business stays, internet was fast.', 'Online'),
(9, 1009, 105, 5, 'Loved the spa and the rooftop pool!', 'Online'),
(10, 1010, 105, 1, 'Unsatisfactory experience, would not recommend.', 'In-person');


INSERT INTO roomAvailability (availability_id, room_id, hotel_id, room_type_id, is_available, date, cleaning_status) VALUES
(1, 300,101, 1, TRUE, '2023-12-01', 'Cleaned'),
(2, 301,101,2, TRUE, '2023-12-01', 'Cleaned'),
(3, 302,101,1, TRUE, '2023-12-01', 'Cleaned'),
(4, 303,101,3, TRUE, '2023-12-01', 'Cleaned'),
(5, 304,101,2, TRUE, '2023-12-01', 'Cleaned'),
(6, 305,102,1, TRUE, '2023-12-01', 'Cleaned'),
(7, 306,102,2, TRUE, '2023-12-01', 'Cleaned'),
(8, 307,102,3, TRUE, '2023-12-01', 'Cleaned'),
(9, 308,102,1, TRUE, '2023-12-01', 'Cleaned'),
(10, 309,102,2, TRUE, '2023-12-01', 'Cleaned'),
(11, 300,101,1, TRUE, '2023-12-02', 'Cleaned'),
(12, 301,101,2, TRUE, '2023-12-02', 'Cleaned'),
(13, 302,101,1, TRUE, '2023-12-02', 'Cleaned'),
(14, 303,101,3, TRUE, '2023-12-02', 'Cleaned'),
(15, 304,101,2, TRUE, '2023-12-02', 'Cleaned'),
(16, 305,102,1, TRUE, '2023-12-02', 'Cleaned'),
(17, 306,102,2, TRUE, '2023-12-02', 'Cleaned'),
(18, 307,102,3, TRUE, '2023-12-02', 'Cleaned'),
(19, 308,102,1, TRUE, '2023-12-02', 'Cleaned'),
(20, 309,102,2, TRUE, '2023-12-02', 'Cleaned'),
(21, 300,101,1, TRUE, '2023-12-03', 'Cleaned'),
(22, 301,101,2, TRUE, '2023-12-03', 'Cleaned'),
(23, 302,101,1, TRUE, '2023-12-03', 'Cleaned'),
(24, 303,101,3, TRUE, '2023-12-03', 'Cleaned'),
(25, 304,101,2, TRUE, '2023-12-03', 'Cleaned'),
(26, 305,102,1, TRUE, '2023-12-03', 'Cleaned'),
(27, 306,102,2, TRUE, '2023-12-03', 'Cleaned'),
(28, 307,102,3, TRUE, '2023-12-03', 'Cleaned'),
(29, 308,102,1, TRUE, '2023-12-03', 'Cleaned'),
(30, 309,102,2, TRUE, '2023-12-03', 'Cleaned');


