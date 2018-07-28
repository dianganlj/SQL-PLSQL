--川旬 

--1、
SELECT *
  FROM employees emp
 WHERE emp.hire_date > to_date('1997-01-01',
                               'yyyy-mm-dd');
                               
--2、
SELECT emp.last_name,
       emp.job_id,
       emp.salary,
       emp.commission_pct
  FROM employees emp
 ORDER BY emp.salary desc
--3、
SELECT 
       emp.salary,
       emp.commission_pct
  FROM employees emp 
  update employees emp  set emp.salary= emp.salary *1.1 where emp.commission_pct =0
 
--4、
SELECT emp.last_name,
       trunc(months_between(SYSDATE,
                            emp.hire_date) / 12) AS years,
       trunc(MOD( months_between(SYSDATE,
                            emp.hire_date),12)) AS months
  FROM employees emp

--5、
SELECT emp.last_name
  FROM employees emp
 WHERE emp.last_name LIKE '%J%'
    OR emp.last_name LIKE '%K%'
    OR emp.last_name LIKE '%L%'
    OR emp.last_name LIKE '%M%'

--6、 
SELECT last_name, salary,
       decode(commission_pct, NULL, 'No', 'Yes') commission
FROM   employees

 
--7、
SELECT d.department_name,
       d.location_id,
       e.last_name,
       e.job_id,
       e.salary
  FROM employees   e,
       departments d
 WHERE e.department_id = d.department_id
   AND d.location_id = 1800

--8.   
SELECT COUNT(*)
  FROM employees emp
 WHERE emp.last_name LIKE '%n'

SELECT COUNT(1)
          FROM employees emp
         WHERE emp.last_name LIKE '%n'

SELECT COUNT(*)
FROM   employees
WHERE  last_name LIKE '%n'


SELECT COUNT(*)
FROM   employees
WHERE  SUBSTR(last_name, -1) = 'n'

--9.
SELECT e.department_id,
       d.department_name,
       d.location_id,
       COUNT(e.employee_id) 
  FROM employees   e,
       departments d
 WHERE e.department_id(+) = d.department_id
  GROUP BY e.department_id, d.department_name, d.location_id
 
--10
SELECT e.job_id
  FROM employees e
 WHERE e.department_id IN (10,
                           20)

--11
  SELECT e.job_id,
         COUNT(e.job_id) frequency
          FROM employees   e,
         departments d
         WHERE e.department_id(+) = d.department_id
           AND d.department_name IN ('Administration',
                                     'Executive')
         GROUP BY e.job_id
         ORDER BY frequency DESC

--12.
SELECT e.last_name,
       to_char(e.hire_date,
               'DD-MON-YY')
  FROM employees e
 WHERE to_char(e.hire_date,
               'dd') BETWEEN 1 AND 10

--13.
SELECT e.last_name,
       e.salary,
       trunc(e.salary / 1000) "THOUSANDS"
  FROM employees e

--14
SELECT e.last_name,
       emp.last_name manager,
       emp.salary,
       CASE
         WHEN emp.salary BETWEEN 1000 AND 2999 THEN
          'A'
         WHEN emp.salary BETWEEN 3000 AND 5999 THEN
          'B'
         WHEN emp.salary BETWEEN 6000 AND 9999 THEN
          'C'
         WHEN emp.salary BETWEEN 10000 AND 14999 THEN
          'D'
         WHEN emp.salary BETWEEN 15000 AND 24999 THEN
          'E'
         WHEN emp.salary BETWEEN 25000 AND 40000 THEN
          'F'
       END gra
  FROM employees e,
       employees emp
 WHERE e.manager_id = emp.employee_id;
 
 --15

SELECT  d.department_id, d.department_name,
        count(e1.employee_id) employees,
        NVL(TO_CHAR(AVG(e1.salary), '99999.99'),
        'No average' ) avg_sal,
        e2.last_name, e2.salary, e2.job_id
FROM    departments d, employees e1, employees e2
WHERE   d.department_id = e1.department_id(+)
AND     d.department_id = e2.department_id(+)
GROUP BY d.department_id, d.department_name,
         e2.last_name,   e2.salary, e2.job_id
ORDER BY d.department_id, employees

 
 --16.
 SELECT *
   FROM (SELECT e.department_id,
                AVG(e.salary) maxsalary
           FROM employees e
          GROUP BY e.department_id
          ORDER BY maxsalary DESC)
  WHERE rownum = 1

