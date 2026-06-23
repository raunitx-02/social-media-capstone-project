const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');
const fs = require('fs');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Database connection configuration
const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'social_media_db',
    multipleStatements: true // Required for running schema and seed scripts
};

let pool;

async function initPool() {
    try {
        pool = mysql.createPool(dbConfig);
        // Test connection
        const conn = await pool.getConnection();
        console.log('Connected to MySQL database:', dbConfig.database);
        conn.release();
    } catch (err) {
        console.error('Database connection failed. Express server will run, but database actions will error.', err.message);
    }
}

initPool();

// API: Check database connection status
app.get('/api/db-status', async (req, res) => {
    try {
        if (!pool) {
            return res.json({ connected: false, message: 'Database pool not initialized.' });
        }
        const conn = await pool.getConnection();
        conn.release();
        res.json({ 
            connected: true, 
            config: { 
                host: dbConfig.host, 
                user: dbConfig.user, 
                database: dbConfig.database 
            } 
        });
    } catch (err) {
        res.json({ connected: false, message: err.message });
    }
});

// API: Auto Setup/Initialize Database using schema.sql and sample_data.sql
app.post('/api/setup-database', async (req, res) => {
    try {
        // First connect to MySQL server without database selected to run CREATE DATABASE
        const setupConfig = { ...dbConfig, database: undefined };
        const tempConn = await mysql.createConnection(setupConfig);
        
        const schemaPath = path.join(__dirname, 'schema.sql');
        const schemaSql = fs.readFileSync(schemaPath, 'utf8');
        
        await tempConn.query(schemaSql);
        await tempConn.end();

        // Reconnect with database selected to seed data
        const seedConn = await mysql.createConnection(dbConfig);
        const seedPath = path.join(__dirname, 'sample_data.sql');
        const seedSql = fs.readFileSync(seedPath, 'utf8');
        
        await seedConn.query(seedSql);
        await seedConn.end();

        // Re-initialize pool
        await initPool();

        res.json({ success: true, message: 'Database and tables created, and 100+ records successfully seeded!' });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
});

// API: Fetch all rows from a given table
app.get('/api/table/:name', async (req, res) => {
    const tableName = req.params.name;
    const allowedTables = ['users', 'user_phones', 'posts', 'comments', 'messages', 'user_groups', 'hashtags', 'post_hashtags', 'follows', 'likes', 'joins', 'user_activity_summary'];
    
    if (!allowedTables.includes(tableName)) {
        return res.status(400).json({ error: 'Invalid or restricted table name' });
    }

    try {
        const [rows] = await pool.query(`SELECT * FROM \`${tableName}\` LIMIT 100`);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// API: Run Predefined Complex Queries
app.get('/api/query/:category', async (req, res) => {
    const category = req.params.category;
    let querySql = '';
    let description = '';

    switch (category) {
        case 'joins_posts':
            querySql = `
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
            `;
            description = 'Retrieving posts with primary phone numbers (INNER + LEFT JOIN).';
            break;
        case 'joins_mutual':
            querySql = `
                SELECT 
                    f1.follower_id AS user_a_id,
                    u1.username AS user_a,
                    f1.followee_id AS user_b_id,
                    u2.username AS user_b
                FROM follows f1
                INNER JOIN follows f2 ON f1.follower_id = f2.followee_id AND f1.followee_id = f2.follower_id
                INNER JOIN users u1 ON f1.follower_id = u1.user_id
                INNER JOIN users u2 ON f1.followee_id = u2.user_id
                WHERE f1.follower_id < f1.followee_id;
            `;
            description = 'Self join to identify users who follow each other mutually.';
            break;
        case 'nested_queries':
            querySql = `
                SELECT user_id, username, email 
                FROM users 
                WHERE user_id IN (SELECT DISTINCT user_id FROM comments)
                  AND user_id NOT IN (SELECT DISTINCT user_id FROM posts);
            `;
            description = 'Subqueries to find users who commented but never posted.';
            break;
        case 'aggregate':
            querySql = `
                SELECT 
                    p.post_id,
                    SUBSTRING(p.content, 1, 50) AS snippet,
                    (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id) AS likes_count,
                    (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id) AS comments_count,
                    (SELECT COUNT(*) FROM post_hashtags ph WHERE ph.post_id = p.post_id) AS hashtags_count
                FROM posts p;
            `;
            description = 'Aggregate count subqueries for likes, comments, and hashtags on each post.';
            break;
        case 'groupby_having':
            querySql = `
                SELECT 
                    g.group_id,
                    g.group_name,
                    COUNT(j.user_id) AS member_count
                FROM user_groups g
                INNER JOIN joins j ON g.group_id = j.group_id
                GROUP BY g.group_id, g.group_name
                HAVING member_count >= 3;
            `;
            description = 'GROUP BY with HAVING to display groups with at least 3 members.';
            break;
        default:
            return res.status(400).json({ error: 'Unknown query category' });
    }

    try {
        const [rows] = await pool.query(querySql);
        res.json({ sql: querySql.trim(), description, rows });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// API: Insert New User
app.post('/api/insert/user', async (req, res) => {
    const { username, email, password, bio, dob, phone } = req.body;
    if (!username || !email || !password || !dob) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();
        const joinDate = new Date().toISOString().split('T')[0];
        
        const [result] = await conn.query(
            'INSERT INTO users (username, email, password, bio, d_o_b, join_date) VALUES (?, ?, ?, ?, ?, ?)',
            [username, email, password, bio || '', dob, joinDate]
        );
        const userId = result.insertId;

        if (phone) {
            await conn.query('INSERT INTO user_phones (user_id, phone_no) VALUES (?, ?)', [userId, phone]);
        }

        await conn.commit();
        res.json({ success: true, userId, message: `User ${username} successfully inserted!` });
    } catch (err) {
        await conn.rollback();
        res.status(500).json({ error: err.message });
    } finally {
        conn.release();
    }
});

// API: Insert New Post
app.post('/api/insert/post', async (req, res) => {
    const { content, media_url, visibility, user_id } = req.body;
    if (!content || !user_id) {
        return res.status(400).json({ error: 'Content and user_id are required' });
    }

    try {
        const [result] = await pool.query(
            'INSERT INTO posts (content, media_url, visibility, user_id) VALUES (?, ?, ?, ?)',
            [content, media_url || null, visibility || 'public', user_id]
        );
        res.json({ success: true, postId: result.insertId, message: 'Post successfully created!' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Serve frontend dashboard page
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
