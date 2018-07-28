DECLARE
  l_directory_name VARCHAR2(30) := 'CUX_DIR_TEST';
  l_file_type      utl_file.file_type;
  l_buffer         VARCHAR2(32767) := NULL;

BEGIN
  dbms_output.put_line('0');
  l_file_type := utl_file.fopen(location  => l_directory_name,
                                filename  => 'test_lijie.sql',
                                open_mode => 'W' --W:д�ļ���û�и��ļ��Ļ����Զ���ӣ��еĻ��Ḳ��
                                );
  dbms_output.put_line('1');
  --------------------------------------------------------------------
  --2.ͨ��UTL_FILE.PUT_LINE�������ļ���д�����ݣ�UTL_FILE.PUT_LINEд��VARCHAR2�������ݣ�
  --------------------------------------------------------------------
  utl_file.put_line(file   => l_file_type,
                    buffer => 'BEGIN');
  dbms_output.put_line('2');
  utl_file.put_line(file   => l_file_type,
                    buffer => 'This is file test_1;');
  dbms_output.put_line('3');
  utl_file.put_line(file   => l_file_type,
                    buffer => 'END;');
  dbms_output.put_line('4');
  --------------------------------------------------------------------
  --3.д����ɺ�ͨ��UTL_FILE.FCLOSE�����ر��ļ�������д��
  --------------------------------------------------------------------
  utl_file.fclose(l_file_type);
  dbms_output.put_line('5');
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    dbms_output.put_line('6');
  
END;
