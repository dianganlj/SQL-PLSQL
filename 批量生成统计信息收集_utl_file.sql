--Created by Yixin.zhou
--实现：利用utl_file包，批量生成CUX表的统计信息，并且生成20个sql文件

--###############################################################--
--准备：
--1.创建路径：注意这里的路径文件夹一定要存在，没有的话手工先创建
--create or replace directory CUX_DIR_TEST as '/home/oraams';--linux系统路径，CUX_DIR_TEST是创建的路径名
--create or replace directory CUX_DIR_TEST as 'D:\test';--windows系统路径
--SELECT * FROM all_directories;

--2.授权：该目录和UTL_FILE包授权给所需用户，注意授权一定要做，不然会无法使用
--grant read, write on directory CUX_DIR_TEST to apps;--路径授权，添加对路径读、写权限
--grant execute on utl_file to apps;--utl_file包授权，添加执行权限

--3.写入文件，如下：
--###############################################################--

DECLARE

  l_directory_name VARCHAR2(30) := 'CUX_DIR_TEST';
  l_file_type      utl_file.file_type;
  l_buffer         VARCHAR2(32767) := NULL;
  l_count          NUMBER := 0;

  CURSOR cur_tab(p_rb NUMBER,
                 p_re NUMBER) IS
    SELECT x.owner,
           x.table_name
      FROM (SELECT t.owner,
                   t.table_name,
                   rownum row_num
              FROM all_tables t
             WHERE t.table_name LIKE 'CUX%'
               AND rownum <= 100
             ORDER BY t.owner) x
     WHERE x.row_num >= p_rb
       AND x.row_num <= p_re;

  l_number    NUMBER := 0;
  l_count_key NUMBER := 20; --设定生成20个sql文件
  l_row_begin NUMBER := 0;
  l_row_end   NUMBER := 0;

BEGIN
  SELECT COUNT(1) INTO l_number FROM all_tables t WHERE t.table_name LIKE 'CUX%';

  FOR i IN 1 .. l_count_key LOOP
  
    l_row_begin := l_row_end + 1;
    l_row_end   := l_row_end + trunc(l_number / l_count_key);
  
    l_count := l_count + 1;
    --------------------------------------------------------------------
    --1.通过UTL_FILE.FOPEN方法找到对应路径，创建文件，并且给出写入规则
    --------------------------------------------------------------------
    l_file_type := utl_file.fopen(location  => l_directory_name,
                                  filename  => 'GATHER_TABLE_STATS_' || to_char(l_count) || '.sql',
                                  open_mode => 'W' --W:写文件，没有该文件的话会自动添加；有的话会覆盖
                                  );
  
    --------------------------------------------------------------------
    --2.通过UTL_FILE.PUT_LINE方法向文件中写入内容（UTL_FILE.PUT_LINE写入VARCHAR2类型数据）
    --------------------------------------------------------------------
    utl_file.put_line(file => l_file_type, buffer => 'BEGIN');
  
    dbms_output.put_line('l_row_begin: ' || l_row_begin || ', l_row_end: ' || l_row_end);
    --统计信息生成拼接
    FOR rec IN cur_tab(l_row_begin, l_row_end) LOOP
    
      utl_file.put_line(file   => l_file_type,
                        buffer => 'DBMS_STATS.gather_table_stats(OWNNAME=>' || '''' || rec.owner || '''' || ',TABNAME=>' || '''' ||
                                  rec.table_name || '''' || ',METHOD_OPT => ''FOR ALL COLUMNS SIZE REPEAT'',CASCADE=> TRUE); ');
    
    END LOOP;
  
    utl_file.put_line(file => l_file_type, buffer => 'END;');
  
    --------------------------------------------------------------------
    --3.写入完成后，通过UTL_FILE.FCLOSE方法关闭文件，结束写出
    --------------------------------------------------------------------
    utl_file.fclose(l_file_type);
  
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
  
END;
