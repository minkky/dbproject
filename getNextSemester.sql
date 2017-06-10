CREATE OR REPLACE PROCEDURE getNextSemester (
    next_semester OUT INTEGER
)
IS
    current_month INTEGER;
    semester_error EXCEPTION;
BEGIN
    SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'MM'))
    INTO current_month
    FROM DUAL;

    IF (current_month > 11) OR (current_month < 4) THEN
        next_semester := 1;
    ELSIF (current_month > 5) AND (current_month < 10) THEN
        next_semester := 2;
    ELSE 
        next_semester := 0;
    END IF;

    IF (next_semester = 0) THEN
        RAISE semester_error;
    END IF;

EXCEPTION
    WHEN semester_error THEN
        RAISE_APPLICATION_ERROR(-20010, '수강 신청 기간이 아닙니다');
END;
/


/* test */
DECLARE
	next_semester INTEGER;
BEGIN
	getNextSemester(next_semester);
	DBMS_OUTPUT.PUT_LINE(next_semester);
END;
/ 