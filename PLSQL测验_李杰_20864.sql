--1
D
--2
B
--3
ABCD
--4
C 
--5
C 
--基础题
--1
--包头
   FUNCTION get_score(p_s_no IN VARCHAR2,
                     p_c_no IN VARCHAR2) RETURN NUMBER;
--包体；
FUNCTION GET_SCORE(p_s_no IN VARCHAR2,
                     p_c_no IN VARCHAR2) RETURN NUMBER IS
    v_score NUMBER;
  BEGIN
    SELECT t.core
      INTO v_score
      FROM HAND_STUDENT_CORE t
     WHERE t.student_no = p_s_no
       AND t.course_no = p_c_no;
    RETURN v_score;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN - 1;
    WHEN TOO_MANY_ROWS THEN
      RETURN - 2;
    WHEN OTHERS THEN
      RETURN - 3;
  END GET_SCORE;

--结果检测：
/*declare 
v_score number;
begin 
  v_score:=HAND_PLSQL_TEST_20864_PKG.get_score(p_s_no =>'s001' ,p_c_no =>'c001');
  dbms_output.put_line(v_score);
end;*/


--2
--包头
  PROCEDURE insert_log(p_code IN VARCHAR2,
                       p_msg  IN VARCHAR2,
                       p_key1 IN VARCHAR2 DEFAULT NULL,
                       p_key2 IN VARCHAR2 DEFAULT NULL,
                       p_key3 IN VARCHAR2 DEFAULT NULL,
                       p_key4 IN VARCHAR2 DEFAULT NULL,
                       p_key5 IN VARCHAR2 DEFAULT NULL);
--包体
 PROCEDURE INSERT_LOG(p_code IN VARCHAR2,
                       p_msg  IN VARCHAR2,
                       p_key1 IN VARCHAR2 DEFAULT NULL,
                       p_key2 IN VARCHAR2 DEFAULT NULL,
                       p_key3 IN VARCHAR2 DEFAULT NULL,
                       p_key4 IN VARCHAR2 DEFAULT NULL,
                       p_key5 IN VARCHAR2 DEFAULT NULL) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO hand_log
      (code, msg, key1, key2, key3, key4, key5)
    VALUES
      (p_code, p_msg, p_key1, p_key2, p_key3, p_key4, p_key5);
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      dbms_output.put_line('发生错误。。。');
  END INSERT_LOG;


--测试结果
/*DECLARE
BEGIN
  hand_plsql_test_20864_pkg.insert_log(p_code => '222',
                                       p_msg  => 'lijie_erroe',
                                       p_key1 => '213',
                                       p_key2 => '',
                                       p_key3 => '',
                                       p_key4 => '',
                                       p_key5 => '');
END;
SELECT * FROM hand_log;*/

--3.
--包头
PROCEDURE p_insert_stu;
--包体：
  PROCEDURE p_insert_stu IS
    stu_record hand_student%ROWTYPE;
  BEGIN
    FOR i IN 1 .. 10
    LOOP
      stu_record.student_no := 's10' || (i - 1);
        IF i < 10 THEN
          stu_record.student_name := '王00' || i;
        ELSE
          stu_record.student_name := '王0'|| i;
        END IF;
      stu_record.student_age := 22;
        IF MOD(i,
               2) = 0 THEN
          stu_record.student_gender := '难';
        ELSE
          stu_record.student_gender := '女';
        END IF;
      INSERT INTO HAND_STUDENT
      VALUES stu_record;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('插入出错！！！');
      ROLLBACK;
  END p_insert_stu;

--测试结果
/*BEGIN
  hand_plsql_test_20864_pkg.p_insert_stu;
END;
SELECT * FROM hand_student;*/


--4
--包头
PROCEDURE P_ADD_SCORE(p_id        IN VARCHAR2,
                      p_course_id IN VARCHAR2,
                      p_score     OUT NUMBER) ;
--包体
PROCEDURE P_ADD_SCORE(p_id        IN VARCHAR2,
                      p_course_id IN VARCHAR2,
                      p_score     OUT NUMBER) IS
  CURSOR score_cursor IS
    SELECT t.core
      FROM hand_student_core t
     WHERE t.student_no = p_id
       AND t.course_no = p_course_id
       FOR UPDATE OF t.core NOWAIT;
BEGIN
  FOR i IN score_cursor
  LOOP
    IF (i.core + i.core * 0.2) <= 100 THEN
      UPDATE hand_student_core t
         SET t.core = t.core + t.core * 0.2
       WHERE CURRENT OF score_cursor;
      p_score := i.core + i.core * 0.2;
    ELSE
      p_score := i.core;
    END IF;
  END LOOP;
END P_ADD_SCORE;

--测试结果
/*DECLARE
  v_score NUMBER;
BEGIN
  hand_plsql_test_20864_pkg.p_add_score(p_id        => 's003',
                                        p_course_id => 'c001',
                                        p_score     => v_score);
  dbms_output.put_line(v_score);
END;*/

