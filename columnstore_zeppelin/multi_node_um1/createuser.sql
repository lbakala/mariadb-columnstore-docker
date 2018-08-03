CREATE USER 'zeppelin_user'@'%' IDENTIFIED BY 'zeppelin_pass';
GRANT ALL ON bookstore.* TO 'zeppelin_user'@'%';
FLUSH PRIVILEGES;