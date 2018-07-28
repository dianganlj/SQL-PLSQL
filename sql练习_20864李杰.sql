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

--6、 F
 
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

--8.   F
SELECT count(*) FROM  employees emp where emp.last_name like '%n'
SELECT count(1) FROM  employees emp where emp.last_name like '%n'

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
update employees e 