--匿名块
--1题
DECLARE
  CURSOR scoretable_cur IS
    SELECT stu.student_name,
           stu.student_no,
           c.course_name,
           hand_plsql_test_20864_pkg.get_score(sc.student_no,
                                               sc.course_no) core
      FROM hand_student_core sc,
           hand_course       c,
           hand_student      stu
     WHERE sc.student_no = stu.student_no
       AND sc.course_no = c.course_no
       AND EXISTS (SELECT 1
              FROM hand_student_core stu,
                   hand_course       c,
                   hand_teacher      t
             WHERE stu.course_no = c.course_no
               AND c.teacher_no = t.teacher_no
               AND stu.student_no = sc.student_no
               AND t.teacher_name = '胡明星');
BEGIN

  FOR i IN scoretable_cur
  LOOP
    IF i.core NOT IN (-1,
                      -2,
                      -3) THEN
      dbms_output.put_line('姓名：' || i.student_name || ' 学号：' || i.student_no || '  课程名：' || i.course_name || '  成绩：' || i.core);
    ELSE
      hand_plsql_test_20864_pkg.insert_log(p_code => i.core,
                                           p_msg  => i.student_name);
    END IF;
  END LOOP;
END;



-- 匿名块 2 题
DECLARE
  v_cnt NUMBER;
  v_sql varchar2(2000) ;
BEGIN
  hand_plsql_test_20864_pkg.p_insert_stu;
  v_sql:= 'create TABLE hand_student_temp_20864 AS SELECT * FROM hand_student';
  EXECUTE IMMEDIATE v_sql;
END;

--匿名块  3 题
declare 
 cursor score_cur is 
    SELECT stu.student_name,
           stu.student_no,
           sc.course_no,
           c.course_name,
           hand_plsql_test_20864_pkg.get_score(sc.student_no,
                                               sc.course_no) core
      FROM hand_student_core sc,
           hand_course       c,
           hand_student      stu
     WHERE sc.student_no = stu.student_no
       AND sc.course_no = c.course_no
       AND EXISTS (SELECT 1
              FROM hand_student_core hsc,
                   hand_course       c,
                   hand_teacher      t
             WHERE hsc.course_no = c.course_no
               AND c.teacher_no = t.teacher_no
               AND hsc.student_no = sc.student_no
               AND hsc.core<70);
               v_new_score number;
               v_old_score number;

BEGIN
  FOR i IN score_cur
  LOOP
    v_old_score := i.core;
    hand_plsql_test_20864_pkg.p_add_score(p_id        => i.student_no,
                                          p_course_id => i.course_no,
                                          p_score     => v_new_score);
 dbms_output.put_line('姓名：' || i.student_name || ' 学号：' || i.student_no || '  课程名：' || i.course_name || ' 加分前成绩：' || v_old_score||' 加分后成绩'||v_new_score);
  END LOOP;
END;


--进阶题
--1
CREATE OR REPLACE TRIGGER hand_student_trig_20864
  AFTER INSERT OR UPDATE OR DELETE ON hand_student
  FOR EACH ROW
DECLARE
BEGIN
  IF inserting THEN
    INSERT INTO hand_student_his
      (student_no, student_name, student_age, student_gender, last_update_date, status)
    VALUES
      (:new.student_no, :new.student_name, :new.student_age, :new.student_gender, SYSDATE, 'N');
  ELSIF updating THEN
    INSERT INTO hand_student_his
      (student_no, student_name, student_age, student_gender, last_update_date, status)
    VALUES
      (:old.student_no, :old.student_name, :old.student_age, :old.student_gender, SYSDATE, 'U');
  ELSIF deleting THEN
    INSERT INTO hand_student_his
      (student_no, student_name, student_age, student_gender, last_update_date, status)
    VALUES
      (:old.student_no, :old.student_name, :old.student_age, :old.student_gender, SYSDATE, 'D');
  END IF;
END hand_student_trig_20864;

--测试答案
/*update hand_student  set student_name = '吴鹏' where student_no = 's003';
SELECT * FROM hand_student 
SELECT * FROM hand_student_his
*/
--2


DECLARE
  TYPE score_rec IS RECORD(
    stu_name hand_student.student_name%TYPE,
    student_no   hand_student.student_no%TYPE,
    course_name  hand_course.course_name%TYPE,
    stu_core         hand_student_core.core%TYPE);
    type  index_stuno is table of hand_student%type;
    ss_rec score_rec;
    cursor get_info is
     select stu.student_name,stu.student_no,c.course_name,sc.core 
     from hand_student stu ,
     hand_student_core sc,
     hand_course c where stu.student_no = sc.student_no and 
     sc.course_no = c.course_no;
BEGIN
  for  i in score_rec loop
     
END;


--3



SELECT * FROM HAND_STUDENT;

SELECT * FROM HAND_TEACHER;
SELECT * FROM HAND_COURSE;
SELECT * FROM HAND_STUDENT_CORE;
SELECT * FROM HAND_STUDENT_HIS;
SELECT * FROM HAND_LOG;
