--Created by Yixin.zhou
--ʵ�֣�����utl_file������������CUX���ͳ����Ϣ����������20��sql�ļ�

--###############################################################--
--׼����
--1.����·����ע�������·���ļ���һ��Ҫ���ڣ�û�еĻ��ֹ��ȴ���
--create or replace directory CUX_DIR_TEST as '/home/oraams';--linuxϵͳ·����CUX_DIR_TEST�Ǵ�����·����
--create or replace directory CUX_DIR_TEST as 'D:\test';--windowsϵͳ·��
--SELECT * FROM all_directories;

--2.��Ȩ����Ŀ¼��UTL_FILE����Ȩ�������û���ע����Ȩһ��Ҫ������Ȼ���޷�ʹ��
--grant read, write on directory CUX_DIR_TEST to apps;--·����Ȩ����Ӷ�·������дȨ��
--grant execute on utl_file to apps;--utl_file����Ȩ�����ִ��Ȩ��

--3.д���ļ������£�
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
  l_count_key NUMBER := 20; --�趨����20��sql�ļ�
  l_row_begin NUMBER := 0;
  l_row_end   NUMBER := 0;

BEGIN
  SELECT COUNT(1) INTO l_number FROM all_tables t WHERE t.table_name LIKE 'CUX%';

  FOR i IN 1 .. l_count_key LOOP
  
    l_row_begin := l_row_end + 1;
    l_row_end   := l_row_end + trunc(l_number / l_count_key);
  
    l_count := l_count + 1;
    --------------------------------------------------------------------
    --1.ͨ��UTL_FILE.FOPEN�����ҵ���Ӧ·���������ļ������Ҹ���д�����
    --------------------------------------------------------------------
    l_file_type := utl_file.fopen(location  => l_directory_name,
                                  filename  => 'GATHER_TABLE_STATS_' || to_char(l_count) || '.sql',
                                  open_mode => 'W' --W:д�ļ���û�и��ļ��Ļ����Զ���ӣ��еĻ��Ḳ��
                                  );
  
    --------------------------------------------------------------------
    --2.ͨ��UTL_FILE.PUT_LINE�������ļ���д�����ݣ�UTL_FILE.PUT_LINEд��VARCHAR2�������ݣ�
    --------------------------------------------------------------------
    utl_file.put_line(file => l_file_type, buffer => 'BEGIN');
  
    dbms_output.put_line('l_row_begin: ' || l_row_begin || ', l_row_end: ' || l_row_end);
    --ͳ����Ϣ����ƴ��
    FOR rec IN cur_tab(l_row_begin, l_row_end) LOOP
    
      utl_file.put_line(file   => l_file_type,
                        buffer => 'DBMS_STATS.gather_table_stats(OWNNAME=>' || '''' || rec.owner || '''' || ',TABNAME=>' || '''' ||
                                  rec.table_name || '''' || ',METHOD_OPT => ''FOR ALL COLUMNS SIZE REPEAT'',CASCADE=> TRUE); ');
    
    END LOOP;
  
    utl_file.put_line(file => l_file_type, buffer => 'END;');
  
    --------------------------------------------------------------------
    --3.д����ɺ�ͨ��UTL_FILE.FCLOSE�����ر��ļ�������д��
    --------------------------------------------------------------------
    utl_file.fclose(l_file_type);
  
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
  
END;
