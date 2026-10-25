-- Bank Management System database schema
-- Review against your source code before using with any existing database.
CREATE DATABASE IF NOT EXISTS bankmanagementsystem;
USE bankmanagementsystem;

CREATE TABLE IF NOT EXISTS signup (
    formno VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    fname VARCHAR(100),
    dob VARCHAR(30),
    gender VARCHAR(30),
    email VARCHAR(150),
    marital VARCHAR(30),
    address VARCHAR(255),
    city VARCHAR(100),
    pincode VARCHAR(20),
    state VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS signup2 (
    formno VARCHAR(20) PRIMARY KEY,
    religion VARCHAR(60),
    category VARCHAR(60),
    income VARCHAR(60),
    education VARCHAR(100),
    occupation VARCHAR(100),
    pan VARCHAR(30),
    aadhar VARCHAR(30),
    scitizen VARCHAR(20),
    eaccount VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS signup3 (
    formno VARCHAR(20) PRIMARY KEY,
    atype VARCHAR(100),
    cardno VARCHAR(30) UNIQUE,
    pin VARCHAR(20),
    facility VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS login (
    formno VARCHAR(20),
    cardno VARCHAR(30) PRIMARY KEY,
    pin VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS bank (
    pin VARCHAR(20) NOT NULL,
    date VARCHAR(30),
    type VARCHAR(30),
    amount VARCHAR(30)
);

CREATE INDEX idx_bank_pin ON bank(pin);
