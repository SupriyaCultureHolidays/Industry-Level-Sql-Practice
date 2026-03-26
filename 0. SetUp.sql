CREATE DATABASE ECOMMERCE;
USE ECOMMERCE;

-- ============================================================
-- E-COMMERCE DATABASE SCHEMA (MySQL 8+)
-- Run this first. Safe to re-run (drops existing tables).
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS product_inventory;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS vendors;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. ROLES
CREATE TABLE roles (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL UNIQUE,
    description TEXT,
    permissions JSON,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. USERS
CREATE TABLE users (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    role_id           INT UNSIGNED NOT NULL,
    name              VARCHAR(150) NOT NULL,
    email             VARCHAR(200) NOT NULL UNIQUE,
    phone             VARCHAR(20),
    password_hash     VARCHAR(255) NOT NULL,
    profile_picture   VARCHAR(500),
    is_email_verified TINYINT(1)   NOT NULL DEFAULT 0,
    status            ENUM('active','inactive','banned') NOT NULL DEFAULT 'active',
    last_login_at     DATETIME,
    created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id),
    INDEX idx_users_role_id (role_id),
    INDEX idx_users_status  (status)
);

-- 3. VENDORS
CREATE TABLE vendors (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id           INT UNSIGNED NOT NULL UNIQUE,
    store_name        VARCHAR(200) NOT NULL,
    store_description TEXT,
    logo_url          VARCHAR(500),
    contact_email     VARCHAR(200) NOT NULL,
    contact_phone     VARCHAR(20),
    address           TEXT,
    city              VARCHAR(100),
    country           VARCHAR(100) NOT NULL DEFAULT 'India',
    commission_rate   DECIMAL(5,2) NOT NULL DEFAULT 12.00,
    rating            DECIMAL(3,2)          DEFAULT 0.00,
    status            ENUM('pending','active','suspended') NOT NULL DEFAULT 'pending',
    approved_at       DATETIME,
    created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vendors_user FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_vendors_status (status)
);

-- 4. CATEGORIES
CREATE TABLE categories (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parent_id     INT UNSIGNED,
    name          VARCHAR(150) NOT NULL,
    slug          VARCHAR(150) NOT NULL UNIQUE,
    description   TEXT,
    image_url     VARCHAR(500),
    is_active     TINYINT(1)   NOT NULL DEFAULT 1,
    display_order INT          NOT NULL DEFAULT 0,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- 5. PRODUCTS
CREATE TABLE products (
    id                INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    vendor_id         INT UNSIGNED  NOT NULL,
    category_id       INT UNSIGNED  NOT NULL,
    title             VARCHAR(300)  NOT NULL,
    description       TEXT,
    short_description VARCHAR(500),
    sku               VARCHAR(100)  UNIQUE,
    price             DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    sale_price        DECIMAL(10,2),
    cost_price        DECIMAL(10,2),
    weight            DECIMAL(8,2),
    images            JSON,
    tags              JSON,
    status            ENUM('active','inactive','draft','deleted') NOT NULL DEFAULT 'active',
    is_featured       TINYINT(1)    NOT NULL DEFAULT 0,
    created_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_vendor   FOREIGN KEY (vendor_id)   REFERENCES vendors(id),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id),
    INDEX idx_products_vendor_id   (vendor_id),
    INDEX idx_products_category_id (category_id),
    INDEX idx_products_status      (status),
    INDEX idx_products_price       (price)
);

