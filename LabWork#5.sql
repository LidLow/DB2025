--Zhaskairatuly Margulan
--24B031036



--Part 1: CHECK Constraints
--Task 1.1: Basic CHECK Constraint
CREATE TABLE employees (
    employee_id         SERIAL PRIMARY KEY,
    first_name          TEXT,
    last_name           TEXT,
    age                 INT CHECK (age BETWEEN 18 AND 65),  --age have to be >=18 and <=65
    salary              NUMERIC CHECK (salary > 0)          --salary have to be greater than 0
);


--Task 1.2: Named CHECK Constraint
CREATE TABLE products_catalog (
    product_id          SERIAL PRIMARY KEY,
    product_name        TEXT,
    regular_price       NUMERIC(32, 2),
    discount_price      NUMERIC(32, 2),

    CONSTRAINT valid_discount
        CHECK (
            regular_price > 0               --regular price have to be greater than 0
            AND
            discount_price > 0              --discount price have to be greater than 0
            AND
            discount_price < regular_price  --discount have to be less than default price
        )
);


--Task 1.3 Multiple Column CHECK
CREATE TABLE bookings (
    booking_id          SERIAL PRIMARY KEY,
    check_in_date       DATE,
    check_out_date      DATE,
    num_guests          INT,

    CONSTRAINT valid_data
        CHECK (
            num_guests BETWEEN 1 AND 10     --number of guests is >=1 and <= 10
            AND
            check_out_date > check_in_date  --check out is after check in
        )
);


--Task 1.4: Testing CHECK Constraints
--Valid
INSERT INTO employees (first_name, last_name, age, salary)
    VALUES
        ('John', 'Doe', 30, 50000);
INSERT INTO employees (first_name, last_name, age, salary)
    VALUES
        ('Jane', 'Smith', 45, 75000);

--Invalid
INSERT INTO employees (first_name, last_name, age, salary)
    VALUES
        ('Tom', 'Young', 16, 40000); --age is lower than 18
INSERT INTO employees (first_name, last_name, age, salary)
    VALUES
        ('Anna', 'Zero', 25, 0);     --salary is equal to 0


--Valid
INSERT INTO products_catalog (product_name, regular_price, discount_price)
    VALUES
        ('Laptop', 1000, 800);
INSERT INTO products_catalog (product_name, regular_price, discount_price)
    VALUES
        ( 'Phone', 600, 500);

--Invalid
INSERT INTO products_catalog (product_name, regular_price, discount_price)
    VALUES
        ('Tablet', 700, 700);
INSERT INTO products_catalog (product_name, regular_price, discount_price)
    VALUES
        ('Headphones', 0, 100);


--Valid
INSERT INTO bookings (check_in_date, check_out_date, num_guests)
    VALUES
        ( '2025-10-15', '2025-10-20', 2);
INSERT INTO bookings (check_in_date, check_out_date, num_guests)
    VALUES
        ( '2025-11-01', '2025-11-05', 4);

--Invalid
INSERT INTO bookings (check_in_date, check_out_date, num_guests)
    VALUES
        ('2025-12-01', '2025-12-10', 12);
INSERT INTO bookings (check_in_date, check_out_date, num_guests)
    VALUES
        ( '2025-10-20', '2025-10-18', 3);





--Part 2: NOT NULL Constraints
--Task 2.1: NOT NULL Implementation
CREATE TABLE customers (
    customer_id         SERIAL PRIMARY KEY NOT NULL,
    email               TEXT NOT NULL,
    phone               TEXT,
    registration_date   DATE NOT NULL
);


--Task 2.2: Combining Constraints
CREATE TABLE inventory (
    item_id             SERIAL PRIMARY KEY NOT NULL,
    item_name           TEXT NOT NULL,
    quantity            INT NOT NULL CHECK (quantity >= 0),
    unit_price          NUMERIC(32, 2) NOT NULL CHECK (unit_price > 0),
    last_updated        TIMESTAMP NOT NULL
);


--Task 2.3: Testing NOT NULL
--Valid
INSERT INTO customers (email, phone, registration_date)
    VALUES
        ('john@example.com', '555-1234', '2025-10-10'),
        ('mary@example.com', NULL, '2025-10-11');

--Invalid
INSERT INTO customers (email, phone, registration_date)
    VALUES
        (NULL, '555-9999', '2025-10-12'),       --null email
        ('tom@example.com', '555-1111', NULL);  --null registration date


--Valid
INSERT INTO inventory (item_name, quantity, unit_price, last_updated)
    VALUES
        ('Laptop', 10, 1200.00, NOW()),
        ('Mouse', 50, 15.50, NOW());

--Invalid
INSERT INTO inventory (item_name, quantity, unit_price, last_updated)
    VALUES
        (NULL, 5, 20.00, NOW()),            --null item name
        ('Keyboard', -3, 25.00, NOW()),     --item quantity is negative
        ('Monitor', 8, 0, NOW());           --price is equal to 0





