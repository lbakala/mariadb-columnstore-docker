CREATE USER 'sandbox'@'%' IDENTIFIED BY 'highlyillogical';
GRANT ALL ON bookstore.* TO 'sandbox'@'%';
FLUSH PRIVILEGES;