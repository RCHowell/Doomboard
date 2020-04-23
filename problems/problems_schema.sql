-- Simple table to store problems
---- sure sure I could add constraints
CREATE TABLE problems (
  id INT PRIMARY KEY,
  name TEXT,
  img TEXT,
  spray TEXT,
  moves TEXT, -- list of moves comma delimited AB,BC,CA ...
  quality INT, -- -1 bomb, 0 not rated, 1 star
  grade_a INT, -- [1-4]
  grade_b INT, -- [1-4]
  sent INT -- bool 0/1
);
