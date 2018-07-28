--4
DECLARE
  v_year NUMBER(4) := &p_v_year;
BEGIN
  IF mod(v_year,4)=0 and mod(v_year,100)!=0
     OR mod(v_year,400)=0 THEN
    dbms_output.put_line('leap year');
  ELSE
    dbms_output.put_line('not a leap year');
  END IF;
END;


--5.a
CREATE TABLE TEMP_20864(
num_store Number(7,2),
char_store VARCHAR(35),
date_store DATE
);

SELECT *
  FROM temp_20864
--5.b
        DECLARE message VARCHAR2(35) := 'This is my first PL/SQL program';
date_written DATE := current_date;
BEGIN
  INSERT INTO temp_20864
    (char_store, date_store)
  VALUES
    (message, date_written);
  dbms_output.put_line(message);
  dbms_output.put_line(date_written);
END;


--6.a


DECLARE
  v_department_id departments.department_id%TYPE;
BEGIN
  SELECT d.department_id
    INTO v_department_id
    FROM departments d
   WHERE d.department_id = &p_dep_id;
  dbms_output.put_line(v_department_id);
  Exception 
    when  NO_DATA_FOUND then
      dbms_output.put_line('查无此编号');
END;


--6.b
DECLARE
  v_cnt    NUMBER;
  v_dep_id NUMBER;
BEGIN
  SELECT e.department_id,
         COUNT(e.employee_id)
    INTO v_dep_id,
         v_cnt
    FROM employees   e,
         departments d
   WHERE d.department_id = e.department_id
     AND e.department_id = &department_id --50
   GROUP BY e.department_id;
  dbms_output.put_line(v_dep_id || '号部门' || '的人数是' || v_cnt);
  Exception 
    when  NO_DATA_FOUND then
      dbms_output.put_line('无此记录');
END;


--7.
DECLARE
  v_emp_name employees.last_name%TYPE :='&p_emp_name';
  v_salary   employees.salary%TYPE;
