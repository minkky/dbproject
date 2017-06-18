create or replace PROCEDURE InsertLecture(
	sCourseName IN VARCHAR2,
	nCourseUnit IN NUMBER,
	sProfessorId IN VARCHAR2, 
	sCourseId IN VARCHAR2, 
	nCourseIdNo IN NUMBER,
	nDay IN NUMBER,
	nStart_h IN NUMBER,
	nStart_m IN NUMBER,
	nEnd_h IN NUMBER,
	nEnd_m IN NUMBER,
	nLOC IN VARCHAR2,
	nMax IN NUMBER,
	result OUT VARCHAR2)
IS
	duplicate_time_professor EXCEPTION;
	duplicate_location EXCEPTION;

	check1 NUMBER;
	check2 NUMBER;

	nYear NUMBER;
	nSemester NUMBER;
	

	CURSOR duplicate_time_cursor IS
		SELECT *
		FROM TEACH
		WHERE p_id = sProfessorId;

	CURSOR duplicate_loc_cursor IS
		SELECT *
		FROM teach
		WHERE t_where = nLOC;

BEGIN
	result := '';
	
	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(sProfessorId || '님이 과목번호 ' || sCourseId || ', 분반 ' || TO_CHAR(nCourseIdNo) || '의 수업 등록을 요청하였습니다.');

	/* 년도, 학기 알아내기 */
	nYear := Date2EnrollYear(SYSDATE);
	nSemester := Date2EnrollSemester(SYSDATE);

	/* 에러처리 1 : 중복 시간 수업 있는 경우*/
	check1 := 0;
	FOR enroll_list IN duplicate_time_cursor LOOP
    	check1 := compareTime4pro(nDay, nStart_h, nStart_m, nEnd_h, nEnd_m, enroll_list.c_id, enroll_list.c_id_no);
  	END LOOP;

  	IF(check1 > 0) THEN
  		RAISE duplicate_time_professor;
  	END IF;

	/* 에러처리 2 : 중복 시간 속 중복 장소*/
	check2 := 0;
	FOR enroll_list IN duplicate_loc_cursor LOOP
    	check2 := compareTime4pro(nDay, nStart_h, nStart_m, nEnd_h, nEnd_m, enroll_list.c_id, enroll_list.c_id_no);
  	END LOOP;

  	IF(check2 > 0) THEN
  		RAISE duplicate_location;
  	END IF;

  	/* teach와 course 테이블에 수업 추가 */
	INSERT INTO course
	VALUES(sCourseId, nCourseIdNo, sCourseName, nCourseUnit);
 
   	INSERT INTO TEACH
  	VALUES(sProfessorId, sCourseId, nCourseIdNo, nYear, nSemester, nDay, nStart_h, nStart_m, nEnd_h, nEnd_m, nLOC, nMax);
 	
  	COMMIT;
  	result := '수업을 추가하였습니다.';

EXCEPTION
	WHEN duplicate_time_professor THEN
		result := '이미 등록된 과목 중 중복되는 강의가 존재합니다.';
	WHEN duplicate_location THEN
		result := '해당 강의실에 이미 수업이 있습니다.';
	WHEN OTHERS THEN
    	ROLLBACK;
    	result := '잠시후에 다시 시도해주세요';
END;
/