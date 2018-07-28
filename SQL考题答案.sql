һ����ѯûѧ�������ࡱ��ʦ�ε�ͬѧ����ʾ��ѧ�š�������
SELECT hs.student_no, 
       hs.student_name
  FROM hand_student hs
 WHERE NOT EXISTS (SELECT 1
                     FROM hand_course hc, hand_teacher ht, hand_student_core hsc
                    WHERE hc.teacher_no = ht.teacher_no
                      AND hc.course_no = hsc.course_no
                      AND ht.teacher_name = '����'
                      AND hsc.student_no = hs.student_no);

������ѯû��ѧȫ���пε�ͬѧ����ʾ��ѧ�š�������
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
                  
������ѯ��c001���γ̱ȡ�c002���γ̳ɼ��ߵ�����ѧ������ʾ��ѧ�š�������
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
                  
�ġ�������ƽ���ɼ��ͼ����ʵİٷ������������ʸߵ���˳����ʾ���γ̺š�ƽ���֡������ʣ�
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
 
�塢1992��֮�������ѧ�������ҳ�����������С��ͬѧ����ʾ��ѧ�š����������䣩
SELECT hs.student_no,
       hs.student_name,
       hs.student_age
  FROM hand_student hs,
       (SELECT MAX(hs.student_age) max_age, 
               MIN(hs.student_age) min_age
          FROM hand_student hs
         WHERE to_number(to_char(SYSDATE, 'yyyy')) - hs.student_age > 1992) hh
 WHERE hs.student_age = hh.max_age OR hs.student_age = hh.min_age;

����ͳ���г��������͸�����������������Ϊ������[100-85]��[85-70]��[70-60]��[<60]������Ϊ�γ̺š��γ�����
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
 
�ߡ���ѯ���Ƴɼ�ǰ�����ļ�¼:(�����ǳɼ��������)����ʾ��ѧ�š��γ̺š�������
SELECT student_no,
       course_no,
       core
  FROM (SELECT hsc.student_no,
               hsc.course_no,
               hsc.core,
               DENSE_RANK() OVER(PARTITION BY hsc.course_no ORDER BY hsc.core DESC) ranks
          FROM hand_student_core hsc)
 WHERE ranks < 4;
 
�ˡ���ѯѡ�ޡ����ࡱ��ʦ���ڿγ̵�ѧ����ÿ�Ƴɼ���ߵ�ѧ������ʾ��ѧ�š��������γ����ơ��ɼ���
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
   AND ht.teacher_name = '����'
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
   AND ht.teacher_name = '����'
      --
   AND EXISTS (SELECT 1
          FROM hand_student_core sc 
         WHERE sc.course_no = hc.course_no
         GROUP BY hc.course_no
        HAVING MAX(sc.core) = hsc.core
        );
             
�š���ѯ���ż����ϲ�����γ̵�ͬѧ��ƽ���ɼ�����ʾ��ѧ�š�������ƽ���ɼ���������λС������
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
 
ʮ����ѯ������������ѧ����������ʾ��ѧ�š�������������
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
   
ʮһ����ѯ�γ�����Ϊ��J2SE����ѧ���ɼ���Ϣ��90����Ϊ�����㡱��80-90Ϊ�����á���60-80Ϊ�����񡱡�60������Ϊ�������񡱣���ʾ��ѧ�š��������γ����ơ��ɼ����ȼ���
SELECT hsc.student_no,
       hs.student_name,
       hc.course_name,
       hsc.core,
       CASE WHEN hsc.core >= 90 THEN
         '����'
       WHEN hsc.core < 90 AND hsc.core >= 80 THEN
         '����'
       WHEN hsc.core < 80 AND hsc.core >= 60 THEN
         '����'
       WHEN hsc.core < 60 THEN
         '������'
       END core_level
  FROM hand_student_core hsc,
       hand_course hc,
       hand_student hs
 WHERE hsc.course_no = hc.course_no
   AND hsc.student_no = hs.student_no
   AND hc.course_name = 'J2SE';
   
ʮ������ѯ��ʦ�������ǡ����������ܼ�����:�������ܵĽ�ʦҲ��Ҫ��ʾ������ʾ����ʦ��š���ʦ���ơ����ܱ�š��������ƣ�
 SELECT ht1.teacher_no,
        ht1.teacher_name,
        ht1.manager_no,
        ht2.teacher_name manager_name
   FROM hand_teacher ht1,
        hand_teacher ht2
  WHERE ht1.manager_no = ht2.teacher_no(+)
  START WITH ht1.teacher_name = '������'
CONNECT BY PRIOR ht1.manager_no = ht1.teacher_no;

ʮ������ѯ�������ڿγ̡�J2SE��������ѧ���γ���Ϣ����ʾ��ѧ�ţ��������γ����ơ�������
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
   
ʮ�ġ��ֱ���ݽ�ʦ���γ̡���ʦ�Ϳγ���������ͳ��ѡ�ε�ѧ��������(ʹ��rollup),��ʾ����ʦ���ơ��γ����ơ�ѡ��������
SELECT ht.teacher_name,
       hc.course_name,
       COUNT(1) nums
  FROM hand_student_core hsc,
       hand_teacher ht,
       hand_course hc
 WHERE hsc.course_no = hc.course_no
   AND hc.teacher_no = ht.teacher_no
 GROUP BY ROLLUP(ht.teacher_name,hc.course_name);
 
ʮ�塢��ѯ���пγ̳ɼ�ǰ�����İ������������ͷ�������������򱣳�Ĭ�ϣ�7�֣�,��ʾ��ѧ�š��γ̱�š��ɼ���
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
