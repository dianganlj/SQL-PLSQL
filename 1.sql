
DECLARE
 -- l_directory_name VARC) := 'FILE_20864_TEST';
  l_directory_name VARCHAR2(30):= 'FILE_20864_TEST';
  l_file_type      utl_file.file_type;
  l_buffer         VARCHAR2(32767) := NULL;
BEGIN
  dbms_output.put_line('0');
  l_file_type := utl_file.fopen(location  => l_directory_name,
                                filename  => 'test1_lie_20864.txt',
                                open_mode => 'W' 
                                );
  dbms_output.put_line('1');
  utl_file.put_line(file   => l_file_type,
                    buffer => 'BEGIN');
  dbms_output.put_line('2');
  utl_file.put_line(file   => l_file_type,
                    buffer => 'This is file test_1;');
  dbms_output.put_line('3');
  utl_file.put_line(file   => l_file_type,
                    buffer => 'END;');
  dbms_output.put_line('4');
  utl_file.fclose(l_file_type);
  dbms_output.put_line('5');
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
    dbms_output.put_line('6');
END;


create or replace directory FILE_20864_TEST as '/home/FILE_TEST';
SELECT * FROM all_directories;
