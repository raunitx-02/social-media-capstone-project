-- Active: Database Management Systems Capstone Project
-- Sample Dataset containing 100+ total records for Social Media Application

USE social_media_db;

-- 1. Populate Users (15 records)
INSERT INTO users (user_id, username, email, password, bio, d_o_b, join_date) VALUES
(1, 'john_doe', 'john@example.com', '$2b$10$eFytJDGtjb...', 'Living life to the fullest. Tech enthusiast.', '1995-05-15', '2025-01-10'),
(2, 'jane_smith', 'jane@example.com', '$2b$10$eFytJDGtjb...', 'Design is intelligence made visible. 🎨', '1998-09-22', '2025-01-12'),
(3, 'alex_jones', 'alex@example.com', '$2b$10$eFytJDGtjb...', 'Explorer, photographer, coffee lover.', '1990-11-05', '2025-01-15'),
(4, 'emily_watson', 'emily@example.com', '$2b$10$eFytJDGtjb...', 'Bibliophile. Writer. Dreamer.', '1993-03-30', '2025-01-20'),
(5, 'david_miller', 'david@example.com', '$2b$10$eFytJDGtjb...', 'Software engineer working on cloud platforms.', '1988-07-12', '2025-02-01'),
(6, 'sarah_connor', 'sarah@example.com', '$2b$10$eFytJDGtjb...', 'No fate but what we make.', '1985-12-10', '2025-02-05'),
(7, 'mike_tyson', 'mike@example.com', '$2b$10$eFytJDGtjb...', 'Former champ. Iron Mike.', '1966-06-30', '2025-02-10'),
(8, 'lisa_simpson', 'lisa@example.com', '$2b$10$eFytJDGtjb...', 'Jazz saxophonist and activist.', '2000-01-01', '2025-02-15'),
(9, 'bruce_wayne', 'bruce@example.com', '$2b$10$eFytJDGtjb...', 'I am vengeance. I am the night.', '1980-02-19', '2025-02-20'),
(10, 'clark_kent', 'clark@example.com', '$2b$10$eFytJDGtjb...', 'Reporter at Daily Planet.', '1982-06-18', '2025-02-22'),
(11, 'diana_prince', 'diana@example.com', '$2b$10$eFytJDGtjb...', 'Amazonian princess. Defender of peace.', '1984-03-22', '2025-02-25'),
(12, 'barry_allen', 'barry@example.com', '$2b$10$eFytJDGtjb...', 'The fastest man alive.', '1992-04-16', '2025-03-01'),
(13, 'hal_jordan', 'hal@example.com', '$2b$10$eFytJDGtjb...', 'In brightest day, in blackest night...', '1989-08-20', '2025-03-03'),
(14, 'arthur_curry', 'arthur@example.com', '$2b$10$eFytJDGtjb...', 'King of Atlantis.', '1986-01-25', '2025-03-05'),
(15, 'victor_stone', 'victor@example.com', '$2b$10$eFytJDGtjb...', 'Part man, part machine. All hero.', '1994-10-11', '2025-03-10');

-- 2. Populate User Phones (15 records)
INSERT INTO user_phones (user_id, phone_no) VALUES
(1, '+1555010011'), (1, '+1555010012'),
(2, '+1555010021'),
(3, '+1555010031'), (3, '+1555010032'),
(4, '+1555010041'),
(5, '+1555010051'),
(6, '+1555010061'),
(8, '+1555010081'),
(9, '+1555010091'),
(10, '+1555010101'),
(11, '+1555010111'),
(12, '+1555010121'),
(14, '+1555010141'),
(15, '+1555010151');

