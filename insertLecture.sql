CREATE OR REPLACE PROCEDURE insertLecture(
	sProfessorId IN VARCHAR2, nYear IN NUMBER,
	nSemester IN NUMBER,	nDAY IN NUMBER,
	n_ST_H IN NUMBER,	n_ST_M IN NUMBER,
	n_ET_H IN NUMBER,	n_ET_M IN NUMBER,
	nLOC IN VARCHAR2
)
IS
	duplicate_time_professor EXCEPTION;
	duplicate_location EXCEPTION;

BEGIN
overlap := 0;
  FOR enroll_list IN duplicate_time_cursor LOOP
    overlap := compareTime(sCourseId, nCourseIdNo, enroll_list.c_id, enroll_list.c_id_no);
  END LOOP;

/* 에러처리 1 : 중복 시간 수업 있는 경우*/

/* 에러처리 2 : 중복 시간 속 중복 장소*/
SELECT

FROM TEACH

END;