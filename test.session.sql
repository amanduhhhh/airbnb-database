-- comments preface by double dash
-- @block 
-- blocks can be run individually with block comment

-- statements end in ; 
-- blue words are sql keywords, convention uppercase, could be lower
-- Users is identifier, name of table
CREATE TABLE Users(
    -- identifier, data type, constraint (extra data validation)
    id INT PRIMARY KEY AUTO_INCREMENT,  -- primarykey=unique, not null, auto-increment starts at 0, increments id
    email VARCHAR(255) NOT NULL UNIQUE, -- varchar(maxlength)
    bio TEXT,
    country VARCHAR(2)
);

-- find scheme on left hand of IDE
-- @block inserts data into table, value order matters
INSERT INTO Users (email, bio, country)
VALUES (
    'hello@world.com',
    'lorem skibidi ipsum dolor toilet sit amet', 
    'US'
);

-- @block inserts multiple rows
INSERT INTO Users (email, bio, country)
VALUES
    ('hello@worlds.com', 'aaa', 'CA'),
    ('skibidi@toilet.ca', 'gronk', 'LA'),
    ('arrrr@gmail.com', 'kai cenat', 'ND');

-- @block retrieve data
-- SELECT * FROM Users; -- returns entire table with every column
SELECT email, id FROM Users -- returns only those columsn

WHERE country = 'US' -- logic: filters based on value
AND id >= 1 -- AND chains logic
AND email LIKE 'h%' -- LIKE finds patterns (h%=start with h)

ORDER BY id ASC -- ASC=ascending, DESC=descending
LIMIT 2; -- max rows returned

-- this method gets slow for large tables
-- the solution? INDEX - lookup table for specific columns (slower writes, additional memory)
-- @block indexing
CREATE INDEX email_index ON Users(email);

-- @block 
CREATE TABLE Rooms(
    id INT AUTO_INCREMENT, -- primary key
    street VARCHAR(255),
    owner_id INT NOT NULL, -- foreign key: reference id in another table
    PRIMARY KEY (id),
    FOREIGN KEY (owner_id) REFERENCES Users(id)  -- tells db to not delete related data
);

-- @block
INSERT INTO Rooms (owner_id, street)
VALUES
    (1, 'shack'),
    (1, "funnies"),
    (1, "chicken mcnugget"),
    (1, "idek");

-- joins: left, right, inner, outer 
-- users=left, rooms=right
-- @block
SELECT * FROM Users
INNER JOIN Rooms -- only selects data from both sets that satisfies condition
ON Rooms.owner_id = Users.id;

-- @block
SELECT * FROM Users
LEFT JOIN Rooms -- selects all data in first db + overlap 
ON Rooms.owner_id = Users.id;

-- right returns second db + overlap
-- outer returns all elements in both dbs (NOT SUPPORTED IN MYSQL)
-- when column names are shared between dbs, mysql automatically updates to db.key

-- @block casting to different names
SELECT 
    Users.id AS user_id,
    Rooms.id AS room_id,
    email,
    street
FROM Users
INNER JOIN Rooms ON Rooms.owner_id != Users.id;

-- @block
CREATE TABLE Bookings(
    id INT AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (guest_id) REFERENCES Users(id), -- user can have many booked rooms
    FOREIGN KEY (room_id) REFERENCES Rooms(id) -- room can have many booked users
)

-- @block
INSERT INTO Bookings (guest_id, room_id, check_in)
VALUES
    (1, 2, '1000-01-01 00:00:00'),
    (6, 2, '1000-01-01 00:00:00'),
    (5, 1, '1000-01-01 00:00:00');

-- @block Rooms user has booked
SELECT 
    room_id,
    street,
    check_in
FROM Bookings
INNER JOIN Rooms ON Rooms.id = room_id
WHERE guest_id = 1;
-- join rooms to bookings, filter by guest id

-- @block History of room guests
SELECT 
    room_id,
    guest_id,
    email,
    bio
FROM Bookings
INNER JOIN Users ON Users.id = guest_id -- overlap between user and guest id
WHERE room_id = 2; -- gets room 
-- join users to bookings, filter by room id

-- @block removing tables
DROP TABLE Users;
DROP TABLE Rooms;
-- USE WITH CAUTION!!!!