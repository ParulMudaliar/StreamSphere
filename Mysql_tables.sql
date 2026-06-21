-- ============================================================
-- StreamSphere Database — Fixed & Complete Script
-- ============================================================

CREATE DATABASE IF NOT EXISTS StreamSphere;
USE StreamSphere;

-- ------------------------------------------------------------
-- USER
-- ------------------------------------------------------------
CREATE TABLE USER (
    user_ID       INT          NOT NULL AUTO_INCREMENT,
    first_name    VARCHAR(100) NOT NULL,
    last_name     VARCHAR(100) NOT NULL,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(255) NOT NULL UNIQUE,
    date_of_birth DATE,
    Joining_date  DATE,
    PRIMARY KEY (user_ID)
);

-- ------------------------------------------------------------
-- USER_CONTACT
-- ------------------------------------------------------------
CREATE TABLE USER_CONTACT (
    contact_ID     INT         NOT NULL AUTO_INCREMENT,
    contact_number VARCHAR(20),
    user_ID        INT         NOT NULL,
    PRIMARY KEY (contact_ID),
    CONSTRAINT fk_usercontact_user FOREIGN KEY (user_ID) REFERENCES USER (user_ID)
);

-- ------------------------------------------------------------
-- ADMINISTRATOR  (specialisation of USER)
-- ------------------------------------------------------------
CREATE TABLE ADMINISTRATOR (
    Admin_ID   INT          NOT NULL,
    department VARCHAR(100),
    job_title  VARCHAR(100),
    hire_date  DATE,
    PRIMARY KEY (Admin_ID),
    CONSTRAINT fk_admin_user FOREIGN KEY (Admin_ID) REFERENCES USER (user_ID)
);

-- ------------------------------------------------------------
-- CREATOR  (specialisation of USER)
-- ------------------------------------------------------------
CREATE TABLE CREATOR (
    Creator_ID   INT          NOT NULL,
    Channel_desc TEXT,
    Followers    INT          DEFAULT 0,
    Verified     TINYINT(1)   DEFAULT 0,
    PRIMARY KEY (Creator_ID),
    CONSTRAINT fk_creator_user FOREIGN KEY (Creator_ID) REFERENCES USER (user_ID)
);

-- ------------------------------------------------------------
-- VIEWER  (specialisation of USER)
-- ------------------------------------------------------------
CREATE TABLE VIEWER (
    Viewer_id         INT         NOT NULL,
    account_status    VARCHAR(50),
    prefered_language VARCHAR(50),
    PRIMARY KEY (Viewer_id),
    CONSTRAINT fk_viewer_user FOREIGN KEY (Viewer_id) REFERENCES USER (user_ID)
);

-- ------------------------------------------------------------
-- SUBSCRIPTION_PLAN
-- ------------------------------------------------------------
CREATE TABLE SUBSCRIPTION_PLAN (
    plan_ID                 INT            NOT NULL AUTO_INCREMENT,
    subs_ID                 INT,
    monthly_fee             DECIMAL(10, 2),
    max_streams             INT,
    max_vid_qual            VARCHAR(50),
    subscription_start_date DATE,
    subscription_end_date   DATE,
    Viewer_id               INT            NOT NULL,
    PRIMARY KEY (plan_ID),
    CONSTRAINT fk_subplan_viewer FOREIGN KEY (Viewer_id) REFERENCES VIEWER (Viewer_id)
);

-- ------------------------------------------------------------
-- PAYMENT
-- ------------------------------------------------------------
CREATE TABLE PAYMENT (
    pay_ID     INT            NOT NULL AUTO_INCREMENT,
    amount     DECIMAL(10, 2),
    pay_date   DATE,
    pay_method VARCHAR(100),
    pay_status VARCHAR(50),
    user_ID    INT            NOT NULL,
    PRIMARY KEY (pay_ID),
    CONSTRAINT fk_payment_user FOREIGN KEY (user_ID) REFERENCES USER (user_ID)
);

-- ------------------------------------------------------------
-- CONTENT
-- ------------------------------------------------------------
CREATE TABLE CONTENT (
    content_ID     INT          NOT NULL AUTO_INCREMENT,
    title          VARCHAR(255) NOT NULL,
    publish_status VARCHAR(50),
    release_date   DATE,
    language       VARCHAR(50),
    content_desc   TEXT,
    creator_ID     INT,
    PRIMARY KEY (content_ID),
    CONSTRAINT fk_content_creator FOREIGN KEY (creator_ID) REFERENCES CREATOR (Creator_ID)
);