-- 3. Populate Posts (20 records)
INSERT INTO posts (post_id, content, media_url, created_at, visibility, user_id) VALUES
(1, 'Hello World! Excited to join this new social network.', NULL, '2025-01-11 10:00:00', 'public', 1),
(2, 'Working on some beautiful new UI designs today. Stay tuned!', 'https://images.unsplash.com/photo-1541462608141-27b2864e002d', '2025-01-13 09:30:00', 'public', 2),
(3, 'Hiking up the Swiss Alps. The view is absolutely breathtaking.', 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b', '2025-01-16 15:45:00', 'public', 3),
(4, 'Just finished reading "1984" by George Orwell. What a masterpiece.', NULL, '2025-01-21 21:00:00', 'public', 4),
(5, 'Docker and Kubernetes are game changers for backend scalability.', NULL, '2025-02-02 08:00:00', 'public', 5),
(6, 'Preparation is the key to victory in any field.', NULL, '2025-02-11 11:00:00', 'public', 7),
(7, 'Jazz music is the freedom of expression. sax solo tonight!', NULL, '2025-02-16 18:30:00', 'public', 8),
(8, 'Gotham needs a hero. Not the one it wants, but the one it deserves.', 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5', '2025-02-21 02:00:00', 'private', 9),
(9, 'Truth, justice, and a better tomorrow.', NULL, '2025-02-23 12:00:00', 'public', 10),
(10, 'Peace is not just the absence of war, but the presence of justice.', NULL, '2025-02-26 14:00:00', 'public', 11),
(11, 'If you run fast enough, you can outrun your past.', NULL, '2025-03-02 09:15:00', 'public', 12),
(12, 'The universe is vast, but we will protect every sector.', NULL, '2025-03-04 22:00:00', 'public', 13),
(13, 'Deep sea exploration is the next frontier.', 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e', '2025-03-06 06:30:00', 'public', 14),
(14, 'System diagnostic complete. All hardware operating at 100%.', NULL, '2025-03-11 08:45:00', 'public', 15),
(15, 'Had an awesome espresso macchiato at the local cafe.', 'https://images.unsplash.com/photo-1509042239860-f550ce710b93', '2025-03-12 10:00:00', 'public', 3),
(16, 'Designing liquid-glass interfaces is so satisfying. The blur is magic!', 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe', '2025-03-13 16:30:00', 'public', 2),
(17, 'Debugging CSS Grid issues... Why does it align like this?!', NULL, '2025-03-14 11:20:00', 'public', 5),
(18, 'The night is darkest just before the dawn. And I promise you, the dawn is coming.', NULL, '2025-03-15 03:00:00', 'private', 9),
(19, 'Sometimes the best thing you can do is just breathe and observe.', NULL, '2025-03-16 17:00:00', 'public', 4),
(20, 'Anyone down for a run? Let us race.', NULL, '2025-03-17 09:00:00', 'public', 12);

-- 4. Populate Comments (25 records)
INSERT INTO comments (comment_id, comment_text, created_at, user_id, post_id) VALUES
(1, 'Welcome! Glad to have you here.', '2025-01-11 11:00:00', 2, 1),
(2, 'Agreed! Excited for the platform.', '2025-01-11 11:30:00', 3, 1),
(3, 'Wow, that looks stunning! Can not wait to see the final layout.', '2025-01-13 10:00:00', 1, 2),
(4, 'Amazing composition. Love the colors.', '2025-01-13 10:15:00', 4, 2),
(5, 'Is that the Matterhorn? I went there last year!', '2025-01-16 16:00:00', 5, 3),
(6, 'Unbelievable photo, Alex!', '2025-01-16 16:30:00', 2, 3),
(7, 'A chilling yet incredibly deep book. Definitely a favorite.', '2025-01-21 21:30:00', 8, 4),
(8, 'It is scary how accurate some predictions turned out to be.', '2025-01-21 22:00:00', 6, 4),
(9, 'Totally agree. Swarm mode or K8s?', '2025-02-02 08:30:00', 15, 5),
(10, 'K8s for production, docker-compose for local development.', '2025-02-02 09:00:00', 5, 5),
(11, 'Everyone has a plan until they get punched in the mouth.', '2025-02-11 11:15:00', 9, 6),
(12, 'True champion mentality, Mike.', '2025-02-11 12:00:00', 10, 6),
(13, 'Play some Coltrane!', '2025-02-16 19:00:00', 3, 7),
(14, 'You should upload a video of you playing!', '2025-02-16 20:00:00', 1, 7),
(15, 'What is with the dark aesthetic, Bruce?', '2025-02-21 08:00:00', 10, 8),
(16, 'Classic Gotham drama.', '2025-02-21 09:00:00', 11, 8),
(17, 'A motto we can all live by.', '2025-02-23 12:30:00', 11, 9),
(18, 'Inspiring words, Clark.', '2025-02-23 13:00:00', 12, 9),
(19, 'Wisdom from the Princess.', '2025-02-26 14:30:00', 13, 10),
(20, 'Don not trip and fall, Barry.', '2025-03-02 09:30:00', 13, 11),
(21, 'I am fast enough to run on water, Hal.', '2025-03-02 10:00:00', 12, 11),
(22, 'Atlantis is beautiful this time of the year.', '2025-03-06 08:00:00', 11, 13),
(23, 'Show off.', '2025-03-11 09:00:00', 13, 14),
(24, 'Beautiful blur effects. Tutorial please!', '2025-03-13 17:00:00', 1, 16),
(25, 'Nice shot, looks delicious!', '2025-03-12 11:00:00', 2, 15);

-- 5. Populate Messages (20 records)
INSERT INTO messages (message_id, message_text, sent_time, sender_id, receiver_id) VALUES
(1, 'Hey Jane, loved your post about the new UI guidelines!', '2025-01-13 12:00:00', 1, 2),
(2, 'Thanks John! Working hard on the design system.', '2025-01-13 12:05:00', 2, 1),
(3, 'Are you free for a call at 3 PM?', '2025-01-13 12:10:00', 1, 2),
(4, 'Yes, let us talk then.', '2025-01-13 12:15:00', 2, 1),
(5, 'Alex, can you send me the raw photo of the Alps?', '2025-01-16 18:00:00', 2, 3),
(6, 'Sure! Sending a Google Drive link in a minute.', '2025-01-16 18:05:00', 3, 2),
(7, 'Received it, thank you!', '2025-01-16 18:10:00', 2, 3),
(8, 'Hi David, are we still on for the server setup?', '2025-02-02 10:00:00', 15, 5),
(9, 'Yes, ready when you are. Let us launch the database.', '2025-02-02 10:02:00', 5, 15),
(10, 'Do you need help with Gotham City issues, Bruce?', '2025-02-21 10:00:00', 10, 9),
(11, 'I work alone, Clark.', '2025-02-21 10:05:00', 9, 10),
(12, 'If you change your mind, let me know.', '2025-02-21 10:06:00', 10, 9),
(13, 'We need to discuss the Justice League meeting.', '2025-02-26 15:00:00', 11, 9),
(14, 'I will be there.', '2025-02-26 15:05:00', 9, 11),
(15, 'Did you race Barry today?', '2025-03-02 12:00:00', 13, 12),
(16, 'He won... easily.', '2025-03-02 12:05:00', 12, 13),
(17, 'Obviously.', '2025-03-02 12:06:00', 13, 12),
(18, 'Arthur, the telemetry from the deep-sea sensor is offline.', '2025-03-06 10:00:00', 15, 14),
(19, 'I will dive down and inspect it.', '2025-03-06 10:10:00', 14, 15),
(20, 'Thanks! Keep me updated.', '2025-03-06 10:12:00', 15, 14);

-- 6. Populate User Groups (5 records)
INSERT INTO user_groups (group_id, group_name, description, created_on) VALUES
(1, 'Tech & Development', 'A group for software development, systems design, and database architectures.', '2025-01-10'),
(2, 'Creative Designers', 'For sharing portfolios, wireframes, vector arts, and visual inspirations.', '2025-01-12'),
(3, 'Outdoor Explorers', 'Hiking, photography, mountain climbing, and nature trips.', '2025-01-15'),
(4, 'Justice League Official', 'Protecting the earth from cosmic and domestic threats.', '2025-02-15'),
(5, 'Daily Planet Newsroom', 'Editorial discussions, breaking news alerts, and publishing schedules.', '2025-02-20');

-- 7. Populate Joins Relationship (16 records)
INSERT INTO joins (user_id, group_id, join_date) VALUES
(1, 1, '2025-01-11'),
(5, 1, '2025-02-01'),
(15, 1, '2025-03-10'),
(2, 2, '2025-01-12'),
(1, 2, '2025-01-13'),
(3, 3, '2025-01-15'),
(4, 3, '2025-01-20'),
(9, 4, '2025-02-20'),
(10, 4, '2025-02-22'),
(11, 4, '2025-02-25'),
(12, 4, '2025-03-01'),
(13, 4, '2025-03-03'),
(14, 4, '2025-03-05'),
(15, 4, '2025-03-10'),
(10, 5, '2025-02-20'),
(4, 5, '2025-02-22');

-- 8. Populate Hashtags (8 records)
INSERT INTO hashtags (hastag_id, tag_name) VALUES
(1, 'hello'),
(2, 'design'),
(3, 'travel'),
(4, 'coding'),
(5, 'philosophy'),
(6, 'justice'),
(7, 'tech'),
(8, 'nature');

-- 9. Populate Post Hashtags (20 records)
INSERT INTO post_hashtags (post_id, hastag_id) VALUES
(1, 1), (1, 7),
(2, 2),
(3, 3), (3, 8),
(4, 5),
(5, 4), (5, 7),
(8, 6),
(9, 6),
(10, 6),
(13, 8), (13, 3),
(15, 8),
(16, 2), (16, 7),
(17, 4), (17, 7),
(18, 6),
(20, 8);

-- 10. Populate Follows (25 records)
INSERT INTO follows (follower_id, followee_id) VALUES
(1, 2), (1, 3), (1, 5),
(2, 1), (2, 3),
(3, 1), (3, 2),
(4, 1), (4, 2), (4, 3),
(5, 1), (5, 15),
(9, 10), (9, 11),
(10, 9), (10, 11),
(11, 9), (11, 10),
(12, 9), (12, 13),
(13, 12), (13, 9),
(14, 9), (14, 11),
(15, 5);

-- 11. Populate Likes (30 records)
INSERT INTO likes (user_id, post_id) VALUES
(2, 1), (3, 1), (4, 1),
(1, 2), (3, 2), (4, 2),
(1, 3), (2, 3), (5, 3),
(6, 4), (8, 4), (2, 4),
(15, 5), (1, 5), (3, 5),
(9, 6), (10, 6),
(3, 7), (1, 7),
(10, 8), (11, 8),
(11, 9), (12, 9), (9, 9),
(9, 10), (10, 10),
(13, 11),
(14, 13),
(15, 14),
(2, 16);
