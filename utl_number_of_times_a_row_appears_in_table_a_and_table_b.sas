Number of times a row appears in table a and table b.

github do_over macro
https://github.com/rogerjdeangelis/utl_sql_looping_or_using_arrays_in_sql_do_over_macro

INPUT
=====                      |     RULES after tagging, appending and sorting
                           |
  WORK.HAV1ST TOTAL OBS=8  |   WORK.HAV3RD total obs=16
                           |
    X1    X2   X3          |     X1    X2    X3     TBL      HAV1ST   HAV2ND
                           |
     0     0    0          |      0     0     0    HAV1ST      1        0
     1     2    2          |
     0     2    0          |      0     0     1    HAV2ND
     0     0    1          |      0     0     1    HAV1ST
     0     0    1          |      0     0     1    HAV1ST      2        1
     1     0    0          |
     2     0    2          |      0     2     0    HAV1ST      1        0
     1     0    2          |      1     0     0    HAV1ST      1        0
                           |      1     0     2    HAV1ST      1        0
                           |
  WORK.HAV2ND total obs=8  |      1     2     2    HAV2ND
                           |      1     2     2    HAV2ND
   X1    X2    X3          |      1     2     2    HAV1ST      1        2
                           |
    2     2     0          |      2     0     0    HAV2ND
    1     2     2          |
    1     2     2          |      2     0     2    HAV2ND
    2     0     0          |      2     0     2    HAV1ST
    0     0     1          |      2     0     2    HAV2ND      1        2
    2     2     1          |
    2     0     2          |      2     2     0    HAV2ND      0        1
    2     0     2          |      2     2     1    HAV2ND      0        1



PROCESS (all the code)
======================

    * tage append and sort;
    * just change x3 to x100 in the array macro for bigger array;
    proc sql;
      create
        table hav3rd as
      select
        *
       ,'HAV1ST' as tbl
      from
        sd1.hav1st
      union all
      select
        *
       ,'HAV2ND' as tbl
      from
        sd1.hav2nd
      order
        by %array(xs,values=x1-x3)
           %do_over(xs,phrase=?,between=comma)
    ;quit;

    * macro variable xsn is from %array;

    data want;
     retain hav1st hav2nd 0;
     do cnt=1 by 1 until(last.x&xsn);
        set hav3rd;
        by x:;
        select (tbl);
          when ('HAV1ST') hav1st=hav1st+1;
          when ('HAV2ND') hav2nd=hav2nd+1;
        end;
        if last.x&xsn then output;
        drop tbl;
     end;
     hav1st=0;
     hav2nd=0;
    run;quit;

OUTPUT
======

 WORK.WANT total obs=10

   HAV1ST    HAV2ND    CNT    X1    X2    X3

      1         0       1      0     0     0
      2         1       3      0     0     1
      1         0       1      0     2     0
      1         0       1      1     0     0
      1         0       1      1     0     2
      1         2       3      1     2     2
      0         1       1      2     0     0
      1         2       3      2     0     2
      0         1       1      2     2     0
      0         1       1      2     2     1
see
https://goo.gl/X61zQa
https://stackoverflow.com/questions/47761429/find-the-number-of-times-that-each-row-of-a-matrix-appears-in-another