-- ------------------------------------------------------------
-- CONTENT_GENRE
-- ------------------------------------------------------------
CREATE TABLE CONTENT_GENRE (
    content_ID INT          NOT NULL,
    genre      VARCHAR(100) NOT NULL,
    PRIMARY KEY (content_ID, genre),
    CONSTRAINT fk_genre_content FOREIGN KEY (content_ID) REFERENCES CONTENT (content_ID)
);

-- ------------------------------------------------------------
-- SHORT_CLIPS  (specialisation of CONTENT)
-- ------------------------------------------------------------
CREATE TABLE SHORT_CLIPS (
    content_ID INT  NOT NULL,
    length     INT,
    likes      INT  DEFAULT 0,
    PRIMARY KEY (content_ID),
    CONSTRAINT fk_shortclips_content FOREIGN KEY (content_ID) REFERENCES CONTENT (content_ID)
);

-- ------------------------------------------------------------
-- MOVIES  (specialisation of CONTENT)
-- ------------------------------------------------------------
CREATE TABLE MOVIES (
    content_ID INT         NOT NULL,
    duration   INT,
    rating     VARCHAR(20),
    PRIMARY KEY (content_ID),
    CONSTRAINT fk_movies_content FOREIGN KEY (content_ID) REFERENCES CONTENT (content_ID)
);

-- ------------------------------------------------------------
-- TV_SHOWS  (specialisation of CONTENT)
-- ------------------------------------------------------------
CREATE TABLE TV_SHOWS (
    content_ID INT          NOT NULL,
    ratings    DECIMAL(3,1),
    spin_off   INT,
    PRIMARY KEY (content_ID),
    CONSTRAINT fk_tvshows_content FOREIGN KEY (content_ID) REFERENCES CONTENT (content_ID),
    CONSTRAINT fk_tvshows_spinoff FOREIGN KEY (spin_off)   REFERENCES CONTENT (content_ID)
);

-- ------------------------------------------------------------
-- SEASONS
-- ------------------------------------------------------------
CREATE TABLE SEASONS (
    season_id  INT NOT NULL AUTO_INCREMENT,
    Number     INT,
    content_ID INT NOT NULL,
    PRIMARY KEY (season_id),
    CONSTRAINT fk_seasons_tvshow FOREIGN KEY (content_ID) REFERENCES TV_SHOWS (content_ID)
);

-- ------------------------------------------------------------
-- EPISODE
-- ------------------------------------------------------------
CREATE TABLE EPISODE (
    Episode_id INT NOT NULL AUTO_INCREMENT,
    Number     INT,
    Length     INT,
    season_id  INT NOT NULL,
    PRIMARY KEY (Episode_id),
    CONSTRAINT fk_episode_season FOREIGN KEY (season_id) REFERENCES SEASONS (season_id)
);

-- ------------------------------------------------------------
-- ACTORS
-- ------------------------------------------------------------
CREATE TABLE ACTORS (
    Actor_id   INT          NOT NULL AUTO_INCREMENT,
    Name       VARCHAR(255),
    Gender     VARCHAR(20),
    Movie_id   INT,
    TV_show_id INT,
    PRIMARY KEY (Actor_id),
    CONSTRAINT fk_actor_movie  FOREIGN KEY (Movie_id)   REFERENCES MOVIES   (content_ID),
    CONSTRAINT fk_actor_tvshow FOREIGN KEY (TV_show_id) REFERENCES TV_SHOWS (content_ID)
);

-- ------------------------------------------------------------
-- HISTORY
-- ------------------------------------------------------------
CREATE TABLE HISTORY (
    history_ID         INT          NOT NULL AUTO_INCREMENT,
    watch_timestamp    DATETIME,
    completion_percent DECIMAL(5,2),
    user_ID            INT          NOT NULL,
    content_ID         INT          NOT NULL,
    PRIMARY KEY (history_ID),
    CONSTRAINT fk_history_user    FOREIGN KEY (user_ID)    REFERENCES USER    (user_ID),
    CONSTRAINT fk_history_content FOREIGN KEY (content_ID) REFERENCES CONTENT (content_ID)
);

