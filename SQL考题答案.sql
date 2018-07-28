一、查询没学过“谌燕”老师课的同学，显示（学号、姓名）
SELECT hs.student_no, 
       hs.student_name
  FROM hand_student hs
 WHERE NOT EXISTS (SELECT 1
                     FROM hand_course hc, hand_teacher ht, hand_student_core hsc
                    WHERE hc.teacher_no = ht.teacher_no
                      AND hc.course_no = hsc.course_no
                      AND ht.teacher_name = '谌燕'
                      AND hsc.student_no = hs.student_no);

二、查询没有学全所有课的同学，显示（学号、姓名）
SELECT hs.student_no, 
       hs.student_name, 
       COUNT(hsc.course_no)
  FROM hand_student hs,
       hand_student_core hsc
 WHERE hs.student_no = hsc.student_no(+)
 GROUP BY hs.student_no, hs.student_name
HAVING COUNT(hsc.course_no) < (SELECT COUNT(hc.course_no) FROM hand_course hc);
---------------------------------------
SELECT hs.student_no,
       hs.student_name
  FROM hand_student hs
 WHERE hs.student_no in
       (SELECT student_no
          FROM (SELECT hs.student_no, hc.course_no
                  from hand_student hs
                 CROSS JOIN hand_course hc
                MINUS
                SELECT hsc.student_no, 
                       hsc.course_no
                  FROM hand_student_core hsc));
                  
三、查询“c001”课程比“c002”课程成绩高的所有学生，显示（学号、姓名）
SELECT hsc1.student_no,
       hs.student_name
  FROM (SELECT * FROM hAND_student_core sc1 WHERE sc1.course_no = 'c001') hsc1,
       (SELECT * FROM hAND_student_core sc2 WHERE sc2.course_no = 'c002') hsc2,
       hand_student hs
 WHERE hsc1.student_no = hsc2.student_no
   AND hsc1.core > hsc2.core
   AND hsc1.student_no = hs.student_no;
---------------------------------------
SELECT hsc.student_no,
       hs.student_name
  FROM hand_student_core hsc,
       hand_student hs
 WHERE hsc.student_no = hs.student_no
   AND hsc.course_no = 'c001'
   AND EXISTS (SELECT *
          FROM hAND_student_core hs
         WHERE hs.course_no = 'c002'
           AND hs.core < hsc.core
           AND hs.student_no = hsc.student_no);
                  
四、按各科平均成绩和及格率的百分数，按及格率高到低顺序，显示（课程号、平均分、及格率）
SELECT hsc.course_no,
       AVG(hsc.core) avg_core,
     (SUM(CASE
             WHEN hsc.core >= 60 THEN
              1
             ELSE
              0
           END) / COUNT(*) * 100) || '%' AS pass_rate
  FROM hand_student_core hsc
 GROUP BY hsc.course_no
 ORDER BY pass_rate DESC;
 
五、1992年之后出生的学生名单找出年龄最大和最小的同学，显示（学号、姓名、年龄）
SELECT hs.student_no,
       hs.student_name,
       hs.student_age
  FROM hand_student hs,
       (SELECT MAX(hs.student_age) max_age, 
               MIN(hs.student_age) min_age
          FROM hand_student hs
         WHERE to_number(to_char(SYSDATE, 'yyyy')) - hs.student_age > 1992) hh
 WHERE hs.student_age = hh.max_age OR hs.student_age = hh.min_age;

六、统计列出矩阵类型各分数段人数，横轴为分数段[100-85]、[85-70]、[70-60]、[<60]，纵轴为课程号、课程名称
SELECT hsc.course_no,
       hc.course_name,
       SUM(CASE
             WHEN hsc.core BETWEEN 85 AND 100 THEN
              1
             ELSE
              0
           END) AS "[100-85]",
       SUM(CASE
             WHEN hsc.core BETWEEN 70 AND 85 THEN
              1
             ELSE
              0
           END) AS "[85-70]",
       SUM(CASE
             WHEN hsc.core BETWEEN 60 AND 70 THEN
              1
             ELSE
              0
           END) AS "[70-60]",
       SUM(CASE
             WHEN hsc.core < 60 then
              1
             ELSE
              0
           END) AS "[<60]"
  FROM hand_student_core hsc, 
       hand_course hc
 WHERE hsc.course_no = hc.course_no
 GROUP BY hsc.course_no, hc.course_name;
 
七、查询各科成绩前三名的记录:(不考虑成绩并列情况)，显示（学号、课程号、分数）
SELECT student_no,
       course_no,
       core
  FROM (SELECT hsc.student_no,
               hsc.course_no,
               hsc.core,
               DENSE_RANK() OVER(PARTITION BY hsc.course_no ORDER BY hsc.core DESC) ranks
          FROM hand_student_core hsc)
 WHERE ranks < 4;
 
八、查询选修“谌燕”老师所授课程的学生中每科成绩最高的学生，显示（学号、姓名、课程名称、成绩）
SELECT hs.student_no, 
       hs.student_name, 
       hc.course_name, 
       hsc.core
  FROM hand_student      hs,
       hand_student_core hsc,
       hand_course       hc,
       hand_teacher      ht
 WHERE hs.student_no = hsc.student_no
   AND hsc.course_no = hc.course_no
   AND hc.teacher_no = ht.teacher_no
   AND ht.teacher_name = '谌燕'
   AND hsc.core = (SELECT MAX(sc.core)
                     FROM hand_student_core sc
                    WHERE sc.course_no = hc.course_no);
       