BEGIN
  SELECT e.last_name,
         e.salary
    INTO v_emp_name,
         v_salary
    FROM employees e
   WHERE e.last_name =v_emp_name ;
   if v_salary < 3000
     then  v_salary := v_salary+500;
     dbms_output.put_line(v_emp_name||''''||'s salary updated ');
     else   
       dbms_output.put_line(v_emp_name || ' earns '||v_salary);
       end if;
       Exception 
    when  NO_DATA_FOUND then
      dbms_output.put_line('无此姓名记录');
END;


--8(2)
DECLARE
  v_salary    employees.salary%TYPE;
  v_annualsal employees.salary%TYPE;
  v_emp_name  employees.last_name%TYPE;
  v_bonus     employees.salary%TYPE;
  v_emp_id    employees.employee_id%TYPE := &p_emp_id;
BEGIN
  SELECT e.last_name,
         e.salary
    INTO v_emp_name,
         v_salary
    FROM employees e
   WHERE e.employee_id = v_emp_id;
   v_annualsal := v_salary * 12;
   dbms_output.put_line(v_emp_name || ' annualsal is: ' || v_annualsal);
  IF v_annualsal <= 9999 THEN
    v_bonus := 500;
  ELSIF v_annualsal < 19999 THEN
    v_bonus := 1000;
  ELSE
    v_bonus := 2000;
  END IF;
  dbms_output.put_line(v_emp_name || ' BOnus is: ' || v_bonus);
   Exception 
    when  NO_DATA_FOUND then
      dbms_output.put_line('无此编号记录');
END;


--8(3)
DECLARE
  v_salary employees.salary%TYPE;
  v_bonus  employees.salary%TYPE;
BEGIN
  v_salary := &p_salary;
  v_bonus  := CASE v_salary
                WHEN 5000 THEN
                 2000
                WHEN 10000 THEN
                 1000
                WHEN 15000 THEN
                 2000
              END;
   dbms_output.put_line('Bonus is :'||v_bonus);
END;


--9

DECLARE
  v_emp_id    employees.employee_id%TYPE := &p_emp_id;
  v_newdep_id departments.department_id%TYPE := &p_new_dep_id;
  v_increase  NUMBER := &p_increase;
BEGIN
  UPDATE employees 
     SET department_id = v_newdep_id,
         salary  =salary * (1 + v_increase)
   WHERE employee_id = v_emp_id;
  IF SQL%FOUND THEN
    dbms_output.put_line('Update complete');
  ELSE
    dbms_output.put_line('No Data Found');
  END IF;
END;


--10.
DECLARE
  cursor emp_cur IS
    SELECT last_name,
           salary,
           hire_date
      FROM employees;

BEGIN
  FOR i IN emp_cur
  LOOP
    IF i.salary > 1500
       AND i.hire_date >= to_date('01-2月-1988',
                                  'DD-MON-YYYY') THEN
      dbms_output.put_line(i.last_name || ' earns ' || (i.salary) || ' and joined the organization on ' ||
                           to_char(i.hire_date));
    END IF;
  END LOOP;
END;




--11
DECLARE
  TYPE emp_name_table IS TABLE OF employees.last_name%TYPE
  INDEX BY BINARY_INTEGER;
  TYPE dep_id_table IS TABLE OF employees.department_id%TYPE
  INDEX    BY BINARY_INTEGER;
  v_name   emp_name_table;
  v_dep_id dep_id_table;
  v_cnt    NUMBER := 15;
  v_i      NUMBER := 0 ;
  CURSOR emp_cur IS SELECT last_name, department_id FROM employees WHERE employee_id < 115;
BEGIN
  FOR i IN emp_cur
  LOOP
    v_i := v_i + 1;
    v_name(v_i) := i.last_name;
    v_dep_id(v_i) := i.department_id;
  END LOOP;
  FOR c IN 1 .. v_cnt
  LOOP
    dbms_output.put_line('Employee Name: ' || v_name(c) || ' Department_id: ' || v_dep_id(c));
  END LOOP;

EXCEPTION
  WHEN no_data_found THEN
    dbms_output.put_line('没有找到该行数据');
END;


--12 --时间类型老是不匹配
DECLARE
  v_id       employees.employee_id%TYPE;
  v_name     employees.last_name%TYPE;
  v_hiredate employees.hire_date%TYPE;
  v_date     employees.hire_date%TYPE := &p_date;--错
  CURSOR date_cur(emp_hire_date DATE) IS
    SELECT employee_id,
           last_name,
           hire_date
      FROM employees
     WHERE hire_date > emp_hire_date;
BEGIN
  FOR i IN date_cur(v_date)
  LOOP
    dbms_output.put_line('id:' ||i.employee_id || ' name:' || i.last_name || '  hire_date' || i.hire_date);
  END LOOP;
END;


--13
DECLARE
  CURSOR emp_cur IS
    SELECT employee_id,
           job_id
      FROM employees where job_id = 'ST_CLERK' AND salary > 3000
       FOR UPDATE OF job_id NOWAIT;
BEGIN
  FOR i IN emp_cur
  LOOP
    UPDATE employees
       SET salary = 1.1 * salary
     WHERE CURRENT OF emp_cur;
  END LOOP;
END;


--14a
CREATE TABLE analysis_20864_lijie
(name varchar2(20),
years number(2),
sal number(8,2));

--SELECT * FROM analysis_20864_lijie
--14b
DECLARE
  v_name employees.last_name%TYPE;
  CURSOR emp_name_cur IS
    SELECT last_name
      FROM employees;
BEGIN
  FOR i IN emp_name_cur
  LOOP
    v_name := i.last_name;
    dbms_output.put_line(v_name);
  END LOOP;
END;

--14.c 
DECLARE
  sal_raise EXCEPTION;
  v_hiredate  employees.hire_date%TYPE;
  v_name      employees.last_name%TYPE := '&p_name';
  v_sal       employees.salary%TYPE;
  v_cnt_years NUMBER(2);
BEGIN
  SELECT last_name,
         salary,
         hire_date
    INTO v_name,
         v_sal,
         v_hiredate
    FROM employees
   WHERE last_name = v_name;
  v_cnt_years := months_between(SYSDATE,
                                v_hiredate) / 12;
  IF v_sal < 3500
     AND v_cnt_years > 5 THEN
    RAISE sal_raise;
  ELSE
    dbms_output.put_line('Not due for a raise');
  END IF;

EXCEPTION
  WHEN sal_raise THEN
    INSERT INTO analysis_20864_lijie
      (NAME, years, sal)
    VALUES
      (v_name, v_cnt_years, v_sal);
   when NO_DATA_FOUND then 
     dbms_output.put_line('查无此人');
END;


--15.a
CREATE OR REPLACE PROCEDURE add_jobs_20864(p_job_id     IN jobs.job_id%TYPE,
                                           p_title      IN jobs.job_title%TYPE,
                                           p_min_salary in jobs.min_salary%type) IS
BEGIN
  INSERT INTO jobs
    (job_id, job_title, min_salary, max_salary)
  VALUES
    (p_job_id, p_title, p_min_salary, p_min_salary * 2);
END add_jobs_20864;

--15.b
ALTER TRIGGER secure_employees DISABLE;
begin
  add_jobs_20864('SY_ANAL_li', 'System Analyst', 6000);
end;

--15.c
SELECT * FROM jobs where job_id ='SY_ANAL_li';


--16.a
CREATE OR REPLACE PROCEDURE add_job_hist_20864
  (p_emp_id IN employees.employee_id%TYPE,
   p_newjob_id IN jobs.job_id%TYPE)
IS v_sal employees.salary%type;
BEGIN
   INSERT INTO job_history    
     SELECT employee_id, hire_date, SYSDATE, job_id, department_id
     FROM   employees
     WHERE  employee_id = p_emp_id;
     --赋值用语句into  如果用：= 则会报错00103
     SELECT min_salary+500 into v_sal
                    FROM   jobs
                    WHERE  job_id = p_newjob_id;
   UPDATE employees
     SET  hire_date = SYSDATE,
          job_id = p_newjob_id,
          salary = v_sal
   WHERE employee_id = p_emp_id;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('员工不存在');
END add_job_hist_20864;

--16.b
 add_job_hist(106, 'SY_ANAL_li')

--16.c
SELECT * FROM job_history where employee_id =106;


--17

CREATE OR REPLACE PROCEDURE upd_sal_20864(p_job_id  IN jobs.job_id%TYPE,
                                          p_min_sal IN jobs.min_salary%TYPE,
                                          p_max_sal IN jobs.max_salary%TYPE) IS
  e_sal EXCEPTION;
BEGIN
  IF p_max_sal < p_min_sal THEN
    RAISE e_sal;
  END IF;
  UPDATE jobs
     SET min_salary = p_min_sal,
         max_salary = p_max_sal
   WHERE job_id = p_job_id;
EXCEPTION
  WHEN e_sal THEN
    dbms_output.put_line('最大工资不能小于最小工资！！');
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('表中无该记录，请确认');
    --未实现表被锁住的例外，不知异常编号
END upd_sal_20864;

--17.b
BEGIN
  upd_sal_20864('SY_ANAL',
                7000,
                140);
  upd_sal_20864('SY_ANAL',
                7000,
                14000);
END;

--17.c
SELECT *
  FROM   jobs
  WHERE job_id = 'SY_ANAL';


--18.a  --00054 错误，资源正忙
ALTER TABLE CUX.employees
	 ADD (sal_limit_indicate  VARCHAR2(3) DEFAULT 'NO'
  	      CONSTRAINT emp_sallimit_ck CHECK
           (sal_limit_indicate IN ('YES', 'NO')));

--18.b