-- ------------------------------------------------------------
-- CONTENT_CONSUMPTION  (junction: VIEWER <-> CONTENT)
-- ------------------------------------------------------------
CREATE TABLE CONTENT_CONSUMPTION (
    viewer_ID   INT      NOT NULL,
    content_ID  INT      NOT NULL,
    consumed_at DATETIME,
    PRIMARY KEY (viewer_ID, content_ID),
    CONSTRAINT fk_cc_viewer  FOREIGN KEY (viewer_ID)  REFERENCES VIEWER  (Viewer_id),
    CONSTRAINT fk_cc_content FOREIGN KEY (content_ID) REFERENCES CONTENT (content_ID)
);

-- ------------------------------------------------------------
-- WATCHED  (NEW — junction: VIEWER <-> HISTORY)
-- ------------------------------------------------------------
CREATE TABLE WATCHED (
    viewer_id  INT NOT NULL,
    history_id INT NOT NULL,
    PRIMARY KEY (viewer_id, history_id),
    CONSTRAINT fk_watched_viewer  FOREIGN KEY (viewer_id)  REFERENCES VIEWER  (Viewer_id),
    CONSTRAINT fk_watched_history FOREIGN KEY (history_id) REFERENCES HISTORY (history_ID)
);

-- ============================================================
-- INSERT DATA
-- ============================================================

INSERT INTO USER (user_ID, first_name, last_name, username, email, date_of_birth, Joining_date) VALUES
(1,  'Alice',   'Morgan',    'amorgan',    'alice.morgan@email.com',  '1990-03-12', '2022-01-10'),
(2,  'Brian',   'Cho',       'bcho',       'brian.cho@email.com',     '1985-07-22', '2021-06-15'),
(3,  'Carla',   'Diaz',      'cdiaz',      'carla.diaz@email.com',    '1992-11-05', '2022-03-20'),
(4,  'David',   'Osei',      'dosei',      'david.osei@email.com',    '1988-09-18', '2020-08-01'),
(5,  'Elena',   'Kovacs',    'ekovacs',    'elena.kovacs@email.com',  '1995-01-30', '2023-02-14'),
(6,  'Frank',   'Lin',       'flin',       'frank.lin@email.com',     '1991-04-08', '2021-09-05'),
(7,  'Grace',   'Okafor',    'gokafor',    'grace.okafor@email.com',  '1993-12-17', '2022-07-11'),
(8,  'Hiro',    'Tanaka',    'htanaka',    'hiro.tanaka@email.com',   '1989-06-25', '2020-11-30'),
(9,  'Isla',    'Petrov',    'ipetrov',    'isla.petrov@email.com',   '1997-02-14', '2023-01-07'),
(10, 'James',   'Nwosu',     'jnwosu',     'james.nwosu@email.com',   '1986-08-03', '2019-04-22'),
(11, 'Karen',   'Bell',      'kbell',      'karen.bell@email.com',    '1994-05-19', '2022-10-01'),
(12, 'Leo',     'Sato',      'lsato',      'leo.sato@email.com',      '1990-09-27', '2021-12-15'),
(13, 'Mia',     'Ferreira',  'mferreira',  'mia.ferreira@email.com',  '1998-03-06', '2023-03-28'),
(14, 'Nathan',  'Johansson', 'njohansson', 'nathan.j@email.com',      '1987-11-11', '2020-05-17'),
(15, 'Olivia',  'Park',      'opark',      'olivia.park@email.com',   '1996-07-23', '2022-08-09');

INSERT INTO USER_CONTACT (contact_number, user_ID) VALUES
('+1-555-0101', 1),
('+1-555-0102', 2),
('+1-555-0103', 3),
('+1-555-0104', 4),
('+1-555-0105', 5);

INSERT INTO ADMINISTRATOR (Admin_ID, department, job_title, hire_date) VALUES
(1, 'Engineering', 'Platform Engineer', '2022-01-10'),
(2, 'Content',     'Content Moderator', '2021-06-15'),
(3, 'Finance',     'Finance Manager',   '2022-03-20'),
(4, 'Operations',  'Ops Lead',          '2020-08-01'),
(5, 'HR',          'HR Specialist',     '2023-02-14');

