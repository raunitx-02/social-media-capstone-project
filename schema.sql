-- Active: Database Management Systems Capstone Project
-- Schema definition for Social Media Application (Project 1)

-- 1. Create Database if not exists
CREATE DATABASE IF NOT EXISTS social_media_db;
USE social_media_db;

-- Drop tables in order of dependencies if they exist
DROP TABLE IF EXISTS joins;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS post_hashtags;
DROP TABLE IF EXISTS hashtags;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS user_phones;
DROP TABLE IF EXISTS user_groups;
DROP TABLE IF EXISTS users;

-- 2. CREATE TABLES

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    bio TEXT,
    d_o_b DATE NOT NULL,
    join_date DATE NOT NULL,
    PRIMARY KEY (user_id)
);

-- User Multivalued Phone Numbers table (3NF Decomposition)
CREATE TABLE user_phones (
    user_id INT,
    phone_no VARCHAR(20),
    PRIMARY KEY (user_id, phone_no),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Posts table
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT,
    content TEXT NOT NULL,
    media_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visibility VARCHAR(20) DEFAULT 'public',
    user_id INT NOT NULL,
    PRIMARY KEY (post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (comment_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

-- Messages table
CREATE TABLE messages (
    message_id INT AUTO_INCREMENT,
    message_text TEXT NOT NULL,
    sent_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    PRIMARY KEY (message_id),
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- User Groups table
CREATE TABLE user_groups (
    group_id INT AUTO_INCREMENT,
    group_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_on DATE NOT NULL,
    PRIMARY KEY (group_id)
);

-- Hashtags table (hastag_id spelled matching the ER Diagram)
CREATE TABLE hashtags (
    hastag_id INT AUTO_INCREMENT,
    tag_name VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY (hastag_id)
);

-- RELATIONSHIP TABLES (Junction Tables)

-- Post Hashtags (Contains) - Many-to-Many
CREATE TABLE post_hashtags (
    post_id INT,
    hastag_id INT,
    PRIMARY KEY (post_id, hastag_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (hastag_id) REFERENCES hashtags(hastag_id) ON DELETE CASCADE
);

-- Follows relationship - Recursive Many-to-Many
CREATE TABLE follows (
    follower_id INT,
    followee_id INT,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT chk_not_self_follow CHECK (follower_id <> followee_id)
);

-- Likes relationship - Many-to-Many
CREATE TABLE likes (
    user_id INT,
    post_id INT,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

-- Joins relationship - Many-to-Many
CREATE TABLE joins (
    user_id INT,
    group_id INT,
    join_date DATE NOT NULL,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES user_groups(group_id) ON DELETE CASCADE
);

-- 3. INDEXES FOR OPTIMIZATION
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_posts_user ON posts(user_id);
CREATE INDEX idx_comments_post ON comments(post_id);
CREATE INDEX idx_messages_conversation ON messages(sender_id, receiver_id);

-- 4. VIEW DEFINITION (For easy aggregation querying)
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    u.user_id,
    u.username,
    u.email,
    (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.user_id) AS total_posts,
    (SELECT COUNT(*) FROM comments c WHERE c.user_id = u.user_id) AS total_comments,
    (SELECT COUNT(*) FROM follows f WHERE f.follower_id = u.user_id) AS total_following,
    (SELECT COUNT(*) FROM follows f WHERE f.followee_id = u.user_id) AS total_followers
FROM users u;
