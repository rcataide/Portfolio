-- Uso da função WITH do Oracle para cálculo de datas 
with dt1 as (
select 
  to_date('13/08/2015 00:00:00','dd/mm/yyyy hh24:mi:ss') data_inicial, 
  to_date('14/08/2015 21:40:11','dd/mm/yyyy hh24:mi:ss') data_final
from dual),
dt2 as (
select data_final - data_inicial diferenca from dt1
)
select 
  trunc(diferenca)*24 + trunc((diferenca - trunc(diferenca))*24)||':'||
  trunc((((diferenca - trunc(diferenca))*24) - trunc((diferenca - trunc(diferenca))*24))*60)
from dt2;

------------------------------------------------

--   1- QUERY ORIGINAL: Utilizando somente o subselect como base.   

        SELECT         D.DEPARTMENT_NAME, 
                               SUM(E.SALARY) AS DEPT_TOTAL
        FROM            HR.EMPLOYEES E
        INNER JOIN  HR.DEPARTMENTS D
                ON          E.DEPARTMENT_ID = D.DEPARTMENT_ID
        GROUP BY    D.DEPARTMENT_NAME
        HAVING        SUM(E.SALARY)   >  (
                                              SELECT  SUM(DEPT_TOTAL)/COUNT(*)
                                              FROM    (
                                                        SELECT      D.DEPARTMENT_NAME, 
                                                                           SUM(E.SALARY) AS DEPT_TOTAL
                                                        FROM        HR.EMPLOYEES E
                                                        INNER JOIN  HR.DEPARTMENTS D
                                                            ON        E.DEPARTMENT_ID = D.DEPARTMENT_ID
                                                        GROUP BY    D.DEPARTMENT_NAME))                                                        
        ORDER BY    department_name;

  --  2- QUERY ALTERADA COM CLÁUSULA WITH: Select mais rápido e de melhor entendimento 

WITH
          DEPT_COSTS AS (
                          SELECT          D.DEPARTMENT_NAME, 
                                                  SUM(E.SALARY) AS DEPT_TOTAL
                          FROM             HR.EMPLOYEES E
                          INNER JOIN  HR.DEPARTMENTS D
                              ON              E.DEPARTMENT_ID = D.DEPARTMENT_ID
                          GROUP BY    D.DEPARTMENT_NAME),
          AVG_COST AS (
                          SELECT         SUM(DEPT_TOTAL)/COUNT(*) AS DEPT_AVG
                          FROM            HR.DEPT_COSTS)
        SELECT         *
        FROM           DEPT_COSTS
        WHERE         DEPT_TOTAL >  ( SELECT  DEPT_AVG
                                                          FROM    AVG_COST)
        ORDER BY   department_name;