INSERT INTO CREATOR (Creator_ID, Channel_desc, Followers, Verified) VALUES
(6,  'Tech reviews and coding tutorials',  120000, 1),
(7,  'Lifestyle, travel and food vlogs',    85000, 1),
(8,  'Anime and manga deep-dives',          47000, 0),
(9,  'Music covers and original songs',     33000, 0),
(10, 'Documentary storytelling channel',   210000, 1);

INSERT INTO VIEWER (Viewer_id, account_status, prefered_language) VALUES
(11, 'Active',    'English'),
(12, 'Active',    'Japanese'),
(13, 'Suspended', 'Portuguese'),
(14, 'Active',    'Swedish'),
(15, 'Active',    'Korean');

INSERT INTO SUBSCRIPTION_PLAN (subs_ID, monthly_fee, max_streams, max_vid_qual, subscription_start_date, subscription_end_date, Viewer_id) VALUES
(101,  9.99, 1, '1080p',  '2024-01-01', '2025-01-01', 11),
(102, 14.99, 2, '4K',     '2024-02-15', '2025-02-15', 12),
(103,  9.99, 1, '1080p',  '2024-03-01', '2025-03-01', 13),
(104, 19.99, 4, '4K HDR', '2024-01-20', '2025-01-20', 14),
(105, 14.99, 2, '4K',     '2024-04-10', '2025-04-10', 15);

INSERT INTO PAYMENT (amount, pay_date, pay_method, pay_status, user_ID) VALUES
( 9.99, '2024-01-01', 'Credit Card', 'Completed', 11),
(14.99, '2024-02-15', 'PayPal',      'Completed', 12),
( 9.99, '2024-03-01', 'Debit Card',  'Failed',    13),
(19.99, '2024-01-20', 'Credit Card', 'Completed', 14),
(14.99, '2024-04-10', 'Apple Pay',   'Completed', 15);

INSERT INTO CONTENT (content_ID, title, publish_status, release_date, language, content_desc, creator_ID) VALUES
(1,  'Quick Python Tips',          'Published', '2024-01-15', 'English',  '5 Python tricks in 60 seconds',             6),
(2,  'Tokyo Street Food Tour',     'Published', '2024-02-20', 'English',  'A quick taste of Tokyo street eats',         7),
(3,  'Top 10 Anime Openings',      'Published', '2024-03-05', 'English',  'Ranking the most iconic anime intros',       8),
(4,  'Acoustic Cover - Starlight', 'Published', '2024-03-18', 'English',  'Mia covers Starlight on acoustic guitar',    9),
(5,  'Behind the Lens',            'Published', '2024-04-01', 'English',  'A 90-second documentary teaser',             10),
(6,  'Neon Horizon',               'Published', '2023-11-10', 'English',  'A sci-fi thriller set in 2087',              6),
(7,  'Sakura Storm',               'Published', '2023-08-25', 'Japanese', 'A romantic drama set in Kyoto',              7),
(8,  'Shadow Protocol',            'Published', '2022-06-14', 'English',  'An espionage action film',                   10),
(9,  'The Last Verse',             'Published', '2024-01-30', 'English',  'A musician biopic',                          9),
(10, 'Echoes of the Savanna',      'Published', '2023-05-22', 'Swahili',  'A nature documentary feature film',          10),
(11, 'Code Breakers',              'Published', '2023-01-01', 'English',  'Hackers vs corporations - a drama series',   6),
(12, 'Wanderlust Chronicles',      'Published', '2022-09-01', 'English',  'A travel reality show',                      7),
(13, 'Mecha Rising',               'Published', '2023-04-10', 'Japanese', 'Giant robots defend Earth',                  8),
(14, 'Strings Attached',           'Published', '2024-02-01', 'English',  'A music competition drama',                  9),
(15, 'Earth Untold',               'Published', '2021-07-15', 'English',  'Award-winning nature documentary series',    10);

INSERT INTO CONTENT_GENRE (content_ID, genre) VALUES
(1,  'Education'),
(2,  'Travel'),
(3,  'Animation'),
(4,  'Music'),
(5,  'Documentary'),
(6,  'Sci-Fi'),
(7,  'Romance'),
(8,  'Action'),
(9,  'Drama'),
(10, 'Documentary'),
(11, 'Thriller'),
(12, 'Reality'),
(13, 'Animation'),
(14, 'Drama'),
(15, 'Documentary');

