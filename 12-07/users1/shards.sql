CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    CONSTRAINT user_id_check CHECK (user_id <= 4),  
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);