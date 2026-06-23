<div align="center">

<br/>

<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
<img src="https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white" />
<img src="https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white" />
<img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white" />
<img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white" />
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" />

<br/><br/>

# 🌐 SocialSphere — DBMS Capstone Project

### A fully normalized, production-grade **Social Media Database Application**  
built with **MySQL · Node.js · Express** and an **iOS 27-inspired Liquid Glass UI**

<br/>

[![GitHub Stars](https://img.shields.io/github/stars/raunitx-02/social-media-capstone-project?style=flat-square&color=6366f1)](https://github.com/raunitx-02/social-media-capstone-project/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/raunitx-02/social-media-capstone-project?style=flat-square&color=a855f7)](https://github.com/raunitx-02/social-media-capstone-project/network)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](LICENSE)
[![Node Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen?style=flat-square)](https://nodejs.org)

<br/>

</div>

---

## 📌 Table of Contents

- [📖 Project Overview](#-project-overview)
- [✨ Features](#-features)
- [🧩 Database Schema & E-R Design](#-database-schema--e-r-design)
- [📊 Relational Tables](#-relational-tables)
- [🔗 Relationship Types & Cardinality](#-relationship-types--cardinality)
- [📐 Normalization (1NF → 3NF)](#-normalization-1nf--3nf)
- [🗂️ Advanced SQL Queries](#️-advanced-sql-queries)
- [🖥️ Frontend Dashboard](#️-frontend-dashboard)
- [📁 Project Structure](#-project-structure)
- [⚙️ Setup & Installation](#️-setup--installation)
- [🌐 API Endpoints](#-api-endpoints)
- [🚀 Deployment (Railway)](#-deployment-railway)
- [👥 Team & Contributions](#-team--contributions)

---

## 📖 Project Overview

**SocialSphere** is a **Database Management Systems (DBMS) Capstone Project** that models a real-world social media platform at the database level. The project demonstrates advanced relational database design, normalization theory, SQL query engineering, and backend API development — all wrapped in a modern, premium web interface.

The application supports:
- User registration with multivalued phone numbers
- Social graph (follow / unfollow relationships)
- Post creation, content visibility controls
- Comment threads on posts
- Private messaging between users
- Group / community memberships
- Hashtag categorization of posts
- Like interactions on posts

Everything is connected to a **live MySQL database** and rendered in real-time through a **Node.js Express REST API**.

---

## ✨ Features

### 🗄️ Database Layer
| Feature | Detail |
|---|---|
| **11 Relational Tables** | Covers all entities from the E-R Diagram |
| **1 Virtual View** | `user_activity_summary` for aggregated user metrics |
| **4 Optimized Indexes** | On `username`, `user_id`, `post_id`, `sender/receiver` |
| **183+ Seed Records** | Realistic sample data across all tables |
| **Referential Integrity** | `ON DELETE CASCADE` on all foreign keys |
| **3NF Normalization** | All transitive & partial dependencies removed |
| **CHECK Constraints** | Prevents self-follow (`follower_id ≠ followee_id`) |

### 🌐 Web Application
| Feature | Detail |
|---|---|
| **Table Explorer** | Browse all 11 tables + view live from MySQL |
| **SQL Analytics Engine** | Run 5 categories of mandatory DBMS queries |
| **Live Data Insertion** | INSERT into `users` + `user_phones` (with transaction) |
| **Post Publisher** | INSERT into `posts` with visibility control |
| **One-Click DB Migration** | Auto-runs `schema.sql` + `sample_data.sql` |
| **Onboarding Modal** | iOS-style bouncy spring animation guide on load |
| **Toast Notifications** | Real-time success/error feedback system |

---

## 🧩 Database Schema & E-R Design

The relational schema is derived from the following **Entity-Relationship model**:

### Entities
```
USER       — user_id (PK), username, email, password, bio, d_o_b, join_date
POST       — post_id (PK), content, media_url, created_at, visibility, user_id (FK)
COMMENT    — comment_id (PK), comment_text, created_at, user_id (FK), post_id (FK)
MESSAGE    — message_id (PK), message_text, sent_time, sender_id (FK), receiver_id (FK)
USER_GROUP — group_id (PK), group_name, description, created_on
HASHTAG    — hastag_id (PK), tag_name
```

### Multivalued Attribute Decomposition (1NF)
The `phone_no` attribute on `USER` is **multivalued** (double-oval in E-R diagram).  
To satisfy **First Normal Form**, it is decomposed into a separate table:

```
USER_PHONES — user_id (FK), phone_no  →  PK (user_id, phone_no)
```
This allows a single user to have multiple phone numbers without repeating groups.

---

## 📊 Relational Tables

### `users`
| Column | Type | Constraint |
|---|---|---|
| user_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| username | VARCHAR(50) | UNIQUE, NOT NULL |
| email | VARCHAR(100) | UNIQUE, NOT NULL |
| password | VARCHAR(255) | NOT NULL |
| bio | TEXT | NULLABLE |
| d_o_b | DATE | NOT NULL |
| join_date | DATE | NOT NULL |

### `user_phones` *(3NF Decomposition of multivalued attribute)*
| Column | Type | Constraint |
|---|---|---|
| user_id | INT | FK → users.user_id, ON DELETE CASCADE |
| phone_no | VARCHAR(20) | — |
| — | — | PK (user_id, phone_no) |

### `posts`
| Column | Type | Constraint |
|---|---|---|
| post_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| content | TEXT | NOT NULL |
| media_url | VARCHAR(255) | NULLABLE |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| visibility | VARCHAR(20) | DEFAULT 'public' |
| user_id | INT | FK → users.user_id, ON DELETE CASCADE |

### `comments`
| Column | Type | Constraint |
|---|---|---|
| comment_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| comment_text | TEXT | NOT NULL |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| user_id | INT | FK → users.user_id, ON DELETE CASCADE |
| post_id | INT | FK → posts.post_id, ON DELETE CASCADE |

### `messages`
| Column | Type | Constraint |
|---|---|---|
| message_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| message_text | TEXT | NOT NULL |
| sent_time | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP |
| sender_id | INT | FK → users.user_id, ON DELETE CASCADE |
| receiver_id | INT | FK → users.user_id, ON DELETE CASCADE |

### `user_groups`
| Column | Type | Constraint |
|---|---|---|
| group_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| group_name | VARCHAR(100) | NOT NULL |
| description | TEXT | NULLABLE |
| created_on | DATE | NOT NULL |

### `hashtags`
| Column | Type | Constraint |
|---|---|---|
| hastag_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| tag_name | VARCHAR(50) | UNIQUE, NOT NULL |

### Junction Tables (Many-to-Many Resolvers)

| Table | Resolves | Columns |
|---|---|---|
| `follows` | User ↔ User (recursive) | follower_id, followee_id |
| `likes` | User ↔ Post | user_id, post_id |
| `joins` | User ↔ Group | user_id, group_id, join_date |
| `post_hashtags` | Post ↔ Hashtag | post_id, hastag_id |

---

## 🔗 Relationship Types & Cardinality

| Relationship | Type | Tables Involved | Junction Table |
|---|---|---|---|
| User **creates** Posts | 1 : N | users → posts | — |
| User **writes** Comments | 1 : N | users → comments | — |
| Post **has** Comments | 1 : N | posts → comments | — |
| User **sends** Messages | 1 : N | users → messages (sender) | — |
| User **receives** Messages | 1 : N | users → messages (receiver) | — |
| User **follows** User | M : N (Recursive) | users ↔ users | `follows` |
| User **likes** Post | M : N | users ↔ posts | `likes` |
| User **joins** Group | M : N | users ↔ user_groups | `joins` |
| Post **contains** Hashtag | M : N | posts ↔ hashtags | `post_hashtags` |
| User **has** Phones | 1 : N (Multivalued) | users → user_phones | — |

---

## 📐 Normalization (1NF → 3NF)

### First Normal Form (1NF)
- All attributes contain **atomic values** (no sets, no arrays)
- `phone_no` multivalued attribute decomposed into `user_phones(user_id, phone_no)`
- Every table has a well-defined **primary key**

### Second Normal Form (2NF)
- All tables with composite keys are checked for **partial dependencies**
- In `joins(user_id, group_id, join_date)`: `join_date` depends on the full composite key — no partial dependency ✅
- In `follows(follower_id, followee_id)`: no non-key attributes — trivially 2NF ✅

### Third Normal Form (3NF)
- All **transitive dependencies** eliminated
- User details (bio, dob) live only in `users` — not repeated in `posts` or `comments`
- Post metadata fully depends on `post_id` alone
- No non-key attribute determines another non-key attribute in any table ✅

> **Result:** The schema satisfies **Boyce-Codd Normal Form (BCNF)** for most relations, and at minimum **3NF** for all.

---

## 🗂️ Advanced SQL Queries

All queries are available interactively in the **Analytics** tab and documented in [`queries.sql`](queries.sql).

### 1. INNER JOIN + LEFT JOIN — Posts with Author & Phone
```sql
SELECT 
    p.post_id, p.content, p.created_at,
    u.username,
    MIN(up.phone_no) AS primary_phone
FROM posts p
INNER JOIN users u ON p.user_id = u.user_id
LEFT JOIN user_phones up ON u.user_id = up.user_id
GROUP BY p.post_id, p.content, p.created_at, u.username
ORDER BY p.created_at DESC;
```

### 2. Recursive SELF JOIN — Mutual Followers
```sql
SELECT 
    u1.username AS user_a,
    u2.username AS user_b
FROM follows f1
INNER JOIN follows f2 
    ON f1.follower_id = f2.followee_id 
    AND f1.followee_id = f2.follower_id
INNER JOIN users u1 ON f1.follower_id = u1.user_id
INNER JOIN users u2 ON f1.followee_id = u2.user_id
WHERE f1.follower_id < f1.followee_id;
```

### 3. Nested Subquery — Active Commenters Who Never Posted
```sql
SELECT user_id, username, email 
FROM users 
WHERE user_id IN (SELECT DISTINCT user_id FROM comments)
  AND user_id NOT IN (SELECT DISTINCT user_id FROM posts);
```

### 4. Aggregate Functions — Engagement Metrics Per Post
```sql
SELECT 
    p.post_id,
    SUBSTRING(p.content, 1, 50) AS snippet,
    (SELECT COUNT(*) FROM likes l WHERE l.post_id = p.post_id)        AS likes_count,
    (SELECT COUNT(*) FROM comments c WHERE c.post_id = p.post_id)     AS comments_count,
    (SELECT COUNT(*) FROM post_hashtags ph WHERE ph.post_id = p.post_id) AS hashtags_count
FROM posts p;
```

### 5. GROUP BY + HAVING — Popular Groups
```sql
SELECT 
    g.group_id, g.group_name,
    COUNT(j.user_id) AS member_count
FROM user_groups g
INNER JOIN joins j ON g.group_id = j.group_id
GROUP BY g.group_id, g.group_name
HAVING member_count >= 3;
```

### 6. Virtual VIEW — User Activity Summary
```sql
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    u.user_id, u.username, u.email,
    (SELECT COUNT(*) FROM posts p WHERE p.user_id = u.user_id)       AS total_posts,
    (SELECT COUNT(*) FROM comments c WHERE c.user_id = u.user_id)    AS total_comments,
    (SELECT COUNT(*) FROM follows f WHERE f.follower_id = u.user_id) AS total_following,
    (SELECT COUNT(*) FROM follows f WHERE f.followee_id = u.user_id) AS total_followers
FROM users u;
```

---

## 🖥️ Frontend Dashboard

Built with pure **HTML5, CSS3, and Vanilla JavaScript** — no frameworks.

### Design Language — iOS 27 Liquid Glass
- **Frosted glass** card surfaces with `backdrop-filter: blur(30px) saturate(180%)`
- **Animated ambient orbs** — 4 large gradient blobs drifting in the background
- **Spring physics animations** — `cubic-bezier(0.34, 1.56, 0.64, 1)` for bouncy iOS-style entrances
- **Staggered reveal sequences** — elements animate in with progressive delays
- **Inter typeface** — premium variable-weight system font

### Dashboard Tabs
| Tab | Description |
|---|---|
| **Tables** | Browse all 11 tables + the activity summary view live from MySQL |
| **Analytics** | Click query cards → preview SQL → execute → results table |
| **Insert** | Register users (+ phone number) and publish posts with live transaction support |
| **Setup** | One-click database migration (schema + seed data) |

---

## 📁 Project Structure

```
social-media-capstone-project/
│
├── 📄 schema.sql           # CREATE TABLE statements, indexes, views, constraints
├── 📄 sample_data.sql      # 183 realistic seed records across all 11 tables
├── 📄 queries.sql          # Advanced SQL: Joins, Subqueries, Aggregates, Views
│
├── 📄 server.js            # Express REST API (MySQL pool, routes, transactions)
├── 📄 package.json         # Node.js project manifest + dependencies
├── 📄 .env                 # Local DB credentials (not committed to git)
├── 📄 .gitignore
│
└── 📁 public/              # Frontend static files
    ├── 📄 index.html       # Dashboard HTML — topbar, panels, modal, forms
    ├── 📄 style.css        # iOS 27 Liquid Glass design system (750+ lines)
    └── 📄 app.js           # Client-side logic — fetch, rendering, tab nav
```

---

## ⚙️ Setup & Installation

### Prerequisites
- [Node.js](https://nodejs.org) v18+
- [MySQL](https://dev.mysql.com/downloads/) 8.0+ running locally (or use Railway)

### 1. Clone the repository
```bash
git clone https://github.com/raunitx-02/social-media-capstone-project.git
cd social-media-capstone-project
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure environment (optional)
By default, the app connects to `localhost` with `root` and no password.  
If your MySQL setup is different, create a `.env` file:
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=social_media_db
PORT=3000
```

### 4. Start the server
```bash
npm run dev
```

### 5. Initialize the database
1. Open **[http://localhost:3000](http://localhost:3000)** in your browser
2. Click the **Setup** tab
3. Click **Initialize Database**
4. All 11 tables are created and 183 records are seeded automatically ✅

---

## 🌐 API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/db-status` | Check MySQL connection status |
| `POST` | `/api/setup-database` | Run schema + seed migration |
| `GET` | `/api/table/:name` | Fetch all rows from a table/view |
| `GET` | `/api/query/joins_posts` | INNER + LEFT JOIN query |
| `GET` | `/api/query/joins_mutual` | Recursive SELF JOIN query |
| `GET` | `/api/query/nested_queries` | Nested subquery |
| `GET` | `/api/query/aggregate` | Aggregate COUNT subqueries |
| `GET` | `/api/query/groupby_having` | GROUP BY + HAVING query |
| `POST` | `/api/insert/user` | INSERT user + phone (transaction) |
| `POST` | `/api/insert/post` | INSERT new post |

---

## 🚀 Deployment (Railway)

This project is configured for **zero-config deployment** on [Railway](https://railway.app).

1. **Fork/clone** this repo to your GitHub
2. Go to [railway.app](https://railway.app) → **New Project** → **Deploy from GitHub**
3. Select this repository
4. Add a **MySQL** database service in the same Railway project
5. Link MySQL environment variables to your Node service via **"Add Reference"**
6. Railway auto-builds and deploys 🎉
7. Open the live URL → **Setup → Initialize Database**

---

## 👥 Team & Contributions

| Name | Role |
|---|---|
| **Raunit Jha** | Database Design, SQL Engineering, Full-Stack Development |

> **College:** DBMS Capstone Project Submission  
> **Project Option:** Option 1 — Social Media Application  
> **Tech Stack:** MySQL · Node.js · Express · HTML · CSS · JavaScript

---

<div align="center">

**Built with ❤️ for the DBMS Capstone**  
*SocialSphere — where database theory meets real-world design*

</div>
