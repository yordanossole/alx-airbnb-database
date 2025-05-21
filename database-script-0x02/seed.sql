INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
(UUID(), 'Alice', 'Smith', 'alice@example.com', 'hashedpass1', '1234567890', 'guest'),
(UUID(), 'Bob', 'Johnson', 'bob@example.com', 'hashedpass2', '1234567891', 'host'),
(UUID(), 'Charlie', 'Lee', 'charlie@example.com', 'hashedpass3', NULL, 'admin'),
(UUID(), 'Diana', 'Brown', 'diana@example.com', 'hashedpass4', '1234567893', 'host'),
(UUID(), 'Evan', 'Davis', 'evan@example.com', 'hashedpass5', '1234567894', 'guest'),
(UUID(), 'Fiona', 'Clark', 'fiona@example.com', 'hashedpass6', NULL, 'guest'),
(UUID(), 'George', 'White', 'george@example.com', 'hashedpass7', '1234567896', 'host'),
(UUID(), 'Hannah', 'Lewis', 'hannah@example.com', 'hashedpass8', '1234567897', 'admin'),
(UUID(), 'Ian', 'Hall', 'ian@example.com', 'hashedpass9', '1234567898', 'host'),
(UUID(), 'Jane', 'Young', 'jane@example.com', 'hashedpass10', '1234567899', 'guest');

INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
(UUID(), (SELECT user_id FROM User WHERE email='bob@example.com'), 'Cozy Cottage', 'A small cottage in the woods.', 'Oregon', 120.00),
(UUID(), (SELECT user_id FROM User WHERE email='diana@example.com'), 'Modern Apartment', 'Sleek city living.', 'New York', 150.00),
(UUID(), (SELECT user_id FROM User WHERE email='george@example.com'), 'Mountain Retreat', 'Peaceful cabin view.', 'Colorado', 180.00),
(UUID(), (SELECT user_id FROM User WHERE email='ian@example.com'), 'Beach Bungalow', 'Steps from the beach.', 'California', 200.00),
(UUID(), (SELECT user_id FROM User WHERE email='bob@example.com'), 'Lake House', 'Beautiful lakefront.', 'Michigan', 170.00),
(UUID(), (SELECT user_id FROM User WHERE email='diana@example.com'), 'Downtown Loft', 'In the heart of the city.', 'Chicago', 160.00),
(UUID(), (SELECT user_id FROM User WHERE email='george@example.com'), 'Desert Escape', 'Unique desert experience.', 'Arizona', 110.00),
(UUID(), (SELECT user_id FROM User WHERE email='ian@example.com'), 'Farm Stay', 'Experience rural life.', 'Texas', 90.00),
(UUID(), (SELECT user_id FROM User WHERE email='bob@example.com'), 'Historic Home', 'Charming old house.', 'Virginia', 130.00),
(UUID(), (SELECT user_id FROM User WHERE email='diana@example.com'), 'City Studio', 'Compact city living.', 'Seattle', 140.00);

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
SELECT UUID(), p.property_id, u.user_id, DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 10) DAY), DATE_ADD(CURDATE(), INTERVAL 10 + FLOOR(RAND() * 5) DAY), 150 + FLOOR(RAND() * 200),
ELT(FLOOR(1 + RAND() * 3), 'pending', 'confirmed', 'canceled')
FROM Property p
JOIN User u ON u.role = 'guest'
LIMIT 10;

INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
SELECT UUID(), booking_id, total_price,
ELT(FLOOR(1 + RAND() * 3), 'credit_card', 'paypal', 'stripe')
FROM Booking
LIMIT 10;

INSERT INTO Review (review_id, property_id, user_id, rating, comment)
SELECT UUID(), p.property_id, u.user_id, FLOOR(1 + RAND() * 5), CONCAT('Nice place! Rating: ', FLOOR(1 + RAND() * 5))
FROM Property p
JOIN User u ON u.role = 'guest'
LIMIT 10;

INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
SELECT UUID(), u1.user_id, u2.user_id, CONCAT('Hello from ', u1.first_name)
FROM User u1
JOIN User u2 ON u1.user_id != u2.user_id
LIMIT 10;