USE alx_airbnb_database;

INSERT INTO User (first_name, last_name, email, password_hash, phone_number, role)
VALUES
('Alice', 'Smith', 'alice@example.com', 'hashedpass1', '1234567890', 'guest'),
('Bob', 'Johnson', 'bob@example.com', 'hashedpass2', '1234567891', 'host'),
('Charlie', 'Lee', 'charlie@example.com', 'hashedpass3', NULL, 'admin'),
('Diana', 'Brown', 'diana@example.com', 'hashedpass4', '1234567893', 'host'),
('Evan', 'Davis', 'evan@example.com', 'hashedpass5', '1234567894', 'guest'),
('Fiona', 'Clark', 'fiona@example.com', 'hashedpass6', NULL, 'guest'),
('George', 'White', 'george@example.com', 'hashedpass7', '1234567896', 'host'),
('Hannah', 'Lewis', 'hannah@example.com', 'hashedpass8', '1234567897', 'admin'),
('Ian', 'Hall', 'ian@example.com', 'hashedpass9', '1234567898', 'host'),
('Jane', 'Young', 'jane@example.com', 'hashedpass10', '1234567899', 'guest');

INSERT INTO Property (host_id, name, description, location, pricepernight)
VALUES
((SELECT user_id FROM User WHERE email='bob@example.com'), 'Cozy Cottage', 'A small cottage in the woods.', 'Oregon', 120.00),
((SELECT user_id FROM User WHERE email='diana@example.com'), 'Modern Apartment', 'Sleek city living.', 'New York', 150.00),
((SELECT user_id FROM User WHERE email='george@example.com'), 'Mountain Retreat', 'Peaceful cabin view.', 'Colorado', 180.00),
((SELECT user_id FROM User WHERE email='ian@example.com'), 'Beach Bungalow', 'Steps from the beach.', 'California', 200.00),
((SELECT user_id FROM User WHERE email='bob@example.com'), 'Lake House', 'Beautiful lakefront.', 'Michigan', 170.00),
((SELECT user_id FROM User WHERE email='diana@example.com'), 'Downtown Loft', 'In the heart of the city.', 'Chicago', 160.00),
((SELECT user_id FROM User WHERE email='george@example.com'), 'Desert Escape', 'Unique desert experience.', 'Arizona', 110.00),
((SELECT user_id FROM User WHERE email='ian@example.com'), 'Farm Stay', 'Experience rural life.', 'Texas', 90.00),
((SELECT user_id FROM User WHERE email='bob@example.com'), 'Historic Home', 'Charming old house.', 'Virginia', 130.00),
((SELECT user_id FROM User WHERE email='diana@example.com'), 'City Studio', 'Compact city living.', 'Seattle', 140.00);

INSERT INTO Booking (property_id, user_id, start_date, end_date, total_price, status)
SELECT p.property_id, u.user_id, DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 10) DAY), DATE_ADD(CURDATE(), INTERVAL 10 + FLOOR(RAND() * 5) DAY), 150 + FLOOR(RAND() * 200),
ELT(FLOOR(1 + RAND() * 3), 'pending', 'confirmed', 'canceled')
FROM Property p
JOIN User u ON u.role = 'guest'
LIMIT 10;

INSERT INTO Payment (booking_id, amount, payment_method)
SELECT booking_id, total_price,
ELT(FLOOR(1 + RAND() * 3), 'credit_card', 'paypal', 'stripe')
FROM Booking
LIMIT 10;

INSERT INTO Review (property_id, user_id, rating, comment)
SELECT p.property_id, u.user_id, FLOOR(1 + RAND() * 5), CONCAT('Nice place! Rating: ', FLOOR(1 + RAND() * 5))
FROM Property p
JOIN User u ON u.role = 'guest'
LIMIT 10;

INSERT INTO Message (sender_id, recipient_id, message_body)
SELECT u1.user_id, u2.user_id, CONCAT('Hello from ', u1.first_name)
FROM User u1
JOIN User u2 ON u1.user_id != u2.user_id
LIMIT 10;