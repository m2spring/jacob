MODULE Set;
CONST
   s1 = {-1};
(*         ^ err 202: set element greater than MAX(SET) or less than 0 *)
   s2 = {32};
(*         ^ err 202: set element greater than MAX(SET) or less than 0 *)
   s3 = {5..2};
(*           ^ err 201: lower bound of set range greater than higher bound *)
END Set.
