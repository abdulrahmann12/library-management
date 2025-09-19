
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) UNIQUE,
    role ENUM('ADMIN', 'LIBRARIAN', 'STAFF') NOT NULL,
	phone VARCHAR(50),
	image VARCHAR(255), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, email, phone, role)
VALUES 
('admin', '$2a$10$7eqJtq98hPqEX7fNZaFWoO7sz2Yx4VZ7O4h1m8ZUJvLC/7Y0E6F/u', 'admin1@library.com', '01010000001', 'ADMIN'),
('librarian', '$2a$10$9v3qjYY5K6X9hR0RU/6r8uDPemxF0VxKNz2A2oUNohHZz/7R1Jjpi', 'librarian1@library.com', '01010000002', 'LIBRARIAN'),
('staff', '$2a$10$G7N1hF2eZC1rC3G5zH6e5uQjJZgkN4gLhMxwBq0nLhG2o4J7Hqkpe', 'staff1@library.com', '01010000003', 'STAFF');

CREATE TABLE publishers (
    publisher_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(50),
    email VARCHAR(100),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE INDEX idx_publishers_name ON publishers(name);

INSERT INTO publishers (name, address, phone, email) VALUES
('Dar El Shorouk', 'Giza, Egypt', '+20-2-35720000', 'info@shorouk.com'),
('Egyptian Book Organization', 'Cairo, Egypt', '+20-2-25250000', 'contact@ekb.eg'),
('Nahdet Misr', 'Mokattam, Cairo, Egypt', '+20-2-25070000', 'support@nahda.com');

CREATE TABLE categories (
    category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    parent_id BIGINT DEFAULT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

CREATE INDEX idx_categories_name ON categories(name);

INSERT INTO categories (name, description, image_url, parent_id) VALUES
('Programming', 'All programming related books and resources', 'https://example.com/images/programming.jpg', NULL),
('Databases', 'Database systems, design, and administration', 'https://example.com/images/databases.jpg', NULL),
('Java', 'Java programming language and frameworks', 'https://example.com/images/java.jpg', 1),
('SQL', 'Structured Query Language guides and tutorials', 'https://example.com/images/sql.jpg', 2);


CREATE TABLE books (
    book_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    summary TEXT,
    language VARCHAR(100),
    publication_year INT,
    isbn VARCHAR(20) UNIQUE,
    edition VARCHAR(50),
    cover_image VARCHAR(255),

    publisher_id BIGINT,
    category_id BIGINT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id),
    CONSTRAINT fk_books_category FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_publisher ON books(publisher_id);
CREATE INDEX idx_books_category ON books(category_id);

INSERT INTO books (title, summary, language, publication_year, isbn, edition, publisher_id, category_id)
VALUES
('Clean Code', 'A Handbook of Agile Software Craftsmanship', 'English', 2008, '9780132350884', '1st', 1, 1),
('Effective Java', 'Best practices for the Java platform', 'English', 2018, '9780134685991', '3rd', 2, 3),
('Database System Concepts', 'Foundations of database systems', 'English', 2019, '9780078022159', '7th', 3, 2);


CREATE TABLE authors (
    author_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bio TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_authors_name ON authors(name);

INSERT INTO authors (name, bio) VALUES
('Robert C. Martin', 'Known as Uncle Bob, author of Clean Code'),
('Joshua Bloch', 'Author of Effective Java, former Java architect at Google'),
('Abraham Silberschatz', 'Expert in database systems and co-author of Database System Concepts');




CREATE TABLE book_authors (
    book_id BIGINT NOT NULL,
    author_id BIGINT NOT NULL,
    PRIMARY KEY (book_id, author_id),

    CONSTRAINT fk_book_authors_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_book_authors_author FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE INDEX idx_book_authors_book ON book_authors(book_id);
CREATE INDEX idx_book_authors_author ON book_authors(author_id);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), 
(2, 2), 
(3, 3); 


CREATE TABLE members (
    member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(255),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_members_name ON members(name);

INSERT INTO members (name, email, phone, address) VALUES
('Ali Hassan', 'ali@example.com', '+20-1111111111', 'Cairo, Egypt'),
('Mona Adel', 'mona@example.com', '+20-1222222222', 'Giza, Egypt'),
('Omar Khaled', 'omar@example.com', '+20-1333333333', 'Alexandria, Egypt');



CREATE TABLE borrowing_transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    book_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    returned_at TIMESTAMP NULL,
    status ENUM('Borrowed','Returned','Overdue') DEFAULT 'Borrowed',
    handled_by BIGINT NOT NULL,

    CONSTRAINT fk_borrowing_book FOREIGN KEY (book_id) REFERENCES books(book_id),
    CONSTRAINT fk_borrowing_member FOREIGN KEY (member_id) REFERENCES members(member_id),
    CONSTRAINT fk_borrowing_user FOREIGN KEY (handled_by) REFERENCES users(id)
);

CREATE INDEX idx_borrowing_book ON borrowing_transactions(book_id);
CREATE INDEX idx_borrowing_member ON borrowing_transactions(member_id);
CREATE INDEX idx_borrowing_status ON borrowing_transactions(status);

INSERT INTO borrowing_transactions (book_id, member_id, borrowed_at, due_date, returned_at, status, handled_by) VALUES
(1, 1, '2025-09-01 10:00:00', '2025-09-10', '2025-09-10 15:00:00', 'Returned', 2),
(2, 2, '2025-09-05 14:00:00', '2025-09-15', NULL, 'Borrowed', 2),
(3, 3, '2025-09-07 09:00:00', '2025-09-17', NULL, 'Overdue', 2);


CREATE TABLE user_activity_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    action VARCHAR(255) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_logs_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_logs_user ON user_activity_logs(user_id);
CREATE INDEX idx_logs_entity ON user_activity_logs(entity_type, entity_id);

INSERT INTO user_activity_logs (user_id, action, entity_type, entity_id) VALUES
(1, 'CREATE', 'BOOK', 1),
(1, 'UPDATE', 'BOOK', 2),
(2, 'BORROW', 'TRANSACTION', 1);



CREATE TABLE roles (
    role_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE, -- Admin, Librarian, Staff, Manager
    description VARCHAR(255)
);

ALTER TABLE users
ADD COLUMN role_id BIGINT,
ADD CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(role_id);

ALTER TABLE users Drop column role; 

INSERT INTO roles (name, description) VALUES
('ADMIN', 'System administrator with full access'),
('LIBRARIAN', 'Manages books and borrowing'),
('STAFF', 'Library staff with limited permissions');

UPDATE users SET role_id = 1 WHERE users.id = 1; 
UPDATE users SET role_id = 2 WHERE users.id = 2; 


ALTER TABLE members
ADD COLUMN status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE';

ALTER TABLE borrowing_transactions
ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00;