-------------add by hand.zhou 20170317
SELECT hs.student_no,
       hs.student_name,
       hc.course_name,
       hsc.course_no,
       hsc.core
  FROM hand_student      hs,
       hand_student_core hsc,
       hand_course       hc,
       hand_teacher      ht
 WHERE hs.student_no = hsc.student_no
   AND hsc.course_no = hc.course_no
   AND hc.teacher_no = ht.teacher_no
      --
   AND ht.teacher_name = '谌燕'
      --
   AND EXISTS (SELECT 1
          FROM hand_student_core sc 
         WHERE sc.course_no = hc.course_no
         GROUP BY hc.course_no
        HAVING MAX(sc.core) = hsc.core
        );
             
九、查询两门及以上不及格课程的同学及平均成绩，显示（学号、姓名、平均成绩（保留两位小数））
SELECT hsc.student_no, 
       hs.student_name,
       ROUND(AVG(hsc.core),2) avg_core
  FROM hand_student_core hsc,
       hand_student hs
 WHERE EXISTS (SELECT sc.student_no
                 FROM hand_student_core sc
                WHERE sc.core < 60
                  AND sc.student_no = hsc.student_no
                GROUP BY sc.student_no
               HAVING COUNT(sc.student_no) > 1)
   AND hsc.student_no = hs.student_no
 GROUP BY hsc.student_no,hs.student_name;
 
十、查询姓氏数量最多的学生名单，显示（学号、姓名、人数）
SELECT hs.student_no,
       hs.student_name,
       ht.cnt
  FROM (SELECT SUBSTR(hs.student_name, 1, 1) surname,
               COUNT(1) cnt,
               dense_rank() OVER(ORDER BY COUNT(1) DESC) ranks
          FROM hand_student hs
         GROUP BY SUBSTR(hs.student_name, 1, 1)) ht,
       hand_student hs  
 WHERE SUBSTR(hs.student_name,1,1) = ht.surname
   AND ht.ranks = 1;
   
十一、查询课程名称为“J2SE”的学生成绩信息，90以上为“优秀”、80-90为“良好”、60-80为“及格”、60分以下为“不及格”，显示（学号、姓名、课程名称、成绩、等级）
SELECT hsc.student_no,
       hs.student_name,
       hc.course_name,
       hsc.core,
       CASE WHEN hsc.core >= 90 THEN
         '优秀'
       WHEN hsc.core < 90 AND hsc.core >= 80 THEN
         '良好'
       WHEN hsc.core < 80 AND hsc.core >= 60 THEN
         '及格'
       WHEN hsc.core < 60 THEN
         '不及格'
       END core_level
  FROM hand_student_core hsc,
       hand_course hc,
       hand_student hs
 WHERE hsc.course_no = hc.course_no
   AND hsc.student_no = hs.student_no
   AND hc.course_name = 'J2SE';
   
十二、查询教师“胡明星”的所有主管及姓名:（无主管的教师也需要显示），显示（教师编号、教师名称、主管编号、主管名称）
 SELECT ht1.teacher_no,
        ht1.teacher_name,
        ht1.manager_no,
        ht2.teacher_name manager_name
   FROM hand_teacher ht1,
        hand_teacher ht2
  WHERE ht1.manager_no = ht2.teacher_no(+)
  START WITH ht1.teacher_name = '胡明星'
CONNECT BY PRIOR ht1.manager_no = ht1.teacher_no;

十三、查询分数高于课程“J2SE”的所有学生课程信息，显示（学号，姓名，课程名称、分数）
SELECT hsc.student_no, 
       hs.student_name,
       hc.course_name, 
       hsc.core
  FROM hand_student_core hsc,
       hand_course hc,
       hand_student hs
 WHERE hsc.course_no = hc.course_no
   AND hsc.student_no = hs.student_no
   AND hsc.core > ALL (SELECT hsc.core 
                         FROM hand_student_core hsc,
                              hand_course hc
                        WHERE hsc.course_no = hc.course_no
                          AND hc.course_name = 'J2SE')
   AND hc.course_name != 'J2SE';
   
十四、分别根据教师、课程、教师和课程三个条件统计选课的学生数量：(使用rollup),显示（教师名称、课程名称、选课数量）
SELECT ht.teacher_name,
       hc.course_name,
       COUNT(1) nums
  FROM hand_student_core hsc,
       hand_teacher ht,
       hand_course hc
 WHERE hsc.course_no = hc.course_no
   AND hc.teacher_no = ht.teacher_no
 GROUP BY ROLLUP(ht.teacher_name,hc.course_name);
 
十五、查询所有课程成绩前三名的按照升序排在最开头，其余数据排序保持默认（7分）,显示（学号、课程编号、成绩）
 SELECT *
   FROM (SELECT HSC.STUDENT_NO,
                HSC.COURSE_NO,
                HSC.CORE,
                ROW_NUMBER() OVER(PARTITION BY HSC.COURSE_NO ORDER BY HSC.CORE DESC) RANKS
           FROM HAND_STUDENT_CORE HSC) HS
  WHERE RANKS <= 3
UNION ALL
 SELECT *
   FROM (SELECT HSC.STUDENT_NO,
                HSC.COURSE_NO,
                HSC.CORE,
                ROW_NUMBER() OVER(PARTITION BY HSC.COURSE_NO ORDER BY HSC.CORE DESC) RANKS
           FROM HAND_STUDENT_CORE HSC) HS
  WHERE RANKS > 3