--17.
SELECT DISTINCT d.department_id,
                d.department_name,
                d.manager_id,
                d.location_id
  FROM employees   e,
       departments d
 WHERE e.department_id = d.department_id
   AND e.job_id != 'SA_REP'
   order by d.department_id 
   
 --18.a
SELECT *
  FROM (SELECT DISTINCT e.department_id,
                        d.department_name,
                        COUNT(e.employee_id) countn0
          FROM employees   e,
               departments d
         WHERE e.department_id = d.department_id
         GROUP BY e.department_id,
                  d.department_name)
 WHERE countn0 < 3
 ORDER BY department_id
--18.b
SELECT *
  FROM (SELECT DISTINCT e.department_id,
                        d.department_name,
                         COUNT(e.employee_id) countn0
          FROM employees   e,
               departments d
         WHERE e.department_id = d.department_id
         GROUP BY e.department_id,
                  d.department_name order by countn0 desc)
 WHERE rownum = 1
--18.c
SELECT *
  FROM (SELECT DISTINCT e.department_id,
                        d.department_name,
                         COUNT(e.employee_id) countn0
          FROM employees   e,
               departments d
         WHERE e.department_id = d.department_id
         GROUP BY e.department_id,
                  d.department_name order by countn0 )
 WHERE rownum = 1
 
 --19.
 SELECT e.employee_id,
        e.last_name,
        e.department_id,
        d.avgsal
   FROM employees e,
        (SELECT department_id,
                AVG(salary) avgsal
           FROM employees e
          GROUP BY department_id) d
  WHERE e.department_id = d.department_id
  ORDER BY e.employee_id
  
 --20
 SELECT emp.last_name,
        to_char(emp.hire_date,
                'day') empday
   FROM employees emp,
        (SELECT *
           FROM (SELECT to_char(e.hire_date,
                                'day') daynum,
                        COUNT(e.employee_id) countno
                   FROM employees e
                  GROUP BY to_char(e.hire_date,
                                   'day')
                  ORDER BY countno DESC)
          WHERE rownum = 1) t
  WHERE to_char(emp.hire_date,
                'day') = t.daynum


--21 
SELECT e.last_name,
       to_char(e.hire_date,
               'MM-DD') birthday
  FROM employees e
 ORDER BY birthday
 
--22
SELECT job_id
FROM   employees
WHERE  hire_date 
BETWEEN '01-JAN-1990' AND '30-JUN-1990'
INTERSECT
SELECT job_id
FROM   employees
WHERE  hire_date BETWEEN '01-JAN-1991'AND '30-JUN-1991';


--23
SELECT '05% raise' raise, employee_id, salary, 
salary *.05 new_salary
FROM   employees
WHERE  department_id IN (10,50, 110)
UNION
SELECT '10% raise', employee_id, salary, salary * .10
FROM   employees
WHERE  department_id = 60
UNION
SELECT '15% raise', employee_id, salary, salary * .15 
FROM   employees
WHERE  department_id IN (20, 80)
UNION
SELECT 'no raise', employee_id, salary, salary
FROM   employees
WHERE  department_id = 90;

--24.
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

--SELECT sysdate FROM dual

--25.a1
SELECT tz_offset('Australia/Sydney')
  FROM dual;
--25a
SELECT tz_offset('Chile/EasterIsland')
  FROM dual;
--25 b.
ALTER SESSION SET TIME_ZONE = '+10:00';

--SELECT sessiontimezone  FROM dual
--25.c
SELECT SYSDATE,
       current_date,
       current_timestamp,
       localtimestamp
  FROM dual
--25 d.
ALTER SESSION SET TIME_ZONE = '-06:00';
--25.e
SELECT SYSDATE,
       current_date,
       current_timestamp,
       localtimestamp
  FROM dual;
--25 f.
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';


--26.
SELECT e.last_name,
       extract(month  FROM e.hire_date),
       to_char(e.hire_date,
               'dd-mm-yyyy')
  FROM employees e


--27.
SELECT l.city,
       d.department_name,
       e.job_id,
       SUM(e.salary)
  FROM departments d,
       locations   l,
       employees   e
 WHERE d.department_id = e.department_id
   AND d.location_id = l.location_id
   AND e.department_id > 80
 GROUP BY CUBE(l.city,d.department_name, e.job_id)


