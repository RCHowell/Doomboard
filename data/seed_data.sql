-- bogus seed data for testing

INSERT INTO problems
VALUES (0, "The First", "", "AB,BC,CA", 1, 1, 1, 1);

INSERT INTO problems
VALUES (1, "Spoiled Milk", "", "", "AB,BC,CA", -1, 3, 2, 0);

INSERT INTO problems
VALUES (2, "Water","", "", "AB,BC,CA", 1, 2, 2, 1);

INSERT INTO problems
VALUES (3, "Decaf Coffee", "", "", "AB,BC,CA", 0, 1, 1, 0);

-- .read seed_data.sql
-- .mode columns
-- .headers on

-- id          name        spray       moves       quality     grade_a     grade_b     sent      
-- ----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------
-- 0           The First               AB,BC,CA    1           1           1           1         
-- 1           Spoiled Mi              AB,BC,CA    -1          3           2           0         
-- 2           Water                   AB,BC,CA    1           2           2           1         
-- 3           Decaf Coff              AB,BC,CA    0           1           1           0        