-- 6. PRODUCT_INVENTORY
CREATE TABLE product_inventory (
    id                 INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id         INT UNSIGNED NOT NULL UNIQUE,
    quantity_in_stock  INT          NOT NULL DEFAULT 0 CHECK (quantity_in_stock >= 0),
    reserved_quantity  INT          NOT NULL DEFAULT 0,
    reorder_level      INT          NOT NULL DEFAULT 10,
    reorder_quantity   INT          NOT NULL DEFAULT 50,
    warehouse_location VARCHAR(100),
    last_restocked_at  DATETIME,
    updated_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 7. CARTS
CREATE TABLE carts (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         INT UNSIGNED  NOT NULL,
    status          ENUM('active','abandoned','converted') NOT NULL DEFAULT 'active',
    total_amount    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    coupon_code     VARCHAR(50),
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    session_id      VARCHAR(200),
    created_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    abandoned_at    DATETIME,
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_carts_user_id (user_id),
    INDEX idx_carts_status  (status)
);

-- 8. CART_ITEMS
CREATE TABLE cart_items (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cart_id     INT UNSIGNED  NOT NULL,
    product_id  INT UNSIGNED  NOT NULL,
    quantity    INT           NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price  DECIMAL(10,2) NOT NULL,
    added_at    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_cart_product (cart_id, product_id),
    CONSTRAINT fk_cart_items_cart    FOREIGN KEY (cart_id)    REFERENCES carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 9. ORDERS
CREATE TABLE orders (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id          INT UNSIGNED  NOT NULL,
    order_number     VARCHAR(50)   NOT NULL UNIQUE,
    order_status     ENUM('pending','confirmed','processing','shipped','delivered','cancelled','refunded') NOT NULL DEFAULT 'pending',
    payment_status   ENUM('pending','paid','failed','refunded','partially_refunded') NOT NULL DEFAULT 'pending',
    total_amount     DECIMAL(10,2) NOT NULL,
    subtotal         DECIMAL(10,2) NOT NULL,
    shipping_amount  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    discount_amount  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    tax_amount       DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    coupon_code      VARCHAR(50),
    shipping_address JSON,
    billing_address  JSON,
    notes            TEXT,
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    confirmed_at     DATETIME,
    delivered_at     DATETIME,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_orders_user_id        (user_id),
    INDEX idx_orders_order_status   (order_status),
    INDEX idx_orders_payment_status (payment_status),
    INDEX idx_orders_created_at     (created_at)
);

-- 10. ORDER_ITEMS
CREATE TABLE order_items (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id      INT UNSIGNED  NOT NULL,
    product_id    INT UNSIGNED  NOT NULL,
    vendor_id     INT UNSIGNED  NOT NULL,
    quantity      INT           NOT NULL CHECK (quantity > 0),
    unit_price    DECIMAL(10,2) NOT NULL,
    total_price   DECIMAL(10,2) NOT NULL,
    status        VARCHAR(30)   NOT NULL DEFAULT 'pending',
    return_status VARCHAR(30),
    return_reason TEXT,
    CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders(id),
    CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT fk_oi_vendor  FOREIGN KEY (vendor_id)  REFERENCES vendors(id),
    INDEX idx_order_items_order_id   (order_id),
    INDEX idx_order_items_product_id (product_id),
    INDEX idx_order_items_vendor_id  (vendor_id)
);

-- 11. PAYMENTS
CREATE TABLE payments (
    id               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id         INT UNSIGNED  NOT NULL,
    user_id          INT UNSIGNED  NOT NULL,
    transaction_id   VARCHAR(200)  NOT NULL UNIQUE,
    payment_method   ENUM('credit_card','debit_card','upi','netbanking','wallet','cod','emi') NOT NULL,
    payment_gateway  ENUM('razorpay','stripe','paytm','cashfree','paypal') NOT NULL,
    amount           DECIMAL(10,2) NOT NULL,
    currency         VARCHAR(10)   NOT NULL DEFAULT 'INR',
    status           ENUM('pending','success','failed','refunded','partially_refunded') NOT NULL DEFAULT 'pending',
    gateway_response JSON,
    failure_reason   VARCHAR(500),
    refund_amount    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    refunded_at      DATETIME,
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_payments_user  FOREIGN KEY (user_id)  REFERENCES users(id),
    INDEX idx_payments_order_id (order_id),
    INDEX idx_payments_status   (status),
    INDEX idx_payments_method   (payment_method)
);

-- 12. SHIPMENTS
CREATE TABLE shipments (
    id                      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id                INT UNSIGNED  NOT NULL,
    vendor_id               INT UNSIGNED  NOT NULL,
    tracking_number         VARCHAR(100),
    courier_partner         VARCHAR(100),
    shipping_method         ENUM('standard','express','overnight') NOT NULL DEFAULT 'standard',
    status                  ENUM('pending','packed','dispatched','in_transit','out_for_delivery','delivered','returned','lost') NOT NULL DEFAULT 'pending',
    estimated_delivery_date DATE,
    actual_delivery_date    DATE,
    origin_address          TEXT,
    destination_address     TEXT,
    weight_kg               DECIMAL(8,2),
    shipping_cost           DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    dispatched_at           DATETIME,
    delivered_at            DATETIME,
    created_at              DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shipments_order  FOREIGN KEY (order_id)  REFERENCES orders(id),
    CONSTRAINT fk_shipments_vendor FOREIGN KEY (vendor_id) REFERENCES vendors(id),
    INDEX idx_shipments_order_id (order_id),
    INDEX idx_shipments_status   (status)
);

-- 13. REVIEWS
CREATE TABLE reviews (
    id                   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id           INT UNSIGNED NOT NULL,
    user_id              INT UNSIGNED NOT NULL,
    order_id             INT UNSIGNED NOT NULL,
    rating               TINYINT      NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title                VARCHAR(200),
    body                 TEXT,
    is_verified_purchase TINYINT(1)   NOT NULL DEFAULT 1,
    helpful_votes        INT          NOT NULL DEFAULT 0,
    images               JSON,
    status               ENUM('pending','published','rejected') NOT NULL DEFAULT 'published',
    reply                TEXT,
    replied_at           DATETIME,
    created_at           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_product_order (user_id, product_id, order_id),
    CONSTRAINT fk_reviews_product FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT fk_reviews_user    FOREIGN KEY (user_id)    REFERENCES users(id),
    CONSTRAINT fk_reviews_order   FOREIGN KEY (order_id)   REFERENCES orders(id),
    INDEX idx_reviews_product_id (product_id),
    INDEX idx_reviews_rating     (rating)
);

SHOW TABLES;

-- ============================================================
-- SEED DATA — Run after schema
-- Uses stored procedures to generate bulk rows
-- ============================================================

-- ROLES
INSERT INTO roles (name, description, permissions) VALUES
  ('admin',    'Platform administrator',  '["all"]'),
  ('vendor',   'Merchant/seller account', '["products.manage","orders.view","shipments.manage"]'),
  ('customer', 'Regular buyer account',   '["orders.place","reviews.write","profile.edit"]');

-- CATEGORIES (parent first, then sub-categories)
INSERT INTO categories (parent_id, name, slug, is_active, display_order) VALUES
  (NULL, 'Electronics',      'electronics',       1, 1),
  (NULL, 'Fashion',          'fashion',           1, 2),
  (NULL, 'Home & Living',    'home-living',       1, 3),
  (NULL, 'Sports & Fitness', 'sports-fitness',    1, 4),
  (NULL, 'Books',            'books',             1, 5),
  (NULL, 'Beauty & Health',  'beauty-health',     1, 6),
  (NULL, 'Grocery & Food',   'grocery-food',      1, 7),
  (NULL, 'Toys & Games',     'toys-games',        1, 8),
  (NULL, 'Automotive',       'automotive',        1, 9),
  (NULL, 'Jewelry',          'jewelry',           1, 10);

INSERT INTO categories (parent_id, name, slug, is_active, display_order) VALUES
  (1, 'Smartphones',        'smartphones',       1, 1),
  (1, 'Laptops',            'laptops',           1, 2),
  (1, 'Audio',              'audio',             1, 3),
  (1, 'Cameras',            'cameras',           1, 4),
  (1, 'Smart Home',         'smart-home',        1, 5),
  (2, 'Men Clothing',       'men-clothing',      1, 1),
  (2, 'Women Clothing',     'women-clothing',    1, 2),
  (2, 'Footwear',           'footwear',          1, 3),
  (2, 'Bags & Accessories', 'bags-accessories',  1, 4),
  (3, 'Furniture',          'furniture',         1, 1),
  (3, 'Bedding',            'bedding',           1, 2),
  (3, 'Kitchen',            'kitchen',           1, 3),
  (4, 'Gym Equipment',      'gym-equipment',     1, 1),
  (4, 'Outdoor Sports',     'outdoor-sports',    1, 2),
  (6, 'Skincare',           'skincare',          1, 1),
  (6, 'Haircare',           'haircare',          1, 2),
  (6, 'Supplements',        'supplements',       1, 3);

-- ============================================================
-- STORED PROCEDURE: Seed all bulk data
-- Call: CALL seed_ecommerce_data();
-- ============================================================

DROP PROCEDURE IF EXISTS seed_ecommerce_data;

DELIMITER $$

CREATE PROCEDURE seed_ecommerce_data()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE v_name VARCHAR(150);
  DECLARE v_city VARCHAR(50);
  DECLARE v_status VARCHAR(20);
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_pay_status VARCHAR(30);
  DECLARE v_method VARCHAR(30);
  DECLARE v_gateway VARCHAR(30);
  DECLARE v_courier VARCHAR(50);
  DECLARE v_ship_status VARCHAR(30);
  DECLARE v_rating TINYINT;
  DECLARE v_title VARCHAR(200);

  -- ── ADMIN USERS (5) ──────────────────────────────────────
  SET i = 1;
  WHILE i <= 5 DO
    INSERT INTO users (role_id, name, email, phone, password_hash, is_email_verified, status)
    VALUES (1,
      CONCAT('Admin ', i),
      CONCAT('admin', i, '@estore.com'),
      CONCAT('+9190000000', i),
      CONCAT('$2b$12$hashedadmin', i),
      1, 'active');
    SET i = i + 1;
  END WHILE;

  -- ── VENDOR USERS (200) ───────────────────────────────────
  SET i = 1;
  WHILE i <= 200 DO
    SET v_name = ELT(1 + (i MOD 20),
      'Rajesh Kumar','Priya Sharma','Amit Singh','Sneha Patel','Vikram Joshi',
      'Kavya Nair','Arjun Mehta','Divya Reddy','Rahul Gupta','Ananya Das',
      'Suresh Yadav','Meena Iyer','Kiran Verma','Pooja Agarwal','Nikhil Chandra',
      'Ritu Saxena','Aakash Malhotra','Nisha Pillai','Tarun Bose','Sonia Kapoor');
    INSERT INTO users (role_id, name, email, phone, password_hash, is_email_verified, status)
    VALUES (2,
      CONCAT(v_name, ' ', i),
      CONCAT('vendor', i, '@shop.com'),
      CONCAT('+91800', LPAD(i, 6, '0')),
      CONCAT('$2b$12$hashedvendor', i),
      1, 'active');
    SET i = i + 1;
  END WHILE;

  -- ── CUSTOMER USERS (2000) ────────────────────────────────
  SET i = 1;
  WHILE i <= 2000 DO
    SET v_name = ELT(1 + (i MOD 30),
      'Aarav Shah','Ishaan Patel','Vihaan Sharma','Reyansh Gupta','Ayaan Khan',
      'Krishna Rao','Sai Reddy','Arnav Joshi','Aditya Verma','Vivaan Singh',
      'Ananya Mishra','Diya Nair','Aadhya Menon','Myra Chaudhary','Saanvi Bhat',
      'Anika Pillai','Sara Ahmed','Kavya Srinivas','Shreya Tiwari','Pari Dubey',
      'Ravi Kumar','Nikhil Chopra','Alok Trivedi','Manish Soni','Deepak Rawat',
      'Pradeep Chauhan','Gaurav Seth','Rohit Bansal','Sumit Arora','Vinay Grover');
    SET v_status = CASE
      WHEN i MOD 50 = 0 THEN 'banned'
      WHEN i MOD 15 = 0 THEN 'inactive'
      ELSE 'active' END;
    INSERT INTO users (role_id, name, email, phone, password_hash, is_email_verified, status, created_at)
    VALUES (3,
      CONCAT(v_name, ' #', i),
      CONCAT('customer', i, '@gmail.com'),
      CONCAT('+91700', LPAD(i, 6, '0')),
      CONCAT('$2b$12$hashedcustomer', i),
      IF(i MOD 5 != 0, 1, 0),
      v_status,
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY));
    SET i = i + 1;
  END WHILE;

  -- ── VENDORS (200) ────────────────────────────────────────
  SET i = 1;
  WHILE i <= 200 DO
    SET v_city = ELT(1 + (i MOD 10),
      'Mumbai','Delhi','Bangalore','Chennai','Hyderabad',
      'Pune','Kolkata','Ahmedabad','Jaipur','Lucknow');
    SET v_status = CASE
      WHEN i MOD 20 = 0 THEN 'pending'
      WHEN i MOD 30 = 0 THEN 'suspended'
      ELSE 'active' END;
    INSERT INTO vendors (user_id, store_name, contact_email, city, commission_rate, rating, status, approved_at)
    VALUES (
      5 + i,  -- vendor users start at id 6 (after 5 admins)
      CONCAT(ELT(1 + (i MOD 25),
        'TechZone','FashionHub','GadgetPlanet','HomeNest','SportsPro',
        'BookCorner','BeautyBliss','KidZone','FoodieDelight','AutoParts India',
        'ElectroMart','StyleCraft','OrganicHarvest','FitnessFirst','ArtisanCraft',
        'MobileWorld','PetCare Plus','GardenGuru','JewelryBox','ToyLand',
        'KitchenKing','PrintMasters','HealthFirst','MusicMania','LuxuryBrands'),
        ' #', i),
      CONCAT('vendor', i, '@shop.com'),
      v_city,
      ROUND(10 + RAND() * 10, 2),
      ROUND(3.0 + RAND() * 2.0, 2),
      v_status,
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY));
    SET i = i + 1;
  END WHILE;

  -- ── PRODUCTS (2200) ──────────────────────────────────────
  SET i = 1;
  WHILE i <= 2200 DO
    SET v_title = ELT(1 + (i MOD 40),
      'Premium Wireless Earbuds Pro','Ultra HD Smart TV 55 inch',
      'Running Shoes Air Cushion','Organic Green Tea 200g',
      'Leather Office Chair Ergonomic','DSLR Camera 24MP Kit',
      'Protein Whey Powder 1kg','Silk Saree Handloom',
      'Gaming Laptop RTX 4060','Bluetooth Speaker Waterproof',
      'Non-Stick Cookware Set','Men Formal Suit Navy Blue',
      'Yoga Mat Anti-Slip 6mm','Stainless Steel Water Bottle',
      'Wooden Study Table','Baby Soft Toy Elephant',
      'Gold Plated Necklace Set','Mechanical Keyboard RGB',
      'Women Sneakers White','Air Purifier HEPA Filter',
      'Ayurvedic Face Cream 50ml','Smartwatch Fitness Tracker',
      'Denim Jacket Men Dark Blue','Rice Cooker 1.8L',
      'Electric Trimmer Cordless','School Backpack Waterproof',
      'Mountain Bike 21-Speed','Badminton Racket Set',
      'Foundation Matte Finish 30ml','Car Dash Cam 4K',
      'Noise Cancelling Headphones','Kurta Embroidered Cotton',
      'Whey Isolate Chocolate 2kg','Trekking Boots Waterproof',
      'Robot Vacuum Cleaner Auto','Lehenga Choli Bridal',
      'Pen Drive USB 3.0 64GB','Cricket Bat Kashmir Willow',
      'Shampoo Hair Fall Control','Vitamin C Serum 30ml');
    INSERT INTO products (vendor_id, category_id, title, sku, price, sale_price, cost_price, status, is_featured, created_at)
    VALUES (
      1 + (i MOD 200),
      1 + (i MOD 27),
      CONCAT(v_title, ' - Model ', i),
      CONCAT('SKU-', LPAD(i, 6, '0')),
      ROUND(100 + RAND() * 49900, 2),
      IF(i MOD 3 = 0, ROUND(80 + RAND() * 39000, 2), NULL),
      ROUND(50 + RAND() * 20000, 2),
      CASE WHEN i MOD 25 = 0 THEN 'inactive'
           WHEN i MOD 40 = 0 THEN 'draft'
           ELSE 'active' END,
      IF(i MOD 10 = 0, 1, 0),
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY));
    SET i = i + 1;
  END WHILE;

  -- ── PRODUCT INVENTORY ────────────────────────────────────
  INSERT INTO product_inventory (product_id, quantity_in_stock, reserved_quantity, reorder_level, warehouse_location)
  SELECT id,
    FLOOR(RAND() * 500),
    FLOOR(RAND() * 20),
    IF(id MOD 5 = 0, 5, 10),
    CONCAT('WH-', 1 + (id MOD 5), '-BIN-', LPAD(id MOD 100, 3, '0'))
  FROM products;

  -- ── CARTS (1800) ─────────────────────────────────────────
  SET i = 1;
  WHILE i <= 1800 DO
    SET v_status = CASE
      WHEN i MOD 3 = 0 THEN 'abandoned'
      WHEN i MOD 7 = 0 THEN 'converted'
      ELSE 'active' END;
    INSERT INTO carts (user_id, status, total_amount, created_at, abandoned_at)
    VALUES (
      206 + (i MOD 2000),  -- customer users start after admin+vendor = 205
      v_status,
      ROUND(RAND() * 9999, 2),
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY),
      IF(i MOD 3 = 0, DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 60) DAY), NULL));
    SET i = i + 1;
  END WHILE;

  -- ── CART ITEMS ───────────────────────────────────────────
  INSERT INTO cart_items (cart_id, product_id, quantity, unit_price)
  SELECT
    c.id,
    1 + (c.id * 7 MOD 2200),
    1 + FLOOR(RAND() * 4),
    ROUND(100 + RAND() * 9900, 2)
  FROM carts c;

  -- Add a second item to ~half the carts
  INSERT IGNORE INTO cart_items (cart_id, product_id, quantity, unit_price)
  SELECT
    c.id,
    1 + (c.id * 13 MOD 2200),
    1 + FLOOR(RAND() * 3),
    ROUND(200 + RAND() * 8000, 2)
  FROM carts c WHERE c.id MOD 2 = 0;

  -- ── ORDERS (3200) ────────────────────────────────────────
  SET i = 1;
  WHILE i <= 3200 DO
    SET v_order_status = ELT(1 + (i MOD 7),
      'pending','confirmed','processing','shipped','delivered','cancelled','refunded');
    SET v_pay_status = ELT(1 + (i MOD 5),
      'pending','paid','paid','failed','refunded');
    INSERT INTO orders (user_id, order_number, order_status, payment_status,
      total_amount, subtotal, shipping_amount, discount_amount, tax_amount,
      coupon_code, created_at, confirmed_at, delivered_at)
    VALUES (
      206 + (i MOD 2000),
      CONCAT('ORD-', YEAR(DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*730) DAY)), '-', LPAD(i, 6, '0')),
      v_order_status,
      v_pay_status,
      ROUND(199 + RAND() * 49800, 2),
      ROUND(180 + RAND() * 48000, 2),
      IF(RAND() > 0.7, ROUND(49 + RAND() * 200, 2), 0.00),
      IF(i MOD 5 = 0, ROUND(RAND() * 500, 2), 0.00),
      ROUND(RAND() * 500, 2),
      IF(i MOD 8 = 0, CONCAT('SAVE', FLOOR(RAND()*50)), NULL),
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 730) DAY),
      IF(i MOD 7 NOT IN (0,5,6), DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*700) DAY), NULL),
      IF(i MOD 7 = 4, DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*600) DAY), NULL));
    SET i = i + 1;
  END WHILE;

  -- ── ORDER ITEMS (5500+) ──────────────────────────────────
  -- 1 item per order
  INSERT INTO order_items (order_id, product_id, vendor_id, quantity, unit_price, total_price, status)
  SELECT
    o.id,
    1 + (o.id * 3 MOD 2200),
    1 + (o.id MOD 200),
    1 + FLOOR(RAND() * 4),
    ROUND(100 + RAND() * 9900, 2),
    ROUND((1 + FLOOR(RAND() * 4)) * (100 + RAND() * 9900), 2),
    ELT(1 + (o.id MOD 6), 'pending','confirmed','shipped','delivered','cancelled','returned')
  FROM orders o;

  -- 2nd item for ~60% of orders
  INSERT INTO order_items (order_id, product_id, vendor_id, quantity, unit_price, total_price, status)
  SELECT
    o.id,
    1 + (o.id * 11 MOD 2200),
    1 + ((o.id + 5) MOD 200),
    1 + FLOOR(RAND() * 3),
    ROUND(200 + RAND() * 5000, 2),
    ROUND((1 + FLOOR(RAND() * 3)) * (200 + RAND() * 5000), 2),
    ELT(1 + (o.id MOD 6), 'pending','confirmed','shipped','delivered','cancelled','returned')
  FROM orders o WHERE o.id MOD 5 != 0;

  -- 3rd item for ~25% of orders
  INSERT INTO order_items (order_id, product_id, vendor_id, quantity, unit_price, total_price, status)
  SELECT
    o.id,
    1 + (o.id * 17 MOD 2200),
    1 + ((o.id + 10) MOD 200),
    1 + FLOOR(RAND() * 2),
    ROUND(150 + RAND() * 3000, 2),
    ROUND((1 + FLOOR(RAND() * 2)) * (150 + RAND() * 3000), 2),
    ELT(1 + (o.id MOD 6), 'pending','confirmed','shipped','delivered','cancelled','returned')
  FROM orders o WHERE o.id MOD 4 = 0;

  -- ── PAYMENTS (3000+) ─────────────────────────────────────
  SET i = 1;
  WHILE i <= 3200 DO
    SET v_method = ELT(1 + (i MOD 7),
      'upi','credit_card','debit_card','netbanking','wallet','cod','emi');
    SET v_gateway = ELT(1 + (i MOD 4),
      'razorpay','paytm','stripe','cashfree');
    INSERT IGNORE INTO payments
      (order_id, user_id, transaction_id, payment_method, payment_gateway,
       amount, status, failure_reason, created_at)
    SELECT
      o.id, o.user_id,
      CONCAT('TXN-', MD5(CONCAT(o.id, i, RAND()))),
      v_method, v_gateway,
      o.total_amount,
      o.payment_status,
      CASE WHEN o.payment_status = 'failed' THEN
        ELT(1 + (i MOD 5),
          'Insufficient funds','Card declined','Network timeout','Invalid OTP','Bank server error')
      ELSE NULL END,
      DATE_ADD(o.created_at, INTERVAL 2 MINUTE)
    FROM orders o WHERE o.id = i AND o.payment_status != 'pending';
    SET i = i + 1;
  END WHILE;

  -- ── SHIPMENTS ────────────────────────────────────────────
  SET i = 1;
  WHILE i <= 3200 DO
    SET v_courier = ELT(1 + (i MOD 5),
      'Delhivery','Bluedart','FedEx','XpressBees','DTDC');
    SET v_ship_status = ELT(1 + (i MOD 7),
      'pending','packed','dispatched','in_transit','delivered','out_for_delivery','returned');
    INSERT IGNORE INTO shipments
      (order_id, vendor_id, tracking_number, courier_partner, shipping_method,
       status, estimated_delivery_date, actual_delivery_date,
       shipping_cost, dispatched_at, delivered_at)
    SELECT
      o.id,
      1 + (o.id MOD 200),
      CONCAT('TRACK', UPPER(MD5(CONCAT(o.id, i)))),
      v_courier,
      ELT(1 + (o.id MOD 3), 'standard','express','overnight'),
      v_ship_status,
      DATE_ADD(o.created_at, INTERVAL 5 DAY),
      IF(i MOD 7 = 4, DATE_ADD(o.created_at, INTERVAL 4 DAY), NULL),
      IF(o.id MOD 4 = 0, ROUND(49 + RAND() * 200, 2), 0.00),
      IF(i MOD 7 NOT IN (0,1), DATE_ADD(o.created_at, INTERVAL 1 DAY), NULL),
      IF(i MOD 7 = 4, DATE_ADD(o.created_at, INTERVAL 4 DAY), NULL)
    FROM orders o
    WHERE o.id = i AND o.order_status NOT IN ('pending','cancelled');
    SET i = i + 1;
  END WHILE;

  -- ── REVIEWS (2000+) ──────────────────────────────────────
  SET i = 1;
  WHILE i <= 2000 DO
    SET v_rating = 1 + FLOOR(RAND() * 5);
    SET v_title = ELT(1 + (i MOD 10),
      'Excellent product, highly recommend!',
      'Good value for money',
      'Quality could be better',
      'Fast delivery, product as described',
      'Not as expected',
      'Great purchase, very satisfied',
      'Average product, nothing special',
      'Packaging was damaged but product ok',
      'Loved it! Will buy again',
      'Decent quality at this price point');
    INSERT IGNORE INTO reviews
      (product_id, user_id, order_id, rating, title, body, is_verified_purchase, helpful_votes, status, created_at)
    SELECT
      1 + (o.id * 3 MOD 2200),
      o.user_id,
      o.id,
      v_rating,
      v_title,
      CONCAT('Detailed review #', i, ': The product quality and packaging were as expected. Delivery was on time.'),
      1,
      FLOOR(RAND() * 50),
      IF(i MOD 20 = 0, 'pending', 'published'),
      DATE_ADD(o.delivered_at, INTERVAL FLOOR(RAND() * 30) DAY)
    FROM orders o
    WHERE o.id = i
      AND o.order_status = 'delivered'
      AND o.delivered_at IS NOT NULL;
    SET i = i + 1;
  END WHILE;

END$$

DELIMITER ;

-- ============================================================
-- RUN THE SEEDER
-- ============================================================
CALL seed_ecommerce_data();

-- Verify row counts
SELECT 'roles' AS tbl, COUNT(*) AS total_rows FROM roles
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'vendors', COUNT(*) FROM vendors
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'product_inventory', COUNT(*) FROM product_inventory
UNION ALL SELECT 'carts', COUNT(*) FROM carts
UNION ALL SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews;
