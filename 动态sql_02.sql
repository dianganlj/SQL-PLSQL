DECLARE
  v_sql           VARCHAR2(2000);
  v_department_id NUMBER;
BEGIN
  v_department_id := 50;
  v_sql           := 'UPDATE cux_employees_7606
   SET attribute15 = ''SQL train''
 WHERE department_id = ' || v_department_id;
  EXECUTE IMMEDIATE v_sql;
END;

DECLARE
  v_sql           VARCHAR2(2000);
  v_department_id NUMBER;
  v_cnt           NUMBER;
BEGIN
  v_department_id := 50;
  v_sql           := 'SELECT count(1) FROM cux_employees_7606 where department_id =' || v_department_id;
  EXECUTE IMMEDIATE v_sql
    INTO v_cnt;
  dbms_output.put_line(v_cnt);
END;

DECLARE
  v_sql           VARCHAR2(2000);
  v_department_id NUMBER;
  v_cnt           NUMBER;
BEGIN
  v_sql := 'SELECT count(1) FROM cux_employees_7606 where department_id = :1 AND JOB_ID = :2';
  EXECUTE IMMEDIATE v_sql
    INTO v_cnt
    USING 60,'IT_PROG';
  dbms_output.put_line(v_cnt);
END;
