CREATE DATABASE IF NOT EXISTS bookstore;

USE bookstore

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
book_id BIGINT UNSIGNED NOT NULL,
cover_price DECIMAL(7,2) NOT NULL,
isbn VARCHAR(255) NOT NULL,
bookname VARCHAR(255) NOT NULL,
category VARCHAR(255) NOT NULL,
discount DECIMAL(7,2) NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS Covers;
CREATE TABLE Covers (
cover_id INTEGER NOT NULL,
image LONGBLOB NOT NULL,
PRIMARY KEY(cover_id)) Engine = INNODB;

DROP TABLE IF EXISTS TransactionTypes;
CREATE TABLE TransactionTypes (
tr_type_id BIGINT UNSIGNED NOT NULL,
tr_type VARCHAR(50) NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS MaritalStatuses;
CREATE TABLE MaritalStatuses (
ms_id BIGINT UNSIGNED NOT NULL,
ms_type VARCHAR(50) NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS Cards;
CREATE TABLE Cards (
card_id BIGINT UNSIGNED NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
card_nm VARCHAR(255) NOT NULL,
card_type VARCHAR(255) NOT NULL,
discount VARCHAR(255) NOT NULL,
points INTEGER NOT NULL,
is_threshold TINYINT NOT NULL,
award_percent DECIMAL(3,2) NOT NULL
)
engine=columnstore;

DROP TABLE IF EXISTS Emails;
CREATE TABLE Emails (
email_id BIGINT UNSIGNED NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
email_adr VARCHAR(255) NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS Phones;
CREATE TABLE Phones (
phone_id BIGINT UNSIGNED NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
phone_nm VARCHAR(255) NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS Addresses;
CREATE TABLE Addresses (
address_id BIGINT UNSIGNED NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
address VARCHAR(255) NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS Transactions;
CREATE TABLE Transactions (
trans_date DATETIME NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,
transaction_id BIGINT UNSIGNED NOT NULL,
book_id INTEGER UNSIGNED NOT NULL,
price DECIMAL(7,2) NOT NULL,
discount DECIMAL(7,2) NOT NULL,
discounted_price DECIMAL(7,2) NOT NULL,
transaction_type INTEGER NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS LoyaltyPoints;
CREATE TABLE LoyaltyPoints (
trans_date DATETIME NOT NULL,
order_id BIGINT UNSIGNED NOT NULL,
card_is BIGINT UNSIGNED NOT NULL,
points INTEGER NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL)
engine=columnstore;

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
customer_nm VARCHAR(512) NOT NULL,
customer_id BIGINT UNSIGNED NOT NULL,
customer_username_nm VARCHAR(512) NOT NULL,
sex CHAR(1) NOT NULL,
age INTEGER NOT NULL,
ms_id INTEGER NOT NULL)
engine=columnstore;
