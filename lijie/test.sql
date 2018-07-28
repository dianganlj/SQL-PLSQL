create or replace function lijie_test(p_id in number) return  varchar2 is 
 v_name varchar2(30);
begin 
 select last_name into v_name from employees where employee_id = p_id ;
 return v_name;
 --这个是一个注释，用于检测文件同步信息
 end;
