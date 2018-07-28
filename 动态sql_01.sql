--DDL
--CREATE TABLE
DECLARE
  v_sql        VARCHAR2(2000);
  v_table_name VARCHAR(40) := 'CUX_SQL_TRAIN_7606';
  v_cur        INTEGER;

BEGIN
  v_sql := 'CREATE TABLE ' || v_table_name || ' (id NUMBER,
  NAME VARCHAR2(40))';
  /*v_sql := 'DROP TABLE ' || v_table_name;*/
  v_cur := dbms_sql.open_cursor;
  dbms_sql.parse(v_cur,
                 v_sql,
                 dbms_sql.native);
  dbms_sql.close_cursor(v_cur);
END;

--select
DECLARE
  v_sql           VARCHAR2(2000);
  v_cur           INTEGER;
  v_department_id NUMBER := 60;
  v_last_name     VARCHAR2(40);
  v_salary        NUMBER;
  v_cnt           NUMBER;
BEGIN
  v_sql := 'SELECT last_name,
       salary
  FROM cux_employees_7606 
 WHERE department_id = :p';

  v_cur := dbms_sql.open_cursor;
  dbms_sql.parse(v_cur,
                 v_sql,
                 dbms_sql.native);
  dbms_sql.bind_variable(v_cur,
                         ':p',
                         v_department_id);

  dbms_sql.define_column(v_cur,
                         1,
                         v_last_name,
                         40);
  dbms_sql.define_column(v_cur,
                         2,
                         v_salary);
  v_cnt := dbms_sql.execute(v_cur);

  LOOP
    EXIT WHEN dbms_sql.fetch_rows(v_cur) <= 0;
    dbms_sql.column_value(v_cur,
                          1,
                          v_last_name);
    dbms_sql.column_value(v_cur,
                          2,
                          v_salary);
  
    dbms_output.put_line('last name:' || v_last_name || ' salary:' || v_salary);
  END LOOP;
  dbms_sql.close_cursor(v_cur);
END;

--insert
DECLARE
  v_sql  VARCHAR2(2000);
  v_cur  INTEGER;
  v_id   NUMBER;
  v_name VARCHAR2(40);
  v_cnt  NUMBER;
BEGIN
  v_sql  := 'INSERT INTO cux_sql_train_7606
VALUES
  (:a,:b)';
  v_id   := 101;
  v_name := 'Alex';
  v_cur  := dbms_sql.open_cursor;
  dbms_sql.parse(v_cur,
                 v_sql,
                 dbms_sql.native);
  dbms_sql.bind_variable(v_cur,
                         ':a',
                         v_id);
  dbms_sql.bind_variable(v_cur,
                         ':b',
                         v_name);
  v_cnt := dbms_sql.execute(v_cur);

  dbms_sql.close_cursor(v_cur);
END;
