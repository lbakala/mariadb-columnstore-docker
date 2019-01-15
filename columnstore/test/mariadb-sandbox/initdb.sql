CREATE DATABASE IF NOT EXISTS `##test_db_name##`;
USE `##test_db_name##`;
CREATE TABLE test (a INT, b INT, c VARCHAR(255));
INSERT INTO test VALUES (1, 2, 'hello');
INSERT INTO test VALUES (2, 3, 'goodbye!');
DELETE FROM test WHERE a = 1;

CREATE USER IF NOT EXISTS '##test_user_name##'@'%' IDENTIFIED BY '##test_user_pass##';
GRANT ALL ON `##test_bookstore_db##`.* TO '##test_user_name##'@'%';
GRANT ALL ON `##test_bookstore_db##`.* TO '##test_user_name##'@'localhost';