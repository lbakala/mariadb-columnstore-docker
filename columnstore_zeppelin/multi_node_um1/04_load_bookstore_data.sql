use bookstore

INSERT INTO TransactionTypes (tr_type_id,tr_type)
VALUES (1,'Item'),
       (2,'Discount'),
       (3,'Shipping');

INSERT INTO MaritalStatuses (ms_id,ms_type)
VALUES (1,'Never married'),
       (2,'Married'),
       (3,'Widow'),
       (4,'Separated'),
       (5,'Divorced');

SET @@max_length_for_sort_data = 4096;
