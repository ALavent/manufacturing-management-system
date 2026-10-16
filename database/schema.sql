-- Manufacturing Management System Database Schema

CREATE DATABASE IF NOT EXISTS manufacturing_db;
USE manufacturing_db;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Suppliers table
CREATE TABLE IF NOT EXISTS suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact VARCHAR(100),
    email VARCHAR(100),
    address TEXT
);

-- Inventory table
CREATE TABLE IF NOT EXISTS inventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    warehouse_location VARCHAR(100),
    quantity INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert default admin user (password: admin123)
INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'admin'),
('user', 'user123', 'user');

-- Insert sample products
INSERT INTO products (product_name, price, stock, category) VALUES
('Widget A', 19.99, 100, 'Electronics'),
('Widget B', 29.99, 50, 'Electronics'),
('Gadget X', 49.99, 75, 'Tools'),
('Component Y', 9.99, 200, 'Parts'),
('Assembly Z', 99.99, 25, 'Complete');

-- Insert sample orders
INSERT INTO orders (product_id, quantity, status) VALUES
(1, 10, 'completed'),
(2, 5, 'pending'),
(3, 3, 'processing'),
(4, 20, 'completed');

-- Insert sample suppliers
INSERT INTO suppliers (supplier_name, contact, email) VALUES
('TechCorp Industries', '555-0101', 'contact@techcorp.com'),
('Global Parts Ltd', '555-0102', 'sales@globalparts.com'),
('Quality Components', '555-0103', 'info@qualitycomp.com');
