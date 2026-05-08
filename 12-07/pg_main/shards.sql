CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER users_1_server FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'users_1', port '5432', dbname 'users');

CREATE SERVER users_2_server FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'users_2', port '5432', dbname 'users');

CREATE USER MAPPING FOR CURRENT_USER SERVER users_1_server
    OPTIONS (user 'admin', password 'admin');

CREATE USER MAPPING FOR CURRENT_USER SERVER users_2_server
    OPTIONS (user 'admin', password 'admin');

CREATE FOREIGN TABLE users_1 (
    user_id INTEGER,
    user_name VARCHAR(100),
    email VARCHAR(255),
    password VARCHAR(255)
) SERVER users_1_server OPTIONS (table_name 'users');

CREATE FOREIGN TABLE users_2 (
    user_id INTEGER,
    user_name VARCHAR(100),
    email VARCHAR(255),
    password VARCHAR(255)
) SERVER users_2_server OPTIONS (table_name 'users');


CREATE VIEW users AS
    SELECT * FROM users_1
    UNION ALL
    SELECT * FROM users_2;    


CREATE SERVER books_catalog_server FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'books_catalog', port '5432', dbname 'books');

CREATE SERVER books_description_server FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'books_description', port '5432', dbname 'books');

CREATE USER MAPPING FOR CURRENT_USER SERVER books_catalog_server
    OPTIONS (user 'admin', password 'admin');

CREATE USER MAPPING FOR CURRENT_USER SERVER books_description_server
    OPTIONS (user 'admin', password 'admin');


CREATE FOREIGN TABLE books_catalog (
    book_id INTEGER,
    book_name VARCHAR(200)
) SERVER books_catalog_server OPTIONS (table_name 'books_catalog');

CREATE FOREIGN TABLE books_description (
    book_id INTEGER,
    description TEXT
) SERVER books_description_server OPTIONS (table_name 'books_description');

CREATE VIEW books AS
    SELECT
        c.book_id,
        c.book_name,
        d.description
    FROM books_catalog c
    LEFT JOIN books_description d ON c.book_id = d.book_id;



CREATE TABLE stores (
    store_id INTEGER PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL
);



CREATE RULE users_insert_ignore AS ON INSERT TO users DO INSTEAD NOTHING;
CREATE RULE users_update_ignore AS ON UPDATE TO users DO INSTEAD NOTHING;
CREATE RULE users_delete_ignore AS ON DELETE TO users DO INSTEAD NOTHING;

CREATE RULE users_insert_to_shard1 AS ON INSERT TO users
WHERE NEW.user_id <= 4
DO INSTEAD INSERT INTO users_1 VALUES (NEW.*);

CREATE RULE users_insert_to_shard2 AS ON INSERT TO users
WHERE NEW.user_id >= 5
DO INSTEAD INSERT INTO users_2 VALUES (NEW.*);

CREATE RULE books_insert_ignore AS ON INSERT TO books DO INSTEAD NOTHING;
CREATE RULE books_update_ignore AS ON UPDATE TO books DO INSTEAD NOTHING;
CREATE RULE books_delete_ignore AS ON DELETE TO books DO INSTEAD NOTHING;


CREATE RULE books_insert_to_both AS ON INSERT TO books
DO INSTEAD (
    INSERT INTO books_catalog (book_id, book_name)
    VALUES (NEW.book_id, NEW.book_name);
    INSERT INTO books_description (book_id, description)
    VALUES (NEW.book_id, NEW.description);
);