--Part 3: UNIQUE Constraints
--Task 3.1: Single Column UNIQUE
CREATE TABLE users (
    user_id         SERIAL PRIMARY KEY,
    username        TEXT UNIQUE,
    email           TEXT UNIQUE,
    created_at      TIMESTAMP
);


--Task 3.2: Multi-Column UNIQUE
CREATE TABLE course_enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_code TEXT,
    semester TEXT,

    UNIQUE (
        student_id,
        course_code,
        semester
    )
);


--Task 3.3: Named UNIQUE Constraints
--Add a named UNIQUE constraint called unique_username on username
CREATE TABLE users (
    user_id         SERIAL PRIMARY KEY,
    username        TEXT,
    email           TEXT UNIQUE,
    created_at      TIMESTAMP,

    CONSTRAINT unique_username
        UNIQUE (
            username
        )
);

--Add a named UNIQUE constraint called unique_email on email
CREATE TABLE users (
    user_id         SERIAL PRIMARY KEY,
    username        TEXT,
    email           TEXT,
    created_at      TIMESTAMP,

    CONSTRAINT unique_username
        UNIQUE (
            username
        ),

    CONSTRAINT unique_email
        UNIQUE (
            email
        )
);

--Valid
INSERT INTO course_enrollments (student_id, course_code, semester)
    VALUES
        (101, 'CS101', 'Fall2025'),
        (101, 'CS102', 'Fall2025');

--Invalid
INSERT INTO course_enrollments (student_id, course_code, semester)
    VALUES
        (101, 'CS101', 'Fall2025');

--Valid
INSERT INTO users (username, email, created_at)
    VALUES
        ('Max_Payne228', 'alice@gmail.com', NOW()),
        ('Smile:)', 'bob@gmail.com', NOW());

--Invalid
INSERT INTO users (username, email, created_at)
    VALUES
        ('Max_Payne228', 'charlie@gmail.com', NOW()),   --not unique username
        ('Roamer2007', 'bob@gmail.com', NOW());         --not unique email





--Part 4: PRIMARY KEY Constraints
--Task 4.1: Single Column Primary Key
CREATE TABLE departments (
    dept_id         INT PRIMARY KEY,
    dept_name       TEXT NOT NULL,
    location        TEXT
);

--Insert at least 3 departments and attempt to
--Insert a duplicate dept_id
INSERT INTO departments
    VALUES
        (1, 'School of Math', '402'),
        (1, 'School of Science', '301');    --duplicate, will raise an error, because dept_id have to be unique

--Insert a NULL dept_id
INSERT INTO departments
    VALUES
        (NULL, 'School of Math', '402');    --null value, will raise an error, because primary key cannot be null


--Task 4.2: Composite Primary Key
CREATE TABLE student_courses (
    student_id          INT,
    course_id           INT,
    enrollment_date     DATE,
    grade               TEXT,

    PRIMARY KEY (
        student_id,
        course_id
    )
);


--Task 4.3: Comparison Exercise
--Unique value can be null. Primary key is Unique + Not Null
--If there are just an id, we can use single-column Primary Key. If there are several ids, and we cannot have duplicates, we use composite primary key.
--We use Primary key value to identify unique record, while this record can have unique username or phone that can be changed in the future.





--Part 5: FOREIGN KEY Constraints
--Task 5.1: Basic Foreign Key
CREATE TABLE employees_dept (
    emp_id          SERIAL PRIMARY KEY,
    emp_name        TEXT NOT NULL,
    dept_id         INT REFERENCES departments,
    hire_date       DATE
);

--Test by
--Inserting employees with valid dept_id
INSERT INTO employees_dept (emp_name, dept_id, hire_date)
    VALUES
        ('Alice Johnson', 1, '2025-01-15'),
        ('Bob Smith', 2, '2025-03-20');

--Attempting to insert an employee with a non-existent dept_id
INSERT INTO employees_dept (emp_name, dept_id, hire_date)
    VALUES
        ('Charlie Davis', 99, '2025-05-10');


--Task 5.2: Multiple Foreign Keys
CREATE TABLE authors (
    author_id           SERIAL PRIMARY KEY,
    author_name         TEXT NOT NULL,
    country             TEXT
);

CREATE TABLE publishers (
    publisher_id        SERIAL PRIMARY KEY,
    publisher_name      TEXT NOT NULL,
    city                TEXT
);

CREATE TABLE books (
    book_id             SERIAL PRIMARY KEY,
    title               TEXT NOT NULL,
    author_id           INT REFERENCES authors,
    publisher_id        INT REFERENCES publishers,
    publication_year    INT,
    isbn                TEXT UNIQUE
);

--Insert sample data into all tables.
INSERT INTO authors (author_name, country)
    VALUES
        ('George Orwell', 'United Kingdom'),
        ('Haruki Murakami', 'Japan'),
        ('Ernest Hemingway', 'United States');

