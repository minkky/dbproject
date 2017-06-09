CREATE OR Replace PROCEDURE DeleteEnroll (sStudentId IN VARCHAR2, 
		sCourseId IN VARCHAR2, 
		nCourseIdNo IN NUMBER,
		result	OUT VARCHAR2)
IS
BEGIN
	result := '';

	DBMS_OUTPUT.put_line('#');
	DBMS_OUTPUT.put_line(sStudentId || '���� �����ȣ ' || sCourseId || ', �й� ' || TO_CHAR(nCourseIdNo) || '�� ���� ��Ҹ� ��û�Ͽ����ϴ�.');

	DELETE
	FROM enroll
	WHERE s_id = sStudentId and c_id = sCourseId and c_id_no = nCourseIdNo;

	COMMIT;
	result := '������Ұ� �Ϸ�Ǿ����ϴ�.';

EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		result := SQLCODE;
END;
/