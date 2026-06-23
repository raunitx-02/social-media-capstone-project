-- Active: Database Management Systems Capstone Project
-- Advanced SQL queries demonstration matching Capstone requirements

USE social_media_db;

-- 1. JOINS (Inner, Left, and Self Joins)
-- A. Retrieve posts along with the creator's username and their primary phone number (Inner and Left Join)
SELECT 
    p.post_id,
    p.content,
    p.created_at,
    u.username,
    MIN(up.phone_no) AS primary_phone
FROM posts p
INNER JOIN users u ON p.user_id = u.user_id
LEFT JOIN user_phones up ON u.user_id = up.user_id
GROUP BY p.post_id, p.content, p.created_at, u.username
ORDER BY p.created_at DESC;

-- B. SELF JOIN: Find pairs of users who follow each other (mutual follows)
SELECT 
    f1.follower_id AS user_a_id,
    u1.username AS user_a,
    f1.followee_id AS user_b_id,
    u2.username AS user_b
FROM follows f1
INNER JOIN follows f2 ON f1.follower_id = f2.followee_id AND f1.followee_id = f2.follower_id
INNER JOIN users u1 ON f1.follower_id = u1.user_id
INNER JOIN users u2 ON f1.followee_id = u2.user_id
WHERE f1.follower_id < f1.followee_id; -- Avoid duplicate symmetric rows


-- 2. NESTED QUERIES / SUBQUERIES
-- Find users who have written comments but have NEVER created a post themselves
SELECT user_id, username, email 
FROM users 
WHERE user_id IN (SELECT DISTINCT user_id FROM comments)
  AND user_id NOT IN (SELECT DISTINCT user_id FROM posts);


-- 3. AGGREGATE FUNCTIONS
-- Retrieve the total number of likes, total comments, and total hashtags for each post
SELECT 
    p.post_id,
    SUBSTRING(p.content, 1, 50) AS snippet,
    (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS likes_count,
    (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comments_count,
    (SELECT COUNT(*) FROM post_hashtags ph WHERE ph.post_id = p.post_id) AS hashtags_count
FROM posts p;


-- 4. GROUP BY AND HAVING
-- Find groups that have 3 or more members who joined after January 1st, 2025
SELECT 
    g.group_id,
    g.group_name,
    COUNT(j.user_id) AS member_count
FROM user_groups g
INNER JOIN joins j ON g.group_id = j.group_id
GROUP BY g.group_id, g.group_name
HAVING member_count >= 3;


-- 5. VIEW EXPLORATION
-- Select all active members using the user activity summary view
SELECT * 
FROM user_activity_summary
WHERE total_posts > 0 OR total_comments > 0
ORDER BY total_posts DESC;
