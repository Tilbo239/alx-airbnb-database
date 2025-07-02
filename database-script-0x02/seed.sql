-- Users
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
-- Guests
('11111111-1111-1111-1111-111111111111', 'Emma', 'Johnson', 'emma.johnson@gmail.com', 'hash_EmmaJ', '0654231234', 'guest'),
('22222222-2222-2222-2222-222222222222', 'Liam', 'Martin', 'liam.martin@yahoo.com', 'hash_LiamM', '0751239876', 'guest'),
-- Hosts
('33333333-3333-3333-3333-333333333333', 'Claire', 'Dubois', 'claire.dubois@airbnb.com', 'hash_ClaireD', '0678432938', 'host'),
('44444444-4444-4444-4444-444444444444', 'Marco', 'Rossi', 'marco.rossi@host.it', 'hash_MarcoR', '0687654321', 'host'),
-- Admin
('55555555-5555-5555-5555-555555555555', 'Admin', 'System', 'admin@airbnb.com', 'admin_hash', NULL, 'admin');

-- Properties
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', 'Appartement Chic au Marais', 'Charmant 2 pièces lumineux, proche des musées et restaurants.', 'Paris, France', 120.00),
('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaab', '44444444-4444-4444-4444-444444444444', 'Villa Toscane', 'Maison avec piscine et vue sur les collines toscanes.', 'Florence, Italy', 200.00),
('aaaaaaa3-aaaa-aaaa-aaaa-aaaaaaaaaaac', '33333333-3333-3333-3333-333333333333', 'Studio Montmartre', 'Petit studio cosy au pied du Sacré-Cœur.', 'Paris, France', 85.00);

-- Bookings
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', '2025-08-01', '2025-08-05', 480.00, 'confirmed'),
('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbc', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaab', '22222222-2222-2222-2222-222222222222', '2025-07-20', '2025-07-27', 1400.00, 'confirmed'),
('bbbbbbb3-bbbb-bbbb-bbbb-bbbbbbbbbbbd', 'aaaaaaa3-aaaa-aaaa-aaaa-aaaaaaaaaaac', '11111111-1111-1111-1111-111111111111', '2025-09-10', '2025-09-12', 170.00, 'pending');

-- Payments
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES
('ppppppp1-pppp-pppp-pppp-pppppppppppp', 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 480.00, 'credit_card'),
('ppppppp2-pppp-pppp-pppp-pppppppppppa', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbc', 1400.00, 'paypal');

-- Reviews
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES
('rrrrrrr1-rrrr-rrrr-rrrr-rrrrrrrrrrrr', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 5, 'Appartement parfait, emplacement idéal, hôte très réactif.'),
('rrrrrrr2-rrrr-rrrr-rrrr-rrrrrrrrrrrs', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaab', '22222222-2222-2222-2222-222222222222', 4, 'Très belle villa, piscine magnifique. Un peu bruyante le soir.');

-- Messages
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES
('mmmmmmm1-mmmm-mmmm-mmmm-mmmmmmmmmmmm', '11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'Bonjour Claire, l’appartement est-il disponible début août ?'),
('mmmmmmm2-mmmm-mmmm-mmmm-mmmmmmmmmmma', '33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Oui Emma, il est disponible du 1er au 5 août.');