INSERT INTO SHORT_CLIPS (content_ID, length, likes) VALUES
(1, 62, 15400),
(2, 88, 23700),
(3, 75, 41200),
(4, 55,  8900),
(5, 90, 12600);

INSERT INTO MOVIES (content_ID, duration, rating) VALUES
(6,  118, 'PG-13'),
(7,  104, 'PG'),
(8,  132, 'R'),
(9,   98, 'PG-13'),
(10, 110, 'G');

INSERT INTO TV_SHOWS (content_ID, ratings, spin_off) VALUES
(11, 8.4, NULL),
(12, 7.1, NULL),
(13, 8.9, NULL),
(14, 7.8, NULL),
(15, 9.2, NULL);

INSERT INTO SEASONS (Number, content_ID) VALUES
(1, 11),
(2, 11),
(1, 12),
(1, 13),
(1, 14);

INSERT INTO EPISODE (Number, Length, season_id) VALUES
(1, 45, 1),
(2, 47, 1),
(1, 42, 2),
(1, 50, 3),
(1, 38, 4);

INSERT INTO ACTORS (Name, Gender, Movie_id, TV_show_id) VALUES
('Lena Vasquez', 'Female', 6,  11),
('Kenji Mori',   'Male',   7,  13),
('Daniel Stone', 'Male',   8,  NULL),
('Priya Sharma', 'Female', 9,  14),
('Marcus Webb',  'Male',   10, 15);

INSERT INTO HISTORY (watch_timestamp, completion_percent, user_ID, content_ID) VALUES
('2024-04-01 20:15:00', 100.00, 11, 6),
('2024-04-02 18:30:00',  72.50, 12, 7),
('2024-04-03 21:00:00', 100.00, 14, 8),
('2024-04-04 15:45:00',  45.00, 15, 11),
('2024-04-05 22:10:00',   NULL, 11, 13);

INSERT INTO CONTENT_CONSUMPTION (viewer_ID, content_ID, consumed_at) VALUES
(11, 1,  '2024-04-01 19:00:00'),
(12, 3,  '2024-04-02 17:00:00'),
(14, 5,  '2024-04-03 20:00:00'),
(15, 2,  '2024-04-04 14:30:00'),
(11, 11, '2024-04-05 21:00:00');

-- ============================================================
-- Migrate ACTORS to M:N junction tables
-- ============================================================

ALTER TABLE ACTORS DROP FOREIGN KEY fk_actor_movie;
ALTER TABLE ACTORS DROP FOREIGN KEY fk_actor_tvshow;
ALTER TABLE ACTORS DROP COLUMN Movie_id;
ALTER TABLE ACTORS DROP COLUMN TV_show_id;

CREATE TABLE MOVIE_ACTORS (
    content_ID INT NOT NULL,
    Actor_id   INT NOT NULL,
    PRIMARY KEY (content_ID, Actor_id),
    CONSTRAINT fk_movieactors_movie FOREIGN KEY (content_ID) REFERENCES MOVIES (content_ID),
    CONSTRAINT fk_movieactors_actor FOREIGN KEY (Actor_id)   REFERENCES ACTORS (Actor_id)
);

CREATE TABLE TV_ACTORS (
    Actor_id   INT NOT NULL,
    content_ID INT NOT NULL,
    PRIMARY KEY (Actor_id, content_ID),
    CONSTRAINT fk_tvactors_actor  FOREIGN KEY (Actor_id)   REFERENCES ACTORS   (Actor_id),
    CONSTRAINT fk_tvactors_tvshow FOREIGN KEY (content_ID) REFERENCES TV_SHOWS (content_ID)
);

INSERT INTO MOVIE_ACTORS (content_ID, Actor_id) VALUES
(6,  1),
(7,  2),
(8,  3),
(9,  4),
(10, 5);

INSERT INTO TV_ACTORS (Actor_id, content_ID) VALUES
(1, 11),
(2, 13),
(3, 11),
(4, 14),
(5, 15);

-- ============================================================
-- INSERT 5 rows into WATCHED
-- ============================================================
INSERT INTO WATCHED (viewer_id, history_id) VALUES
(11, 1),
(12, 2),
(14, 3),
(15, 4),
(11, 5);

