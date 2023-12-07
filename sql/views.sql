-- View for highest rated hotels

CREATE VIEW highestRatedHotels AS
SELECT
    h.name AS hotel_name,
    AVG(r.rating) AS average_rating
FROM
    hotel h
JOIN
    review r ON h.hotel_id = r.hotel_id
GROUP BY
    h.hotel_id
ORDER BY
    average_rating;

-- View for most booked activities

CREATE VIEW mostBookedActivities AS
SELECT
    a.name AS activity_name,
    COUNT(ab.booking_id) AS times_booked
FROM
    activity a
JOIN
    activityBooking ab ON a.activity_id = ab.activity_id
GROUP BY
    a.activity_id
ORDER BY
times_booked DESC;