--28.
SELECT department_id, job_id, manager_id,max(salary),min(salary)
FROM   employees
GROUP BY GROUPING SETS
((department_id,job_id), (job_id,manager_id))


--29.
SELECT *
  FROM (SELECT e.last_name,
               e.salary
          FROM employees e
         ORDER BY e.salary DESC)
 WHERE rownum < 4


--30
SELECT e.employee_id,
       e.last_name
  FROM employees e
 WHERE e.department_id = (SELECT d.department_id
                            FROM departments d
                           WHERE d.location_id = (SELECT l.location_id
                                                    FROM locations l
                                                   WHERE l.state_province = 'California'))
                                                   


--31.
DELETE FROM job_history j
 WHERE j.employee_id = (SELECT employee_id
                          FROM (SELECT jh.employee_id,
                                       SUM(months_between(jh.end_date,
                                                          jh.start_date)) sumyear
                                  FROM job_history jh
                                HAVING jh.employee_id IN (SELECT jh.employee_id
                                                           FROM job_history jh
                                                          GROUP BY jh.employee_id
                                                         HAVING COUNT(1) > 1)
                                 GROUP BY jh.employee_id
                                 ORDER BY sumyear)
                         WHERE rownum = 1)
 
 --SELECT * FROM job_history
 
 
 --32

SELECT *
  FROM employees e;
SAVEPOINT a;
DELETE FROM employees e
 WHERE e.employee_id = (SELECT MAX(emp.employee_id)
                          FROM employees emp)  SELECT *
          FROM employees e;

ROLLBACK TO a;

SELECT *
  FROM employees e
   
   
 --33
 WITH sql1 AS
  (SELECT j.job_title,
          MAX(e.salary) max_sal
     FROM employees e,
          jobs      j
    WHERE e.job_id = j.job_id
    GROUP BY e.job_id,
             j.job_title)
 SELECT *
   FROM sql1
  WHERE max_sal > (SELECT MAX(salary) / 2
                     FROM employees)
  ORDER BY max_sal DESC

--34.a
SELECT e.employee_id,
       e.last_name,
       e.hire_date,
       e.salary
  FROM employees e
 WHERE e.manager_id = (SELECT emp.employee_id
                         FROM employees emp
                      WHERE emp.last_name = 'De Haan')
                      
--34 b
SELECT employee_id,
       last_name,
       job_id,
       manager_id
  FROM employees
 START WITH manager_id = (SELECT emp.employee_id
                         FROM employees emp
                      WHERE emp.last_name = 'De Haan')
CONNECT BY PRIOR  employee_id =manager_id ;

--35 
SELECT * FROM (
SELECT level ll, employee_id,
       last_name,
       job_id,
       manager_id
  FROM employees
 START WITH manager_id = (SELECT emp.employee_id
                         FROM employees emp
                      WHERE emp.last_name = 'De Haan') 
CONNECT BY PRIOR  employee_id =manager_id  )where  ll = 2


--36.
SELECT e.employee_id,
       e.manager_id,
       LEVEL,
       e.last_name,
       lpad(e.last_name,
            length(e.last_name) + LEVEL * 3 - 3,
            '_')
  FROM employees e
CONNECT BY e.employee_id = PRIOR e.manager_id


--37.
INSERT ALL WHEN sal < 5000 THEN INTO special_sal
VALUES
  (empid, sal) ELSE INTO sal_history
VALUES
  (empid, hiredate, sal) INTO mgr_history
VALUES
  (empid, mgr, sal)
  SELECT employee_id empid,
         hire_date   hiredate,
         salary      sal,
         manager_id  mgr
    FROM employees
   WHERE employee_id >= 200;


--38.

SELECT *
  FROM special_sal;
SELECT *
  FROM sal_history;
SELECT *
  FROM mgr_history;

--39.
CREATE TABLE LOCATIONS_NAMED_INDEX_20864
 (location_id NUMBER(4)
         PRIMARY KEY USING INDEX
        (CREATE INDEX locations_pk_idx ON
         LOCATIONS_NAMED_INDEX_20864(location_id)),
 location_name VARCHAR2(30));
 
 --40.
 SELECT INDEX_NAME, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'LOCATIONS_NAMED_INDEX';      

--41