INSERT INTO publishers (publisher_name, city)
    VALUES
        ('Penguin Books', 'London'),
        ('Vintage', 'Tokyo'),
        ('Scribner', 'New York');

INSERT INTO books (title, author_id, publisher_id, publication_year, isbn)
    VALUES
        ('1984', 1, 1, 1949, '9780451524935'),
        ('Norwegian Wood', 2, 2, 1987, '9780375704024'),
        ('The Old Man and the Sea', 3, 3, 1952, '9780684801223');


--Task 5.3: ON DELETE Options
CREATE TABLE categories (
    category_id         SERIAL PRIMARY KEY,
    category_name       TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id          SERIAL PRIMARY KEY,
    product_name        TEXT NOT NULL,
    category_id         INT REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id            SERIAL PRIMARY KEY,
    order_date          DATE NOT NULL
);

CREATE TABLE order_items (
    item_id             SERIAL PRIMARY KEY,
    order_id            INT REFERENCES orders ON DELETE CASCADE,
    product_id          INT REFERENCES products_fk,
    quantity            INT CHECK (quantity > 0)
);

--Test the following scenarios:
INSERT INTO categories (category_name)
    VALUES
        ('Electronics'),
        ('Furniture');

INSERT INTO products_fk (product_name, category_id)
    VALUES
        ('Laptop', 1),
        ('Chair', 2);

INSERT INTO orders (order_date)
    VALUES
        ('2025-10-12'),
        ('2025-10-13');

INSERT INTO order_items (order_id, product_id, quantity)
    VALUES
        (1, 1, 2),
        (1, 2, 1);

DELETE FROM categories
    WHERE category_id = 1;

DELETE FROM orders
    WHERE order_id = 1;





--Part 6: Practical Application
--Task 6.1: E-commerce Database Design
CREATE TABLE customers (
    customer_id         SERIAL PRIMARY KEY,
    name                TEXT NOT NULL,
    email               TEXT UNIQUE NOT NULL,
    phone               TEXT NOT NULL,
    registration        DATE DEFAULT CURRENT_DATE
);

CREATE TABLE products (
    product_id          SERIAL PRIMARY KEY,
    name                TEXT NOT NULL,
    description         TEXT,
    price               NUMERIC(32, 2) NOT NULL,
    stock_quantity      INT NOT NULL,

    CHECK (
        price > 0
        AND
        stock_quantity >= 0
    )
);

CREATE TABLE orders (
    order_id            SERIAL PRIMARY KEY,
    customer_id         INT REFERENCES customers ON DELETE RESTRICT,
    order_date          DATE,
    total_amount        NUMERIC(32, 2) NOT NULL,
    status              TEXT

    CONSTRAINT correct_status CHECK (
        status = 'pending'
        OR
        status = 'processing'
        OR
        status = 'shipped'
        OR
        status = 'delivered'
        OR
        status = 'cancelled'
    ),

    CONSTRAINT positive_total_amount CHECK (
        total_amount > 0
    )
);

CREATE TABLE order_details (
    order_detail_id     SERIAL PRIMARY KEY,
    order_id            INT REFERENCES orders ON DELETE CASCADE,
    product_id          INT REFERENCES products ON DELETE RESTRICT,
    quantity            INT NOT NULL,
    unit_price          NUMERIC(32, 2) NOT NULL,

    CONSTRAINT correct_data CHECK (
        quantity > 0
        AND
        unit_price > 0
    )
);

--At least 5 sample records per table
-- Customers
INSERT INTO customers (name, email, phone)
    VALUES
        ('Alice Johnson', 'alice@example.com', '1234567890'),
        ('Bob Smith', 'bob@example.com', '0987654321'),
        ('Charlie Brown', 'charlie@example.com', '1112223333'),
        ('Diana Prince', 'diana@example.com', '4445556666'),
        ('Ethan Hunt', 'ethan@example.com', '7778889999');

-- Products
INSERT INTO products (name, description, price, stock_quantity)
    VALUES
        ('Laptop', '14-inch, 16GB RAM', 1200.00, 10),
        ('Mouse', 'Wireless optical mouse', 25.00, 100),
        ('Keyboard', 'Mechanical keyboard', 80.00, 50),
        ('Monitor', '24-inch LED display', 200.00, 30),
        ('USB Cable', '1m USB-C cable', 10.00, 200);

-- Orders
INSERT INTO orders (customer_id, order_date, total_amount, status)
    VALUES
        (1, '2025-06-01', 1225.00, 'pending'),
        (2, '2025-06-05', 305.00, 'processing'),
        (3, '2025-06-10', 210.00, 'shipped'),
        (4, '2025-06-15', 1200.00, 'delivered'),
        (5, '2025-06-20', 35.00, 'cancelled');

-- Order Details
INSERT INTO order_details (order_id, product_id, quantity, unit_price)
    VALUES
        (1, 1, 1, 1200.00),
        (1, 2, 1, 25.00),
        (2, 3, 2, 80.00),
        (3, 4, 1, 200.00),
        (5, 5, 3, 10.00);