-- ============================================================
-- QUERIES
-- ============================================================

-- Query 1: Viewers with their subscription details
SELECT u.first_name, u.last_name, u.username,
       sp.max_vid_qual, sp.monthly_fee,
       sp.subscription_start_date
FROM USER u
INNER JOIN VIEWER v             ON u.user_ID   = v.Viewer_id
INNER JOIN SUBSCRIPTION_PLAN sp ON v.Viewer_id = sp.Viewer_id
ORDER BY u.last_name;

-- Query 2: Creators ranked by follower count with total content uploaded
SELECT u.first_name, u.last_name,
       c.Followers,
       COUNT(co.content_ID) AS total_content
FROM USER u
INNER JOIN CREATOR c  ON u.user_ID    = c.Creator_ID
INNER JOIN CONTENT co ON c.Creator_ID = co.creator_ID
GROUP BY u.user_ID, u.first_name, u.last_name, c.Followers
ORDER BY c.Followers DESC;

-- Query 3
SELECT u.first_name, u.last_name,
       c.Followers, c.Verified
FROM USER u
INNER JOIN CREATOR c ON u.user_ID = c.Creator_ID
GROUP BY u.user_ID, u.first_name, u.last_name,
         c.Followers, c.Verified
HAVING c.Followers > 50000
ORDER BY c.Followers DESC;

-- Query 4
SELECT co.title,
       ROUND(AVG(h.completion_percent), 2) AS avg_completion,
       COUNT(h.history_ID) AS total_views
FROM CONTENT co
INNER JOIN HISTORY h ON co.content_ID = h.content_ID
GROUP BY co.content_ID, co.title
ORDER BY avg_completion DESC;

-- Query 5
SELECT u.first_name, u.last_name,
       co.title, co.language,
       cc.consumed_at
FROM USER u
INNER JOIN VIEWER v              ON u.user_ID    = v.Viewer_id
INNER JOIN CONTENT_CONSUMPTION cc ON v.Viewer_id  = cc.viewer_ID
INNER JOIN CONTENT co            ON cc.content_ID = co.content_ID
ORDER BY cc.consumed_at;

-- Query 6
SELECT co.content_ID, co.title,
       co.release_date,
       cg.genre
FROM CONTENT co
LEFT JOIN CONTENT_GENRE cg
       ON co.content_ID = cg.content_ID
ORDER BY co.content_ID;

-- Query 7
SELECT cg.genre,
       COUNT(cg.content_ID) AS content_count
FROM CONTENT_GENRE cg
GROUP BY cg.genre
HAVING COUNT(cg.content_ID) > 1
ORDER BY content_count DESC;

-- Query 8
SELECT u.first_name, u.last_name,
       p.amount, p.pay_method, p.pay_status
FROM USER u
INNER JOIN PAYMENT p ON u.user_ID = p.user_ID
WHERE p.amount > (
    SELECT AVG(amount)
    FROM PAYMENT
    WHERE pay_status = 'Completed'
)
ORDER BY p.amount DESC;

-- Query 9
SELECT co.title, ts.ratings,
       COUNT(ta.Actor_id) AS actor_count,
       GROUP_CONCAT(a.Name ORDER BY a.Name SEPARATOR ', ') AS cast
FROM CONTENT co
INNER JOIN TV_SHOWS ts  ON co.content_ID = ts.content_ID
LEFT JOIN  TV_ACTORS ta ON ts.content_ID = ta.content_ID
LEFT JOIN  ACTORS a    ON ta.Actor_id   = a.Actor_id
WHERE ts.ratings > (
    SELECT AVG(ratings) FROM TV_SHOWS
)
GROUP BY co.content_ID, co.title, ts.ratings
HAVING COUNT(ta.Actor_id) >= 1
ORDER BY ts.ratings DESC;

-- Query 10
SELECT u.first_name, u.last_name, u.username,
       sp.max_vid_qual, sp.monthly_fee,
       sp.subscription_start_date
FROM USER u
INNER JOIN VIEWER v   ON u.user_ID    = v.Viewer_id
INNER JOIN SUBSCRIPTION_PLAN sp ON v.Viewer_id = sp.Viewer_id
ORDER BY u.last_name;